import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'wallet_balance_text_model.dart';
export 'wallet_balance_text_model.dart';

class WalletBalanceTextWidget extends StatefulWidget {
  const WalletBalanceTextWidget({
    super.key,
    String? balance,
  }) : this.balance = balance ?? '[balance]';

  final String balance;

  @override
  State<WalletBalanceTextWidget> createState() =>
      _WalletBalanceTextWidgetState();
}

class _WalletBalanceTextWidgetState extends State<WalletBalanceTextWidget> {
  late WalletBalanceTextModel _model;


  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => WalletBalanceTextModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'WALLET  BALANCE',
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                font: GoogleFonts.inter(
                  fontWeight: FontWeight.normal,
                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                ),
                color: Colors.white,
                fontSize: 12.0,
                letterSpacing: 0.0,
                fontWeight: FontWeight.normal,
                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
              ),
        ),
        Text(
          widget.balance,
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                font: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                ),
                color: Colors.white,
                fontSize: 30.0,
                letterSpacing: 0.0,
                fontWeight: FontWeight.w600,
                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
              ),
        ),
      ],
    );
  }
}
