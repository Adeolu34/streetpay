import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'emptylistaccess_model.dart';
export 'emptylistaccess_model.dart';

class EmptylistaccessWidget extends StatefulWidget {
  const EmptylistaccessWidget({
    super.key,
    this.title,
    this.message,
    this.icon,
  });

  final String? title;
  final String? message;
  final IconData? icon;

  @override
  State<EmptylistaccessWidget> createState() => _EmptylistaccessWidgetState();
}

class _EmptylistaccessWidgetState extends State<EmptylistaccessWidget> {
  late EmptylistaccessModel _model;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => EmptylistaccessModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 36.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: const Color(0xFFE6EAE7)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 64.0,
            height: 64.0,
            decoration: const BoxDecoration(
              color: Color(0xFFEDF7EE),
              shape: BoxShape.circle,
            ),
            child: Icon(
              widget.icon ?? Icons.supervisor_account_outlined,
              color: const Color(0xFF2F8F3C),
              size: 32.0,
            ),
          ),
          const SizedBox(height: 16.0),
          Text(
            widget.title ?? 'No access granted yet',
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              color: const Color(0xFF0B2018),
              fontSize: 16.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6.0),
          Text(
            widget.message ?? 'Staff members or delegated accounts will appear here once added.',
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              color: const Color(0xFF6B7F72),
              fontSize: 13.0,
              fontWeight: FontWeight.w400,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
