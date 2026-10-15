import '/backend/api_requests/api_calls.dart';
import '/components/emptylisttransaction_widget.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/streetjob/lotto/lottonav/lottonav_widget.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'historyflip_model.dart';
export 'historyflip_model.dart';

class HistoryflipWidget extends StatefulWidget {
  const HistoryflipWidget({super.key});

  static String routeName = 'historyflip';
  static String routePath = '/historyflip';

  @override
  State<HistoryflipWidget> createState() => _HistoryflipWidgetState();
}

class _HistoryflipWidgetState extends State<HistoryflipWidget> {
  late HistoryflipModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HistoryflipModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.streetautg = await StreetauthCall.call();

      _model.history = await GethistoryflipCall.call(
        accessToken: StreetauthCall.streettoken(
          (_model.streetautg?.jsonBody ?? ''),
        ),
        userphone: FFAppState().phonenumber,
      );

      FFAppState().lottohistroy = GethistoryflipCall.fulldata(
        (_model.history?.jsonBody ?? ''),
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
                context.pushNamed(LottohomeWidget.routeName);
              },
            ),
            title: Text(
              'Game History',
              style: FlutterFlowTheme.of(context).headlineMedium.override(
                    font: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      fontStyle:
                          FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                    ),
                    color: FlutterFlowTheme.of(context).primaryBackground,
                    fontSize: 24.0,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.bold,
                    fontStyle:
                        FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                  ),
            ),
            actions: [],
            centerTitle: true,
            elevation: 2.0,
          ),
          body: Stack(
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 60.0),
                child: SingleChildScrollView(
                  controller: _model.columnController1,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                16.0, 20.0, 16.0, 0.0),
                            child: Container(
                              width: double.infinity,
                              height: 80.0,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    FlutterFlowTheme.of(context).primary,
                                    Color(0xFF025E01)
                                  ],
                                  stops: [0.0, 1.0],
                                  begin: AlignmentDirectional(1.0, -1.0),
                                  end: AlignmentDirectional(-1.0, 1.0),
                                ),
                              ),
                              child: Align(
                                alignment: AlignmentDirectional(0.0, 0.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          10.0, 0.0, 0.0, 0.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Total Games',
                                            style: FlutterFlowTheme.of(context)
                                                .titleMedium
                                                .override(
                                                  font: GoogleFonts.inter(
                                                    fontWeight: FontWeight.w600,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .titleMedium
                                                            .fontStyle,
                                                  ),
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryBackground,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w600,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleMedium
                                                          .fontStyle,
                                                ),
                                          ),
                                          Text(
                                            valueOrDefault<String>(
                                              GethistoryflipCall.fulldata(
                                                (_model.history?.jsonBody ??
                                                    ''),
                                              )?.length.toString(),
                                              '000',
                                            ),
                                            style: FlutterFlowTheme.of(context)
                                                .headlineSmall
                                                .override(
                                                  font: GoogleFonts.inter(
                                                    fontWeight: FontWeight.bold,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .headlineSmall
                                                            .fontStyle,
                                                  ),
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryBackground,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .headlineSmall
                                                          .fontStyle,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: 1.0,
                                      height: 40.0,
                                      decoration: BoxDecoration(
                                        color: Color(0x80FFFFFF),
                                      ),
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Total Wins',
                                          style: FlutterFlowTheme.of(context)
                                              .titleMedium
                                              .override(
                                                font: GoogleFonts.inter(
                                                  fontWeight: FontWeight.w600,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleMedium
                                                          .fontStyle,
                                                ),
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryBackground,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w600,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .titleMedium
                                                        .fontStyle,
                                              ),
                                        ),
                                        Text(
                                          valueOrDefault<String>(
                                            functions.getwin(
                                                GethistoryflipCall.fulldata(
                                              (_model.history?.jsonBody ?? ''),
                                            )!
                                                    .toList()),
                                            '0',
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .headlineSmall
                                              .override(
                                                font: GoogleFonts.inter(
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .headlineSmall
                                                          .fontStyle,
                                                ),
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryBackground,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.bold,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .headlineSmall
                                                        .fontStyle,
                                              ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      width: 1.0,
                                      height: 40.0,
                                      decoration: BoxDecoration(
                                        color: Color(0x80FFFFFF),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 0.0, 10.0, 0.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Win Rate',
                                            style: FlutterFlowTheme.of(context)
                                                .titleMedium
                                                .override(
                                                  font: GoogleFonts.inter(
                                                    fontWeight: FontWeight.w600,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .titleMedium
                                                            .fontStyle,
                                                  ),
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryBackground,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w600,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleMedium
                                                          .fontStyle,
                                                ),
                                          ),
                                          Text(
                                            () {
                                              final _d = GethistoryflipCall
                                                      .fulldata((_model.history
                                                              ?.jsonBody ??
                                                          ''))
                                                      ?.toList() ??
                                                  [];
                                              if (_d.isEmpty) return '0%';
                                              return formatNumber(
                                                (functions.stringtoint(
                                                        functions.getwin(
                                                            _d))!) /
                                                    _d.length,
                                                formatType: FormatType.percent,
                                              );
                                            }(),
                                            style: FlutterFlowTheme.of(context)
                                                .headlineSmall
                                                .override(
                                                  font: GoogleFonts.inter(
                                                    fontWeight: FontWeight.bold,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .headlineSmall
                                                            .fontStyle,
                                                  ),
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryBackground,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .headlineSmall
                                                          .fontStyle,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                16.0, 12.0, 16.0, 12.0),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Color(0x00F5F5F5),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(12.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Recent Games',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            font: GoogleFonts.inter(
                                              fontWeight: FontWeight.bold,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.bold,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                    ),
                                    FlutterFlowDropDown<String>(
                                      controller:
                                          _model.dropDownValueController ??=
                                              FormFieldController<String>(null),
                                      options: [
                                        'ALL GAMES',
                                        'WIN',
                                        'LOSS',
                                        'PENDING'
                                      ],
                                      onChanged: (val) => safeSetState(
                                          () => _model.dropDownValue = val),
                                      width: 120.0,
                                      height: 36.0,
                                      textStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            font: GoogleFonts.inter(
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                            fontSize: 14.0,
                                            letterSpacing: 0.0,
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                      hintText: 'Filter',
                                      icon: Icon(
                                        Icons.filter_list,
                                        color: FlutterFlowTheme.of(context)
                                            .primaryText,
                                        size: 20.0,
                                      ),
                                      fillColor: FlutterFlowTheme.of(context)
                                          .primaryBackground,
                                      elevation: 2.0,
                                      borderColor: Color(0x00E0E0E0),
                                      borderWidth: 0.0,
                                      borderRadius: 8.0,
                                      margin: EdgeInsetsDirectional.fromSTEB(
                                          12.0, 4.0, 12.0, 4.0),
                                      hidesUnderline: true,
                                      isSearchable: false,
                                      isMultiSelect: false,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  16.0, 0.0, 16.0, 16.0),
                              child: Builder(
                                builder: (context) {
                                  final myhistroy =
                                      FFAppState().lottohistroy.toList();
                                  if (myhistroy.isEmpty) {
                                    return EmptylisttransactionWidget();
                                  }

                                  return SingleChildScrollView(
                                    controller: _model.columnController2,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: List.generate(myhistroy.length,
                                          (myhistroyIndex) {
                                        final myhistroyItem =
                                            myhistroy[myhistroyIndex];
                                        return Container(
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .primaryBackground,
                                            border: Border.all(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                            ),
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.all(16.0),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              'N ${getJsonField(
                                                                myhistroyItem,
                                                                r'''$.PlayAmount''',
                                                              ).toString()}',
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .titleMedium
                                                                  .override(
                                                                    font: GoogleFonts
                                                                        .inter(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .titleMedium
                                                                          .fontStyle,
                                                                    ),
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .primaryText,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .titleMedium
                                                                        .fontStyle,
                                                                  ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          4.0,
                                                                          0.0,
                                                                          0.0),
                                                              child: Text(
                                                                'Game Id: ${getJsonField(
                                                                  myhistroyItem,
                                                                  r'''$.ID''',
                                                                ).toString()}',
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      font: GoogleFonts
                                                                          .inter(
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .fontStyle,
                                                                      ),
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .secondaryText,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .fontStyle,
                                                                    ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Container(
                                                          width: 80.0,
                                                          height: 35.0,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Color(
                                                                0x00E6F7E6),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        16.0),
                                                          ),
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                getJsonField(
                                                                  myhistroyItem,
                                                                  r'''$.FinalSum''',
                                                                ).toString(),
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      font: GoogleFonts
                                                                          .inter(
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .fontStyle,
                                                                      ),
                                                                      color:
                                                                          () {
                                                                        if (getJsonField(
                                                                              myhistroyItem,
                                                                              r'''$.WinStatus''',
                                                                            ) ==
                                                                            getJsonField(
                                                                              functions.stringtojson('WIN'),
                                                                              r'''$.message''',
                                                                            )) {
                                                                          return FlutterFlowTheme.of(context)
                                                                              .primary;
                                                                        } else if (getJsonField(
                                                                              myhistroyItem,
                                                                              r'''$.WinStatus''',
                                                                            ) ==
                                                                            getJsonField(
                                                                              functions.stringtojson('TRY AGAIN'),
                                                                              r'''$.message''',
                                                                            )) {
                                                                          return FlutterFlowTheme.of(context)
                                                                              .secondary;
                                                                        } else {
                                                                          return FlutterFlowTheme.of(context)
                                                                              .alternate;
                                                                        }
                                                                      }(),
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .fontStyle,
                                                                    ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0.0,
                                                                  12.0,
                                                                  0.0,
                                                                  12.0),
                                                      child: Divider(
                                                        height: 1.0,
                                                        thickness: 1.0,
                                                        color:
                                                            Color(0x00F0F0F0),
                                                      ),
                                                    ),
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              'Your Numbers',
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    font: GoogleFonts
                                                                        .inter(
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .fontStyle,
                                                                    ),
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .secondaryText,
                                                                    fontSize:
                                                                        12.0,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontWeight,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontStyle,
                                                                  ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          8.0,
                                                                          0.0,
                                                                          0.0),
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Container(
                                                                    height:
                                                                        32.0,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color:
                                                                          () {
                                                                        if (getJsonField(
                                                                              myhistroyItem,
                                                                              r'''$.WinStatus''',
                                                                            ) ==
                                                                            getJsonField(
                                                                              functions.stringtojson('WIN'),
                                                                              r'''$.message''',
                                                                            )) {
                                                                          return FlutterFlowTheme.of(context)
                                                                              .primary;
                                                                        } else if (getJsonField(
                                                                              myhistroyItem,
                                                                              r'''$.WinStatus''',
                                                                            ) ==
                                                                            getJsonField(
                                                                              functions.stringtojson('TRY AGAIN'),
                                                                              r'''$.message''',
                                                                            )) {
                                                                          return FlutterFlowTheme.of(context)
                                                                              .secondary;
                                                                        } else {
                                                                          return FlutterFlowTheme.of(context)
                                                                              .alternate;
                                                                        }
                                                                      }(),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              16.0),
                                                                    ),
                                                                    child:
                                                                        Align(
                                                                      alignment:
                                                                          AlignmentDirectional(
                                                                              0.0,
                                                                              0.0),
                                                                      child:
                                                                          Text(
                                                                        getJsonField(
                                                                          myhistroyItem,
                                                                          r'''$.No1''',
                                                                        ).toString(),
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .override(
                                                                              font: GoogleFonts.inter(
                                                                                fontWeight: FontWeight.bold,
                                                                                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                              ),
                                                                              color: FlutterFlowTheme.of(context).primaryBackground,
                                                                              letterSpacing: 0.0,
                                                                              fontWeight: FontWeight.bold,
                                                                              fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                            ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    height:
                                                                        32.0,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color:
                                                                          () {
                                                                        if (getJsonField(
                                                                              myhistroyItem,
                                                                              r'''$.WinStatus''',
                                                                            ) ==
                                                                            getJsonField(
                                                                              functions.stringtojson('WIN'),
                                                                              r'''$.message''',
                                                                            )) {
                                                                          return FlutterFlowTheme.of(context)
                                                                              .primary;
                                                                        } else if (getJsonField(
                                                                              myhistroyItem,
                                                                              r'''$.WinStatus''',
                                                                            ) ==
                                                                            getJsonField(
                                                                              functions.stringtojson('TRY AGAIN'),
                                                                              r'''$.message''',
                                                                            )) {
                                                                          return FlutterFlowTheme.of(context)
                                                                              .secondary;
                                                                        } else {
                                                                          return FlutterFlowTheme.of(context)
                                                                              .alternate;
                                                                        }
                                                                      }(),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              16.0),
                                                                    ),
                                                                    child:
                                                                        Align(
                                                                      alignment:
                                                                          AlignmentDirectional(
                                                                              0.0,
                                                                              0.0),
                                                                      child:
                                                                          Text(
                                                                        getJsonField(
                                                                          myhistroyItem,
                                                                          r'''$.No2''',
                                                                        ).toString(),
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .override(
                                                                              font: GoogleFonts.inter(
                                                                                fontWeight: FontWeight.bold,
                                                                                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                              ),
                                                                              color: FlutterFlowTheme.of(context).primaryBackground,
                                                                              letterSpacing: 0.0,
                                                                              fontWeight: FontWeight.bold,
                                                                              fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                            ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    height:
                                                                        32.0,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color:
                                                                          () {
                                                                        if (getJsonField(
                                                                              myhistroyItem,
                                                                              r'''$.WinStatus''',
                                                                            ) ==
                                                                            getJsonField(
                                                                              functions.stringtojson('WIN'),
                                                                              r'''$.message''',
                                                                            )) {
                                                                          return FlutterFlowTheme.of(context)
                                                                              .primary;
                                                                        } else if (getJsonField(
                                                                              myhistroyItem,
                                                                              r'''$.WinStatus''',
                                                                            ) ==
                                                                            getJsonField(
                                                                              functions.stringtojson('TRY AGAIN'),
                                                                              r'''$.message''',
                                                                            )) {
                                                                          return FlutterFlowTheme.of(context)
                                                                              .secondary;
                                                                        } else {
                                                                          return FlutterFlowTheme.of(context)
                                                                              .alternate;
                                                                        }
                                                                      }(),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              16.0),
                                                                    ),
                                                                    child:
                                                                        Align(
                                                                      alignment:
                                                                          AlignmentDirectional(
                                                                              0.0,
                                                                              0.0),
                                                                      child:
                                                                          Text(
                                                                        getJsonField(
                                                                          myhistroyItem,
                                                                          r'''$.No3''',
                                                                        ).toString(),
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .override(
                                                                              font: GoogleFonts.inter(
                                                                                fontWeight: FontWeight.bold,
                                                                                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                              ),
                                                                              color: FlutterFlowTheme.of(context).primaryBackground,
                                                                              letterSpacing: 0.0,
                                                                              fontWeight: FontWeight.bold,
                                                                              fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                            ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ].divide(SizedBox(
                                                                    width:
                                                                        10.0)),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Text(
                                                              'Prize Amount',
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    font: GoogleFonts
                                                                        .inter(
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .fontStyle,
                                                                    ),
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .secondaryText,
                                                                    fontSize:
                                                                        12.0,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontWeight,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontStyle,
                                                                  ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          8.0,
                                                                          0.0,
                                                                          0.0),
                                                              child: Text(
                                                                'N ${valueOrDefault<String>(
                                                                  getJsonField(
                                                                    myhistroyItem,
                                                                    r'''$.WinAmount''',
                                                                  )?.toString(),
                                                                  '0',
                                                                )}',
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleMedium
                                                                    .override(
                                                                      font: GoogleFonts
                                                                          .inter(
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .titleMedium
                                                                            .fontStyle,
                                                                      ),
                                                                      color:
                                                                          () {
                                                                        if (getJsonField(
                                                                              myhistroyItem,
                                                                              r'''$.WinStatus''',
                                                                            ) ==
                                                                            getJsonField(
                                                                              functions.stringtojson('WIN'),
                                                                              r'''$.message''',
                                                                            )) {
                                                                          return FlutterFlowTheme.of(context)
                                                                              .primary;
                                                                        } else if (getJsonField(
                                                                              myhistroyItem,
                                                                              r'''$.WinStatus''',
                                                                            ) ==
                                                                            getJsonField(
                                                                              functions.stringtojson('TRY AGAIN'),
                                                                              r'''$.message''',
                                                                            )) {
                                                                          return FlutterFlowTheme.of(context)
                                                                              .secondary;
                                                                        } else {
                                                                          return FlutterFlowTheme.of(context)
                                                                              .alternate;
                                                                        }
                                                                      }(),
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .titleMedium
                                                                          .fontStyle,
                                                                    ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0.0,
                                                                  16.0,
                                                                  0.0,
                                                                  0.0),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            getJsonField(
                                                              myhistroyItem,
                                                              r'''$.DateIn''',
                                                            ).toString(),
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  font:
                                                                      GoogleFonts
                                                                          .inter(
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontWeight,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontStyle,
                                                                  ),
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondaryText,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontStyle,
                                                                ),
                                                          ),
                                                          FFButtonWidget(
                                                            onPressed:
                                                                () async {
                                                              context.pushNamed(
                                                                AllwinnersWidget
                                                                    .routeName,
                                                                queryParameters:
                                                                    {
                                                                  'planamount':
                                                                      serializeParam(
                                                                    getJsonField(
                                                                      myhistroyItem,
                                                                      r'''$.PlanAmount''',
                                                                    ).toString(),
                                                                    ParamType
                                                                        .String,
                                                                  ),
                                                                  'datein':
                                                                      serializeParam(
                                                                    getJsonField(
                                                                      myhistroyItem,
                                                                      r'''$.Datein''',
                                                                    ).toString(),
                                                                    ParamType
                                                                        .String,
                                                                  ),
                                                                }.withoutNulls,
                                                              );
                                                            },
                                                            text:
                                                                'View Details',
                                                            options:
                                                                FFButtonOptions(
                                                              height: 36.0,
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(8.0),
                                                              iconPadding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                              color: Colors
                                                                  .transparent,
                                                              textStyle:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        font: GoogleFonts
                                                                            .inter(
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .fontStyle,
                                                                        ),
                                                                        color:
                                                                            () {
                                                                          if (getJsonField(
                                                                                myhistroyItem,
                                                                                r'''$.WinStatus''',
                                                                              ) ==
                                                                              getJsonField(
                                                                                functions.stringtojson('WIN'),
                                                                                r'''$.message''',
                                                                              )) {
                                                                            return FlutterFlowTheme.of(context).primary;
                                                                          } else if (getJsonField(
                                                                                myhistroyItem,
                                                                                r'''$.WinStatus''',
                                                                              ) ==
                                                                              getJsonField(
                                                                                functions.stringtojson('TRY AGAIN'),
                                                                                r'''$.message''',
                                                                              )) {
                                                                            return FlutterFlowTheme.of(context).secondary;
                                                                          } else {
                                                                            return FlutterFlowTheme.of(context).alternate;
                                                                          }
                                                                        }(),
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .fontStyle,
                                                                      ),
                                                              elevation: 0.0,
                                                              borderSide:
                                                                  BorderSide(
                                                                color: () {
                                                                  if (getJsonField(
                                                                        myhistroyItem,
                                                                        r'''$.WinStatus''',
                                                                      ) ==
                                                                      getJsonField(
                                                                        functions
                                                                            .stringtojson('WIN'),
                                                                        r'''$.message''',
                                                                      )) {
                                                                    return FlutterFlowTheme.of(
                                                                            context)
                                                                        .primary;
                                                                  } else if (getJsonField(
                                                                        myhistroyItem,
                                                                        r'''$.WinStatus''',
                                                                      ) ==
                                                                      getJsonField(
                                                                        functions
                                                                            .stringtojson('TRY AGAIN'),
                                                                        r'''$.message''',
                                                                      )) {
                                                                    return FlutterFlowTheme.of(
                                                                            context)
                                                                        .secondary;
                                                                  } else {
                                                                    return FlutterFlowTheme.of(
                                                                            context)
                                                                        .alternate;
                                                                  }
                                                                }(),
                                                                width: 1.0,
                                                              ),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8.0),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(),
                                            ].divide(SizedBox(height: 1.0)),
                                          ),
                                        );
                                      }).divide(SizedBox(height: 10.0)),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
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
