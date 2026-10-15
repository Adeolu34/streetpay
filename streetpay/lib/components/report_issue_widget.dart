import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ReportIssueWidget extends StatefulWidget {
  const ReportIssueWidget({super.key, this.transactionRef});

  final String? transactionRef;

  @override
  State<ReportIssueWidget> createState() => _ReportIssueWidgetState();
}

class _ReportIssueWidgetState extends State<ReportIssueWidget> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _selectedCategory = 'Payment Failed';
  bool _isSending = false;
  bool _needsEmail = false;

  static const _categories = [
    'Payment Failed',
    'Wrong Amount Deducted',
    'Unauthorized Transaction',
    'Transfer Not Received',
    'App Bug / Error',
    'Account Issue',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    final appEmail = FFAppState().email;
    _needsEmail = appEmail.trim().isEmpty;
    if (!_needsEmail) {
      _emailController.text = appEmail.trim();
    }
    if (widget.transactionRef != null) {
      _subjectController.text = 'Issue with transaction ${widget.transactionRef}';
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _subjectController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _isSending = true);

    final userEmail = _emailController.text.trim();
    final subject = _subjectController.text.trim();
    final description = _descriptionController.text.trim();
    final phone = FFAppState().phonenumber;
    final account = FFAppState().accountno;
    final ref = widget.transactionRef ?? 'N/A';

    final body = '''
Category: $_selectedCategory
Subject: $subject

Description:
$description

---
User Email: $userEmail
Phone: $phone
Account: $account
Transaction Ref: $ref
''';

    final uri = Uri(
      scheme: 'mailto',
      path: 'ask@streetpayng.com',
      query: 'subject=${Uri.encodeComponent('[StreetPay Issue] $_selectedCategory - $subject')}&body=${Uri.encodeComponent(body)}',
    );

    try {
      final launched = await launchUrl(uri);
      if (mounted) {
        setState(() => _isSending = false);
        if (launched) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Email client opened. Please send the message.',
                style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.w600),
              ),
              backgroundColor: const Color(0xFF1E4230),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Could not open email client. Please email ask@streetpayng.com',
                style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.w600),
              ),
              backgroundColor: const Color(0xFFDC2626),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          );
        }
      }
    } catch (_) {
      if (mounted) setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF6F8F6),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD0D9D1),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Header
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEDF7EE),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      alignment: Alignment.center,
                      child: const Icon(Icons.flag_outlined, color: Color(0xFF2F8F3C), size: 20),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Report an Issue',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF101614),
                          ),
                        ),
                        Text(
                          'We\'ll get back to you within 24 hours',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF6E7A72),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Email field (only if user has no email)
                if (_needsEmail) ...[
                  _label('Your Email'),
                  const SizedBox(height: 6),
                  _textField(
                    controller: _emailController,
                    hint: 'your@email.com',
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Email is required';
                      if (!v.contains('@') || !v.contains('.')) return 'Enter a valid email';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                ],

                // Category
                _label('Issue Category'),
                const SizedBox(height: 6),
                _categoryDropdown(),
                const SizedBox(height: 16),

                // Subject
                _label('Subject'),
                const SizedBox(height: 6),
                _textField(
                  controller: _subjectController,
                  hint: 'Brief summary of the issue',
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter a subject' : null,
                ),
                const SizedBox(height: 16),

                // Description
                _label('Description'),
                const SizedBox(height: 6),
                _textField(
                  controller: _descriptionController,
                  hint: 'Describe what happened in detail…',
                  maxLines: 5,
                  validator: (v) => (v == null || v.trim().length < 10) ? 'Please provide more details' : null,
                ),
                const SizedBox(height: 24),

                // Submit button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isSending ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF56B84B),
                      disabledBackgroundColor: const Color(0xFF56B84B).withValues(alpha: 0.5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    child: _isSending
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : Text(
                            'Send Report',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF06210F),
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 8),
                Center(
                  child: Text(
                    'Sends to ask@streetpayng.com',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      color: const Color(0xFF9EAAA0),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF2B3630),
      ),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF101614),
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.plusJakartaSans(
          fontSize: 13.5,
          fontWeight: FontWeight.w500,
          color: const Color(0xFFABB9B0),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE6EAE7)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE6EAE7)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF56B84B), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFDC2626)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFDC2626), width: 1.5),
        ),
      ),
    );
  }

  Widget _categoryDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE6EAE7)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedCategory,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF6E7A72)),
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF101614),
          ),
          items: _categories.map((cat) {
            return DropdownMenuItem(value: cat, child: Text(cat));
          }).toList(),
          onChanged: (v) {
            if (v != null) setState(() => _selectedCategory = v);
          },
        ),
      ),
    );
  }
}
