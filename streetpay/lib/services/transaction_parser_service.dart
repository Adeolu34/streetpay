import '/flutter_flow/flutter_flow_util.dart';

class ParsedTransaction {
  final String title;
  final String category; // 'transfer_in', 'transfer_out', 'airtime', 'data', 'electricity', 'fee', 'reversal'
  final String categoryLabel;
  final String? network; // 'MTN', 'Airtel', 'Glo', '9mobile'
  final String? phoneNumber;
  final String? beneficiaryOrSender;
  final bool isReversed;
  final bool isReversalCredit;
  final String? reversalReferenceNo;
  final String reference;
  final String status;
  final bool isCredit;
  final double amount;
  final double? balance;
  final String dateString;
  final String rawNarration;

  const ParsedTransaction({
    required this.title,
    required this.category,
    required this.categoryLabel,
    this.network,
    this.phoneNumber,
    this.beneficiaryOrSender,
    required this.isReversed,
    required this.isReversalCredit,
    this.reversalReferenceNo,
    required this.reference,
    required this.status,
    required this.isCredit,
    required this.amount,
    this.balance,
    required this.dateString,
    required this.rawNarration,
  });
}

class TransactionParserService {
  static String toTitleCase(String input) {
    if (input.trim().isEmpty) return '';
    final words = input.trim().split(RegExp(r'\s+'));
    final result = <String>[];
    for (final word in words) {
      if (word.contains('-')) {
        final hyphenParts = word.split('-');
        result.add(hyphenParts.map((p) => p.isNotEmpty ? '${p[0].toUpperCase()}${p.substring(1).toLowerCase()}' : '').join('-'));
      } else if (word.isNotEmpty) {
        result.add('${word[0].toUpperCase()}${word.substring(1).toLowerCase()}');
      }
    }
    return result.join(' ');
  }

  static String? detectNetwork(String text) {
    final upper = text.toUpperCase();
    if (upper.contains('MTN')) return 'MTN';
    if (upper.contains('AIRTEL')) return 'Airtel';
    if (upper.contains('GLO') || upper.contains('GLOBACOM')) return 'Glo';
    if (upper.contains('9MOBILE') || upper.contains('ETISALAT')) return '9mobile';
    return null;
  }

  static String? extractPhoneNumber(String text) {
    // Match Nigerian phone numbers (070, 080, 081, 090, 091, 234...)
    final match = RegExp(r'(?:(?:\+?234)|0)([789][01]\d{8})').firstMatch(text);
    if (match != null) {
      final digits = match.group(0)!;
      if (digits.startsWith('234')) {
        return '0${digits.substring(3)}';
      } else if (digits.startsWith('+234')) {
        return '0${digits.substring(4)}';
      }
      return digits;
    }
    return null;
  }

  /// Detects whether narration/description indicates a reversal or refund even if isReversed == true is missing
  static bool isReversalDescription(String text) {
    if (text.isEmpty) return false;
    final lower = text.toLowerCase().trim();
    return lower.startsWith('rev:') ||
        lower.startsWith('rev-') ||
        lower.startsWith('rev/') ||
        lower.startsWith('rev ') ||
        lower.startsWith('reversal') ||
        lower.startsWith('reversed') ||
        lower.startsWith('rvsl') ||
        lower.contains('reversal of') ||
        lower.contains('rvsl/') ||
        lower.contains('rev: ') ||
        lower.contains('refund') ||
        RegExp(r'\b(rev|reversal|reversed|rvsl|refund)\b', caseSensitive: false).hasMatch(lower);
  }

  /// Detects if transaction reference indicates a Reversal Advice (RA...)
  static bool isReversalReference(String ref) {
    if (ref.isEmpty) return false;
    final upper = ref.toUpperCase().trim();
    return upper.startsWith('RA') || upper.startsWith('REV') || upper.startsWith('RVS');
  }

