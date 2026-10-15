import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/publicoffer/offerdetails/offerdetails_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'offerdetail_model.dart';
export 'offerdetail_model.dart';

class OfferdetailWidget extends StatefulWidget {
  const OfferdetailWidget({
    super.key,
    required this.companyname,
    required this.timeaway,
    required this.offername,
    required this.address,
    required this.instagram,
    required this.expiredate,
    required this.amount,
    required this.mode,
    required this.whatsapp,
    required this.discount,
    required this.offerdescription,
  });

  final String? companyname;
  final String? timeaway;
  final String? offername;
  final String? address;
  final String? instagram;
  final String? expiredate;
  final String? amount;
  final String? mode;
  final String? whatsapp;
  final String? discount;
  final String? offerdescription;

  static String routeName = 'offerdetail';
  static String routePath = '/offerdetail';

  @override
  State<OfferdetailWidget> createState() => _OfferdetailWidgetState();
}

class _OfferdetailWidgetState extends State<OfferdetailWidget> {
  late OfferdetailModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => OfferdetailModel());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            'Offer detail',
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
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              wrapWithModel(
                model: _model.offerdetailsModel,
                updateCallback: () => safeSetState(() {}),
                child: OfferdetailsWidget(
                  companyname: widget.companyname!,
                  address: widget.address!,
                  timeaway: widget.timeaway!,
                  offername: widget.offername!,
                  discount: widget.discount!,
                  amount: widget.amount!,
                  expiredate: widget.expiredate!,
                  mode: widget.mode!,
                  whatsapp: widget.whatsapp!,
                  instagram: widget.instagram!,
                  offerdescription: widget.offerdescription!,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
