import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'grantaccess_model.dart';
export 'grantaccess_model.dart';

class GrantaccessWidget extends StatefulWidget {
  const GrantaccessWidget({
    super.key,
    required this.hostno,
  });

  final String? hostno;

  @override
  State<GrantaccessWidget> createState() => _GrantaccessWidgetState();
}

class _GrantaccessWidgetState extends State<GrantaccessWidget> {
  late GrantaccessModel _model;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => GrantaccessModel());

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  Future<void> _grantAccess() async {
    final guestPhone = _model.textController?.text.trim() ?? '';
    if (guestPhone.isEmpty || guestPhone.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please enter a valid guest phone number (at least 10 digits)',
            style: GoogleFonts.plusJakartaSans(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: const Color(0xFFC93B2B),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final rawHost = (widget.hostno != null && widget.hostno!.isNotEmpty)
          ? widget.hostno!
          : FFAppState().phonenumber;
      final cleanHost = functions.removecode(rawHost) ?? rawHost;
      final cleanGuest = functions.removecode(guestPhone) ?? guestPhone;

      String token = (FFAppState().bsptoken.isNotEmpty)
          ? FFAppState().bsptoken
          : (FFAppState().streetauth.isNotEmpty ? FFAppState().streetauth : '');
      if (token.isEmpty) {
        _model.streetauth = await StreetauthCall.call();
        token = StreetauthCall.streettoken(
              (_model.streetauth?.jsonBody ?? ''),
            ) ??
            '';
      }

      _model.apiResultg8l = await GrantaccessCall.call(
        hostno: cleanHost,
        guestno: cleanGuest,
        accessToken: token,
      );

      final isSuccess = GrantaccessCall.status(
            (_model.apiResultg8l?.jsonBody ?? ''),
          ) ==
          true;

      final message = GrantaccessCall.message(
            (_model.apiResultg8l?.jsonBody ?? ''),
          ) ??
          (isSuccess
              ? 'Access granted successfully!'
              : 'Unable to grant access. Please try again.');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              message,
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            duration: const Duration(milliseconds: 3500),
            backgroundColor:
                isSuccess ? const Color(0xFF2F8F3C) : const Color(0xFFC93B2B),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
          ),
        );

        if (isSuccess) {
          _model.textController?.clear();
          context.pushNamed(
            GrantAccessWidget.routeName,
            queryParameters: {
              'phoneno': serializeParam(
                cleanHost,
                ParamType.String,
              ),
            }.withoutNulls,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'An error occurred: $e',
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            backgroundColor: const Color(0xFFC93B2B),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: const Color(0xFFE6EAE7)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44.0,
                height: 44.0,
                decoration: BoxDecoration(
                  color: const Color(0xFFEDF7EE),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: const Icon(
                  Icons.person_add_alt_1_rounded,
                  color: Color(0xFF2F8F3C),
                  size: 22.0,
                ),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Grant Staff Access',
                      style: GoogleFonts.plusJakartaSans(
                        color: const Color(0xFF0B2018),
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2.0),
                    Text(
                      'Authorize cashier to accept payments & view sales',
                      style: GoogleFonts.plusJakartaSans(
                        color: const Color(0xFF6B7F72),
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18.0),
          Text(
            'STAFF PHONE NUMBER',
            style: GoogleFonts.plusJakartaSans(
              color: const Color(0xFF8FA596),
              fontSize: 11.0,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 8.0),
          Container(
            height: 52.0,
            decoration: BoxDecoration(
              color: const Color(0xFFF6F8F6),
              borderRadius: BorderRadius.circular(14.0),
              border: Border.all(color: const Color(0xFFE6EAE7)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    children: [
                      const Text('🇳🇬', style: TextStyle(fontSize: 18.0)),
                      const SizedBox(width: 6.0),
                      Text(
                        '+234',
                        style: GoogleFonts.plusJakartaSans(
                          color: const Color(0xFF0B2018),
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Container(
                        width: 1.0,
                        height: 24.0,
                        color: const Color(0xFFD0D7D2),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _model.textController,
                    focusNode: _model.textFieldFocusNode,
                    keyboardType: TextInputType.phone,
                    maxLength: 13,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    buildCounter: (context,
                            {required currentLength,
                            required isFocused,
                            maxLength}) =>
                        null,
                    style: GoogleFonts.plusJakartaSans(
                      color: const Color(0xFF0B2018),
                      fontSize: 15.0,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: InputDecoration(
                      hintText: '801 234 5678',
                      hintStyle: GoogleFonts.plusJakartaSans(
                        color: const Color(0xFF9AA79E),
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 14.0),
                    ),
                  ),
                ),
                if ((_model.textController?.text.isNotEmpty ?? false))
                  IconButton(
                    icon: const Icon(Icons.clear_rounded,
                        color: Color(0xFF8FA596), size: 18.0),
                    onPressed: () {
                      _model.textController?.clear();
                      setState(() {});
                    },
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16.0),
          SizedBox(
            width: double.infinity,
            height: 50.0,
            child: ElevatedButton(
              onPressed: _isSubmitting ? null : _grantAccess,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0B2018),
                disabledBackgroundColor:
                    const Color(0xFF0B2018).withValues(alpha: 0.6),
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.0),
                ),
              ),
              child: _isSubmitting
                  ? const SizedBox(
                      width: 22.0,
                      height: 22.0,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.2,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.check_circle_outline_rounded,
                          color: Color(0xFF56B84B),
                          size: 18.0,
                        ),
                        const SizedBox(width: 8.0),
                        Flexible(
                          child: Text(
                            'Grant Cashier Access',
                            style: GoogleFonts.plusJakartaSans(
                              color: Colors.white,
                              fontSize: 14.5,
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
