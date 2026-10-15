import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'billerinput_model.dart';
export 'billerinput_model.dart';

class BillerinputWidget extends StatefulWidget {
  const BillerinputWidget({
    super.key,
    this.label,
    this.description,
  });

  final String? label;
  final String? description;

  @override
  State<BillerinputWidget> createState() => _BillerinputWidgetState();
}

class _BillerinputWidgetState extends State<BillerinputWidget> {
  late BillerinputModel _model;


  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BillerinputModel());

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _model.textController,
      focusNode: _model.textFieldFocusNode,
      onChanged: (_) => EasyDebounce.debounce(
        '_model.textController',
        Duration(milliseconds: 2000),
        () async {
          FFAppState().customerid =
              widget.label == 'customerId' ? _model.textController.text : '';
          FFAppState().billphone =
              widget.label == 'customerName' ? _model.textController.text : '';
          FFAppState().billemail =
              widget.label == 'otherField' ? _model.textController.text : '';
          safeSetState(() {});
        },
      ),
      autofocus: false,
      obscureText: false,
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: FlutterFlowTheme.of(context).bodyMedium.override(
              font: GoogleFonts.inter(
                fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
              ),
              letterSpacing: 0.0,
              fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
              fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
            ),
        hintText: widget.description,
        hintStyle: FlutterFlowTheme.of(context).bodyMedium.override(
              font: GoogleFonts.inter(
                fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
              ),
              letterSpacing: 0.0,
              fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
              fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
            ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: FlutterFlowTheme.of(context).primary,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: FlutterFlowTheme.of(context).primary,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: FlutterFlowTheme.of(context).secondary,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: FlutterFlowTheme.of(context).secondary,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        filled: true,
        fillColor: FlutterFlowTheme.of(context).primaryBackground,
      ),
      style: FlutterFlowTheme.of(context).bodyLarge.override(
            font: GoogleFonts.inter(
              fontWeight: FlutterFlowTheme.of(context).bodyLarge.fontWeight,
              fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
            ),
            letterSpacing: 0.0,
            fontWeight: FlutterFlowTheme.of(context).bodyLarge.fontWeight,
            fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
          ),
      minLines: 1,
      validator: _model.textControllerValidator.asValidator(context),
    );
  }
}
