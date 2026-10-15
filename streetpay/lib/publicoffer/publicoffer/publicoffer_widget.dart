import '/backend/api_requests/api_calls.dart';
import '/components/errorcomp_widget.dart';
import '/components/nooffer_widget.dart';
import '/components/switchss_widget.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'publicoffer_model.dart';
export 'publicoffer_model.dart';

/// Create a pageDesign a clean, modern public offer page with a green and
/// white theme, rounded cards, smooth shadows and clear typography.
///
/// The top section shows “Public Offers In Your Area” with a short note like
/// “We found 10 offers near you. Access Fee is 10 Naira per offer.” Below,
/// display a vertical list of offers showing category name, masked business
/// name, and distance in minutes. Each list item should be clickable to open
/// a pop-up card showing full business details: address, category, company
/// name, offer title, discount or amount, Instagram handle, WhatsApp button,
/// long description, bonanza price, and expiry date. Include a button to
/// Unlock Offer for 10 Naira. Add a rating and report overlay where a user
/// enters phone, selects offer, chooses flag or star rating, and submits a
/// comment. For business owners, include a simple “My Public Offers”
/// dashboard where each offer can be enabled, disabled, or deleted using
/// clean toggle or button controls.
class PublicofferWidget extends StatefulWidget {
  const PublicofferWidget({super.key});

  static String routeName = 'publicoffer';
  static String routePath = '/publicoffer';

  @override
  State<PublicofferWidget> createState() => _PublicofferWidgetState();
}

