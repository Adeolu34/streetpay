// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class TransactionStruct extends BaseStruct {
  TransactionStruct({
    String? narration,
    double? amount,
    String? referenceID,
    DateTime? transactionDate,
    bool? isReversed,
    bool? isCardTransaction,
    String? reversalReferenceNo,
    String? uniqueIdentifier,
    String? transactionDateString,
    String? postingType,
    String? debit,
    String? credit,
    String? accountNumber,
  })  : _narration = narration,
        _amount = amount,
        _referenceID = referenceID,
        _transactionDate = transactionDate,
        _isReversed = isReversed,
        _isCardTransaction = isCardTransaction,
        _reversalReferenceNo = reversalReferenceNo,
        _uniqueIdentifier = uniqueIdentifier,
        _transactionDateString = transactionDateString,
        _postingType = postingType,
        _debit = debit,
        _credit = credit,
        _accountNumber = accountNumber;

  // "narration" field.
  String? _narration;
  String get narration => _narration ?? '';
  set narration(String? val) => _narration = val;

  bool hasNarration() => _narration != null;

  // "amount" field.
  double? _amount;
  double get amount => _amount ?? 0.0;
  set amount(double? val) => _amount = val;

  void incrementAmount(double amount) => amount = amount + amount;

  bool hasAmount() => _amount != null;

  // "referenceID" field.
  String? _referenceID;
  String get referenceID => _referenceID ?? '';
  set referenceID(String? val) => _referenceID = val;

  bool hasReferenceID() => _referenceID != null;

  // "transactionDate" field.
  DateTime? _transactionDate;
  DateTime? get transactionDate => _transactionDate;
  set transactionDate(DateTime? val) => _transactionDate = val;

  bool hasTransactionDate() => _transactionDate != null;

  // "isReversed" field.
  bool? _isReversed;
  bool get isReversed => _isReversed ?? false;
  set isReversed(bool? val) => _isReversed = val;

  bool hasIsReversed() => _isReversed != null;

  // "isCardTransaction" field.
  bool? _isCardTransaction;
  bool get isCardTransaction => _isCardTransaction ?? false;
  set isCardTransaction(bool? val) => _isCardTransaction = val;

  bool hasIsCardTransaction() => _isCardTransaction != null;

  // "reversalReferenceNo" field.
  String? _reversalReferenceNo;
  String get reversalReferenceNo => _reversalReferenceNo ?? '';
  set reversalReferenceNo(String? val) => _reversalReferenceNo = val;

  bool hasReversalReferenceNo() => _reversalReferenceNo != null;

  // "uniqueIdentifier" field.
  String? _uniqueIdentifier;
  String get uniqueIdentifier => _uniqueIdentifier ?? '';
  set uniqueIdentifier(String? val) => _uniqueIdentifier = val;

  bool hasUniqueIdentifier() => _uniqueIdentifier != null;

  // "transactionDateString" field.
  String? _transactionDateString;
  String get transactionDateString => _transactionDateString ?? '';
  set transactionDateString(String? val) => _transactionDateString = val;

  bool hasTransactionDateString() => _transactionDateString != null;

  // "postingType" field.
  String? _postingType;
  String get postingType => _postingType ?? '';
  set postingType(String? val) => _postingType = val;

  bool hasPostingType() => _postingType != null;

  // "debit" field.
  String? _debit;
  String get debit => _debit ?? '';
  set debit(String? val) => _debit = val;

  bool hasDebit() => _debit != null;

  // "credit" field.
  String? _credit;
  String get credit => _credit ?? '';
  set credit(String? val) => _credit = val;

  bool hasCredit() => _credit != null;

  // "accountNumber" field.
  String? _accountNumber;
  String get accountNumber => _accountNumber ?? '';
  set accountNumber(String? val) => _accountNumber = val;

  bool hasAccountNumber() => _accountNumber != null;

  static TransactionStruct fromMap(Map<String, dynamic> data) =>
      TransactionStruct(
        narration: data['narration'] as String?,
        amount: castToType<double>(data['amount']),
        referenceID: data['referenceID'] as String?,
        transactionDate: data['transactionDate'] as DateTime?,
        isReversed: data['isReversed'] as bool?,
        isCardTransaction: data['isCardTransaction'] as bool?,
        reversalReferenceNo: data['reversalReferenceNo'] as String?,
        uniqueIdentifier: data['uniqueIdentifier'] as String?,
        transactionDateString: data['transactionDateString'] as String?,
        postingType: data['postingType'] as String?,
        debit: data['debit'] as String?,
        credit: data['credit'] as String?,
        accountNumber: data['accountNumber'] as String?,
      );

  static TransactionStruct? maybeFromMap(dynamic data) => data is Map
      ? TransactionStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'narration': _narration,
        'amount': _amount,
        'referenceID': _referenceID,
        'transactionDate': _transactionDate,
        'isReversed': _isReversed,
        'isCardTransaction': _isCardTransaction,
        'reversalReferenceNo': _reversalReferenceNo,
        'uniqueIdentifier': _uniqueIdentifier,
        'transactionDateString': _transactionDateString,
        'postingType': _postingType,
        'debit': _debit,
        'credit': _credit,
        'accountNumber': _accountNumber,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'narration': serializeParam(
          _narration,
          ParamType.String,
        ),
        'amount': serializeParam(
          _amount,
          ParamType.double,
        ),
        'referenceID': serializeParam(
          _referenceID,
          ParamType.String,
        ),
        'transactionDate': serializeParam(
          _transactionDate,
          ParamType.DateTime,
        ),
        'isReversed': serializeParam(
          _isReversed,
          ParamType.bool,
        ),
        'isCardTransaction': serializeParam(
          _isCardTransaction,
          ParamType.bool,
        ),
        'reversalReferenceNo': serializeParam(
          _reversalReferenceNo,
          ParamType.String,
        ),
        'uniqueIdentifier': serializeParam(
          _uniqueIdentifier,
          ParamType.String,
        ),
        'transactionDateString': serializeParam(
          _transactionDateString,
          ParamType.String,
        ),
        'postingType': serializeParam(
          _postingType,
          ParamType.String,
        ),
        'debit': serializeParam(
          _debit,
          ParamType.String,
        ),
        'credit': serializeParam(
          _credit,
          ParamType.String,
        ),
        'accountNumber': serializeParam(
          _accountNumber,
          ParamType.String,
        ),
      }.withoutNulls;

  static TransactionStruct fromSerializableMap(Map<String, dynamic> data) =>
      TransactionStruct(
        narration: deserializeParam(
          data['narration'],
          ParamType.String,
          false,
        ),
        amount: deserializeParam(
          data['amount'],
          ParamType.double,
          false,
        ),
        referenceID: deserializeParam(
          data['referenceID'],
          ParamType.String,
          false,
        ),
        transactionDate: deserializeParam(
          data['transactionDate'],
          ParamType.DateTime,
          false,
        ),
        isReversed: deserializeParam(
          data['isReversed'],
          ParamType.bool,
          false,
        ),
        isCardTransaction: deserializeParam(
          data['isCardTransaction'],
          ParamType.bool,
          false,
        ),
        reversalReferenceNo: deserializeParam(
          data['reversalReferenceNo'],
          ParamType.String,
          false,
        ),
        uniqueIdentifier: deserializeParam(
          data['uniqueIdentifier'],
          ParamType.String,
          false,
        ),
        transactionDateString: deserializeParam(
          data['transactionDateString'],
          ParamType.String,
          false,
        ),
        postingType: deserializeParam(
          data['postingType'],
          ParamType.String,
          false,
        ),
        debit: deserializeParam(
          data['debit'],
          ParamType.String,
          false,
        ),
        credit: deserializeParam(
          data['credit'],
          ParamType.String,
          false,
        ),
        accountNumber: deserializeParam(
          data['accountNumber'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'TransactionStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is TransactionStruct &&
        narration == other.narration &&
        amount == other.amount &&
        referenceID == other.referenceID &&
        transactionDate == other.transactionDate &&
        isReversed == other.isReversed &&
        isCardTransaction == other.isCardTransaction &&
        reversalReferenceNo == other.reversalReferenceNo &&
        uniqueIdentifier == other.uniqueIdentifier &&
        transactionDateString == other.transactionDateString &&
        postingType == other.postingType &&
        debit == other.debit &&
        credit == other.credit &&
        accountNumber == other.accountNumber;
  }

  @override
  int get hashCode => const ListEquality().hash([
        narration,
        amount,
        referenceID,
        transactionDate,
        isReversed,
        isCardTransaction,
        reversalReferenceNo,
        uniqueIdentifier,
        transactionDateString,
        postingType,
        debit,
        credit,
        accountNumber
      ]);
}

TransactionStruct createTransactionStruct({
  String? narration,
  double? amount,
  String? referenceID,
  DateTime? transactionDate,
  bool? isReversed,
  bool? isCardTransaction,
  String? reversalReferenceNo,
  String? uniqueIdentifier,
  String? transactionDateString,
  String? postingType,
  String? debit,
  String? credit,
  String? accountNumber,
}) =>
    TransactionStruct(
      narration: narration,
      amount: amount,
      referenceID: referenceID,
      transactionDate: transactionDate,
      isReversed: isReversed,
      isCardTransaction: isCardTransaction,
      reversalReferenceNo: reversalReferenceNo,
      uniqueIdentifier: uniqueIdentifier,
      transactionDateString: transactionDateString,
      postingType: postingType,
      debit: debit,
      credit: credit,
      accountNumber: accountNumber,
    );
