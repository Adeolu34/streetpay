import '/backend/api_requests/api_calls.dart';
import '/components/paymentpinverifygame_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/streetjob/lotto/lottonav/lottonav_widget.dart';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'lottery_model.dart';
export 'lottery_model.dart';

class LotteryWidget extends StatefulWidget {
  const LotteryWidget({
    super.key,
    required this.gametype,
  });

  final String? gametype;

  static String routeName = 'lottery';
  static String routePath = '/lottery';

  @override
  State<LotteryWidget> createState() => _LotteryWidgetState();
}

class _LotteryWidgetState extends State<LotteryWidget> {
  late LotteryModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LotteryModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.streetauth = await StreetauthCall.call();

      _model.winners = await GetwinnersCall.call(
        accessToken: StreetauthCall.streettoken(
          (_model.streetauth?.jsonBody ?? ''),
        ),
      );

      _model.plan = await GetlottoplansCall.call(
        accessToken: StreetauthCall.streettoken(
          (_model.streetauth?.jsonBody ?? ''),
        ),
        gametype: widget.gametype,
      );

      FFAppState().lotteryplan = GetlottoplansCall.plans(
        (_model.plan?.jsonBody ?? ''),
      )!
          .toList()
          .cast<String>();
      FFAppState().winners = GetwinnersCall.winners(
        (_model.winners?.jsonBody ?? ''),
      )!
          .toList()
          .cast<String>();
      safeSetState(() {});
    });
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: PopScope(
        canPop: false,
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          appBar: AppBar(
            backgroundColor: FlutterFlowTheme.of(context).primary,
            automaticallyImplyLeading: false,
            leading: FlutterFlowIconButton(
              borderColor: Colors.transparent,
              borderRadius: 30.0,
              borderWidth: 1.0,
              buttonSize: 60.0,
              icon: Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
                size: 30.0,
              ),
              onPressed: () async {
                context.pop();
              },
            ),
            title: Text(
              'Street ${widget.gametype}',
              style: FlutterFlowTheme.of(context).headlineSmall.override(
                    font: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      fontStyle:
                          FlutterFlowTheme.of(context).headlineSmall.fontStyle,
                    ),
                    color: FlutterFlowTheme.of(context).primaryBackground,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.bold,
                    fontStyle:
                        FlutterFlowTheme.of(context).headlineSmall.fontStyle,
                  ),
            ),
            actions: [],
            centerTitle: true,
            elevation: 2.0,
          ),
          body: Stack(
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 80.0),
                child: SingleChildScrollView(
                  controller: _model.columnController,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 220.0,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              FlutterFlowTheme.of(context).primary,
                              Color(0xFF025D01)
                            ],
                            stops: [0.0, 1.0],
                            begin: AlignmentDirectional(1.0, 1.0),
                            end: AlignmentDirectional(-1.0, -1.0),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  10.0, 60.0, 0.0, 24.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Lucky ${widget.gametype}',
                                    style: FlutterFlowTheme.of(context)
                                        .headlineLarge
                                        .override(
                                          font: GoogleFonts.inter(
                                            fontWeight: FontWeight.bold,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .headlineLarge
                                                    .fontStyle,
                                          ),
                                          color: FlutterFlowTheme.of(context)
                                              .primaryBackground,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.bold,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .headlineLarge
                                                  .fontStyle,
                                        ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 8.0, 0.0, 0.0),
                                    child: Text(
                                      'Try your luck today!',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyLarge
                                          .override(
                                            font: GoogleFonts.inter(
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyLarge
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyLarge
                                                      .fontStyle,
                                            ),
                                            color: FlutterFlowTheme.of(context)
                                                .primaryBackground,
                                            letterSpacing: 0.0,
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .bodyLarge
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyLarge
                                                    .fontStyle,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.asset(
                                'assets/images/2148666496-removebg-preview.png',
                                width: 200.0,
                                height: 200.0,
                                fit: BoxFit.cover,
                                alignment: Alignment(-1.0, 0.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            20.0, 0.0, 20.0, 0.0),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(0.0),
                          ),
                          child: Text(
                            'Available Lottery Plans',
                            style: FlutterFlowTheme.of(context)
                                .titleLarge
                                .override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleLarge
                                        .fontStyle,
                                  ),
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .titleLarge
                                      .fontStyle,
                                ),
                          ),
                        ),
                      ),
                      Container(
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              20.0, 0.0, 20.0, 0.0),
                          child: Builder(
                            builder: (context) {
                              final plans = FFAppState()
                                  .lotteryplan
                                  .sortedList(keyOf: (e) => e, desc: false)
                                  .toList();

                              return ListView.builder(
                                padding: EdgeInsets.zero,
                                primary: false,
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: plans.length,
                                itemBuilder: (context, plansIndex) {
                                  final plansItem = plans[plansIndex];
                                  return Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                        boxShadow: [
                                          BoxShadow(
                                            blurRadius: 4.0,
                                            color: Color(0x10000000),
                                            offset: Offset(
                                              0.0,
                                              2.0,
                                            ),
                                          )
                                        ],
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(12.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${plansItem} Plan',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .titleMedium
                                                      .override(
                                                        font: GoogleFonts.inter(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleMedium
                                                                  .fontStyle,
                                                        ),
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primary,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .titleMedium
                                                                .fontStyle,
                                                      ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          0.0, 4.0, 0.0, 0.0),
                                                  child: Text(
                                                    'Win up to ${formatNumber(
                                                      functions.stringtodouble(
                                                              plansItem) *
                                                          2,
                                                      formatType:
                                                          FormatType.decimal,
                                                      decimalType: DecimalType
                                                          .periodDecimal,
                                                      currency: 'N ',
                                                    )} daily',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          font:
                                                              GoogleFonts.inter(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            FFButtonWidget(
                                              onPressed: () async {
                                                if (widget.gametype ==
                                                    'quiz') {
                                                  _model.transactionref =
                                                      await actions
                                                          .generatetransref();
                                                  await showModalBottomSheet(
                                                    isScrollControlled: true,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    isDismissible: false,
                                                    enableDrag: false,
                                                    context: context,
                                                    builder: (context) {
                                                      return WebViewAware(
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            FocusScope.of(
                                                                    context)
                                                                .unfocus();
                                                            FocusManager
                                                                .instance
                                                                .primaryFocus
                                                                ?.unfocus();
                                                          },
                                                          child: Padding(
                                                            padding: MediaQuery
                                                                .viewInsetsOf(
                                                                    context),
                                                            child:
                                                                PaymentpinverifygameWidget(),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ).then((value) =>
                                                      safeSetState(() => _model
                                                          .receipt = value));

                                                  if (_model.receipt!) {
                                                    _model.debitewallet =
                                                        await WalletAsAServiceGroup
                                                            .debitwalletCall
                                                            .call(
                                                      narration:
                                                          '${widget.gametype} ${plansItem}',
                                                      amount: plansItem,
                                                      transactionid:
                                                          _model.transactionref,
                                                      accountno: FFAppState()
                                                          .accountno,
                                                      authToken:
                                                          FFAppState().bsptoken,
                                                    );

                                                    if (WalletAsAServiceGroup
                                                            .debitwalletCall
                                                            .status(
                                                          (_model.debitewallet
                                                                  ?.jsonBody ??
                                                              ''),
                                                        ) ==
                                                        'success') {
                                                      context.pushNamed(
                                                        LottoquizWidget
                                                            .routeName,
                                                        queryParameters: {
                                                          'selectedplan':
                                                              serializeParam(
                                                            plansItem,
                                                            ParamType.String,
                                                          ),
                                                          'paymentref':
                                                              serializeParam(
                                                            _model
                                                                .transactionref,
                                                            ParamType.String,
                                                          ),
                                                        }.withoutNulls,
                                                      );
                                                    } else {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                            WalletAsAServiceGroup
                                                                .debitwalletCall
                                                                .message(
                                                              (_model.debitewallet
                                                                      ?.jsonBody ??
                                                                  ''),
                                                            )!,
                                                            style: TextStyle(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                            ),
                                                          ),
                                                          duration: Duration(
                                                              milliseconds:
                                                                  4000),
                                                          backgroundColor:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .secondary,
                                                        ),
                                                      );
                                                    }
                                                  } else {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                          'Enter a valid pincode',
                                                          style: TextStyle(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .primaryBackground,
                                                          ),
                                                        ),
                                                        duration: Duration(
                                                            milliseconds: 4000),
                                                        backgroundColor:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondary,
                                                      ),
                                                    );
                                                  }
                                                } else {
                                                  if (widget.gametype ==
                                                      'sum') {
                                                    _model.transactionref2 =
                                                        await actions
                                                            .generatetransref();
                                                    await showModalBottomSheet(
                                                      isScrollControlled: true,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      isDismissible: false,
                                                      enableDrag: false,
                                                      context: context,
                                                      builder: (context) {
                                                        return WebViewAware(
                                                          child:
                                                              GestureDetector(
                                                            onTap: () {
                                                              FocusScope.of(
                                                                      context)
                                                                  .unfocus();
                                                              FocusManager
                                                                  .instance
                                                                  .primaryFocus
                                                                  ?.unfocus();
                                                            },
                                                            child: Padding(
                                                              padding: MediaQuery
                                                                  .viewInsetsOf(
                                                                      context),
                                                              child:
                                                                  PaymentpinverifygameWidget(),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ).then((value) =>
                                                        safeSetState(() =>
                                                            _model.receipt2 =
                                                                value));

                                                    if (_model.receipt2!) {
                                                      _model.debitwallet2 =
                                                          await WalletAsAServiceGroup
                                                              .debitwalletCall
                                                              .call(
                                                        narration:
                                                            '${widget.gametype} ${plansItem}',
                                                        amount: plansItem,
                                                        transactionid: _model
                                                            .transactionref2,
                                                        accountno: FFAppState()
                                                            .accountno,
                                                        authToken: FFAppState()
                                                            .bsptoken,
                                                      );

                                                      if (WalletAsAServiceGroup
                                                              .debitwalletCall
                                                              .status(
                                                            (_model.debitwallet2
                                                                    ?.jsonBody ??
                                                                ''),
                                                          ) ==
                                                          'success') {
                                                        context.pushNamed(
                                                          LottoflipWidget
                                                              .routeName,
                                                          queryParameters: {
                                                            'selectedplan':
                                                                serializeParam(
                                                              plansItem,
                                                              ParamType.String,
                                                            ),
                                                            'paymentref':
                                                                serializeParam(
                                                              _model
                                                                  .transactionref2,
                                                              ParamType.String,
                                                            ),
                                                          }.withoutNulls,
                                                        );
                                                      } else {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          SnackBar(
                                                            content: Text(
                                                              WalletAsAServiceGroup
                                                                  .debitwalletCall
                                                                  .message(
                                                                (_model.debitwallet2
                                                                        ?.jsonBody ??
                                                                    ''),
                                                              )!,
                                                              style: TextStyle(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryText,
                                                              ),
                                                            ),
                                                            duration: Duration(
                                                                milliseconds:
                                                                    4000),
                                                            backgroundColor:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondary,
                                                          ),
                                                        );
                                                      }
                                                    } else {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                            'Enter a valid pincode',
                                                            style: TextStyle(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                            ),
                                                          ),
                                                          duration: Duration(
                                                              milliseconds:
                                                                  4000),
                                                          backgroundColor:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .secondary,
                                                        ),
                                                      );
                                                    }
                                                  } else {
                                                    if (widget.gametype ==
                                                        'lotto') {
                                                      _model.transactionref3 =
                                                          await actions
                                                              .generatetransref();
                                                      await showModalBottomSheet(
                                                        isScrollControlled:
                                                            true,
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        isDismissible: false,
                                                        enableDrag: false,
                                                        context: context,
                                                        builder: (context) {
                                                          return WebViewAware(
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {
                                                                FocusScope.of(
                                                                        context)
                                                                    .unfocus();
                                                                FocusManager
                                                                    .instance
                                                                    .primaryFocus
                                                                    ?.unfocus();
                                                              },
                                                              child: Padding(
                                                                padding: MediaQuery
                                                                    .viewInsetsOf(
                                                                        context),
                                                                child:
                                                                    PaymentpinverifygameWidget(),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      ).then((value) =>
                                                          safeSetState(() =>
                                                              _model.receipt3 =
                                                                  value));

                                                      if (_model.receipt3!) {
                                                        _model.walletdebit3 =
                                                            await WalletAsAServiceGroup
                                                                .debitwalletCall
                                                                .call(
                                                          narration:
                                                              '${widget.gametype} ${plansItem}',
                                                          amount: plansItem,
                                                          transactionid: _model
                                                              .transactionref3,
                                                          accountno:
                                                              FFAppState()
                                                                  .accountno,
                                                          authToken:
                                                              FFAppState()
                                                                  .bsptoken,
                                                        );

                                                        if (WalletAsAServiceGroup
                                                                .debitwalletCall
                                                                .status(
                                                              (_model.walletdebit3
                                                                      ?.jsonBody ??
                                                                  ''),
                                                            ) ==
                                                            'success') {
                                                          context.pushNamed(
                                                            LottoguessWidget
                                                                .routeName,
                                                            queryParameters: {
                                                              'selectedplan':
                                                                  serializeParam(
                                                                plansItem,
                                                                ParamType
                                                                    .String,
                                                              ),
                                                              'paymentref':
                                                                  serializeParam(
                                                                _model
                                                                    .transactionref3,
                                                                ParamType
                                                                    .String,
                                                              ),
                                                            }.withoutNulls,
                                                          );
                                                        } else {
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            SnackBar(
                                                              content: Text(
                                                                WalletAsAServiceGroup
                                                                    .debitwalletCall
                                                                    .message(
                                                                  (_model.walletdebit3
                                                                          ?.jsonBody ??
                                                                      ''),
                                                                )!,
                                                                style:
                                                                    TextStyle(
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryBackground,
                                                                ),
                                                              ),
                                                              duration: Duration(
                                                                  milliseconds:
                                                                      4000),
                                                              backgroundColor:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondary,
                                                            ),
                                                          );
                                                        }
                                                      } else {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          SnackBar(
                                                            content: Text(
                                                              'Enter a valid pincode',
                                                              style: TextStyle(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryBackground,
                                                              ),
                                                            ),
                                                            duration: Duration(
                                                                milliseconds:
                                                                    4000),
                                                            backgroundColor:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondary,
                                                          ),
                                                        );
                                                      }
                                                    } else {
                                                      _model.transactionref4 =
                                                          await actions
                                                              .generatetransref();
                                                      await showModalBottomSheet(
                                                        isScrollControlled:
                                                            true,
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        isDismissible: false,
                                                        enableDrag: false,
                                                        context: context,
                                                        builder: (context) {
                                                          return WebViewAware(
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {
                                                                FocusScope.of(
                                                                        context)
                                                                    .unfocus();
                                                                FocusManager
                                                                    .instance
                                                                    .primaryFocus
                                                                    ?.unfocus();
                                                              },
                                                              child: Padding(
                                                                padding: MediaQuery
                                                                    .viewInsetsOf(
                                                                        context),
                                                                child:
                                                                    PaymentpinverifygameWidget(),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      ).then((value) =>
                                                          safeSetState(() =>
                                                              _model.receipt4 =
                                                                  value));

                                                      if (_model.receipt4!) {
                                                        _model.debitwallet4 =
                                                            await WalletAsAServiceGroup
                                                                .debitwalletCall
                                                                .call(
                                                          narration:
                                                              '${widget.gametype} ${plansItem}',
                                                          amount: plansItem,
                                                          transactionid: _model
                                                              .transactionref4,
                                                          accountno:
                                                              FFAppState()
                                                                  .accountno,
                                                          authToken:
                                                              FFAppState()
                                                                  .bsptoken,
                                                        );

                                                        if (WalletAsAServiceGroup
                                                                .debitwalletCall
                                                                .status(
                                                              (_model.debitwallet4
                                                                      ?.jsonBody ??
                                                                  ''),
                                                            ) ==
                                                            'success') {
                                                          context.pushNamed(
                                                            LottospinWidget
                                                                .routeName,
                                                            queryParameters: {
                                                              'playedamount':
                                                                  serializeParam(
                                                                plansItem,
                                                                ParamType
                                                                    .String,
                                                              ),
                                                              'paymentref':
                                                                  serializeParam(
                                                                _model
                                                                    .transactionref4,
                                                                ParamType
                                                                    .String,
                                                              ),
                                                            }.withoutNulls,
                                                          );
                                                        } else {
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            SnackBar(
                                                              content: Text(
                                                                WalletAsAServiceGroup
                                                                    .debitwalletCall
                                                                    .message(
                                                                  (_model.debitwallet4
                                                                          ?.jsonBody ??
                                                                      ''),
                                                                )!,
                                                                style:
                                                                    TextStyle(
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryText,
                                                                ),
                                                              ),
                                                              duration: Duration(
                                                                  milliseconds:
                                                                      4000),
                                                              backgroundColor:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondary,
                                                            ),
                                                          );
                                                        }
                                                      } else {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          SnackBar(
                                                            content: Text(
                                                              'Enter a valid pincode',
                                                              style: TextStyle(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryBackground,
                                                              ),
                                                            ),
                                                            duration: Duration(
                                                                milliseconds:
                                                                    4000),
                                                            backgroundColor:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondary,
                                                          ),
                                                        );
                                                      }
                                                    }
                                                  }
                                                }

                                                safeSetState(() {});
                                              },
                                              text: 'Play Now',
                                              options: FFButtonOptions(
                                                width: 100.0,
                                                height: 40.0,
                                                padding: EdgeInsets.all(8.0),
                                                iconPadding:
                                                    EdgeInsetsDirectional
                                                        .fromSTEB(
                                                            0.0, 0.0, 0.0, 0.0),
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                textStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          font:
                                                              GoogleFonts.inter(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryBackground,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                borderRadius:
                                                    BorderRadius.circular(30.0),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                      Container(),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            20.0, 0.0, 20.0, 0.0),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(0.0),
                          ),
                        ),
                      ),
                      Container(),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 6.0,
                              color: Color(0x20000000),
                              offset: Offset(
                                0.0,
                                3.0,
                              ),
                            )
                          ],
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFF025D01),
                              FlutterFlowTheme.of(context).primary
                            ],
                            stops: [0.0, 1.0],
                            begin: AlignmentDirectional(1.0, 1.0),
                            end: AlignmentDirectional(-1.0, -1.0),
                          ),
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                      ),
                      Container(),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            20.0, 0.0, 20.0, 0.0),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(0.0),
                          ),
                          child: Text(
                            'Recent Winners',
                            style: FlutterFlowTheme.of(context)
                                .titleLarge
                                .override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleLarge
                                        .fontStyle,
                                  ),
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .titleLarge
                                      .fontStyle,
                                ),
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: 50.0,
                        decoration: BoxDecoration(),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              15.0, 0.0, 15.0, 0.0),
                          child: Container(
                            width: double.infinity,
                            height: 30.0,
                            child: custom_widgets.UserJoinAnimation(
                              width: double.infinity,
                              height: 30.0,
                              users: FFAppState().winners,
                              useDemoWhenEmpty: true,
                              forceDemoData: true,
                              tvNewsStyle: true,
                            ),
                          ),
                        ),
                      ),
                      Container(),
                      FFButtonWidget(
                        onPressed: () async {
                          if (widget.gametype == 'quiz') {
                            context.pushNamed(HistoryquizWidget.routeName);
                          } else {
                            if (widget.gametype == 'sum') {
                              context.pushNamed(HistoryflipWidget.routeName);
                            } else {
                              if (widget.gametype == 'score') {
                                context.pushNamed(HistoryspinWidget.routeName);
                              } else {
                                if (widget.gametype == 'lotto') {
                                  context
                                      .pushNamed(HistoryguessWidget.routeName);
                                }
                              }
                            }
                          }
                        },
                        text: 'View All Results',
                        options: FFButtonOptions(
                          width: 200.0,
                          height: 50.0,
                          padding: EdgeInsets.all(8.0),
                          iconPadding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 0.0),
                          color: FlutterFlowTheme.of(context).primary,
                          textStyle:
                              FlutterFlowTheme.of(context).titleSmall.override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .fontStyle,
                                    ),
                                    color: FlutterFlowTheme.of(context)
                                        .primaryBackground,
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontStyle,
                                  ),
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).primary,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                    ].divide(SizedBox(height: 16.0)),
                  ),
                ),
              ),
              Align(
                alignment: AlignmentDirectional(0.0, 1.0),
                child: wrapWithModel(
                  model: _model.lottonavModel,
                  updateCallback: () => safeSetState(() {}),
                  child: LottonavWidget(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