class _PublicofferWidgetState extends State<PublicofferWidget> {
  late PublicofferModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  LatLng? currentUserLocationValue;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PublicofferModel());

    getCurrentUserLocation(defaultLocation: LatLng(0.0, 0.0), cached: true)
        .then((loc) => safeSetState(() => currentUserLocationValue = loc));
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
    if (currentUserLocationValue == null) {
      return Container(
        color: FlutterFlowTheme.of(context).primaryBackground,
        child: Center(
          child: SizedBox(
            width: 50.0,
            height: 50.0,
            child: SpinKitDoubleBounce(
              color: FlutterFlowTheme.of(context).primary,
              size: 50.0,
            ),
          ),
        ),
      );
    }

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
            'Public Offers',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  font: GoogleFonts.inter(
                    fontWeight:
                        FlutterFlowTheme.of(context).headlineMedium.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                  ),
                  color: Colors.white,
                  fontSize: 22.0,
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
          child: SingleChildScrollView(
            controller: _model.columnController,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Color(0xFF2E7D32),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 8.0,
                          color: Color(0x1A2E7D32),
                          offset: Offset(
                            0.0,
                            2.0,
                          ),
                        )
                      ],
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Public Offers In Your Area',
                            style: FlutterFlowTheme.of(context)
                                .headlineMedium
                                .override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .headlineMedium
                                        .fontStyle,
                                  ),
                                  color: Colors.white,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .headlineMedium
                                      .fontStyle,
                                ),
                          ),
                          Text(
                            'We found 10 offers near you. Access Fee is 10 Naira per offer.',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                                  color: Color(0xE6FFFFFF),
                                  fontSize: 14.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontStyle,
                                ),
                          ),
                        ].divide(SizedBox(height: 8.0)),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional(1.0, 0.0),
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 30.0, 0.0),
                    child: FFButtonWidget(
                      onPressed: () async {
                        context.pushNamed(CreateofferWidget.routeName);
                      },
                      text: 'Create Offer',
                      options: FFButtonOptions(
                        height: 40.0,
                        padding: EdgeInsetsDirectional.fromSTEB(
                            16.0, 0.0, 16.0, 0.0),
                        iconPadding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
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
                                  color: Colors.white,
                                  letterSpacing: 0.0,
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .fontStyle,
                                ),
                        elevation: 0.0,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FutureBuilder<ApiCallResponse>(
                      future: GetoffercategoryCall.call(
                        accessToken: FFAppState().bsptoken,
                      ),
                      builder: (context, snapshot) {
                        // Customize what your widget looks like when it's loading.
                        if (!snapshot.hasData) {
                          return Center(
                            child: SizedBox(
                              width: 50.0,
                              height: 50.0,
                              child: SpinKitDoubleBounce(
                                color: FlutterFlowTheme.of(context).primary,
                                size: 50.0,
                              ),
                            ),
                          );
                        }
                        final dropDownGetoffercategoryResponse = snapshot.data!;

                        return FlutterFlowDropDown<String>(
                          controller: _model.dropDownValueController1 ??=
                              FormFieldController<String>(null),
                          options: GetoffercategoryCall.category(
                            dropDownGetoffercategoryResponse.jsonBody,
                          )!,
                          onChanged: (val) =>
                              safeSetState(() => _model.dropDownValue1 = val),
                          width: 250.0,
                          height: 50.0,
                          textStyle:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                          hintText: 'Select...',
                          icon: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: FlutterFlowTheme.of(context).secondaryText,
                            size: 24.0,
                          ),
                          fillColor:
                              FlutterFlowTheme.of(context).primaryBackground,
                          elevation: 2.0,
                          borderColor: FlutterFlowTheme.of(context).primary,
                          borderWidth: 0.0,
                          borderRadius: 8.0,
                          margin: EdgeInsetsDirectional.fromSTEB(
                              12.0, 0.0, 12.0, 0.0),
                          hidesUnderline: true,
                          isOverButton: false,
                          isSearchable: false,
                          isMultiSelect: false,
                        );
                      },
                    ),
                    if (_model.dropDownValue1 != null &&
                        _model.dropDownValue1 != '')
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
                        child: InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            safeSetState(() {
                              _model.dropDownValueController1?.reset();
                              _model.dropDownValue1 = null;
                            });
                          },
                          child: Text(
                            'Clear filter ',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                                  letterSpacing: 0.0,
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontStyle,
                                ),
                          ),
                        ),
                      ),
                  ],
                ),
                if (_model.dropDownValue1 == null ||
                    _model.dropDownValue1 == '')
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                    child: FutureBuilder<ApiCallResponse>(
                      future: ListnearbyCall.call(
                        lat: getJsonField(
                          functions
                              .latlangsplit(currentUserLocationValue)
                              .toMap(),
                          r'''$.lat''',
                        ),
                        long: getJsonField(
                          functions
                              .latlangsplit(currentUserLocationValue)
                              .toMap(),
                          r'''$.lang''',
                        ),
                        accessToken: FFAppState().bsptoken,
                        radius: '50000',
                      ),
                      builder: (context, snapshot) {
                        // Customize what your widget looks like when it's loading.
                        if (!snapshot.hasData) {
                          return Center(
                            child: SizedBox(
                              width: 50.0,
                              height: 50.0,
                              child: SpinKitDoubleBounce(
                                color: FlutterFlowTheme.of(context).primary,
                                size: 50.0,
                              ),
                            ),
                          );
                        }
                        final columnListnearbyResponse = snapshot.data!;

                        return Builder(
                          builder: (context) {
                            final offerlist = ListnearbyCall.offerlist(
                                  columnListnearbyResponse.jsonBody,
                                )?.toList() ??
                                [];
                            if (offerlist.isEmpty) {
                              return NoofferWidget();
                            }

                            return Column(
                              mainAxisSize: MainAxisSize.max,
                              children: List.generate(offerlist.length,
                                  (offerlistIndex) {
                                final offerlistItem = offerlist[offerlistIndex];
                                return Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      _model.publicofferfess =
                                          await GetofferchargesCall.call(
                                        accessToken: FFAppState().bsptoken,
                                      );

                                      _model.deviceid =
                                          await actions.getdeviceid();
                                      _model.transref =
                                          await actions.generatetransref();
                                      _model.transtoken =
                                          await GettransactiontokenCall.call(
                                        accessToken: FFAppState().bsptoken,
                                        accountno: FFAppState().accountno,
                                        deviceid: _model.deviceid,
                                        sessionid: FFAppState().sessionid,
                                      );

                                      _model.debitwalet =
                                          await WalletAsAServiceGroup
                                              .debitwalletCall
                                              .call(
                                        narration: 'Public offer',
                                        amount: GetofferchargesCall.accessfee(
                                          (_model.publicofferfess?.jsonBody ??
                                              ''),
                                        ),
                                        transactionid: _model.transref,
                                        accountno: FFAppState().accountno,
                                        refid:
                                            GettransactiontokenCall.transtoken(
                                          (_model.transtoken?.jsonBody ?? ''),
                                        ),
                                        authToken: FFAppState().bsptoken,
                                      );

                                      if (WalletAsAServiceGroup.debitwalletCall
                                              .success(
                                            (_model.debitwalet?.jsonBody ?? ''),
                                          ) ==
                                          true) {
                                        context.pushNamed(
                                          OfferdetailWidget.routeName,
                                          queryParameters: {
                                            'companyname': serializeParam(
                                              getJsonField(
                                                offerlistItem,
                                                r'''$.CompanyName''',
                                              ).toString(),
                                              ParamType.String,
                                            ),
                                            'timeaway': serializeParam(
                                              getJsonField(
                                                offerlistItem,
                                                r'''$.TimeAway''',
                                              ).toString(),
                                              ParamType.String,
                                            ),
                                            'offername': serializeParam(
                                              getJsonField(
                                                offerlistItem,
                                                r'''$.OfferName''',
                                              ).toString(),
                                              ParamType.String,
                                            ),
                                            'address': serializeParam(
                                              getJsonField(
                                                offerlistItem,
                                                r'''$.BusinessTextAddress''',
                                              ).toString(),
                                              ParamType.String,
                                            ),
                                            'instagram': serializeParam(
                                              getJsonField(
                                                offerlistItem,
                                                r'''$.Instagram''',
                                              ).toString(),
                                              ParamType.String,
                                            ),
                                            'expiredate': serializeParam(
                                              getJsonField(
                                                offerlistItem,
                                                r'''$.EndDate''',
                                              ).toString(),
                                              ParamType.String,
                                            ),
                                            'amount': serializeParam(
                                              getJsonField(
                                                offerlistItem,
                                                r'''$.Amount''',
                                              ).toString(),
                                              ParamType.String,
                                            ),
                                            'mode': serializeParam(
                                              getJsonField(
                                                offerlistItem,
                                                r'''$.accessmode''',
                                              ).toString(),
                                              ParamType.String,
                                            ),
                                            'whatsapp': serializeParam(
                                              getJsonField(
                                                offerlistItem,
                                                r'''$.WhatsAppNo''',
                                              ).toString(),
                                              ParamType.String,
                                            ),
                                            'discount': serializeParam(
                                              getJsonField(
                                                offerlistItem,
                                                r'''$.Discount''',
                                              ).toString(),
                                              ParamType.String,
                                            ),
                                            'offerdescription': serializeParam(
                                              getJsonField(
                                                offerlistItem,
                                                r'''$.OfferDescription''',
                                              ).toString(),
                                              ParamType.String,
                                            ),
                                          }.withoutNulls,
                                        );
                                      } else {
                                        await showModalBottomSheet(
                                          isScrollControlled: true,
                                          backgroundColor: Colors.transparent,
                                          enableDrag: false,
                                          context: context,
                                          builder: (context) {
                                            return WebViewAware(
                                              child: GestureDetector(
                                                onTap: () {
                                                  FocusScope.of(context)
                                                      .unfocus();
                                                  FocusManager
                                                      .instance.primaryFocus
                                                      ?.unfocus();
                                                },
                                                child: Padding(
                                                  padding:
                                                      MediaQuery.viewInsetsOf(
                                                          context),
                                                  child: ErrorcompWidget(
                                                    message:
                                                        'Unable to fetch details try again',
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ).then((value) => safeSetState(() {}));
                                      }

                                      safeSetState(() {});
                                    },
                                    child: AnimatedContainer(
                                      duration: Duration(milliseconds: 300),
                                      curve: Curves.elasticOut,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            blurRadius: 6.0,
                                            color: Color(0x1A000000),
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        valueOrDefault<String>(
                                                          getJsonField(
                                                            offerlistItem,
                                                            r'''$.OfferName''',
                                                          )?.toString(),
                                                          '- - -',
                                                        ),
                                                        style: FlutterFlowTheme
                                                                .of(context)
                                                            .bodySmall
                                                            .override(
                                                              font: GoogleFonts
                                                                  .inter(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodySmall
                                                                    .fontStyle,
                                                              ),
                                                              color: Color(
                                                                  0xFF2E7D32),
                                                              fontSize: 12.0,
                                                              letterSpacing:
                                                                  0.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontStyle:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodySmall
                                                                      .fontStyle,
                                                            ),
                                                      ),
                                                      Text(
                                                        getJsonField(
                                                          offerlistItem,
                                                          r'''$.accessmode''',
                                                        ).toString(),
                                                        style: FlutterFlowTheme
                                                                .of(context)
                                                            .bodySmall
                                                            .override(
                                                              font: GoogleFonts
                                                                  .inter(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodySmall
                                                                    .fontStyle,
                                                              ),
                                                              color: Color(
                                                                  0xFF2E7D32),
                                                              fontSize: 12.0,
                                                              letterSpacing:
                                                                  0.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontStyle:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodySmall
                                                                      .fontStyle,
                                                            ),
                                                      ),
                                                    ],
                                                  ),
                                                  Text(
                                                    '******* ',
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
                                                  Text(
                                                    valueOrDefault<String>(
                                                      getJsonField(
                                                        offerlistItem,
                                                        r'''$.BusinessTextAddress''',
                                                      )?.toString(),
                                                      '- - -',
                                                    ),
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
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primary,
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
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          Icon(
                                                            Icons.location_on,
                                                            color: Color(
                                                                0xFF757575),
                                                            size: 16.0,
                                                          ),
                                                          Text(
                                                            getJsonField(
                                                              offerlistItem,
                                                              r'''$.DistanceKm''',
                                                            ).toString(),
                                                            style: FlutterFlowTheme
                                                                    .of(context)
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
                                                                  color: Color(
                                                                      0xFF757575),
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
                                                        ].divide(SizedBox(
                                                            width: 4.0)),
                                                      ),
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          Icon(
                                                            Icons.timer_sharp,
                                                            color: Color(
                                                                0xFF757575),
                                                            size: 16.0,
                                                          ),
                                                          Text(
                                                            getJsonField(
                                                              offerlistItem,
                                                              r'''$.TimeAway''',
                                                            ).toString(),
                                                            style: FlutterFlowTheme
                                                                    .of(context)
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
                                                                  color: Color(
                                                                      0xFF757575),
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
                                                        ].divide(SizedBox(
                                                            width: 4.0)),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        'Amount: ₦ ${getJsonField(
                                                          offerlistItem,
                                                          r'''$.Amount''',
                                                        ).toString()}',
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
                                                    ],
                                                  ),
                                                ].divide(SizedBox(height: 4.0)),
                                              ),
                                            ),
                                            Icon(
                                              Icons.chevron_right_rounded,
                                              color: Color(0xFF2E7D32),
                                              size: 24.0,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            );
                          },
                        );
                      },
                    ),
                  ),
                if (_model.dropDownValue1 != null &&
                    _model.dropDownValue1 != '')
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                    child: FutureBuilder<ApiCallResponse>(
                      future: GetnearbybycategoryCall.call(
                        lat: getJsonField(
                          functions
                              .latlangsplit(currentUserLocationValue)
                              .toMap(),
                          r'''$.lat''',
                        ),
                        accessToken: FFAppState().bsptoken,
                        long: getJsonField(
                          functions
                              .latlangsplit(currentUserLocationValue)
                              .toMap(),
                          r'''$.lang''',
                        ),
                        radius: '50000',
                        category: _model.dropDownValue1,
                      ),
                      builder: (context, snapshot) {
                        // Customize what your widget looks like when it's loading.
                        if (!snapshot.hasData) {
                          return Center(
                            child: SizedBox(
                              width: 50.0,
                              height: 50.0,
                              child: SpinKitDoubleBounce(
                                color: FlutterFlowTheme.of(context).primary,
                                size: 50.0,
                              ),
                            ),
                          );
                        }
                        final columnGetnearbybycategoryResponse =
                            snapshot.data!;

                        return Builder(
                          builder: (context) {
                            final offerlist = GetnearbybycategoryCall.offerlist(
                                  columnGetnearbybycategoryResponse.jsonBody,
                                )?.toList() ??
                                [];
                            if (offerlist.isEmpty) {
                              return NoofferWidget();
                            }

                            return Column(
                              mainAxisSize: MainAxisSize.max,
                              children: List.generate(offerlist.length,
                                  (offerlistIndex) {
                                final offerlistItem = offerlist[offerlistIndex];
                                return Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      _model.publicofferfesss =
                                          await GetofferchargesCall.call(
                                        accessToken: FFAppState().bsptoken,
                                      );

                                      _model.deviceid2 =
                                          await actions.getdeviceid();
                                      _model.transref2 =
                                          await actions.generatetransref();
                                      _model.transtoken2 =
                                          await GettransactiontokenCall.call(
                                        accessToken: FFAppState().bsptoken,
                                        accountno: FFAppState().accountno,
                                        deviceid: _model.deviceid2,
                                        sessionid: FFAppState().sessionid,
                                      );

                                      _model.debitwalet2 =
                                          await WalletAsAServiceGroup
                                              .debitwalletCall
                                              .call(
                                        narration: 'Public offer',
                                        amount: GetofferchargesCall.accessfee(
                                          (_model.publicofferfesss?.jsonBody ??
                                              ''),
                                        ),
                                        transactionid: _model.transref2,
                                        accountno: FFAppState().accountno,
                                        refid:
                                            GettransactiontokenCall.transtoken(
                                          (_model.transtoken2?.jsonBody ?? ''),
                                        ),
                                        authToken: FFAppState().bsptoken,
                                      );

                                      if (WalletAsAServiceGroup.debitwalletCall
                                              .success(
                                            (_model.debitwalet2?.jsonBody ??
                                                ''),
                                          ) ==
                                          true) {
                                        context.pushNamed(
                                          OfferdetailWidget.routeName,
                                          queryParameters: {
                                            'companyname': serializeParam(
                                              getJsonField(
                                                offerlistItem,
                                                r'''$.CompanyName''',
                                              ).toString(),
                                              ParamType.String,
                                            ),
                                            'timeaway': serializeParam(
                                              getJsonField(
                                                offerlistItem,
                                                r'''$.TimeAway''',
                                              ).toString(),
                                              ParamType.String,
                                            ),
                                            'offername': serializeParam(
                                              getJsonField(
                                                offerlistItem,
                                                r'''$.OfferName''',
                                              ).toString(),
                                              ParamType.String,
                                            ),
                                            'address': serializeParam(
                                              getJsonField(
                                                offerlistItem,
                                                r'''$.BusinessTextAddress''',
                                              ).toString(),
                                              ParamType.String,
                                            ),
                                            'instagram': serializeParam(
                                              getJsonField(
                                                offerlistItem,
                                                r'''$.Instagram''',
                                              ).toString(),
                                              ParamType.String,
                                            ),
                                            'expiredate': serializeParam(
                                              getJsonField(
                                                offerlistItem,
                                                r'''$.EndDate''',
                                              ).toString(),
                                              ParamType.String,
                                            ),
                                            'amount': serializeParam(
                                              getJsonField(
                                                offerlistItem,
                                                r'''$.Amount''',
                                              ).toString(),
                                              ParamType.String,
                                            ),
                                            'mode': serializeParam(
                                              getJsonField(
                                                offerlistItem,
                                                r'''$.accessmode''',
                                              ).toString(),
                                              ParamType.String,
                                            ),
                                            'whatsapp': serializeParam(
                                              getJsonField(
                                                offerlistItem,
                                                r'''$.WhatsAppNo''',
                                              ).toString(),
                                              ParamType.String,
                                            ),
                                            'discount': serializeParam(
                                              getJsonField(
                                                offerlistItem,
                                                r'''$.Discount''',
                                              ).toString(),
                                              ParamType.String,
                                            ),
                                            'offerdescription': serializeParam(
                                              getJsonField(
                                                offerlistItem,
                                                r'''$.OfferDescription''',
                                              ).toString(),
                                              ParamType.String,
                                            ),
                                          }.withoutNulls,
                                        );
                                      } else {
                                        await showModalBottomSheet(
                                          isScrollControlled: true,
                                          backgroundColor: Colors.transparent,
                                          enableDrag: false,
                                          context: context,
                                          builder: (context) {
                                            return WebViewAware(
                                              child: GestureDetector(
                                                onTap: () {
                                                  FocusScope.of(context)
                                                      .unfocus();
                                                  FocusManager
                                                      .instance.primaryFocus
                                                      ?.unfocus();
                                                },
                                                child: Padding(
                                                  padding:
                                                      MediaQuery.viewInsetsOf(
                                                          context),
                                                  child: ErrorcompWidget(
                                                    message:
                                                        'Unable to fetch details try again',
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ).then((value) => safeSetState(() {}));
                                      }

                                      safeSetState(() {});
                                    },
                                    child: AnimatedContainer(
                                      duration: Duration(milliseconds: 300),
                                      curve: Curves.elasticOut,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            blurRadius: 6.0,
                                            color: Color(0x1A000000),
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        valueOrDefault<String>(
                                                          getJsonField(
                                                            offerlistItem,
                                                            r'''$.OfferName''',
                                                          )?.toString(),
                                                          '- - -',
                                                        ),
                                                        style: FlutterFlowTheme
                                                                .of(context)
                                                            .bodySmall
                                                            .override(
                                                              font: GoogleFonts
                                                                  .inter(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodySmall
                                                                    .fontStyle,
                                                              ),
                                                              color: Color(
                                                                  0xFF2E7D32),
                                                              fontSize: 12.0,
                                                              letterSpacing:
                                                                  0.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontStyle:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodySmall
                                                                      .fontStyle,
                                                            ),
                                                      ),
                                                      Text(
                                                        getJsonField(
                                                          offerlistItem,
                                                          r'''$.accessmode''',
                                                        ).toString(),
                                                        style: FlutterFlowTheme
                                                                .of(context)
                                                            .bodySmall
                                                            .override(
                                                              font: GoogleFonts
                                                                  .inter(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodySmall
                                                                    .fontStyle,
                                                              ),
                                                              color: Color(
                                                                  0xFF2E7D32),
                                                              fontSize: 12.0,
                                                              letterSpacing:
                                                                  0.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontStyle:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodySmall
                                                                      .fontStyle,
                                                            ),
                                                      ),
                                                    ],
                                                  ),
                                                  Text(
                                                    '******* ',
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
                                                  Text(
                                                    valueOrDefault<String>(
                                                      getJsonField(
                                                        offerlistItem,
                                                        r'''$.BusinessTextAddress''',
                                                      )?.toString(),
                                                      '- - -',
                                                    ),
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
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primary,
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
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          Icon(
                                                            Icons.location_on,
                                                            color: Color(
                                                                0xFF757575),
                                                            size: 16.0,
                                                          ),
                                                          Text(
                                                            getJsonField(
                                                              offerlistItem,
                                                              r'''$.DistanceKm''',
                                                            ).toString(),
                                                            style: FlutterFlowTheme
                                                                    .of(context)
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
                                                                  color: Color(
                                                                      0xFF757575),
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
                                                        ].divide(SizedBox(
                                                            width: 4.0)),
                                                      ),
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          Icon(
                                                            Icons.timer_sharp,
                                                            color: Color(
                                                                0xFF757575),
                                                            size: 16.0,
                                                          ),
                                                          Text(
                                                            getJsonField(
                                                              offerlistItem,
                                                              r'''$.TimeAway''',
                                                            ).toString(),
                                                            style: FlutterFlowTheme
                                                                    .of(context)
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
                                                                  color: Color(
                                                                      0xFF757575),
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
                                                        ].divide(SizedBox(
                                                            width: 4.0)),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        'Amount: ₦ ${getJsonField(
                                                          offerlistItem,
                                                          r'''$.Amount''',
                                                        ).toString()}',
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
                                                    ],
                                                  ),
                                                ].divide(SizedBox(height: 4.0)),
                                              ),
                                            ),
                                            Icon(
                                              Icons.chevron_right_rounded,
                                              color: Color(0xFF2E7D32),
                                              size: 24.0,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            );
                          },
                        );
                      },
                    ),
                  ),
                if (responsiveVisibility(
                  context: context,
                  phone: false,
                ))
                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 8.0,
                            color: Color(0x1A000000),
                            offset: Offset(
                              0.0,
                              3.0,
                            ),
                          )
                        ],
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Rate & Report',
                                  style: FlutterFlowTheme.of(context)
                                      .headlineSmall
                                      .override(
                                        font: GoogleFonts.inter(
                                          fontWeight: FontWeight.w600,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .headlineSmall
                                                  .fontStyle,
                                        ),
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .headlineSmall
                                            .fontStyle,
                                      ),
                                ),
                                FlutterFlowIconButton(
                                  borderRadius: 16.0,
                                  buttonSize: 32.0,
                                  fillColor: Color(0xFFF5F5F5),
                                  icon: Icon(
                                    Icons.close,
                                    color: Color(0xFF757575),
                                    size: 20.0,
                                  ),
                                  onPressed: () async {
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                            FlutterFlowDropDown<String>(
                              controller: _model.dropDownValueController2 ??=
                                  FormFieldController<String>(null),
                              options: [
                                'Mama\'s Kitchen - 50% Off',
                                'Fashion Boutique - Buy 1 Get 1',
                                'Tech Hub - Phone Discount'
                              ],
                              onChanged: (val) => safeSetState(
                                  () => _model.dropDownValue2 = val),
                              width: double.infinity,
                              height: 48.0,
                              textStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                              hintText: 'Select Offer',
                              fillColor: Color(0xFFF9F9F9),
                              elevation: 0.0,
                              borderColor: Color(0xFFE0E0E0),
                              borderWidth: 0.0,
                              borderRadius: 8.0,
                              margin: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              isSearchable: false,
                              isMultiSelect: false,
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.star,
                                        color: Color(0xFFFFC107),
                                        size: 32.0,
                                      ),
                                      Text(
                                        'Rate',
                                        textAlign: TextAlign.center,
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
                                              letterSpacing: 0.0,
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .bodySmall
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodySmall
                                                      .fontStyle,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.flag,
                                        color: Color(0xFFE53E3E),
                                        size: 32.0,
                                      ),
                                      Text(
                                        'Report',
                                        textAlign: TextAlign.center,
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
                                              letterSpacing: 0.0,
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .bodySmall
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodySmall
                                                      .fontStyle,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ].divide(SizedBox(width: 16.0)),
                            ),
                            TextFormField(
                              controller: _model.textController,
                              focusNode: _model.textFieldFocusNode,
                              obscureText: false,
                              decoration: InputDecoration(
                                hintText: 'Add your comment...',
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFFE0E0E0),
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0x00000000),
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0x00000000),
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0x00000000),
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                filled: true,
                                fillColor: Color(0xFFF9F9F9),
                              ),
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                              maxLines: 3,
                              validator: _model.textControllerValidator
                                  .asValidator(context),
                            ),
                            FFButtonWidget(
                              onPressed: () async {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Thank you! Your feedback has been submitted.'),
                                    backgroundColor: Color(0xFF2E7D32),
                                  ),
                                );
                              },
                              text: 'Submit',
                              options: FFButtonOptions(
                                width: double.infinity,
                                height: 44.0,
                                padding: EdgeInsets.all(8.0),
                                iconPadding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                color: Color(0xFF2E7D32),
                                textStyle: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .fontStyle,
                                      ),
                                      color: Colors.white,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w600,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .fontStyle,
                                    ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ].divide(SizedBox(height: 16.0)),
                        ),
                      ),
                    ),
                  ),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 8.0,
                          color: Color(0x1A000000),
                          offset: Offset(
                            0.0,
                            3.0,
                          ),
                        )
                      ],
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'My Public Offers',
                            style: FlutterFlowTheme.of(context)
                                .headlineSmall
                                .override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .headlineSmall
                                        .fontStyle,
                                  ),
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .headlineSmall
                                      .fontStyle,
                                ),
                          ),
                          FutureBuilder<ApiCallResponse>(
                            future: GetstoredofferCall.call(
                              phone: FFAppState().phonenumber,
                              accessToken: FFAppState().bsptoken,
                            ),
                            builder: (context, snapshot) {
                              // Customize what your widget looks like when it's loading.
                              if (!snapshot.hasData) {
                                return Center(
                                  child: SizedBox(
                                    width: 50.0,
                                    height: 50.0,
                                    child: SpinKitDoubleBounce(
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      size: 50.0,
                                    ),
                                  ),
                                );
                              }
                              final columnGetstoredofferResponse =
                                  snapshot.data!;

                              return Builder(
                                builder: (context) {
                                  final mysavedlist =
                                      GetstoredofferCall.mysavedoffer(
                                            columnGetstoredofferResponse
                                                .jsonBody,
                                          )?.toList() ??
                                          [];

                                  return Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: List.generate(mysavedlist.length,
                                        (mysavedlistIndex) {
                                      final mysavedlistItem =
                                          mysavedlist[mysavedlistIndex];
                                      return Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Color(0xFFF9F9F9),
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          border: Border.all(
                                            color: Color(0xFFE0E0E0),
                                            width: 1.0,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(16.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          getJsonField(
                                                            mysavedlistItem,
                                                            r'''$.OfferName''',
                                                          ).toString(),
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .titleMedium
                                                              .override(
                                                                font:
                                                                    GoogleFonts
                                                                        .inter(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleMedium
                                                                      .fontStyle,
                                                                ),
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleMedium
                                                                    .fontStyle,
                                                              ),
                                                        ),
                                                        Text(
                                                          getJsonField(
                                                            mysavedlistItem,
                                                            r'''$.Category''',
                                                          ).toString(),
                                                          style: FlutterFlowTheme
                                                                  .of(context)
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
                                                                color: Color(
                                                                    0xFF757575),
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
                                                      ],
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Container(
                                                        width: 50.0,
                                                        height: 28.0,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryBackground,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      14.0),
                                                        ),
                                                        child: InkWell(
                                                          splashColor: Colors
                                                              .transparent,
                                                          focusColor: Colors
                                                              .transparent,
                                                          hoverColor: Colors
                                                              .transparent,
                                                          highlightColor: Colors
                                                              .transparent,
                                                          onTap: () async {
                                                            _model.apiResultb31 =
                                                                await EnableofferCall
                                                                    .call(
                                                              phone: FFAppState()
                                                                  .phonenumber,
                                                              accessToken:
                                                                  FFAppState()
                                                                      .bsptoken,
                                                              userstatus: functions
                                                                  .changeuserstatus(
                                                                      getJsonField(
                                                                mysavedlistItem,
                                                                r'''$.userStatus''',
                                                              ).toString()),
                                                              busizid:
                                                                  getJsonField(
                                                                mysavedlistItem,
                                                                r'''$.ID''',
                                                              ).toString(),
                                                            );

                                                            safeSetState(() {});
                                                          },
                                                          child: SwitchssWidget(
                                                            key: Key(
                                                                'Key9o1_${mysavedlistIndex}_of_${mysavedlist.length}'),
                                                            id: getJsonField(
                                                              mysavedlistItem,
                                                              r'''$.ID''',
                                                            ).toString(),
                                                            userstatus:
                                                                getJsonField(
                                                              mysavedlistItem,
                                                              r'''$.userStatus''',
                                                            ).toString(),
                                                          ),
                                                        ),
                                                      ),
                                                    ].divide(
                                                        SizedBox(width: 8.0)),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                '\"Views: 45 • Unl',
                                                style:
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
                                            ].divide(SizedBox(height: 12.0)),
                                          ),
                                        ),
                                      );
                                    }),
                                  );
                                },
                              );
                            },
                          ),
                        ].divide(SizedBox(height: 16.0)),
                      ),
                    ),
                  ),
                ),
              ]
                  .divide(SizedBox(height: 16.0))
                  .addToStart(SizedBox(height: 24.0))
                  .addToEnd(SizedBox(height: 32.0)),
            ),
          ),
        ),
      ),
    );
  }
}