  static ParsedTransaction parse(
    dynamic rawItem, {
    String? credittitle,
    String? debittitle,
    String? creditamount,
    String? debitamount,
    String? subtitle,
  }) {
    // 1. Extract raw fields
    final Map<dynamic, dynamic> map = rawItem is Map ? rawItem : {};

    final rawNarration = (getJsonField(rawItem, r'''$.narration''')?.toString() ??
            getJsonField(rawItem, r'''$.description''')?.toString() ??
            debittitle ??
            credittitle ??
            '')
        .trim();

    final dateStr = (getJsonField(rawItem, r'''$.transactionDateString''')?.toString() ??
            getJsonField(rawItem, r'''$.transactionDate''')?.toString() ??
            getJsonField(rawItem, r'''$.date''')?.toString() ??
            subtitle ??
            '')
        .trim();

    final creditStr = (creditamount ?? getJsonField(rawItem, r'''$.credit''')?.toString() ?? '').replaceAll(',', '').trim();
    final debitStr = (debitamount ?? getJsonField(rawItem, r'''$.debit''')?.toString() ?? '').replaceAll(',', '').trim();

    final creditVal = double.tryParse(creditStr) ?? 0.0;
    final debitVal = double.tryParse(debitStr) ?? 0.0;
    final numAmount = (getJsonField(rawItem, r'''$.amount''') as num?)?.toDouble() ??
        (creditVal > 0.0001 ? creditVal : debitVal);

    final isCredit = creditVal > 0.0001 || (map['type'] == 'credit');
    final balanceNum = (getJsonField(rawItem, r'''$.balance''') as num?)?.toDouble();

    final ref = (getJsonField(rawItem, r'''$.referenceID''')?.toString() ??
            getJsonField(rawItem, r'''$.uniqueIdentifier''')?.toString() ??
            getJsonField(rawItem, r'''$.reference''')?.toString() ??
            getJsonField(rawItem, r'''$.paymentReference''')?.toString() ??
            getJsonField(rawItem, r'''$.ref''')?.toString() ??
            getJsonField(rawItem, r'''$.id''')?.toString() ??
            '')
        .trim();

    final postingType = (getJsonField(rawItem, r'''$.postingType''')?.toString() ?? '').trim();

    // Comprehensive Reversal Detection (flag, description, postingType, or reference)
    final hasReversalNarr = isReversalDescription(rawNarration);
    final hasReversalPostingType = postingType.toLowerCase().contains('revers');
    final hasReversalRef = isReversalReference(ref);
    final explicitReversedFlag = (getJsonField(rawItem, r'''$.isReversed''') == true) ||
        (getJsonField(rawItem, r'''$.reversalReferenceNo''')?.toString().isNotEmpty ?? false);

    final bool isReversalCredit = isCredit && (hasReversalNarr || hasReversalPostingType || hasReversalRef);
    final bool isReversed = explicitReversedFlag ||
        (!isCredit && (hasReversalNarr || hasReversalPostingType || hasReversalRef));

    final reversalRef = getJsonField(rawItem, r'''$.reversalReferenceNo''')?.toString() ??
        (hasReversalRef ? ref : null);

    final rawStatus = (getJsonField(rawItem, r'''$.status''')?.toString() ?? '').trim();

    String finalStatus = 'Successful';
    if (rawStatus.toLowerCase().contains('fail')) {
      finalStatus = 'Failed';
    } else if (isReversed) {
      finalStatus = 'Reversed';
    } else if (isReversalCredit) {
      finalStatus = 'Refunded';
    } else if (rawStatus.isNotEmpty) {
      finalStatus = rawStatus;
    }

    // 2. Intelligent Categorization & Detail Extraction
    String category = isCredit ? 'transfer_in' : 'transfer_out';
    String categoryLabel = isCredit ? 'Transfer In' : 'Transfer Out';
    String? network = detectNetwork(rawNarration);
    String? phone = extractPhoneNumber(rawNarration);
    String? personOrOrgName;
    String cleanTitle = '';

    final upperNarr = rawNarration.toUpperCase();

    // Check Reversals first
    if (isReversalCredit) {
      category = 'reversal';
      categoryLabel = 'Reversal Refund';
      if (rawNarration.toLowerCase().contains('reversal of')) {
        final insideParen = RegExp(r'\((.*?)\)').firstMatch(rawNarration)?.group(1);
        if (insideParen != null && insideParen.isNotEmpty) {
          final parts = insideParen.split('/');
          final namePart = parts[0].trim();
          personOrOrgName = toTitleCase(namePart);
          cleanTitle = 'Refund: $personOrOrgName';
        } else {
          final afterOf = rawNarration.split(RegExp(r'reversal of', caseSensitive: false)).last.trim();
          cleanTitle = afterOf.isNotEmpty ? 'Refund: ${toTitleCase(afterOf)}' : 'Transaction Refund';
        }
      } else if (rawNarration.toLowerCase().contains('stamp duty')) {
        cleanTitle = 'Stamp Duty Refund';
      } else if (rawNarration.toLowerCase().startsWith('rev:') || rawNarration.toLowerCase().startsWith('rev/')) {
        final afterRev = rawNarration.substring(4).trim();
        cleanTitle = afterRev.isNotEmpty ? 'Refund: ${toTitleCase(afterRev)}' : 'Payment Refund';
      } else {
        cleanTitle = 'Payment Refund';
      }
    } else if (isReversed) {
      category = 'reversal';
      categoryLabel = 'Reversed Payment';
    }

    // Check Airtime
    if (cleanTitle.isEmpty && (upperNarr.contains('/AIRTIME') || upperNarr.contains('AIRTIME'))) {
      category = 'airtime';
      categoryLabel = 'Airtime Top-up';
      final phonePart = phone != null ? ' ($phone)' : '';
      cleanTitle = '${network ?? ''} Airtime$phonePart'.trim();
    }

    // Check Data
    if (cleanTitle.isEmpty && (upperNarr.contains('/DATA') || RegExp(r'\bDATA\b').hasMatch(upperNarr))) {
      category = 'data';
      categoryLabel = 'Data Bundle';
      final phonePart = phone != null ? ' ($phone)' : '';
      cleanTitle = '${network ?? ''} Data$phonePart'.trim();
    }

    // Check Bill Payments & Utilities
    if (cleanTitle.isEmpty &&
        (upperNarr.contains('BILL PAYMENT') ||
            upperNarr.contains('BILLPAYMENT') ||
            upperNarr.startsWith('BILL ') ||
            upperNarr == 'BILL PAYMENT' ||
            upperNarr.contains('UTILITY'))) {
      category = 'bill_payment';
      categoryLabel = 'Bill Payment';
      cleanTitle = 'Bill Payment';
    } else if (cleanTitle.isEmpty &&
        (upperNarr.contains('ELECTRICITY') ||
            upperNarr.contains('IKEDC') ||
            upperNarr.contains('EKEDC') ||
            upperNarr.contains('IBEDC') ||
            upperNarr.contains('AEDC') ||
            upperNarr.contains('PHED') ||
            upperNarr.contains('EEDC') ||
            upperNarr.contains('KEDCO'))) {
      category = 'bill_payment';
      categoryLabel = 'Electricity Bill';
      cleanTitle = 'Electricity Bill';
    }

    // Check Stamp Duty & Fees
    if (cleanTitle.isEmpty &&
        (upperNarr.contains('STAMP DUTY') || upperNarr.contains('EMTL') || upperNarr.startsWith('REV: STAMP'))) {
      category = 'fee';
      categoryLabel = 'Stamp Duty / Fee';
      cleanTitle = upperNarr.contains('REV') ? 'Stamp Duty Refund' : 'Stamp Duty Levy';
    }

    // Check Incoming Transfers (Credit)
    if (cleanTitle.isEmpty && isCredit) {
      category = 'transfer_in';
      categoryLabel = 'Transfer In';

      if (rawNarration.startsWith('/')) {
        final segments = rawNarration.split('/').where((s) => s.trim().isNotEmpty).toList();
        if (segments.isNotEmpty) {
          final rawName = segments[0].trim();
          if (!RegExp(r'^\d+$').hasMatch(rawName)) {
            personOrOrgName = toTitleCase(rawName);
            cleanTitle = 'Transfer from $personOrOrgName';
          }
        }
      } else if (rawNarration.contains('Transfer from')) {
        cleanTitle = rawNarration;
      }

      if (cleanTitle.isEmpty) {
        final recipient = map['recipient_name']?.toString() ?? '';
        if (recipient.trim().isNotEmpty && recipient != '-') {
          cleanTitle = 'Transfer from ${toTitleCase(recipient)}';
        } else {
          cleanTitle = 'Incoming Transfer';
        }
      }
    }

    // Check Outgoing Transfers (Debit)
    if (cleanTitle.isEmpty) {
      category = isReversed ? 'reversal' : 'transfer_out';
      categoryLabel = isReversed ? 'Reversed Payment' : 'Transfer Out';

      final localRecipient = (map['recipient_name']?.toString() ?? '').trim();
      if (localRecipient.isNotEmpty && localRecipient != '-' && !localRecipient.toLowerCase().contains('transaction')) {
        personOrOrgName = toTitleCase(localRecipient);
        cleanTitle = 'Transfer to $personOrOrgName';
      } else if (rawNarration.contains('/')) {
        final parts = rawNarration.split('/');
        final nameCandidate = parts[0].trim();
        if (nameCandidate.isNotEmpty && nameCandidate != '-') {
          if (RegExp(r'^\d{10}$').hasMatch(nameCandidate)) {
            cleanTitle = 'Transfer to $nameCandidate';
          } else {
            personOrOrgName = toTitleCase(nameCandidate);
            cleanTitle = 'Transfer to $personOrOrgName';
          }
        }
      } else if (rawNarration.isNotEmpty && rawNarration != '-') {
        personOrOrgName = toTitleCase(rawNarration);
        cleanTitle = 'Transfer to $personOrOrgName';
      } else {
        cleanTitle = 'Transfer Out';
      }
    }

    return ParsedTransaction(
      title: cleanTitle,
      category: category,
      categoryLabel: categoryLabel,
      network: network,
      phoneNumber: phone,
      beneficiaryOrSender: personOrOrgName,
      isReversed: isReversed,
      isReversalCredit: isReversalCredit,
      reversalReferenceNo: reversalRef,
      reference: ref,
      status: finalStatus,
      isCredit: isCredit,
      amount: numAmount,
      balance: balanceNum,
      dateString: dateStr,
      rawNarration: rawNarration,
    );
  }

  /// Clean title generator for legacy / backwards compatible calls
  static String cleanTitle(String narration) {
    if (narration.trim().isEmpty || narration.trim() == '-') {
      return 'Transfer';
    }
    final parsed = parse({'narration': narration});
    return parsed.title;
  }
}
