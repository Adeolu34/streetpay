import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'pin_code_setup_model.dart';
export 'pin_code_setup_model.dart';

class PinCodeSetupWidget extends StatefulWidget {
  const PinCodeSetupWidget({
    super.key,
    String? phoneNumber,
    required this.registerwith,
    this.bvn,
    this.nin,
    bool? isface,
  })  : this.phoneNumber = phoneNumber ?? '+234 ### ### ####',
        this.isface = isface ?? false;

  final String phoneNumber;
  final String? registerwith;
  final String? bvn;
  final String? nin;
  final bool isface;

  static String routeName = 'PinCodeSetup';
  static String routePath = '/pinCodeSetup';

  @override
  State<PinCodeSetupWidget> createState() => _PinCodeSetupWidgetState();
}

class _PinCodeSetupWidgetState extends State<PinCodeSetupWidget> {
  late PinCodeSetupModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = false;
  String _errorMessage = '';

  // PIN confirmation state machine
  bool _isConfirmStep = false;
  String _firstPin = '';
  final _confirmController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PinCodeSetupModel());
    _model.pinCodeController ??= TextEditingController();
    _model.pinCodeFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _confirmController.dispose();
    _model.dispose();
    super.dispose();
  }

  TextEditingController get _activeController =>
      _isConfirmStep ? _confirmController : (_model.pinCodeController ?? _confirmController);

  void _onKeyPressed(String val) {
    if (_isLoading) return;
    final currentText = _activeController.text;
    if (currentText.length < 5) {
      HapticFeedback.lightImpact();
      final newText = currentText + val;
      _activeController.text = newText;
      setState(() => _errorMessage = '');

      if (newText.length == 5) {
        if (!_isConfirmStep) {
          // Move to confirmation step
          setState(() {
            _firstPin = newText;
            _isConfirmStep = true;
          });
        } else {
          // Validate confirmation matches
          if (newText == _firstPin) {
            _submitPin(newText);
          } else {
            HapticFeedback.heavyImpact();
            setState(() {
              _errorMessage = 'PINs do not match. Please start over.';
              _isConfirmStep = false;
              _firstPin = '';
              _model.pinCodeController?.clear();
              _confirmController.clear();
            });
          }
        }
      }
    }
  }

  void _onDeletePressed() {
    if (_isLoading) return;
    final currentText = _activeController.text;
    if (currentText.isNotEmpty) {
      HapticFeedback.lightImpact();
      _activeController.text = currentText.substring(0, currentText.length - 1);
      setState(() => _errorMessage = '');
    }
  }

  Future<void> _submitPin(String pin) async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      _model.apiResultx7t = await SetpincodeCall.call(
        phoneno: widget.phoneNumber,
        pincode: pin,
        accessToken: FFAppState().streetauth,
      );

      final isSuccess = SetpincodeCall.status(_model.apiResultx7t?.jsonBody ?? '') == true;

      if (!mounted) return;

      if (isSuccess) {
        if (widget.isface == false) {
          context.pushNamed(
            OpenwalletWidget.routeName,
            queryParameters: {
              'openwith': serializeParam(
                widget.registerwith,
                ParamType.String,
              ),
              'phone': serializeParam(
                widget.phoneNumber,
                ParamType.String,
              ),
              'bvn': serializeParam(
                widget.bvn,
                ParamType.String,
              ),
              'nin': serializeParam(
                widget.nin,
                ParamType.String,
              ),
            }.withoutNulls,
          );
        } else {
          context.pushNamed(
            FaceverifyWidget.routeName,
            queryParameters: {
              'phone': serializeParam(
                functions.removecode(widget.phoneNumber),
                ParamType.String,
              ),
              'registerwith': serializeParam(
                widget.registerwith,
                ParamType.String,
              ),
            }.withoutNulls,
          );
        }
      } else {
        setState(() {
          _errorMessage = 'Could not set PIN code. Please try again.';
          _model.pinCodeController?.clear();
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Network error. Please try again.';
          _model.pinCodeController?.clear();
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildKeypadButton(String label, {VoidCallback? onTap, Widget? child}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.0),
        splashColor: const Color(0x3056B84B),
        highlightColor: const Color(0x2056B84B),
        child: Container(
          height: 52.0,
          decoration: BoxDecoration(
            color: const Color(0xFF112B20),
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(color: const Color(0xFF1E4230), width: 0.8),
          ),
          alignment: Alignment.center,
          child: child ??
              Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 21.0,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();
    final enteredPin = _activeController.text;

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: const Color(0xFF0B2018),
      body: SafeArea(
        child: Column(
          children: [
            // Top navigation & step indicator
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 14.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (_isConfirmStep) {
                        // Go back to entry step
                        setState(() {
                          _isConfirmStep = false;
                          _firstPin = '';
                          _confirmController.clear();
                          _errorMessage = '';
                        });
                      } else {
                        context.pop();
                      }
                    },
                    child: Container(
                      width: 36.0,
                      height: 36.0,
                      decoration: const BoxDecoration(
                        color: Color(0xFF152F23),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.chevron_left_rounded,
                        color: Color(0xFFCFE3D6),
                        size: 22.0,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isConfirmStep ? 'Confirm your PIN' : 'Set your PIN',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 15.5,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2.0),
                      Text(
                        'Step 5 of 5 · security',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF8FA596),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Main PIN entry content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 26.0),
                child: Column(
                  children: [
                    const SizedBox(height: 18.0),
                    // Lock icon container
                    Container(
                      width: 56.0,
                      height: 56.0,
                      decoration: BoxDecoration(
                        color: const Color(0xFF12362A),
                        borderRadius: BorderRadius.circular(18.0),
                        border: Border.all(
                          color: const Color(0xFF2C6045),
                          width: 1.2,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        _isConfirmStep
                            ? Icons.lock_rounded
                            : Icons.lock_outline_rounded,
                        color: const Color(0xFF7FD472),
                        size: 26.0,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Text(
                      _isConfirmStep ? 'Confirm your 5-digit PIN' : 'Create a 5-digit PIN',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 22.0,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.6,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        _isConfirmStep
                            ? 'Enter your PIN again to confirm it.'
                            : 'You will use it for every payment. Do not use your birth year or 12345.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13.0,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF8FA596),
                          height: 1.55,
                        ),
                      ),
                    ),
                    const SizedBox(height: 26.0),

                    // 5 PIN Digit Boxes
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        final isFilled = index < enteredPin.length;
                        final isCurrent = index == enteredPin.length;
                        return Container(
                          width: 50.0,
                          height: 62.0,
                          margin: const EdgeInsets.symmetric(horizontal: 5.5),
                          decoration: BoxDecoration(
                            color: const Color(0xFF112B20),
                            borderRadius: BorderRadius.circular(15.0),
                            border: Border.all(
                              color: isFilled
                                  ? const Color(0xFF56B84B)
                                  : isCurrent
                                      ? const Color(0x997FD472)
                                      : const Color(0xFF1E4230),
                              width: isFilled || isCurrent ? 1.5 : 1.0,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: isFilled
                              ? Container(
                                  width: 12.0,
                                  height: 12.0,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF56B84B),
                                    shape: BoxShape.circle,
                                  ),
                                )
                              : null,
                        );
                      }),
                    ),
                    const SizedBox(height: 18.0),

                    // Feedback or hint message
                    if (_isLoading)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 16.0,
                            height: 16.0,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.0,
                              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF7FD472)),
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Text(
                            'Securing your account...',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF7FD472),
                            ),
                          ),
                        ],
                      )
                    else if (_errorMessage.isNotEmpty)
                      Text(
                        _errorMessage,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFFFF6B6B),
                        ),
                      )
                    else
                      Text(
                        'Keep your PIN safe · Never share it',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF7FD472),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // On-screen 3x4 Keypad
            Padding(
              padding: const EdgeInsets.only(left: 14.0, right: 14.0, bottom: 20.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: _buildKeypadButton('1', onTap: () => _onKeyPressed('1'))),
                      const SizedBox(width: 6.0),
                      Expanded(child: _buildKeypadButton('2', onTap: () => _onKeyPressed('2'))),
                      const SizedBox(width: 6.0),
                      Expanded(child: _buildKeypadButton('3', onTap: () => _onKeyPressed('3'))),
                    ],
                  ),
                  const SizedBox(height: 6.0),
                  Row(
                    children: [
                      Expanded(child: _buildKeypadButton('4', onTap: () => _onKeyPressed('4'))),
                      const SizedBox(width: 6.0),
                      Expanded(child: _buildKeypadButton('5', onTap: () => _onKeyPressed('5'))),
                      const SizedBox(width: 6.0),
                      Expanded(child: _buildKeypadButton('6', onTap: () => _onKeyPressed('6'))),
                    ],
                  ),
                  const SizedBox(height: 6.0),
                  Row(
                    children: [
                      Expanded(child: _buildKeypadButton('7', onTap: () => _onKeyPressed('7'))),
                      const SizedBox(width: 6.0),
                      Expanded(child: _buildKeypadButton('8', onTap: () => _onKeyPressed('8'))),
                      const SizedBox(width: 6.0),
                      Expanded(child: _buildKeypadButton('9', onTap: () => _onKeyPressed('9'))),
                    ],
                  ),
                  const SizedBox(height: 6.0),
                  Row(
                    children: [
                      const Expanded(child: SizedBox(height: 52.0)),
                      const SizedBox(width: 6.0),
                      Expanded(child: _buildKeypadButton('0', onTap: () => _onKeyPressed('0'))),
                      const SizedBox(width: 6.0),
                      Expanded(
                        child: _buildKeypadButton(
                          '',
                          onTap: _onDeletePressed,
                          child: const Icon(
                            Icons.backspace_outlined,
                            color: Color(0xFFCFE3D6),
                            size: 22.0,
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
      ),
    );
  }
}
