import '/backend/api_requests/api_calls.dart';
import '/components/bottom_app_bar/bottom_app_bar_widget.dart';
import '/components/emptylistaccess_widget.dart';
import '/components/grantaccess/grantaccess_widget.dart';
import '/flutter_flow/flutter_flow_data_table.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'grant_access_model.dart';
export 'grant_access_model.dart';

class GrantAccessWidget extends StatefulWidget {
  const GrantAccessWidget({
    super.key,
    required this.phoneno,
  });

  final String? phoneno;

  static String routeName = 'grant_access';
  static String routePath = '/grantAccess';

  @override
  State<GrantAccessWidget> createState() => _GrantAccessWidgetState();
}

class _GrantAccessWidgetState extends State<GrantAccessWidget> {
  late GrantAccessModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => GrantAccessModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.streetauth = await StreetauthCall.call();

      await Future.wait([
        Future(() async {
          _model.guestprofile = await ListguestprofileCall.call(
            hostphone: FFAppState().phonenumber,
            accessToken: StreetauthCall.streettoken(
              (_model.streetauth?.jsonBody ?? ''),
            ),
          );
        }),
        Future(() async {
          _model.hostprofile = await ListhostprofileCall.call(
            guestphone: FFAppState().phonenumber,
            accessToken: StreetauthCall.streettoken(
              (_model.streetauth?.jsonBody ?? ''),
            ),
          );
        }),
      ]);
      FFAppState().guestprofile = (ListguestprofileCall.guests(
        (_model.guestprofile?.jsonBody ?? ''),
      ) ?? [])
          .toList()
          .cast<String>();
      FFAppState().hostprofile = (ListhostprofileCall.hostprofile(
        (_model.hostprofile?.jsonBody ?? ''),
      ) ?? [])
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
              'Access Granted by Me',
              style: FlutterFlowTheme.of(context).headlineMedium.override(
                    font: GoogleFonts.inter(
                      fontWeight: FlutterFlowTheme.of(context)
                          .headlineMedium
                          .fontWeight,
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
            child: Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SingleChildScrollView(
                      controller: _model.columnController,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            decoration: BoxDecoration(),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 20.0, 0.0, 0.0),
                                      child: FFButtonWidget(
                                        onPressed: () async {
                                          context.pushNamed(
                                            ViewmyaccesWidget.routeName,
                                            queryParameters: {
                                              'phoneno': serializeParam(
                                                FFAppState().phonenumber,
                                                ParamType.String,
                                              ),
                                            }.withoutNulls,
                                          );
                                        },
                                        text: 'Click here to View all access',
                                        options: FFButtonOptions(
                                          height: 40.0,
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  16.0, 0.0, 16.0, 0.0),
                                          iconPadding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 0.0, 0.0),
                                          color: FlutterFlowTheme.of(context)
                                              .primaryBackground,
                                          textStyle: FlutterFlowTheme.of(
                                                  context)
                                              .titleSmall
                                              .override(
                                                font: GoogleFonts.inter(
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleSmall
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleSmall
                                                          .fontStyle,
                                                ),
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                letterSpacing: 0.0,
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmall
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmall
                                                        .fontStyle,
                                              ),
                                          elevation: 0.0,
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 20.0, 0.0, 0.0),
                                      child: Icon(
                                        Icons.key,
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        size: 24.0,
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 10.0, 0.0, 10.0),
                                  child: Container(
                                    width: 300.0,
                                    height: 1.0,
                                    decoration: BoxDecoration(
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      border: Border.all(
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 10.0, 0.0, 0.0),
                                  child: wrapWithModel(
                                    model: _model.grantaccessModel,
                                    updateCallback: () => safeSetState(() {}),
                                    child: GrantaccessWidget(
                                      hostno: functions.removecode(
                                          FFAppState().phonenumber)!,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          10.0, 20.0, 10.0, 0.0),
                                      child: Builder(
                                        builder: (context) {
                                          final listsofguests = FFAppState()
                                              .guestprofile
                                              .toList()
                                              .take(5)
                                              .toList();
                                          if (listsofguests.isEmpty) {
                                            return EmptylistaccessWidget();
                                          }

                                          return FlutterFlowDataTable<String>(
                                            controller: _model
                                                .paginatedDataTableController,
                                            data: listsofguests,
                                            columnsBuilder: (onSortChanged) => [
                                              DataColumn2(
                                                label: DefaultTextStyle.merge(
                                                  softWrap: true,
                                                  child: Text(
                                                    'Username',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .labelLarge
                                                        .override(
                                                          font:
                                                              GoogleFonts.inter(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelLarge
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelLarge
                                                                    .fontStyle,
                                                          ),
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryBackground,
                                                          fontSize: 14.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelLarge
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelLarge
                                                                  .fontStyle,
                                                        ),
                                                  ),
                                                ),
                                                fixedWidth: 120.0,
                                              ),
                                              DataColumn2(
                                                label: DefaultTextStyle.merge(
                                                  softWrap: true,
                                                  child: Text(
                                                    'Guest Phone',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .labelLarge
                                                        .override(
                                                          font:
                                                              GoogleFonts.inter(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelLarge
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelLarge
                                                                    .fontStyle,
                                                          ),
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryBackground,
                                                          fontSize: 14.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelLarge
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelLarge
                                                                  .fontStyle,
                                                        ),
                                                  ),
                                                ),
                                                fixedWidth: 160.0,
                                              ),
                                              DataColumn2(
                                                label: DefaultTextStyle.merge(
                                                  softWrap: true,
                                                  child: Text(
                                                    '',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .labelLarge
                                                        .override(
                                                          font:
                                                              GoogleFonts.inter(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelLarge
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelLarge
                                                                    .fontStyle,
                                                          ),
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryBackground,
                                                          fontSize: 14.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelLarge
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelLarge
                                                                  .fontStyle,
                                                        ),
                                                  ),
                                                ),
                                                fixedWidth: 70.0,
                                              ),
                                            ],
                                            dataRowBuilder: (listsofguestsItem,
                                                    listsofguestsIndex,
                                                    selected,
                                                    onSelectChanged) =>
                                                DataRow(
                                              color: WidgetStateProperty.all(
                                                listsofguestsIndex % 2 == 0
                                                    ? FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryBackground
                                                    : Color(0xFF4F8E4F),
                                              ),
                                              cells: [
                                                Container(
                                                  decoration: BoxDecoration(),
                                                  child: FutureBuilder<
                                                      ApiCallResponse>(
                                                    future:
                                                        ReturntierprofileCall
                                                            .call(
                                                      phoneno:
                                                          functions.removecode(
                                                              listsofguestsItem),
                                                      accessToken:
                                                          StreetauthCall
                                                              .streettoken(
                                                        (_model.streetauth
                                                                ?.jsonBody ??
                                                            ''),
                                                      ),
                                                    ),
                                                    builder:
                                                        (context, snapshot) {
                                                      // Customize what your widget looks like when it's loading.
                                                      if (!snapshot.hasData) {
                                                        return Center(
                                                          child: SizedBox(
                                                            width: 50.0,
                                                            height: 50.0,
                                                            child:
                                                                SpinKitDoubleBounce(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primary,
                                                              size: 50.0,
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                      final textReturntierprofileResponse =
                                                          snapshot.data!;

                                                      return Text(
                                                        valueOrDefault<String>(
                                                          ReturntierprofileCall
                                                              .fullname(
                                                            ReturntierprofileCall
                                                                .fulldata(
                                                              textReturntierprofileResponse
                                                                  .jsonBody,
                                                            ),
                                                          ),
                                                          '- - -',
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
                                                      );
                                                    },
                                                  ),
                                                ),
                                                Text(
                                                  listsofguestsItem,
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        font: GoogleFonts.inter(
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
                                                    _model.apiResultcde =
                                                        await RevokeguestCall
                                                            .call(
                                                      hostphone:
                                                          functions.removecode(
                                                              FFAppState()
                                                                  .phonenumber),
                                                      guestphone:
                                                          functions.removecode(
                                                              listsofguestsItem),
                                                      accessToken:
                                                          StreetauthCall
                                                              .streettoken(
                                                        (_model.streetauth
                                                                ?.jsonBody ??
                                                            ''),
                                                      ),
                                                    );

                                                    if ((_model.apiResultcde
                                                            ?.succeeded ??
                                                        true)) {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                            '${listsofguestsItem} as been removed successfullyby${widget.phoneno}',
                                                            style: TextStyle(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
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

                                                      context.pushNamed(
                                                        GrantAccessWidget
                                                            .routeName,
                                                        queryParameters: {
                                                          'phoneno':
                                                              serializeParam(
                                                            widget.phoneno,
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
                                                            _model.apiResultcde?.responseMessage.isNotEmpty == true
                                                                ? _model.apiResultcde!.responseMessage
                                                                : 'Unable to revoke access. Please try again.',
                                                            style: TextStyle(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
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

                                                    safeSetState(() {});
                                                  },
                                                  child: Icon(
                                                    Icons.delete_forever_sharp,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondary,
                                                    size: 24.0,
                                                  ),
                                                ),
                                              ]
                                                  .map((c) => DataCell(c))
                                                  .toList(),
                                            ),
                                            emptyBuilder: () =>
                                                EmptylistaccessWidget(),
                                            paginated: false,
                                            selectable: false,
                                            headingRowHeight: 56.0,
                                            dataRowHeight: 48.0,
                                            columnSpacing: 20.0,
                                            headingRowColor:
                                                FlutterFlowTheme.of(context)
                                                    .primary,
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10.0),
                                              topRight: Radius.circular(10.0),
                                              bottomLeft: Radius.circular(10.0),
                                              bottomRight:
                                                  Radius.circular(10.0),
                                            ),
                                            addHorizontalDivider: true,
                                            addTopAndBottomDivider: false,
                                            hideDefaultHorizontalDivider: true,
                                            horizontalDividerColor:
                                                FlutterFlowTheme.of(context)
                                                    .secondaryBackground,
                                            horizontalDividerThickness: 1.0,
                                            addVerticalDivider: false,
                                          );
                                        },
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
                wrapWithModel(
                  model: _model.bottomAppBarModel,
                  updateCallback: () => safeSetState(() {}),
                  child: BottomAppBarWidget(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
