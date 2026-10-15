import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_web_view.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'termsandcondition_model.dart';
export 'termsandcondition_model.dart';

class TermsandconditionWidget extends StatefulWidget {
  const TermsandconditionWidget({super.key});

  @override
  State<TermsandconditionWidget> createState() =>
      _TermsandconditionWidgetState();
}

class _TermsandconditionWidgetState extends State<TermsandconditionWidget> {
  late TermsandconditionModel _model;


  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TermsandconditionModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primaryBackground,
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).primaryBackground,
            boxShadow: [
              BoxShadow(
                blurRadius: 3.0,
                color: Color(0x33000000),
                offset: Offset(
                  0.0,
                  1.0,
                ),
                spreadRadius: 0.0,
              )
            ],
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Terms and Conditions',
                      style:
                          FlutterFlowTheme.of(context).headlineSmall.override(
                                font: GoogleFonts.inter(
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .headlineSmall
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .headlineSmall
                                      .fontStyle,
                                ),
                                letterSpacing: 0.0,
                                fontWeight: FlutterFlowTheme.of(context)
                                    .headlineSmall
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .headlineSmall
                                    .fontStyle,
                              ),
                    ),
                    FlutterFlowIconButton(
                      borderColor: Colors.transparent,
                      borderRadius: 8.0,
                      borderWidth: 1.0,
                      buttonSize: 40.0,
                      fillColor:
                          FlutterFlowTheme.of(context).secondaryBackground,
                      icon: Icon(
                        Icons.close_rounded,
                        color: FlutterFlowTheme.of(context).primaryText,
                        size: 24.0,
                      ),
                      onPressed: () async {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                Container(
                  width: double.infinity,
                  height: 400.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).primaryBackground,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: FlutterFlowWebView(
                    content:
                        '<html lang=\"en\"><head><style data-merge-styles=\"true\"></style>\n    <style data-merge-styles=\"true\"></style><style data-merge-styles=\"true\"></style><meta charset=\"UTF-8\">\n    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n    <title>Terms and Conditions - StreetPay</title>\n    <link rel=\"stylesheet\" href=\"https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css\">\n    <link href=\"img/favicon.ico\" rel=\"icon\">\n\n    <!-- Google Web Fonts -->\n    <link rel=\"preconnect\" href=\"https://fonts.googleapis.com\">\n    <link rel=\"preconnect\" href=\"https://fonts.gstatic.com\" crossorigin=\"\">\n    <link href=\"https://fonts.googleapis.com/css2?family=Heebo:wght@400;500&amp;family=Jost:wght@500;600;700&amp;display=swap\" rel=\"stylesheet\">\n    <link rel=\"icon\" type=\"image/png\" sizes=\"16x16\" href=\"./img/favicon-16x16.png\">\n\n    <link href=\"https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css\" rel=\"stylesheet\">\n    <link href=\"https://cdn.jsdelivr.net/npm/bootstrap-icons@1.4.1/font/bootstrap-icons.css\" rel=\"stylesheet\">\n    <link href=\"css/style.css\" rel=\"stylesheet\">\n    <link rel=\"stylesheet\" href=\"https://unpkg.com/flickity@2/dist/flickity.min.css\">\n    <link href=\"css/bootstrap.min.css\" rel=\"stylesheet\">\n    <link href=\"lib/animate/animate.min.css\" rel=\"stylesheet\">\n    <link href=\"lib/owlcarousel/assets/owl.carousel.min.css\" rel=\"stylesheet\">\n\n    <style>\n      body {\n        font-family: Arial, sans-serif;\n      }\n      .terms-container {\n        margin: 50px auto;\n        max-width: 800px;\n      }\n      h1,\n      h2, h3 {\n         color: #3cb043;\n;\n      }\n    </style>\n  </head>\n  <body data-bs-spy=\"scroll\" data-bs-target=\".navbar\" data-bs-offset=\"51\" class=\"container-xxl\" data-new-gr-c-s-check-loaded=\"14.1097.0\" data-gr-ext-installed=\"\">\n     \n    <div class=\"terms-container container\">\n      <h3 class=\"text-center\">Terms and Conditions</h3>\n      <p>\n        Welcome to StreetPay! By accessing or using our services, you agree to\n        comply with and be bound by the following Terms and Conditions. Please\n        read them carefully. If you do not agree to these terms, you must\n        refrain from using the StreetPay application and its associated\n        services.\n      </p>\n\n      <h3>1.⁠ ⁠Definitions</h3>\n      <p>\n        1.1 \"StreetPay\" refers to the payment application and services provided\n        by Street-Friendly Unified Services Limited.\n      </p>\n      <p>\n        1.2 \"User\" refers to any individual or entity accessing or using\n        StreetPay.\n      </p>\n      <p>\n        1.3 \"Services\" include payment processing, account management, and other\n        functionalities provided by the application.\n      </p>\n      <p>\n        1.4 \"Third-party Services\" refers to external platforms, merchants, or\n        financial institutions integrated with StreetPay.\n      </p>\n      <p>\n        1.1 \"StreetPay\" refers to the payment application and services provided\n        by Street-Friendly Unified Services Limited.\n      </p>\n\n      <h3>2.⁠ ⁠Eligibility</h3>\n      \n        <p>\n          2.1 Users must be at least 18 years old or the age of majority in\n          their jurisdiction.\n        </p>\n          2.2 Users must provide accurate, current, and complete information during registration and keep their account details up to date.\n \n        <p></p>\n    \n\n      <h3>3. Account Responsibilities</h3>\n      <p>\n        3.1 Users are responsible for maintaining the confidentiality of their login credentials.\n      </p>\n       <p>\n       3.2 Users must notify StreetPay immediately of any unauthorized access to their accounts.\n      </p> <p>\n       3.3 StreetPay is not liable for any loss or damage arising from a user\'s failure to secure their account.  \n      </p>\n\n      <h3>4.⁠ ⁠Prohibited Activities</h3>\n      <p>\n      4.1 Users must not use StreetPay for illegal, fraudulent, or unauthorized transactions.\n      </p>\n      <p>\n     4.2 Users are prohibited from attempting to disrupt or interfere with the application’s functionality.\n \n      </p>\n      <p>\n      4.1 Users must not use StreetPay for illegal, fraudulent, or unauthorized transactions.\n      </p>\n\n\n      <h3>5.⁠ ⁠Payment and Fees</h3>\n   \n     <p>\n     5.1 All fees for using StreetPay’s services are disclosed at the time of the transaction.\n      </p>\n     <p>\n      5.2 Users agree to pay all applicable fees and charges associated with their use of the services.\n      </p>\n      <p>\n      5.3 StreetPay reserves the right to modify its fees with prior notice.\n      </p>\n\n      <h3>6. Third-Party Services</h3>\n      <p>\n        6.1 StreetPay may integrate with third-party platforms. Users acknowledge and agree that:\n      </p>\n      <p>•⁠  ⁠StreetPay is not responsible for the actions or services of third-party providers.</p>\n      <p>•⁠  ⁠The use of third-party services may be subject to additional terms and conditions.</p>\n\n      <h3>7.⁠ ⁠Privacy Policy</h3>\n      <p>\n        7.1 Your use of StreetPay is also governed by our Privacy Policy, which outlines how we collect, use, and protect your data. Please review it carefully.\n      </p>\n\n      <h3>8.⁠ ⁠Liability and Indemnity</h3>\n      <p>\n       8.1 StreetPay is not liable for any direct, indirect, incidental, or consequential damages arising from the use or inability to use the services.\n      </p>\n\n      <p>\n     8.2 Users agree to indemnify and hold harmless StreetPay, its affiliates, and employees from any claims, damages, or expenses arising out of their use of the services.\n      </p>\n      \n      \n      <h3>9.⁠ ⁠Termination</h3>\n      <p>\n       9.1 StreetPay reserves the right to suspend or terminate accounts that violate these Terms and Conditions without prior notice.\n      </p>\n      <p>\n      9.2 Users may terminate their accounts by contacting customer support.\n      </p>\n\n      <h3>10.⁠ ⁠Amendments</h3>\n      <p>\n      10.1 StreetPay reserves the right to amend these Terms and Conditions at any time. Users will be notified of changes, and continued use of the services constitutes acceptance of the revised terms.\n      </p>\n\n\n      <h3>11.⁠ ⁠Governing Law</h3>\n      <p>\n     11.1 These Terms and Conditions are governed by the laws of Federal Republic of Nigeria.\n      </p>\n      <p>\n     11.2 Any disputes arising from these terms shall be subject to the exclusive jurisdiction of the courts in [Your Country/State]. \n      </p>\n\n      <h3>12.⁠ ⁠Contact Us</h3>\n      <p>For questions or support, please contact us at:</p>\n         <p> •⁠  ⁠Email: support@streetpayng.com</p>\n         <p> •⁠  ⁠Email: complaints@streetpayng.com</p>\n          <p>•⁠  ⁠Phone: +2349071929127</p>\n          <h4>Thank you for choosing StreetPay!</h4>\n\n     \n    </div>\n <!-- Footer Start -->\n    \n    <!-- Footer End -->\n    <script src=\"https://code.jquery.com/jquery-3.5.1.min.js\"></script>\n    <script src=\"https://cdn.jsdelivr.net/npm/bootstrap@4.5.2/dist/js/bootstrap.bundle.min.js\"></script>\n  \n\n</body><editor-card style=\"position:absolute;top:0px;left:0px;z-index:auto;display: block !important\"><div dir=\"ltr\" style=\"all: initial;\"><div style=\"color-scheme: initial; forced-color-adjust: initial; mask: initial; math-depth: initial; position: absolute; position-anchor: initial; text-size-adjust: initial; appearance: initial; color: initial; font: initial; font-palette: initial; font-synthesis: initial; position-area: initial; text-orientation: initial; text-rendering: initial; text-spacing-trim: initial; -webkit-font-smoothing: initial; -webkit-locale: initial; -webkit-text-orientation: initial; -webkit-writing-mode: initial; writing-mode: initial; zoom: initial; accent-color: initial; place-content: initial; place-items: initial; place-self: initial; alignment-baseline: initial; anchor-name: initial; anchor-scope: initial; animation-composition: initial; animation: initial; app-region: initial; aspect-ratio: initial; backdrop-filter: initial; backface-visibility: initial; background: initial; background-blend-mode: initial; baseline-shift: initial; baseline-source: initial; block-size: initial; border-block: initial; border: initial; border-radius: initial; border-collapse: initial; border-end-end-radius: initial; border-end-start-radius: initial; border-inline: initial; border-start-end-radius: initial; border-start-start-radius: initial; inset: initial; box-decoration-break: initial; box-shadow: initial; box-sizing: initial; break-after: initial; break-before: initial; break-inside: initial; buffered-rendering: initial; caption-side: initial; caret-color: initial; clear: initial; clip: initial; clip-path: initial; clip-rule: initial; color-interpolation: initial; color-interpolation-filters: initial; color-rendering: initial; columns: initial; column-fill: initial; gap: initial; column-rule: initial; column-span: initial; contain: initial; contain-intrinsic-block-size: initial; contain-intrinsic-size: initial; contain-intrinsic-inline-size: initial; container: initial; content: initial; content-visibility: initial; counter-increment: initial; counter-reset: initial; counter-set: initial; cursor: initial; cx: initial; cy: initial; d: initial; display: initial; dominant-baseline: initial; empty-cells: initial; field-sizing: initial; fill: initial; fill-opacity: initial; fill-rule: initial; filter: initial; flex: initial; flex-flow: initial; float: initial; flood-color: initial; flood-opacity: initial; grid: initial; grid-area: initial; height: initial; hyphenate-character: initial; hyphenate-limit-chars: initial; hyphens: initial; image-orientation: initial; image-rendering: initial; initial-letter: initial; inline-size: initial; inset-block: initial; inset-inline: initial; interpolate-size: initial; isolation: initial; letter-spacing: initial; lighting-color: initial; line-break: initial; list-style: initial; margin-block: initial; margin: initial; margin-inline: initial; marker: initial; mask-type: initial; math-shift: initial; math-style: initial; max-block-size: initial; max-height: initial; max-inline-size: initial; max-width: initial; min-block-size: initial; min-height: initial; min-inline-size: initial; min-width: initial; mix-blend-mode: initial; object-fit: initial; object-position: initial; object-view-box: initial; offset: initial; opacity: initial; order: initial; orphans: initial; outline: initial; outline-offset: initial; overflow-anchor: initial; overflow-clip-margin: initial; overflow-wrap: initial; overflow: initial; overlay: initial; overscroll-behavior-block: initial; overscroll-behavior-inline: initial; overscroll-behavior: initial; padding-block: initial; padding: initial; padding-inline: initial; page: initial; page-orientation: initial; paint-order: initial; perspective: initial; perspective-origin: initial; pointer-events: initial; position-try: initial; position-visibility: initial; quotes: initial; r: initial; resize: initial; rotate: initial; ruby-align: initial; ruby-position: initial; rx: initial; ry: initial; scale: initial; scroll-behavior: initial; scroll-initial-target: initial; scroll-margin-block: initial; scroll-margin: initial; scroll-margin-inline: initial; scroll-padding-block: initial; scroll-padding: initial; scroll-padding-inline: initial; scroll-snap-align: initial; scroll-snap-stop: initial; scroll-snap-type: initial; scroll-timeline: initial; scrollbar-color: initial; scrollbar-gutter: initial; scrollbar-width: initial; shape-image-threshold: initial; shape-margin: initial; shape-outside: initial; shape-rendering: initial; size: initial; speak: initial; stop-color: initial; stop-opacity: initial; stroke: initial; stroke-dasharray: initial; stroke-dashoffset: initial; stroke-linecap: initial; stroke-linejoin: initial; stroke-miterlimit: initial; stroke-opacity: initial; stroke-width: initial; tab-size: initial; table-layout: initial; text-align: initial; text-align-last: initial; text-anchor: initial; text-box: initial; text-combine-upright: initial; text-decoration: initial; text-decoration-skip-ink: initial; text-emphasis: initial; text-emphasis-position: initial; text-indent: initial; text-overflow: initial; text-shadow: initial; text-transform: initial; text-underline-offset: initial; text-underline-position: initial; text-wrap: initial; timeline-scope: initial; touch-action: initial; transform: initial; transform-box: initial; transform-origin: initial; transform-style: initial; transition: initial; translate: initial; user-select: initial; vector-effect: initial; vertical-align: initial; view-timeline: initial; view-transition-class: initial; view-transition-name: initial; visibility: initial; border-spacing: initial; -webkit-box-align: initial; -webkit-box-decoration-break: initial; -webkit-box-direction: initial; -webkit-box-flex: initial; -webkit-box-ordinal-group: initial; -webkit-box-orient: initial; -webkit-box-pack: initial; -webkit-box-reflect: initial; -webkit-line-break: initial; -webkit-line-clamp: initial; -webkit-mask-box-image: initial; -webkit-print-color-adjust: initial; -webkit-rtl-ordering: initial; -webkit-ruby-position: initial; -webkit-tap-highlight-color: initial; -webkit-text-combine: initial; -webkit-text-decorations-in-effect: initial; -webkit-text-fill-color: initial; -webkit-text-security: initial; -webkit-text-stroke: initial; -webkit-user-drag: initial; white-space-collapse: initial; widows: initial; width: initial; will-change: initial; word-break: initial; word-spacing: initial; x: initial; y: initial; z-index: 2147483647;\"><link rel=\"stylesheet\" href=\"chrome-extension://hokifickgkhplphjiodbggjmoafhignh/fonts/fabric-icons.css\"><div style=\"all: initial;\"></div></div><div style=\"color-scheme: initial; forced-color-adjust: initial; mask: initial; math-depth: initial; position: absolute; position-anchor: initial; text-size-adjust: initial; appearance: initial; color: initial; font: initial; font-palette: initial; font-synthesis: initial; position-area: initial; text-orientation: initial; text-rendering: initial; text-spacing-trim: initial; -webkit-font-smoothing: initial; -webkit-locale: initial; -webkit-text-orientation: initial; -webkit-writing-mode: initial; writing-mode: initial; zoom: initial; accent-color: initial; place-content: initial; place-items: initial; place-self: initial; alignment-baseline: initial; anchor-name: initial; anchor-scope: initial; animation-composition: initial; animation: initial; app-region: initial; aspect-ratio: initial; backdrop-filter: initial; backface-visibility: initial; background: initial; background-blend-mode: initial; baseline-shift: initial; baseline-source: initial; block-size: initial; border-block: initial; border: initial; border-radius: initial; border-collapse: initial; border-end-end-radius: initial; border-end-start-radius: initial; border-inline: initial; border-start-end-radius: initial; border-start-start-radius: initial; inset: initial; box-decoration-break: initial; box-shadow: initial; box-sizing: initial; break-after: initial; break-before: initial; break-inside: initial; buffered-rendering: initial; caption-side: initial; caret-color: initial; clear: initial; clip: initial; clip-path: initial; clip-rule: initial; color-interpolation: initial; color-interpolation-filters: initial; color-rendering: initial; columns: initial; column-fill: initial; gap: initial; column-rule: initial; column-span: initial; contain: initial; contain-intrinsic-block-size: initial; contain-intrinsic-size: initial; contain-intrinsic-inline-size: initial; container: initial; content: initial; content-visibility: initial; counter-increment: initial; counter-reset: initial; counter-set: initial; cursor: initial; cx: initial; cy: initial; d: initial; display: initial; dominant-baseline: initial; empty-cells: initial; field-sizing: initial; fill: initial; fill-opacity: initial; fill-rule: initial; filter: initial; flex: initial; flex-flow: initial; float: initial; flood-color: initial; flood-opacity: initial; grid: initial; grid-area: initial; height: initial; hyphenate-character: initial; hyphenate-limit-chars: initial; hyphens: initial; image-orientation: initial; image-rendering: initial; initial-letter: initial; inline-size: initial; inset-block: initial; inset-inline: initial; interpolate-size: initial; isolation: initial; letter-spacing: initial; lighting-color: initial; line-break: initial; list-style: initial; margin-block: initial; margin: initial; margin-inline: initial; marker: initial; mask-type: initial; math-shift: initial; math-style: initial; max-block-size: initial; max-height: initial; max-inline-size: initial; max-width: initial; min-block-size: initial; min-height: initial; min-inline-size: initial; min-width: initial; mix-blend-mode: initial; object-fit: initial; object-position: initial; object-view-box: initial; offset: initial; opacity: initial; order: initial; orphans: initial; outline: initial; outline-offset: initial; overflow-anchor: initial; overflow-clip-margin: initial; overflow-wrap: initial; overflow: initial; overlay: initial; overscroll-behavior-block: initial; overscroll-behavior-inline: initial; overscroll-behavior: initial; padding-block: initial; padding: initial; padding-inline: initial; page: initial; page-orientation: initial; paint-order: initial; perspective: initial; perspective-origin: initial; pointer-events: initial; position-try: initial; position-visibility: initial; quotes: initial; r: initial; resize: initial; rotate: initial; ruby-align: initial; ruby-position: initial; rx: initial; ry: initial; scale: initial; scroll-behavior: initial; scroll-initial-target: initial; scroll-margin-block: initial; scroll-margin: initial; scroll-margin-inline: initial; scroll-padding-block: initial; scroll-padding: initial; scroll-padding-inline: initial; scroll-snap-align: initial; scroll-snap-stop: initial; scroll-snap-type: initial; scroll-timeline: initial; scrollbar-color: initial; scrollbar-gutter: initial; scrollbar-width: initial; shape-image-threshold: initial; shape-margin: initial; shape-outside: initial; shape-rendering: initial; size: initial; speak: initial; stop-color: initial; stop-opacity: initial; stroke: initial; stroke-dasharray: initial; stroke-dashoffset: initial; stroke-linecap: initial; stroke-linejoin: initial; stroke-miterlimit: initial; stroke-opacity: initial; stroke-width: initial; tab-size: initial; table-layout: initial; text-align: initial; text-align-last: initial; text-anchor: initial; text-box: initial; text-combine-upright: initial; text-decoration: initial; text-decoration-skip-ink: initial; text-emphasis: initial; text-emphasis-position: initial; text-indent: initial; text-overflow: initial; text-shadow: initial; text-transform: initial; text-underline-offset: initial; text-underline-position: initial; text-wrap: initial; timeline-scope: initial; touch-action: initial; transform: initial; transform-box: initial; transform-origin: initial; transform-style: initial; transition: initial; translate: initial; user-select: initial; vector-effect: initial; vertical-align: initial; view-timeline: initial; view-transition-class: initial; view-transition-name: initial; visibility: initial; border-spacing: initial; -webkit-box-align: initial; -webkit-box-decoration-break: initial; -webkit-box-direction: initial; -webkit-box-flex: initial; -webkit-box-ordinal-group: initial; -webkit-box-orient: initial; -webkit-box-pack: initial; -webkit-box-reflect: initial; -webkit-line-break: initial; -webkit-line-clamp: initial; -webkit-mask-box-image: initial; -webkit-print-color-adjust: initial; -webkit-rtl-ordering: initial; -webkit-ruby-position: initial; -webkit-tap-highlight-color: initial; -webkit-text-combine: initial; -webkit-text-decorations-in-effect: initial; -webkit-text-fill-color: initial; -webkit-text-security: initial; -webkit-text-stroke: initial; -webkit-user-drag: initial; white-space-collapse: initial; widows: initial; width: initial; will-change: initial; word-break: initial; word-spacing: initial; x: initial; y: initial; z-index: 2147483647;\"><link rel=\"stylesheet\" href=\"chrome-extension://hokifickgkhplphjiodbggjmoafhignh/fonts/fabric-icons.css\"></div><div id=\"editorNotificationContainer\" style=\"color-scheme: initial; forced-color-adjust: initial; mask: initial; math-depth: initial; position: fixed; position-anchor: initial; text-size-adjust: initial; appearance: initial; color: initial; font: initial; font-palette: initial; font-synthesis: initial; position-area: initial; text-orientation: initial; text-rendering: initial; text-spacing-trim: initial; -webkit-font-smoothing: initial; -webkit-locale: initial; -webkit-text-orientation: initial; -webkit-writing-mode: initial; writing-mode: initial; zoom: initial; accent-color: initial; place-content: initial; place-items: initial; place-self: initial; alignment-baseline: initial; anchor-name: initial; anchor-scope: initial; animation-composition: initial; animation: initial; app-region: initial; aspect-ratio: initial; backdrop-filter: initial; backface-visibility: initial; background: initial; background-blend-mode: initial; baseline-shift: initial; baseline-source: initial; block-size: initial; border-block: initial; border: initial; border-radius: initial; border-collapse: initial; border-end-end-radius: initial; border-end-start-radius: initial; border-inline: initial; border-start-end-radius: initial; border-start-start-radius: initial; bottom: 0px; box-decoration-break: initial; box-shadow: initial; box-sizing: initial; break-after: initial; break-before: initial; break-inside: initial; buffered-rendering: initial; caption-side: initial; caret-color: initial; clear: initial; clip: initial; clip-path: initial; clip-rule: initial; color-interpolation: initial; color-interpolation-filters: initial; color-rendering: initial; columns: initial; column-fill: initial; gap: initial; column-rule: initial; column-span: initial; contain: initial; contain-intrinsic-block-size: initial; contain-intrinsic-size: initial; contain-intrinsic-inline-size: initial; container: initial; content: initial; content-visibility: initial; counter-increment: initial; counter-reset: initial; counter-set: initial; cursor: initial; cx: initial; cy: initial; d: initial; display: flex; dominant-baseline: initial; empty-cells: initial; field-sizing: initial; fill: initial; fill-opacity: initial; fill-rule: initial; filter: initial; flex: initial; flex-direction: column-reverse; flex-wrap: initial; float: initial; flood-color: initial; flood-opacity: initial; grid: initial; grid-area: initial; height: initial; hyphenate-character: initial; hyphenate-limit-chars: initial; hyphens: initial; image-orientation: initial; image-rendering: initial; initial-letter: initial; inline-size: initial; inset-block: initial; inset-inline: initial; interpolate-size: initial; isolation: initial; left: initial; letter-spacing: initial; lighting-color: initial; line-break: initial; list-style: initial; margin-block: initial; margin: 1em; margin-inline: initial; marker: initial; mask-type: initial; math-shift: initial; math-style: initial; max-block-size: initial; max-height: initial; max-inline-size: initial; max-width: initial; min-block-size: initial; min-height: initial; min-inline-size: initial; min-width: initial; mix-blend-mode: initial; object-fit: initial; object-position: initial; object-view-box: initial; offset: initial; opacity: initial; order: initial; orphans: initial; outline: initial; outline-offset: initial; overflow-anchor: initial; overflow-clip-margin: initial; overflow-wrap: initial; overflow: initial; overlay: initial; overscroll-behavior-block: initial; overscroll-behavior-inline: initial; overscroll-behavior: initial; padding-block: initial; padding: initial; padding-inline: initial; page: initial; page-orientation: initial; paint-order: initial; perspective: initial; perspective-origin: initial; pointer-events: initial; position-try: initial; position-visibility: initial; quotes: initial; r: initial; resize: initial; right: 0px; rotate: initial; ruby-align: initial; ruby-position: initial; rx: initial; ry: initial; scale: initial; scroll-behavior: initial; scroll-initial-target: initial; scroll-margin-block: initial; scroll-margin: initial; scroll-margin-inline: initial; scroll-padding-block: initial; scroll-padding: initial; scroll-padding-inline: initial; scroll-snap-align: initial; scroll-snap-stop: initial; scroll-snap-type: initial; scroll-timeline: initial; scrollbar-color: initial; scrollbar-gutter: initial; scrollbar-width: initial; shape-image-threshold: initial; shape-margin: initial; shape-outside: initial; shape-rendering: initial; size: initial; speak: initial; stop-color: initial; stop-opacity: initial; stroke: initial; stroke-dasharray: initial; stroke-dashoffset: initial; stroke-linecap: initial; stroke-linejoin: initial; stroke-miterlimit: initial; stroke-opacity: initial; stroke-width: initial; tab-size: initial; table-layout: initial; text-align: initial; text-align-last: initial; text-anchor: initial; text-box: initial; text-combine-upright: initial; text-decoration: initial; text-decoration-skip-ink: initial; text-emphasis: initial; text-emphasis-position: initial; text-indent: initial; text-overflow: initial; text-shadow: initial; text-transform: initial; text-underline-offset: initial; text-underline-position: initial; text-wrap: initial; timeline-scope: initial; top: initial; touch-action: initial; transform: initial; transform-box: initial; transform-origin: initial; transform-style: initial; transition: initial; translate: initial; user-select: initial; vector-effect: initial; vertical-align: initial; view-timeline: initial; view-transition-class: initial; view-transition-name: initial; visibility: initial; border-spacing: initial; -webkit-box-align: initial; -webkit-box-decoration-break: initial; -webkit-box-direction: initial; -webkit-box-flex: initial; -webkit-box-ordinal-group: initial; -webkit-box-orient: initial; -webkit-box-pack: initial; -webkit-box-reflect: initial; -webkit-line-break: initial; -webkit-line-clamp: initial; -webkit-mask-box-image: initial; -webkit-print-color-adjust: initial; -webkit-rtl-ordering: initial; -webkit-ruby-position: initial; -webkit-tap-highlight-color: initial; -webkit-text-combine: initial; -webkit-text-decorations-in-effect: initial; -webkit-text-fill-color: initial; -webkit-text-security: initial; -webkit-text-stroke: initial; -webkit-user-drag: initial; white-space-collapse: initial; widows: initial; width: initial; will-change: initial; word-break: initial; word-spacing: initial; x: initial; y: initial; z-index: 2147483647;\"></div></div></editor-card><grammarly-desktop-integration data-grammarly-shadow-root=\"true\"></grammarly-desktop-integration></html>',
                    height: 500.0,
                    verticalScroll: true,
                    horizontalScroll: false,
                    html: true,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'By using our services, you agree to these terms',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
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
                  ].divide(SizedBox(height: 8.0)),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FFButtonWidget(
                      onPressed: () async {
                        context.pushNamed(SignUpWidget.routeName);
                      },
                      text: 'Decline',
                      options: FFButtonOptions(
                        width: 100.0,
                        height: 40.0,
                        padding: EdgeInsets.all(8.0),
                        iconPadding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                        color: FlutterFlowTheme.of(context).secondaryBackground,
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
                        elevation: 0.0,
                        borderSide: BorderSide(
                          color: FlutterFlowTheme.of(context).alternate,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    FFButtonWidget(
                      onPressed: () async {
                        Navigator.pop(context);
                      },
                      text: 'Accept',
                      options: FFButtonOptions(
                        width: 100.0,
                        height: 40.0,
                        padding: EdgeInsets.all(8.0),
                        iconPadding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                        color: FlutterFlowTheme.of(context).primary,
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
                                  color: FlutterFlowTheme.of(context)
                                      .primaryBackground,
                                  letterSpacing: 0.0,
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontStyle,
                                ),
                        elevation: 0.0,
                        borderSide: BorderSide(
                          color: Colors.transparent,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ].divide(SizedBox(width: 12.0)),
                ),
              ].divide(SizedBox(height: 16.0)),
            ),
          ),
        ),
      ),
    );
  }
}
