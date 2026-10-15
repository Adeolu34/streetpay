import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'pin_pad_model.dart';
export 'pin_pad_model.dart';

class PinPadWidget extends StatefulWidget {
  const PinPadWidget({
    super.key,
    String? instruction,
    required this.onPinCompleted,
    int? limit,
    bool? showInstruction,
  })  : this.instruction = instruction ?? '[instruction]',
        this.limit = limit ?? 5,
        this.showInstruction = showInstruction ?? true;

  final String instruction;
  final Future Function(String pin)? onPinCompleted;
  final int limit;
  final bool showInstruction;

  @override
  State<PinPadWidget> createState() => _PinPadWidgetState();
}

class _PinPadWidgetState extends State<PinPadWidget> {
  late PinPadModel _model;


  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PinPadModel());

    _model.pinCodeFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(64.0, 0.0, 64.0, 0.0),
          child: PinCodeTextField(
            autoDisposeControllers: false,
            appContext: context,
            length: widget.limit,
            textStyle: FlutterFlowTheme.of(context).bodyLarge.override(
                  font: GoogleFonts.inter(
                    fontWeight:
                        FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                    fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                  ),
                  color: FlutterFlowTheme.of(context).primary,
                  letterSpacing: 0.0,
                  fontWeight: FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                ),
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            enableActiveFill: true,
            autoFocus: false,
            focusNode: _model.pinCodeFocusNode,
            enablePinAutofill: true,
            errorTextSpace: 0.0,
            showCursor: false,
            cursorColor: FlutterFlowTheme.of(context).primary,
            obscureText: true,
            obscuringCharacter: '●',
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            pinTheme: PinTheme(
              fieldHeight: 20.0,
              fieldWidth: 20.0,
              borderWidth: 1.0,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(1.0),
                bottomRight: Radius.circular(1.0),
                topLeft: Radius.circular(1.0),
                topRight: Radius.circular(1.0),
              ),
              shape: PinCodeFieldShape.circle,
              activeColor: FlutterFlowTheme.of(context).primary,
              inactiveColor: FlutterFlowTheme.of(context).primaryText,
              selectedColor: FlutterFlowTheme.of(context).primary,
              activeFillColor: FlutterFlowTheme.of(context).primary,
              inactiveFillColor: Colors.transparent,
              selectedFillColor: FlutterFlowTheme.of(context).primary,
            ),
            controller: _model.pinCodeController,
            onChanged: (_) {},
            onCompleted: (pin) async {
              await widget.onPinCompleted?.call(pin);
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: _model.pinCodeControllerValidator.asValidator(context),
          ),
        ),
        if (widget.showInstruction)
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
            child: InkWell(
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () async {
                await widget.onPinCompleted
                    ?.call(_model.pinCodeController?.text ?? '');
              },
              child: Text(
                widget.instruction,
                textAlign: TextAlign.center,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                      color: FlutterFlowTheme.of(context).primary,
                      fontSize: 12.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w600,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                    ),
              ),
            ),
          ),
      ],
    );
  }
}
