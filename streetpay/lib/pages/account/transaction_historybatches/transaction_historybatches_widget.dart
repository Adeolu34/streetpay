import '/backend/api_requests/api_calls.dart';
import '/components/bottom_app_bar/bottom_app_bar_widget.dart';
import '/components/emptylisttransaction_widget.dart';
import '/components/overview_card/overview_card_widget.dart';
import '/components/overview_carddebit/overview_carddebit_widget.dart';
import '/components/transaction_card/transaction_card_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'transaction_historybatches_model.dart';
export 'transaction_historybatches_model.dart';

class TransactionHistorybatchesWidget extends StatefulWidget {
  const TransactionHistorybatchesWidget({
    super.key,
    required this.accountno,
    this.accountname,
  });

  final String? accountno;
  final String? accountname;

  static String routeName = 'TransactionHistorybatches';
  static String routePath = '/transactionHistorybatches';

  @override
  State<TransactionHistorybatchesWidget> createState() =>
      _TransactionHistorybatchesWidgetState();
}

class _TransactionHistorybatchesWidgetState
    extends State<TransactionHistorybatchesWidget> {
  late TransactionHistorybatchesModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TransactionHistorybatchesModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.wallethistory = await WalletAsAServiceGroup.wallethistoryCall.call(
        authToken: FFAppState().bsptoken,
        accountno: widget.accountno,
        fromdate: dateTimeFormat(
          "yyyy-MM-dd",
          functions.addtodate(getCurrentTimestamp),
          locale: FFLocalizations.of(context).languageCode,
        ),
        todate: dateTimeFormat(
          "yyyy-MM-dd",
          getCurrentTimestamp,
          locale: FFLocalizations.of(context).languageCode,
        ),
      );

      FFAppState().adddate = false;
      FFAppState().guesttransactionhistory =
          WalletAsAServiceGroup.wallethistoryCall
              .message(
                (_model.wallethistory?.jsonBody ?? ''),
              )!
              .toList()
              .cast<dynamic>();
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
            'Transaction History - Guest',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  font: GoogleFonts.inter(
                    fontWeight:
                        FlutterFlowTheme.of(context).headlineMedium.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                  ),
                  color: Colors.white,
                  fontSize: 20.0,
                  letterSpacing: 0.0,
                  fontWeight:
                      FlutterFlowTheme.of(context).headlineMedium.fontWeight,
                  fontStyle:
                      FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                ),
          ),
          actions: [],
          centerTitle: true,
          elevation: 2.0,
        ),
        body: SafeArea(
          top: true,
          child: Stack(
            children: [
              SingleChildScrollView(
                controller: _model.columnController1,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(15.0, 15.0, 15.0, 0.0),
                      child: Text(
                        'Host- ${widget.accountname}',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              font: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontStyle,
                              ),
                              fontSize: 18.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w600,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(15.0, 15.0, 15.0, 0.0),
                      child: Text(
                        valueOrDefault<String>(
                          widget.accountno,
                          '00000',
                        ),
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              font: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontStyle,
                              ),
                              fontSize: 18.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w600,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(15.0, 24.0, 15.0, 0.0),
                      child: Text(
                        'Transactions',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              font: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontStyle,
                              ),
                              fontSize: 16.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w600,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(15.0, 0.0, 15.0, 0.0),
                      child: Container(
                        decoration: BoxDecoration(),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: wrapWithModel(
                                    model: _model.overviewCardModel,
                                    updateCallback: () => safeSetState(() {}),
                                    updateOnChange: true,
                                    child: OverviewCardWidget(
                                      totalAmount:
                                          functions.sumalltran(FFAppState()
                                              .guesttransactionhistory
                                              .map((e) => getJsonField(
                                                    e,
                                                    r'''$.credit''',
                                                  ))
                                              .toList()
                                              .map((e) => e.toString())
                                              .toList()),
                                    ),
                                  ),
                                ),
                                wrapWithModel(
                                  model: _model.overviewCarddebitModel,
                                  updateCallback: () => safeSetState(() {}),
                                  updateOnChange: true,
                                  child: OverviewCarddebitWidget(
                                    totalAmount:
                                        functions.sumalltran(FFAppState()
                                            .guesttransactionhistory
                                            .map((e) => getJsonField(
                                                  e,
                                                  r'''$.debit''',
                                                ))
                                            .toList()
                                            .map((e) => e.toString())
                                            .toList()),
                                  ),
                                ),
                              ]
                                  .divide(SizedBox(width: 5.0))
                                  .around(SizedBox(width: 5.0)),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 25.0, 0.0, 200.0),
                                  child: Builder(
                                    builder: (context) {
                                      final translist = FFAppState()
                                          .guesttransactionhistory
                                          .toList();
                                      if (translist.isEmpty) {
                                        return Center(
                                          child: EmptylisttransactionWidget(),
                                        );
                                      }

                                      return SingleChildScrollView(
                                        controller: _model.columnController2,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children:
                                              List.generate(translist.length,
                                                  (translistIndex) {
                                            final translistItem =
                                                translist[translistIndex];
                                            return TransactionCardWidget(
                                              key: Key(
                                                  'Keyyzb_${translistIndex}_of_${translist.length}'),
                                              credittitle: functions
                                                  .processTransactionNarration(
                                                      getJsonField(
                                                translistItem,
                                                r'''$.narration''',
                                              ).toString()),
                                              creditsubtitle: getJsonField(
                                                translistItem,
                                                r'''$.transactionDateString''',
                                              ).toString(),
                                              creditamount: getJsonField(
                                                translistItem,
                                                r'''$.credit''',
                                              ).toString(),
                                              debittitle: functions
                                                  .processTransactionNarration(
                                                      getJsonField(
                                                translistItem,
                                                r'''$.narration''',
                                              ).toString()),
                                              debitamount:
                                                  valueOrDefault<String>(
                                                getJsonField(
                                                  translistItem,
                                                  r'''$.debit''',
                                                )?.toString(),
                                                '---',
                                              ),
                                              debitsubtitle:
                                                  valueOrDefault<String>(
                                                getJsonField(
                                                  translistItem,
                                                  r'''$.transactionDateString''',
                                                )?.toString(),
                                                '----',
                                              ),
                                            );
                                          }).divide(SizedBox(height: 10.0)),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ].divide(SizedBox(height: 12.0)),
                ),
              ),
              Align(
                alignment: AlignmentDirectional(0.0, 0.0),
                child: wrapWithModel(
                  model: _model.bottomAppBarModel,
                  updateCallback: () => safeSetState(() {}),
                  child: BottomAppBarWidget(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
