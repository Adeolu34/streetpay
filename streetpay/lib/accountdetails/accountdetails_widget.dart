import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'accountdetails_model.dart';
export 'accountdetails_model.dart';

class AccountdetailsWidget extends StatefulWidget {
  const AccountdetailsWidget({super.key});

  static String routeName = 'accountdetails';
  static String routePath = '/accountdetails';

  @override
  State<AccountdetailsWidget> createState() => _AccountdetailsWidgetState();
}

class _AccountdetailsWidgetState extends State<AccountdetailsWidget> {
  late AccountdetailsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AccountdetailsModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.apiResulta2u = await WalletAsAServiceGroup.walletEnquiryCall.call(
        accountNo: FFAppState().accountno,
        authToken: FFAppState().bsptoken,
      );

      FFAppState().accountname = functions
          .stripSlash(WalletAsAServiceGroup.walletEnquiryCall.accountname(
        (_model.apiResulta2u?.jsonBody ?? ''),
      ));
      safeSetState(() {});
    });
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$label copied to clipboard',
          style: GoogleFonts.plusJakartaSans(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: const Color(0xFF2F8F3C),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(milliseconds: 2000),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool copyable = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13.0,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF6E7A72),
            ),
          ),
          Row(
            children: [
              Text(
                value,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF101614),
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
              if (copyable) ...[
                const SizedBox(width: 8.0),
                GestureDetector(
                  onTap: () => _copyToClipboard(value, label),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 3.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEDF7EE),
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    child: Text(
                      'Copy',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF2F8F3C),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56.0,
            height: 56.0,
            decoration: BoxDecoration(
              color: const Color(0xFFEDF7EE),
              borderRadius: BorderRadius.circular(16.0),
            ),
            alignment: Alignment.center,
            child: Icon(
              icon,
              color: const Color(0xFF2F8F3C),
              size: 24.0,
            ),
          ),
          const SizedBox(height: 6.0),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF101614),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    final accountName = FFAppState().accountname.isNotEmpty
        ? FFAppState().accountname
        : 'Loading...';
    final accountNo = FFAppState().accountno.isNotEmpty
        ? FFAppState().accountno
        : '—';
    final tier = FFAppState().tier.isNotEmpty ? FFAppState().tier : '1';
    final userInitials = accountName.trim().isNotEmpty
        ? accountName
            .trim()
            .split(RegExp(r'\s+'))
            .take(2)
            .map((s) => s.isNotEmpty ? s[0].toUpperCase() : '')
            .join()
        : 'SP';

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: PopScope(
        canPop: false,
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: const Color(0xFFF6F8F6),
          body: Stack(
            children: [
              // Dark green header
              Container(
                width: double.infinity,
                height: 220.0,
                decoration: const BoxDecoration(
                  color: Color(0xFF0B2018),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(26.0),
                    bottomRight: Radius.circular(26.0),
                  ),
                ),
              ),

              SafeArea(
                child: SingleChildScrollView(
                  controller: _model.columnController,
                  padding: const EdgeInsets.only(bottom: 36.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // App Bar
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 16.0),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () => context.safePop(),
                              child: Container(
                                width: 40.0,
                                height: 40.0,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF152F23),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                alignment: Alignment.center,
                                child: const Icon(
                                  Icons.arrow_back_rounded,
                                  color: Color(0xFFCFE3D6),
                                  size: 20.0,
                                ),
                              ),
                            ),
                            const SizedBox(width: 14.0),
                            Text(
                              'Account Details',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: -0.3,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Avatar + Name Card
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFF12362A),
                                Color(0xFF0F2A20),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(22.0),
                            border: Border.all(
                              color: const Color(0xFF22513A),
                              width: 1.0,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 56.0,
                                height: 56.0,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF56B84B)
                                      .withValues(alpha: 0.2),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color(0xFF56B84B)
                                        .withValues(alpha: 0.4),
                                    width: 2.0,
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  userInitials,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w800,
                                    color: const Color(0xFF7FD472),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      accountName,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                        letterSpacing: -0.2,
                                      ),
                                    ),
                                    const SizedBox(height: 4.0),
                                    Text(
                                      'StreetPay · 9PSB',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF8FB3A0),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 5.0),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF56B84B)
                                      .withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(8.0),
                                  border: Border.all(
                                    color: const Color(0xFF56B84B)
                                        .withValues(alpha: 0.3),
                                    width: 1.0,
                                  ),
                                ),
                                child: Text(
                                  'Tier $tier',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11.0,
                                    fontWeight: FontWeight.w800,
                                    color: const Color(0xFF7FD472),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20.0),

                      // Account Information Card
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.0),
                            border: Border.all(
                              color: const Color(0xFFE6EAE7),
                              width: 1.0,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x060B2018),
                                blurRadius: 12.0,
                                offset: Offset(0.0, 4.0),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 36.0,
                                    height: 36.0,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEDF7EE),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    alignment: Alignment.center,
                                    child: const Icon(
                                      Icons.account_balance_wallet_outlined,
                                      color: Color(0xFF2F8F3C),
                                      size: 18.0,
                                    ),
                                  ),
                                  const SizedBox(width: 10.0),
                                  Text(
                                    'Account Information',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w800,
                                      color: const Color(0xFF101614),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16.0),
                              const Divider(
                                  height: 1, color: Color(0xFFEDF0ED)),
                              _buildDetailRow('Account Name', accountName),
                              const Divider(
                                  height: 1, color: Color(0xFFEDF0ED)),
                              _buildDetailRow('Account Number', accountNo,
                                  copyable: true),
                              const Divider(
                                  height: 1, color: Color(0xFFEDF0ED)),
                              _buildDetailRow('Bank Name', '9 Payment Service Bank'),
                              const Divider(
                                  height: 1, color: Color(0xFFEDF0ED)),
                              _buildDetailRow('Currency', 'NGN (Naira)'),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16.0),

                      // Account Status Card
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.0),
                            border: Border.all(
                              color: const Color(0xFFE6EAE7),
                              width: 1.0,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x060B2018),
                                blurRadius: 12.0,
                                offset: Offset(0.0, 4.0),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 36.0,
                                    height: 36.0,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEDF7EE),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    alignment: Alignment.center,
                                    child: const Icon(
                                      Icons.verified_outlined,
                                      color: Color(0xFF2F8F3C),
                                      size: 18.0,
                                    ),
                                  ),
                                  const SizedBox(width: 10.0),
                                  Text(
                                    'Account Status',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w800,
                                      color: const Color(0xFF101614),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16.0),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Status',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF6E7A72),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 4.0),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEDF7EE),
                                      borderRadius:
                                          BorderRadius.circular(20.0),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          width: 6.0,
                                          height: 6.0,
                                          decoration: const BoxDecoration(
                                            color: Color(0xFF2F8F3C),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 5.0),
                                        Text(
                                          'Active',
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w700,
                                            color: const Color(0xFF2F8F3C),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10.0),
                              const Divider(
                                  height: 1, color: Color(0xFFEDF0ED)),
                              _buildDetailRow('Account Type', 'Savings Account'),
                              const Divider(
                                  height: 1, color: Color(0xFFEDF0ED)),
                              _buildDetailRow('Account Tier', 'Tier $tier'),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16.0),

                      // How to fund card
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0B2018),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 36.0,
                                height: 36.0,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF152F23),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                alignment: Alignment.center,
                                child: const Icon(
                                  Icons.info_outline_rounded,
                                  color: Color(0xFF7FD472),
                                  size: 18.0,
                                ),
                              ),
                              const SizedBox(width: 12.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'How to Fund Your Account',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 6.0),
                                    Text(
                                      'Credit your account from any bank using 9PSB as the destination bank and your account number above.',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xFF8FB3A0),
                                        height: 1.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16.0),

                      // Quick Actions Card
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.0),
                            border: Border.all(
                              color: const Color(0xFFE6EAE7),
                              width: 1.0,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x060B2018),
                                blurRadius: 12.0,
                                offset: Offset(0.0, 4.0),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Quick Actions',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF101614),
                                ),
                              ),
                              const SizedBox(height: 18.0),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  _buildQuickAction(
                                    icon: Icons.wifi_tethering_rounded,
                                    label: 'Buy Data',
                                    onTap: () => context.pushNamed(
                                      DatapaymentWidget.routeName,
                                      queryParameters: {
                                        'phonenumber': serializeParam(
                                          functions.addcode(
                                              FFAppState().phonenumber),
                                          ParamType.String,
                                        ),
                                      }.withoutNulls,
                                    ),
                                  ),
                                  _buildQuickAction(
                                    icon: Icons.north_east_rounded,
                                    label: 'Transfer',
                                    onTap: () => context
                                        .pushNamed(ManualPaymentWidget.routeName),
                                  ),
                                  _buildQuickAction(
                                    icon: Icons.receipt_long_rounded,
                                    label: 'History',
                                    onTap: () => context.pushNamed(
                                      TransactionHistoryWidget.routeName,
                                      queryParameters: {
                                        'accountno': serializeParam(
                                          FFAppState().accountno,
                                          ParamType.String,
                                        ),
                                        'accountname': serializeParam(
                                          FFAppState().accountname,
                                          ParamType.String,
                                        ),
                                      }.withoutNulls,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
