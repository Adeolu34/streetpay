import '/backend/api_requests/api_calls.dart';
import '/components/account_card/account_card_widget.dart';
import '/components/emptylistdiscovery_widget.dart';
import '/components/noresultfound_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/streetsecure/acceptconnection/acceptconnection_widget.dart';
import '/streetsecure/eventcard/eventcard_widget.dart';
import '/streetsecure/invitecomponent/invitecomponent_widget.dart';
import '/streetsecure/sendconnect/sendconnect_widget.dart';
import '/streetsecure/sendconnectcomp/sendconnectcomp_widget.dart';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'secureuser_model.dart';
export 'secureuser_model.dart';

class SecureuserWidget extends StatefulWidget {
  const SecureuserWidget({super.key});

  static String routeName = 'secureuser';
  static String routePath = '/secureuser';

  @override
  State<SecureuserWidget> createState() => _SecureuserWidgetState();
}

class _SecureuserWidgetState extends State<SecureuserWidget>
    with TickerProviderStateMixin {
  late SecureuserModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  LatLng? currentUserLocationValue;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SecureuserModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.streetauth = await StreetauthCall.call();

      FFAppState().isauto = false;
      safeSetState(() {});
      _model.apiResultiq8 = await GetrequestlistCall.call(
        phonenumber: FFAppState().phonenumber,
        accessToken: StreetauthCall.streettoken(
          (_model.streetauth?.jsonBody ?? ''),
        ),
      );

      _model.history = await GetsecurehistoryCall.call(
        phonenumber: FFAppState().phonenumber,
        accessToken: StreetauthCall.streettoken(
          (_model.streetauth?.jsonBody ?? ''),
        ),
      );

      FFAppState().securehistory = GetsecurehistoryCall.fulldata(
        (_model.history?.jsonBody ?? ''),
      )!
          .toList()
          .cast<dynamic>();
      safeSetState(() {});
    });

    _model.tabBarController = TabController(
      vsync: this,
      length: 2,
      initialIndex: 0,
    )..addListener(() => safeSetState(() {}));

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
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
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            currentUserLocationValue =
                await getCurrentUserLocation(defaultLocation: LatLng(0.0, 0.0));
            _model.location2 = await actions.getlocationpermission();
            _model.locationdetect2 = await LocationdetectCall.call(
              phoneno: functions.removecode(FFAppState().phonenumber),
              lat: functions.getlat(currentUserLocationValue),
              longi: functions.getlang(currentUserLocationValue),
              accessToken: StreetauthCall.streettoken(
                (_model.streetauth?.jsonBody ?? ''),
              ),
            );

            FFAppState().connectionoff = true;
            FFAppState().discoveredphone = LocationdetectCall.fulldata(
              (_model.locationdetect2?.jsonBody ?? ''),
            )!
                .toList()
                .cast<dynamic>();
            FFAppState().isauto = !(FFAppState().isauto ?? true);
            safeSetState(() {});

            safeSetState(() {});
          },
          backgroundColor: FlutterFlowTheme.of(context).primary,
          elevation: 4.0,
          label: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Icon(
                  Icons.person_add_alt_rounded,
                  color: FlutterFlowTheme.of(context).primaryBackground,
                  size: 24.0,
                ),
                Text(
                  !FFAppState().isauto
                      ? 'Auto dicover your host'
                      : 'Manually discover your host',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        font: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        ),
                        color: FlutterFlowTheme.of(context).primaryBackground,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w600,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                ),
              ].divide(SizedBox(width: 8.0)),
            ),
          ),
        ),
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primary,
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            borderRadius: 20.0,
            buttonSize: 40.0,
            icon: Icon(
              Icons.arrow_back_rounded,
              color: FlutterFlowTheme.of(context).primaryBackground,
              size: 24.0,
            ),
            onPressed: () async {
              context.safePop();
            },
          ),
          title: Text(
            'Connections',
            style: FlutterFlowTheme.of(context).headlineSmall.override(
                  font: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontStyle:
                        FlutterFlowTheme.of(context).headlineSmall.fontStyle,
                  ),
                  color: FlutterFlowTheme.of(context).primaryBackground,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w600,
                  fontStyle:
                      FlutterFlowTheme.of(context).headlineSmall.fontStyle,
                ),
          ),
          actions: [],
          centerTitle: true,
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          controller: _model.columnController1,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding:
                    EdgeInsetsDirectional.fromSTEB(10.0, 10.0, 10.0, 100.0),
                child: SingleChildScrollView(
                  controller: _model.columnController2,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              FlutterFlowTheme.of(context).primary,
                              FlutterFlowTheme.of(context).alternate
                            ],
                            stops: [0.0, 1.0],
                            begin: AlignmentDirectional(1.0, 1.0),
                            end: AlignmentDirectional(-1.0, -1.0),
                          ),
                          borderRadius: BorderRadius.circular(0.0),
                        ),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              20.0, 16.0, 20.0, 16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Be a Smart Visitor',
                                style: FlutterFlowTheme.of(context)
                                    .titleMedium
                                    .override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .titleMedium
                                            .fontStyle,
                                      ),
                                      color: FlutterFlowTheme.of(context)
                                          .primaryBackground,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w600,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .titleMedium
                                          .fontStyle,
                                    ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 4.0, 0.0, 0.0),
                                child: Text(
                                  'Log before you go - Securely tag your host',
                                  style: FlutterFlowTheme.of(context)
                                      .bodySmall
                                      .override(
                                        font: GoogleFonts.inter(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .bodySmall
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodySmall
                                                  .fontStyle,
                                        ),
                                        color: FlutterFlowTheme.of(context)
                                            .primaryBackground,
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .fontStyle,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: 350.0,
                        constraints: BoxConstraints(
                          minHeight: 400.0,
                          maxHeight: 600.0,
                        ),
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).primaryBackground,
                        ),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment(0.0, 0),
                              child: TabBar(
                                labelColor:
                                    FlutterFlowTheme.of(context).primaryText,
                                unselectedLabelColor:
                                    FlutterFlowTheme.of(context).secondaryText,
                                labelStyle: FlutterFlowTheme.of(context)
                                    .titleMedium
                                    .override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .titleMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .titleMedium
                                            .fontStyle,
                                      ),
                                      letterSpacing: 0.0,
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .titleMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .titleMedium
                                          .fontStyle,
                                    ),
                                unselectedLabelStyle: FlutterFlowTheme.of(
                                        context)
                                    .titleMedium
                                    .override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .titleMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .titleMedium
                                            .fontStyle,
                                      ),
                                      letterSpacing: 0.0,
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .titleMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .titleMedium
                                          .fontStyle,
                                    ),
                                indicatorColor:
                                    FlutterFlowTheme.of(context).primary,
                                tabs: [
                                  Tab(
                                    text: 'Outgoing visit',
                                  ),
                                  Tab(
                                    text: 'Incoming Visit',
                                  ),
                                ],
                                controller: _model.tabBarController,
                                onTap: (i) async {
                                  [() async {}, () async {}][i]();
                                },
                              ),
                            ),
                            Expanded(
                              child: TabBarView(
                                controller: _model.tabBarController,
                                children: [
                                  SingleChildScrollView(
                                    controller: _model.columnController3,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            if (!FFAppState().isauto)
                                              Column(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 10.0,
                                                                0.0, 0.0),
                                                    child: Container(
                                                      width: 300.0,
                                                      child: TextFormField(
                                                        controller: _model
                                                            .textController,
                                                        focusNode: _model
                                                            .textFieldFocusNode,
                                                        onChanged: (_) =>
                                                            EasyDebounce
                                                                .debounce(
                                                          '_model.textController',
                                                          Duration(
                                                              milliseconds:
                                                                  2000),
                                                          () async {
                                                            _model.retrievewallet =
                                                                await RetriveaccountfromwalletidCall
                                                                    .call(
                                                              accessToken:
                                                                  StreetauthCall
                                                                      .streettoken(
                                                                (_model.streetauth
                                                                        ?.jsonBody ??
                                                                    ''),
                                                              ),
                                                              walletid: _model
                                                                  .textController
                                                                  .text,
                                                            );

                                                            if (RetriveaccountfromwalletidCall
                                                                .success(
                                                              (_model.retrievewallet
                                                                      ?.jsonBody ??
                                                                  ''),
                                                            )!) {
                                                              FFAppState()
                                                                      .searchid =
                                                                  true;
                                                              safeSetState(
                                                                  () {});
                                                            } else {
                                                              FFAppState()
                                                                      .searchid =
                                                                  false;
                                                              safeSetState(
                                                                  () {});
                                                            }

                                                            safeSetState(() {});
                                                          },
                                                        ),
                                                        autofocus: false,
                                                        obscureText: false,
                                                        decoration:
                                                            InputDecoration(
                                                          isDense: true,
                                                          labelStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelMedium
                                                                  .override(
                                                                    font: GoogleFonts
                                                                        .inter(
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelMedium
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelMedium
                                                                          .fontStyle,
                                                                    ),
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .labelMedium
                                                                        .fontWeight,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .labelMedium
                                                                        .fontStyle,
                                                                  ),
                                                          hintText:
                                                              'Search Wallet ID',
                                                          hintStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelMedium
                                                                  .override(
                                                                    font: GoogleFonts
                                                                        .inter(
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelMedium
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelMedium
                                                                          .fontStyle,
                                                                    ),
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .labelMedium
                                                                        .fontWeight,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .labelMedium
                                                                        .fontStyle,
                                                                  ),
                                                          enabledBorder:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primary,
                                                              width: 1.0,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                          ),
                                                          focusedBorder:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                              color: Color(
                                                                  0x00000000),
                                                              width: 1.0,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                          ),
                                                          errorBorder:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .error,
                                                              width: 1.0,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                          ),
                                                          focusedErrorBorder:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .error,
                                                              width: 1.0,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                          ),
                                                          filled: true,
                                                          fillColor: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondaryBackground,
                                                          suffixIcon: Icon(
                                                            Icons
                                                                .search_rounded,
                                                          ),
                                                        ),
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
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
                                                        cursorColor:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                        validator: _model
                                                            .textControllerValidator
                                                            .asValidator(
                                                                context),
                                                      ),
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment:
                                                        AlignmentDirectional(
                                                            -1.0, 0.0),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  20.0,
                                                                  20.0,
                                                                  0.0,
                                                                  20.0),
                                                      child: Text(
                                                        'Search Result',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
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
                                                  ),
                                                  if (FFAppState().searchid)
                                                    InkWell(
                                                      splashColor:
                                                          Colors.transparent,
                                                      focusColor:
                                                          Colors.transparent,
                                                      hoverColor:
                                                          Colors.transparent,
                                                      highlightColor:
                                                          Colors.transparent,
                                                      onTap: () async {
                                                        await showModalBottomSheet(
                                                          isScrollControlled:
                                                              true,
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
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
                                                                      SendconnectWidget(
                                                                    hphone:
                                                                        RetriveaccountfromwalletidCall
                                                                            .phone(
                                                                      (_model.retrievewallet
                                                                              ?.jsonBody ??
                                                                          ''),
                                                                    )!,
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        ).then((value) =>
                                                            safeSetState(
                                                                () {}));
                                                      },
                                                      child: wrapWithModel(
                                                        model: _model
                                                            .sendconnectcompModel,
                                                        updateCallback: () =>
                                                            safeSetState(() {}),
                                                        child:
                                                            SendconnectcompWidget(
                                                          name:
                                                              '${RetriveaccountfromwalletidCall.surname(
                                                            (_model.retrievewallet
                                                                    ?.jsonBody ??
                                                                ''),
                                                          )} ${RetriveaccountfromwalletidCall.othername(
                                                            (_model.retrievewallet
                                                                    ?.jsonBody ??
                                                                ''),
                                                          )}',
                                                          time: dateTimeFormat(
                                                            "jm",
                                                            getCurrentTimestamp,
                                                            locale: FFLocalizations
                                                                    .of(context)
                                                                .languageCode,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  if (!FFAppState().searchid)
                                                    wrapWithModel(
                                                      model: _model
                                                          .noresultfoundModel,
                                                      updateCallback: () =>
                                                          safeSetState(() {}),
                                                      child:
                                                          NoresultfoundWidget(),
                                                    ),
                                                ],
                                              ),
                                            if (FFAppState().isauto)
                                              Column(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  InkWell(
                                                    splashColor:
                                                        Colors.transparent,
                                                    focusColor:
                                                        Colors.transparent,
                                                    hoverColor:
                                                        Colors.transparent,
                                                    highlightColor:
                                                        Colors.transparent,
                                                    onTap: () async {
                                                      _model.istrue =
                                                          await actions
                                                              .checkJsonList(
                                                        LocationdetectCall
                                                            .fulldata(
                                                          (_model.locationdetect2
                                                                  ?.jsonBody ??
                                                              ''),
                                                        ),
                                                      );

                                                      safeSetState(() {});
                                                    },
                                                    child: Container(
                                                      decoration:
                                                          BoxDecoration(),
                                                      child: Builder(
                                                        builder: (context) {
                                                          final nearbylists =
                                                              FFAppState()
                                                                  .discoveredphone
                                                                  .map((e) => e)
                                                                  .toList();
                                                          if (nearbylists
                                                              .isEmpty) {
                                                            return EmptylistdiscoveryWidget();
                                                          }

                                                          return ListView
                                                              .builder(
                                                            padding:
                                                                EdgeInsets.zero,
                                                            shrinkWrap: true,
                                                            scrollDirection:
                                                                Axis.vertical,
                                                            itemCount:
                                                                nearbylists
                                                                    .length,
                                                            itemBuilder: (context,
                                                                nearbylistsIndex) {
                                                              final nearbylistsItem =
                                                                  nearbylists[
                                                                      nearbylistsIndex];
                                                              return Visibility(
                                                                visible:
                                                                    nearbylistsItem !=
                                                                        null,
                                                                child: Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          10.0,
                                                                          0.0,
                                                                          10.0),
                                                                  child:
                                                                      InkWell(
                                                                    splashColor:
                                                                        Colors
                                                                            .transparent,
                                                                    focusColor:
                                                                        Colors
                                                                            .transparent,
                                                                    hoverColor:
                                                                        Colors
                                                                            .transparent,
                                                                    highlightColor:
                                                                        Colors
                                                                            .transparent,
                                                                    onTap:
                                                                        () async {
                                                                      await showModalBottomSheet(
                                                                        isScrollControlled:
                                                                            true,
                                                                        backgroundColor:
                                                                            Colors.transparent,
                                                                        isDismissible:
                                                                            false,
                                                                        enableDrag:
                                                                            false,
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (context) {
                                                                          return WebViewAware(
                                                                            child:
                                                                                GestureDetector(
                                                                              onTap: () {
                                                                                FocusScope.of(context).unfocus();
                                                                                FocusManager.instance.primaryFocus?.unfocus();
                                                                              },
                                                                              child: Padding(
                                                                                padding: MediaQuery.viewInsetsOf(context),
                                                                                child: SendconnectWidget(
                                                                                  hphone: getJsonField(
                                                                                    nearbylistsItem,
                                                                                    r'''$.phone''',
                                                                                  ).toString(),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          );
                                                                        },
                                                                      ).then((value) =>
                                                                          safeSetState(
                                                                              () {}));
                                                                    },
                                                                    child:
                                                                        AccountCardWidget(
                                                                      key: Key(
                                                                          'Keyxgg_${nearbylistsIndex}_of_${nearbylists.length}'),
                                                                      accountName:
                                                                          valueOrDefault<
                                                                              String>(
                                                                        getJsonField(
                                                                          nearbylistsItem,
                                                                          r'''$.Othernames''',
                                                                        )?.toString(),
                                                                        'John Doe',
                                                                      ),
                                                                      accountNumber:
                                                                          valueOrDefault<
                                                                              String>(
                                                                        getJsonField(
                                                                          nearbylistsItem,
                                                                          r'''$.AccountNo''',
                                                                        )?.toString(),
                                                                        '000000000000',
                                                                      ),
                                                                      bankName:
                                                                          'StreetPay',
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
                                                ],
                                              ),
                                          ],
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  16.0, 16.0, 16.0, 0.0),
                                          child: Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryBackground,
                                              borderRadius:
                                                  BorderRadius.circular(0.0),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      0.0, 0.0, 0.0, 16.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Connection History',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .titleMedium
                                                        .override(
                                                          font:
                                                              GoogleFonts.inter(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleMedium
                                                                    .fontStyle,
                                                          ),
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
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
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 4.0,
                                                                0.0, 0.0),
                                                    child: Text(
                                                      'People you\'ve connected with in the past',
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodySmall
                                                              .override(
                                                                font:
                                                                    GoogleFonts
                                                                        .inter(
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodySmall
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodySmall
                                                                      .fontStyle,
                                                                ),
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryText,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodySmall
                                                                    .fontWeight,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodySmall
                                                                    .fontStyle,
                                                              ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 16.0,
                                                                0.0, 16.0),
                                                    child: Builder(
                                                      builder: (context) {
                                                        final historylist =
                                                            FFAppState()
                                                                .securehistory
                                                                .toList();

                                                        return Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: List.generate(
                                                              historylist
                                                                  .length,
                                                              (historylistIndex) {
                                                            final historylistItem =
                                                                historylist[
                                                                    historylistIndex];
                                                            return Visibility(
                                                              visible: (GetsecurehistoryCall
                                                                      .direction(
                                                                    (_model.history
                                                                            ?.jsonBody ??
                                                                        ''),
                                                                  )?.elementAtOrNull(
                                                                      historylistIndex)) ==
                                                                  'Outgoing',
                                                              child:
                                                                  InvitecomponentWidget(
                                                                key: Key(
                                                                    'Keylcn_${historylistIndex}_of_${historylist.length}'),
                                                                name:
                                                                    valueOrDefault<
                                                                        String>(
                                                                  getJsonField(
                                                                            historylistItem,
                                                                            r'''$.Vphone''',
                                                                          ) ==
                                                                          functions
                                                                              .stringtojson(FFAppState().phonenumber)
                                                                      ? getJsonField(
                                                                          historylistItem,
                                                                          r'''$.HName''',
                                                                        ).toString()
                                                                      : getJsonField(
                                                                          historylistItem,
                                                                          r'''$.VName''',
                                                                        ).toString(),
                                                                  '- - -',
                                                                ),
                                                                datein:
                                                                    dateTimeFormat(
                                                                  "relative",
                                                                  functions
                                                                      .stringtotimstamp(
                                                                          getJsonField(
                                                                    historylistItem,
                                                                    r'''$.VDatein''',
                                                                  ).toString()),
                                                                  locale: FFLocalizations.of(
                                                                          context)
                                                                      .languageCode,
                                                                ),
                                                                status:
                                                                    getJsonField(
                                                                  historylistItem,
                                                                  r'''$.VStatus''',
                                                                ).toString(),
                                                                meetingdetails:
                                                                    getJsonField(
                                                                  historylistItem,
                                                                  r'''$.reqtext''',
                                                                ).toString(),
                                                                id: getJsonField(
                                                                  historylistItem,
                                                                  r'''$.id''',
                                                                ).toString(),
                                                                originator: 'H',
                                                              ),
                                                            );
                                                          }).divide(
                                                            SizedBox(
                                                                height: 10.0),
                                                            filterFn:
                                                                (historylistIndex) {
                                                              final historylistItem =
                                                                  historylist[
                                                                      historylistIndex];
                                                              return (GetsecurehistoryCall
                                                                      .direction(
                                                                    (_model.history
                                                                            ?.jsonBody ??
                                                                        ''),
                                                                  )?.elementAtOrNull(
                                                                      historylistIndex)) ==
                                                                  'Outgoing';
                                                            },
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SingleChildScrollView(
                                    controller: _model.columnController4,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      0.0, 20.0, 0.0, 0.0),
                                              child: Builder(
                                                builder: (context) {
                                                  final fulllist =
                                                      (GetrequestlistCall
                                                                  .fulldata(
                                                                (_model.apiResultiq8
                                                                        ?.jsonBody ??
                                                                    ''),
                                                              )?.toList() ??
                                                              [])
                                                          .take(1)
                                                          .toList();

                                                  return Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: List.generate(
                                                        fulllist.length,
                                                        (fulllistIndex) {
                                                      final fulllistItem =
                                                          fulllist[
                                                              fulllistIndex];
                                                      return InkWell(
                                                        splashColor:
                                                            Colors.transparent,
                                                        focusColor:
                                                            Colors.transparent,
                                                        hoverColor:
                                                            Colors.transparent,
                                                        highlightColor:
                                                            Colors.transparent,
                                                        onTap: () async {
                                                          await showModalBottomSheet(
                                                            isScrollControlled:
                                                                true,
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                            isDismissible:
                                                                false,
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
                                                                  child:
                                                                      Padding(
                                                                    padding: MediaQuery
                                                                        .viewInsetsOf(
                                                                            context),
                                                                    child:
                                                                        AcceptconnectionWidget(
                                                                      id: getJsonField(
                                                                        fulllistItem,
                                                                        r'''$.id''',
                                                                      ).toString(),
                                                                      vName:
                                                                          getJsonField(
                                                                        fulllistItem,
                                                                        r'''$.VFullname''',
                                                                      ).toString(),
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          ).then((value) =>
                                                              safeSetState(
                                                                  () {}));
                                                        },
                                                        child: EventcardWidget(
                                                          key: Key(
                                                              'Keyrk4_${fulllistIndex}_of_${fulllist.length}'),
                                                          name: getJsonField(
                                                            fulllistItem,
                                                            r'''$.VFullname''',
                                                          ).toString(),
                                                          datein:
                                                              dateTimeFormat(
                                                            "relative",
                                                            functions
                                                                .stringtotimstamp(
                                                                    getJsonField(
                                                              fulllistItem,
                                                              r'''$.VDatein''',
                                                            ).toString()),
                                                            locale: FFLocalizations
                                                                    .of(context)
                                                                .languageCode,
                                                          ),
                                                          eventdetail:
                                                              getJsonField(
                                                            fulllistItem,
                                                            r'''$.reqtext''',
                                                          ).toString(),
                                                        ),
                                                      );
                                                    }).divide(
                                                        SizedBox(height: 10.0)),
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  16.0, 16.0, 16.0, 0.0),
                                          child: Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryBackground,
                                              borderRadius:
                                                  BorderRadius.circular(0.0),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      0.0, 0.0, 0.0, 16.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Connection History',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .titleMedium
                                                        .override(
                                                          font:
                                                              GoogleFonts.inter(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleMedium
                                                                    .fontStyle,
                                                          ),
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
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
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 4.0,
                                                                0.0, 0.0),
                                                    child: Text(
                                                      'People you\'ve connected with in the past',
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodySmall
                                                              .override(
                                                                font:
                                                                    GoogleFonts
                                                                        .inter(
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodySmall
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodySmall
                                                                      .fontStyle,
                                                                ),
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryText,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodySmall
                                                                    .fontWeight,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodySmall
                                                                    .fontStyle,
                                                              ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 16.0,
                                                                0.0, 16.0),
                                                    child: Builder(
                                                      builder: (context) {
                                                        final historylistincoming =
                                                            FFAppState()
                                                                .securehistory
                                                                .toList();

                                                        return Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: List.generate(
                                                              historylistincoming
                                                                  .length,
                                                              (historylistincomingIndex) {
                                                            final historylistincomingItem =
                                                                historylistincoming[
                                                                    historylistincomingIndex];
                                                            return Visibility(
                                                              visible: (GetsecurehistoryCall
                                                                      .direction(
                                                                    (_model.history
                                                                            ?.jsonBody ??
                                                                        ''),
                                                                  )?.elementAtOrNull(
                                                                      historylistincomingIndex)) ==
                                                                  'Incoming',
                                                              child:
                                                                  InvitecomponentWidget(
                                                                key: Key(
                                                                    'Keyoo9_${historylistincomingIndex}_of_${historylistincoming.length}'),
                                                                name:
                                                                    valueOrDefault<
                                                                        String>(
                                                                  getJsonField(
                                                                            historylistincomingItem,
                                                                            r'''$.Vphone''',
                                                                          ) ==
                                                                          functions
                                                                              .stringtojson(FFAppState().phonenumber)
                                                                      ? getJsonField(
                                                                          historylistincomingItem,
                                                                          r'''$.HName''',
                                                                        ).toString()
                                                                      : getJsonField(
                                                                          historylistincomingItem,
                                                                          r'''$.VName''',
                                                                        ).toString(),
                                                                  '- - -',
                                                                ),
                                                                datein:
                                                                    dateTimeFormat(
                                                                  "relative",
                                                                  functions
                                                                      .stringtotimstamp(
                                                                          getJsonField(
                                                                    historylistincomingItem,
                                                                    r'''$.VDatein''',
                                                                  ).toString()),
                                                                  locale: FFLocalizations.of(
                                                                          context)
                                                                      .languageCode,
                                                                ),
                                                                status:
                                                                    getJsonField(
                                                                  historylistincomingItem,
                                                                  r'''$.VStatus''',
                                                                ).toString(),
                                                                meetingdetails:
                                                                    getJsonField(
                                                                  historylistincomingItem,
                                                                  r'''$.reqtext''',
                                                                ).toString(),
                                                                id: getJsonField(
                                                                  historylistincomingItem,
                                                                  r'''$.id''',
                                                                ).toString(),
                                                                originator: 'V',
                                                              ),
                                                            );
                                                          }).divide(
                                                            SizedBox(
                                                                height: 10.0),
                                                            filterFn:
                                                                (historylistincomingIndex) {
                                                              final historylistincomingItem =
                                                                  historylistincoming[
                                                                      historylistincomingIndex];
                                                              return (GetsecurehistoryCall
                                                                      .direction(
                                                                    (_model.history
                                                                            ?.jsonBody ??
                                                                        ''),
                                                                  )?.elementAtOrNull(
                                                                      historylistincomingIndex)) ==
                                                                  'Incoming';
                                                            },
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
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
