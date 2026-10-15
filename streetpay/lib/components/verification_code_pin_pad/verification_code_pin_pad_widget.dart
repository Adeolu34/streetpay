import '/components/circle_digit_key/circle_digit_key_widget.dart';
import '/components/circled_icon_key/circled_icon_key_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'verification_code_pin_pad_model.dart';
export 'verification_code_pin_pad_model.dart';

class VerificationCodePinPadWidget extends StatefulWidget {
  const VerificationCodePinPadWidget({
    super.key,
    String? instruction,
    required this.onPinCompleted,
    int? limit,
    bool? showInstruction,
  })  : this.instruction = instruction ?? '[instruction]',
        this.limit = limit ?? 6,
        this.showInstruction = showInstruction ?? true;

  final String instruction;
  final Future Function(String pin)? onPinCompleted;
  final int limit;
  final bool showInstruction;

  @override
  State<VerificationCodePinPadWidget> createState() =>
      _VerificationCodePinPadWidgetState();
}

class _VerificationCodePinPadWidgetState
    extends State<VerificationCodePinPadWidget> {
  late VerificationCodePinPadModel _model;


  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => VerificationCodePinPadModel());

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
        PinCodeTextField(
          autoDisposeControllers: false,
          appContext: context,
          length: widget.limit,
          textStyle: FlutterFlowTheme.of(context).bodyLarge.override(
                font: GoogleFonts.inter(
                  fontWeight: FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                ),
                color: FlutterFlowTheme.of(context).primaryText,
                letterSpacing: 0.0,
                fontWeight: FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
              ),
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          enableActiveFill: true,
          autoFocus: true,
          focusNode: _model.pinCodeFocusNode,
          enablePinAutofill: false,
          errorTextSpace: 0.0,
          showCursor: true,
          cursorColor: FlutterFlowTheme.of(context).primary,
          obscureText: false,
          hintCharacter: '-',
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          pinTheme: PinTheme(
            fieldHeight: 44.0,
            fieldWidth: 44.0,
            borderWidth: 0.0,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(12.0),
              bottomRight: Radius.circular(12.0),
              topLeft: Radius.circular(12.0),
              topRight: Radius.circular(12.0),
            ),
            shape: PinCodeFieldShape.box,
            activeColor: FlutterFlowTheme.of(context).primaryText,
            inactiveColor: Color(0xFFC4C4C4),
            selectedColor: FlutterFlowTheme.of(context).primary,
            activeFillColor: Colors.white,
            inactiveFillColor: Colors.white,
            selectedFillColor: Colors.white,
          ),
          controller: _model.pinCodeController,
          onChanged: (_) {},
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: _model.pinCodeControllerValidator.asValidator(context),
        ),
        if (widget.showInstruction)
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
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
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0.0, 48.0, 0.0, 0.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      safeSetState(() {
                        _model.pinCodeController?.text =
                            functions.appendPinCodeDigit(
                                _model.pinCodeController!.text,
                                '1',
                                widget.limit);
                      });
                    },
                    child: wrapWithModel(
                      model: _model.circleDigitKeyModel1,
                      updateCallback: () => safeSetState(() {}),
                      child: CircleDigitKeyWidget(
                        digit: 1,
                      ),
                    ),
                  ),
                  InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      safeSetState(() {
                        _model.pinCodeController?.text =
                            functions.appendPinCodeDigit(
                                _model.pinCodeController!.text,
                                '2',
                                widget.limit);
                      });
                    },
                    child: wrapWithModel(
                      model: _model.circleDigitKeyModel2,
                      updateCallback: () => safeSetState(() {}),
                      child: CircleDigitKeyWidget(
                        digit: 2,
                      ),
                    ),
                  ),
                  InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      safeSetState(() {
                        _model.pinCodeController?.text =
                            functions.appendPinCodeDigit(
                                _model.pinCodeController!.text,
                                '3',
                                widget.limit);
                      });
                    },
                    child: wrapWithModel(
                      model: _model.circleDigitKeyModel3,
                      updateCallback: () => safeSetState(() {}),
                      child: CircleDigitKeyWidget(
                        digit: 3,
                      ),
                    ),
                  ),
                ].divide(SizedBox(width: 40.0)),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      safeSetState(() {
                        _model.pinCodeController?.text =
                            functions.appendPinCodeDigit(
                                _model.pinCodeController!.text,
                                '4',
                                widget.limit);
                      });
                    },
                    child: wrapWithModel(
                      model: _model.circleDigitKeyModel4,
                      updateCallback: () => safeSetState(() {}),
                      child: CircleDigitKeyWidget(
                        digit: 4,
                      ),
                    ),
                  ),
                  InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      safeSetState(() {
                        _model.pinCodeController?.text =
                            functions.appendPinCodeDigit(
                                _model.pinCodeController!.text,
                                '5',
                                widget.limit);
                      });
                    },
                    child: wrapWithModel(
                      model: _model.circleDigitKeyModel5,
                      updateCallback: () => safeSetState(() {}),
                      child: CircleDigitKeyWidget(
                        digit: 5,
                      ),
                    ),
                  ),
                  InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      safeSetState(() {
                        _model.pinCodeController?.text =
                            functions.appendPinCodeDigit(
                                _model.pinCodeController!.text,
                                '6',
                                widget.limit);
                      });
                    },
                    child: wrapWithModel(
                      model: _model.circleDigitKeyModel6,
                      updateCallback: () => safeSetState(() {}),
                      child: CircleDigitKeyWidget(
                        digit: 6,
                      ),
                    ),
                  ),
                ].divide(SizedBox(width: 40.0)),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      safeSetState(() {
                        _model.pinCodeController?.text =
                            functions.appendPinCodeDigit(
                                _model.pinCodeController!.text,
                                '7',
                                widget.limit);
                      });
                    },
                    child: wrapWithModel(
                      model: _model.circleDigitKeyModel7,
                      updateCallback: () => safeSetState(() {}),
                      child: CircleDigitKeyWidget(
                        digit: 7,
                      ),
                    ),
                  ),
                  InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      safeSetState(() {
                        _model.pinCodeController?.text =
                            functions.appendPinCodeDigit(
                                _model.pinCodeController!.text,
                                '8',
                                widget.limit);
                      });
                    },
                    child: wrapWithModel(
                      model: _model.circleDigitKeyModel8,
                      updateCallback: () => safeSetState(() {}),
                      child: CircleDigitKeyWidget(
                        digit: 8,
                      ),
                    ),
                  ),
                  InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      safeSetState(() {
                        _model.pinCodeController?.text =
                            functions.appendPinCodeDigit(
                                _model.pinCodeController!.text,
                                '9',
                                widget.limit);
                      });
                    },
                    child: wrapWithModel(
                      model: _model.circleDigitKeyModel9,
                      updateCallback: () => safeSetState(() {}),
                      child: CircleDigitKeyWidget(
                        digit: 9,
                      ),
                    ),
                  ),
                ].divide(SizedBox(width: 40.0)),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      await widget.onPinCompleted?.call(
                        _model.pinCodeController!.text,
                      );
                    },
                    child: wrapWithModel(
                      model: _model.circledIconKeyModel1,
                      updateCallback: () => safeSetState(() {}),
                      updateOnChange: true,
                      child: CircledIconKeyWidget(
                        icon: Icon(
                          Icons.check_outlined,
                          color: FlutterFlowTheme.of(context).primaryText,
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      safeSetState(() {
                        _model.pinCodeController?.text =
                            functions.appendPinCodeDigit(
                                _model.pinCodeController!.text,
                                '0',
                                widget.limit);
                      });
                    },
                    child: wrapWithModel(
                      model: _model.circleDigitKeyModel10,
                      updateCallback: () => safeSetState(() {}),
                      child: CircleDigitKeyWidget(
                        digit: 0,
                      ),
                    ),
                  ),
                  InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      safeSetState(() {
                        _model.pinCodeController?.text = functions
                            .removeLastChar(_model.pinCodeController!.text);
                      });
                    },
                    child: wrapWithModel(
                      model: _model.circledIconKeyModel2,
                      updateCallback: () => safeSetState(() {}),
                      child: CircledIconKeyWidget(
                        icon: Icon(
                          Icons.backspace_rounded,
                          color: FlutterFlowTheme.of(context).primaryText,
                        ),
                      ),
                    ),
                  ),
                ].divide(SizedBox(width: 40.0)),
              ),
            ].divide(SizedBox(height: 28.0)),
          ),
        ),
      ],
    );
  }
}
