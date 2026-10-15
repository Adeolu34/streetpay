import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'smart_support_modal_model.dart';
export 'smart_support_modal_model.dart';

class FaqTopic {
  final String id;
  final String title;
  final String category; // 'Registration', 'Login', 'Transfers', 'General'
  final String summary;
  final List<String> steps;
  final String? actionLabel;
  final VoidCallback? onAction;
  final String? ussdCode;

  FaqTopic({
    required this.id,
    required this.title,
    required this.category,
    required this.summary,
    required this.steps,
    this.actionLabel,
    this.onAction,
    this.ussdCode,
  });
}

class SmartSupportModalWidget extends StatefulWidget {
  const SmartSupportModalWidget({
    super.key,
    this.initialCategory,
  });

  final String? initialCategory;

  @override
  State<SmartSupportModalWidget> createState() => _SmartSupportModalWidgetState();
}

class _SmartSupportModalWidgetState extends State<SmartSupportModalWidget> {
  late SmartSupportModalModel _model;
  String _searchQuery = '';

  final List<String> _categories = [
    'All Topics',
    'Registration & BVN',
    'Login & Security',
    'Transfers & Money',
  ];

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SmartSupportModalModel());
    _model.searchTextController ??= TextEditingController();
    _model.searchFocusNode ??= FocusNode();

    if (widget.initialCategory != null) {
      final index = _categories.indexOf(widget.initialCategory!);
      if (index >= 0) {
        _model.selectedCategoryIndex = index;
      }
    }
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  List<FaqTopic> _getAllFaqs(BuildContext context) {
    return [
      FaqTopic(
        id: 'reg_bvn',
        title: 'Cannot Register / BVN Verification Failed',
        category: 'Registration & BVN',
        summary:
            'Ensure the phone number you registered with matches the phone linked to your BVN.',
        steps: [
          'Verify phone link: Dial *564*0# on your registered SIM to confirm your BVN.',
          'Name Spelling: Ensure your name is spelled exactly as registered with your bank and BVN (no nicknames).',
          'Date of Birth: Your DOB on StreetPay must strictly match your BVN record.',
          'NIMC / NIBSS Downtime: If banks are currently experiencing network latency, please retry in 5 minutes.',
        ],
        ussdCode: '*564*0#',
        actionLabel: 'Dial *564*0# for BVN',
        onAction: () => _dialCode('*564*0#'),
      ),
      FaqTopic(
        id: 'reg_nin',
        title: 'NIN Verification Issue or Delay',
        category: 'Registration & BVN',
        summary:
            'If your NIN is not verifying, check that your telecom SIM has been linked to NIMC.',
        steps: [
          'Retrieve NIN: Dial *346# on your mobile network to confirm your 11-digit NIN.',
          'Link SIM to NIN: Use your network carrier\'s code (MTN: *996#, Airtel: *996#, Glo: *109#, 9mobile: *200*8#).',
          'Ensure telecom records and NIMC slip details match StreetPay account profile.',
        ],
        ussdCode: '*346#',
        actionLabel: 'Dial *346# for NIN',
        onAction: () => _dialCode('*346#'),
      ),
      FaqTopic(
        id: 'reg_otp',
        title: 'Did Not Receive OTP SMS',
        category: 'Registration & BVN',
        summary:
            'SMS delay is usually caused by active "Do Not Disturb" (DND) on your telecom network.',
        steps: [
          'Check DND status: Text "STATUS" to 2442 to confirm if promotional or transactional SMS is blocked.',
          'Toggle Airplane mode ON for 5 seconds, then OFF to force fresh network registration.',
          'Check SIM signal bars and ensure your phone memory is not full.',
          'Wait 60 seconds before tapping "Resend OTP" to prevent telecom throttling.',
        ],
      ),
      FaqTopic(
        id: 'login_pin',
        title: 'Forgot Password or Transaction PIN',
        category: 'Login & Security',
        summary:
            'You can instantly reset your password or PIN using your verified phone number.',
        steps: [
          'Tap the "Reset Password" button below.',
          'Enter your registered phone number.',
          'Enter the verification OTP received and set a new 6-character password or PIN.',
        ],
        actionLabel: 'Reset Password Now',
        onAction: () {
          Navigator.pop(context);
          context.pushNamed(ResetpasswordWidget.routeName);
        },
      ),
      FaqTopic(
        id: 'login_bio',
        title: 'Biometric / Fingerprint Login Not Working',
        category: 'Login & Security',
        summary:
            'Biometric authentication may lock temporarily after system updates or sensor errors.',
        steps: [
          'Log in once with your normal password and phone number.',
          'Navigate to Settings > Security.',
          'Toggle Biometric Authentication OFF and then back ON to refresh credentials.',
        ],
      ),
      FaqTopic(
        id: 'transfer_delay',
        title: 'Money Sent but Beneficiary Hasn\'t Received It',
        category: 'Transfers & Money',
        summary:
            'Most NIBSS transfers reflect instantly, but interbank network delays may occur.',
        steps: [
          'Instant Settlement: 95% of transfers deliver in under 60 seconds.',
          'Bank Congestion: Some destination commercial banks experience switch congestion during peak hours.',
          'CBN Reversal Rule: If your wallet was debited but the beneficiary didn\'t receive funds, the NIBSS switch auto-reverses the transaction within 24 to 48 hours.',
          'Keep your Transaction Reference handy to share with Support if needed.',
        ],
      ),
      FaqTopic(
        id: 'kyc_tier',
        title: 'How to Upgrade to Tier 2 or Tier 3',
        category: 'Registration & BVN',
        summary:
            'Tier upgrades unlock higher wallet limits and daily transaction volumes.',
        steps: [
          'Tier 2 Upgrade: Requires your verified NIN, selfie photo, and residential address.',
          'Tier 3 Upgrade: Requires proof of address (utility bill under 3 months old).',
          'StreetPay automatically saves your progress so you can complete the upgrade anytime.',
        ],
      ),
    ];
  }

  void _dialCode(String code) async {
    final encoded = Uri.encodeComponent(code);
    final uri = Uri.parse('tel:$encoded');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      Clipboard.setData(ClipboardData(text: code));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Code $code copied to clipboard'),
            duration: const Duration(seconds: 2),
            backgroundColor: FlutterFlowTheme.of(context).primary,
          ),
        );
      }
    }
  }

  void _launchWhatsApp() async {
    final uri = Uri.parse('https://wa.me/2348164568803?text=Hello%20StreetPay%20Support%2C%20I%20need%20assistance%20with%20my%20account');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final allFaqs = _getAllFaqs(context);

    // Filter FAQs by category and search
    final query = _searchQuery.trim().toLowerCase();
    final filteredFaqs = allFaqs.where((faq) {
      final matchesCategory = _model.selectedCategoryIndex == 0 ||
          faq.category == _categories[_model.selectedCategoryIndex];

      final matchesSearch = query.isEmpty ||
          faq.title.toLowerCase().contains(query) ||
          faq.summary.toLowerCase().contains(query) ||
          faq.steps.any((s) => s.toLowerCase().contains(query));

      return matchesCategory && matchesSearch;
    }).toList();

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.88,
      ),
      decoration: BoxDecoration(
        color: theme.primaryBackground,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12.0, bottom: 8.0),
              width: 44.0,
              height: 5.0,
              decoration: BoxDecoration(
                color: theme.alternate,
                borderRadius: BorderRadius.circular(3.0),
              ),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
            child: Row(
              children: [
                Container(
                  width: 42.0,
                  height: 42.0,
                  decoration: BoxDecoration(
                    color: theme.primary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Icon(
                    Icons.smart_toy_rounded,
                    color: theme.primary,
                    size: 24.0,
                  ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'StreetPay Assistant',
                        style: theme.titleMedium.override(
                              font: GoogleFonts.inter(
                                fontWeight: FontWeight.bold,
                              ),
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        'Fast answers & registration diagnostics',
                        style: theme.bodySmall.override(
                              font: GoogleFonts.inter(),
                              color: theme.secondaryText,
                              fontSize: 12.0,
                            ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close_rounded, color: theme.secondaryText),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          const Divider(height: 1.0),

          // Search Field
          Padding(
            padding:
                EdgeInsetsDirectional.fromSTEB(20.0, 12.0, 20.0, 8.0),
            child: Container(
              decoration: BoxDecoration(
                color: theme.secondaryBackground,
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(
                  color: theme.alternate,
                  width: 1.0,
                ),
              ),
              child: TextField(
                controller: _model.searchTextController,
                focusNode: _model.searchFocusNode,
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val.trim();
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search issues (e.g. BVN, NIN, OTP, transfer...)',
                  hintStyle: theme.bodySmall.override(
                        font: GoogleFonts.inter(),
                        color: theme.secondaryText,
                      ),
                  prefixIcon: Icon(Icons.search_rounded, color: theme.secondaryText, size: 20.0),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18.0),
                          onPressed: () {
                            _model.searchTextController?.clear();
                            setState(() {
                              _searchQuery = '';
                            });
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
                ),
              ),
            ),
          ),

          // Category Chips
          SizedBox(
            height: 38.0,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              itemCount: _categories.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8.0),
              itemBuilder: (context, index) {
                final isSelected = _model.selectedCategoryIndex == index;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _model.selectedCategoryIndex = index;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
                    decoration: BoxDecoration(
                      color: isSelected ? theme.primary : theme.secondaryBackground,
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(
                        color: isSelected ? theme.primary : theme.alternate,
                        width: 1.0,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _categories[index],
                      style: theme.bodySmall.override(
                            font: GoogleFonts.inter(
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                            ),
                            color: isSelected ? Colors.white : theme.primaryText,
                            fontSize: 12.0,
                            letterSpacing: 0.0,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 8.0),

          // FAQ List
          Expanded(
            child: filteredFaqs.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.help_outline_rounded,
                            size: 48.0,
                            color: theme.secondaryText,
                          ),
                          const SizedBox(height: 12.0),
                          Text(
                            'No matching solutions found',
                            style: theme.titleSmall.override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600,
                                  ),
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const SizedBox(height: 6.0),
                          Text(
                            'Try another search term or talk to our live support team below.',
                            textAlign: TextAlign.center,
                            style: theme.bodySmall.override(
                                  font: GoogleFonts.inter(),
                                  color: theme.secondaryText,
                                ),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.separated(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(20.0, 8.0, 20.0, 16.0),
                    itemCount: filteredFaqs.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 10.0),
                    itemBuilder: (context, index) {
                      final item = filteredFaqs[index];
                      final isExpanded = _model.expandedIndex == index;

                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        decoration: BoxDecoration(
                          color: theme.secondaryBackground,
                          borderRadius: BorderRadius.circular(14.0),
                          border: Border.all(
                            color: isExpanded ? theme.primary : theme.alternate.withOpacity(0.6),
                            width: isExpanded ? 1.5 : 1.0,
                          ),
                        ),
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _model.expandedIndex = isExpanded ? -1 : index;
                                });
                              },
                              borderRadius: BorderRadius.circular(14.0),
                              child: Padding(
                                padding: const EdgeInsets.all(14.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(6.0),
                                      decoration: BoxDecoration(
                                        color: theme.primary.withOpacity(0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.check_circle_outline_rounded,
                                        color: theme.primary,
                                        size: 18.0,
                                      ),
                                    ),
                                    const SizedBox(width: 12.0),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.title,
                                            style: theme.bodyMedium.override(
                                                  font: GoogleFonts.inter(
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: 0.0,
                                                ),
                                          ),
                                          const SizedBox(height: 4.0),
                                          Text(
                                            item.summary,
                                            style: theme.bodySmall.override(
                                                  font: GoogleFonts.inter(),
                                                  color: theme.secondaryText,
                                                  fontSize: 12.0,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Icon(
                                      isExpanded
                                          ? Icons.keyboard_arrow_up_rounded
                                          : Icons.keyboard_arrow_down_rounded,
                                      color: theme.secondaryText,
                                      size: 22.0,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (isExpanded) ...[
                              const Divider(height: 1.0),
                              Padding(
                                padding: const EdgeInsets.all(14.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Recommended Troubleshooting Steps:',
                                      style: theme.bodySmall.override(
                                            font: GoogleFonts.inter(
                                              fontWeight: FontWeight.bold,
                                            ),
                                            color: theme.primary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    const SizedBox(height: 8.0),
                                    ...item.steps.map(
                                      (step) => Padding(
                                        padding: const EdgeInsets.only(bottom: 6.0),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '• ',
                                              style: TextStyle(
                                                color: theme.primary,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                step,
                                                style: theme.bodySmall.override(
                                                      font: GoogleFonts.inter(),
                                                      color: theme.primaryText,
                                                      fontSize: 12.0,
                                                      lineHeight: 1.4,
                                                    ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    if (item.actionLabel != null && item.onAction != null) ...[
                                      const SizedBox(height: 10.0),
                                      SizedBox(
                                        width: double.infinity,
                                        child: FFButtonWidget(
                                          onPressed: item.onAction!,
                                          text: item.actionLabel!,
                                          options: FFButtonOptions(
                                            height: 36.0,
                                            color: theme.primary,
                                            textStyle: theme.titleSmall.override(
                                                  font: GoogleFonts.inter(
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  color: Colors.white,
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                            elevation: 0.0,
                                            borderRadius: BorderRadius.circular(8.0),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
          ),

          // Bottom Human Escalation Bar
          Container(
            padding:
                EdgeInsetsDirectional.fromSTEB(20.0, 12.0, 20.0, 24.0),
            decoration: BoxDecoration(
              color: theme.secondaryBackground,
              border: Border(
                top: BorderSide(
                  color: theme.alternate,
                  width: 1.0,
                ),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      'Still stuck?',
                      style: theme.bodySmall.override(
                            font: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                            ),
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(width: 6.0),
                    Text(
                      'Escalate directly to our support engineers:',
                      style: theme.bodySmall.override(
                            font: GoogleFonts.inter(),
                            color: theme.secondaryText,
                            fontSize: 11.0,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                Row(
                  children: [
                    Expanded(
                      child: FFButtonWidget(
                        onPressed: () {
                          Navigator.pop(context);
                          context.pushNamed(ChatWidget.routeName);
                        },
                        text: 'Live Chat',
                        icon: const Icon(Icons.chat_bubble_outline_rounded, size: 16.0),
                        options: FFButtonOptions(
                          height: 40.0,
                          color: theme.primaryBackground,
                          textStyle: theme.bodySmall.override(
                                font: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                ),
                                color: theme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                          borderSide: BorderSide(
                            color: theme.primary,
                            width: 1.2,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12.0),
                    Expanded(
                      child: FFButtonWidget(
                        onPressed: _launchWhatsApp,
                        text: 'WhatsApp',
                        icon: const Icon(Icons.message_rounded, size: 16.0),
                        options: FFButtonOptions(
                          height: 40.0,
                          color: const Color(0xFF25D366),
                          textStyle: theme.bodySmall.override(
                                font: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                ),
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
