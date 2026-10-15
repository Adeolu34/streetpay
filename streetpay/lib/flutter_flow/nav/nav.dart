import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/backend/schema/structs/index.dart';


import '/auth/custom_auth/custom_auth_user_provider.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';

import '/index.dart';

export 'package:go_router/go_router.dart';
export 'serialization_util.dart';

const kTransitionInfoKey = '__transition_info__';

GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

class AppStateNotifier extends ChangeNotifier {
  AppStateNotifier._();

  static AppStateNotifier? _instance;
  static AppStateNotifier get instance => _instance ??= AppStateNotifier._();

  StreetpayAuthUser? initialUser;
  StreetpayAuthUser? user;
  bool showSplashImage = true;
  String? _redirectLocation;

  /// Determines whether the app will refresh and build again when a sign
  /// in or sign out happens. This is useful when the app is launched or
  /// on an unexpected logout. However, this must be turned off when we
  /// intend to sign in/out and then navigate or perform any actions after.
  /// Otherwise, this will trigger a refresh and interrupt the action(s).
  bool notifyOnAuthChange = true;

  bool get loading => user == null || showSplashImage;
  bool get loggedIn => user?.loggedIn ?? false;
  bool get initiallyLoggedIn => initialUser?.loggedIn ?? false;
  bool get shouldRedirect => loggedIn && _redirectLocation != null;

  String getRedirectLocation() => _redirectLocation!;
  bool hasRedirect() => _redirectLocation != null;
  void setRedirectLocationIfUnset(String loc) => _redirectLocation ??= loc;
  void clearRedirectLocation() => _redirectLocation = null;

  /// Mark as not needing to notify on a sign in / out when we intend
  /// to perform subsequent actions (such as navigation) afterwards.
  void updateNotifyOnAuthChange(bool notify) => notifyOnAuthChange = notify;

  void update(StreetpayAuthUser newUser) {
    final shouldUpdate =
        user?.uid == null || newUser.uid == null || user?.uid != newUser.uid;
    initialUser ??= newUser;
    user = newUser;
    // Refresh the app on auth change unless explicitly marked otherwise.
    // No need to update unless the user has changed.
    if (notifyOnAuthChange && shouldUpdate) {
      notifyListeners();
    }
    // Once again mark the notifier as needing to update on auth change
    // (in order to catch sign in / out events).
    updateNotifyOnAuthChange(true);
  }

  void stopShowingSplashImage() {
    showSplashImage = false;
    notifyListeners();
  }
}

GoRouter createRouter(AppStateNotifier appStateNotifier) => GoRouter(
      initialLocation: '/',
      debugLogDiagnostics: true,
      refreshListenable: appStateNotifier,
      navigatorKey: appNavigatorKey,
      errorBuilder: (context, state) =>
          appStateNotifier.loggedIn ? LoginbiometricWidget() : SplashWidget(),
      routes: [
        FFRoute(
          name: '_initialize',
          path: '/',
          builder: (context, _) => appStateNotifier.loggedIn
              ? LoginbiometricWidget()
              : SplashWidget(),
        ),
        FFRoute(
          name: SplashWidget.routeName,
          path: SplashWidget.routePath,
          builder: (context, params) => SplashWidget(),
        ),
        FFRoute(
          name: SignUpWidget.routeName,
          path: SignUpWidget.routePath,
          builder: (context, params) => SignUpWidget(),
        ),
        FFRoute(
          name: PaymentWidget.routeName,
          path: PaymentWidget.routePath,
          builder: (context, params) => PaymentWidget(
            walletBalance: params.getParam(
              'walletBalance',
              ParamType.String,
            ),
            receiveraccountname: params.getParam(
              'receiveraccountname',
              ParamType.String,
            ),
            receiveraccountnumber: params.getParam(
              'receiveraccountnumber',
              ParamType.String,
            ),
            receiverbankname: params.getParam(
              'receiverbankname',
              ParamType.String,
            ),
            sender: params.getParam(
              'sender',
              ParamType.String,
            ),
            senderaccountnumber: params.getParam(
              'senderaccountnumber',
              ParamType.String,
            ),
            sendersbank: params.getParam(
              'sendersbank',
              ParamType.String,
            ),
            phoneno: params.getParam(
              'phoneno',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: PaymentConfirmationWidget.routeName,
          path: PaymentConfirmationWidget.routePath,
          builder: (context, params) => PaymentConfirmationWidget(
            sender: params.getParam(
              'sender',
              ParamType.String,
            ),
            receiver: params.getParam(
              'receiver',
              ParamType.String,
            ),
            receiveraccount: params.getParam(
              'receiveraccount',
              ParamType.String,
            ),
            receiverbank: params.getParam(
              'receiverbank',
              ParamType.String,
            ),
            amounttopay: params.getParam(
              'amounttopay',
              ParamType.double,
            ),
            description: params.getParam(
              'description',
              ParamType.String,
            ),
            walletbalance: params.getParam(
              'walletbalance',
              ParamType.double,
            ),
            myphoneNo: params.getParam(
              'myphoneNo',
              ParamType.String,
            ),
            sendersaccountno: params.getParam(
              'sendersaccountno',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: PaymentSuccessWidget.routeName,
          path: PaymentSuccessWidget.routePath,
          builder: (context, params) => PaymentSuccessWidget(),
        ),
        FFRoute(
          name: SendChoiceWidget.routeName,
          path: SendChoiceWidget.routePath,
          builder: (context, params) => const SendChoiceWidget(),
        ),
        FFRoute(
          name: ManualPaymentWidget.routeName,
          path: ManualPaymentWidget.routePath,
          builder: (context, params) => ManualPaymentWidget(
            prefillAccountNumber: params.getParam(
              'prefillAccountNumber',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: BillSuccessWidget.routeName,
          path: BillSuccessWidget.routePath,
          builder: (context, params) => BillSuccessWidget(),
        ),
        FFRoute(
          name: BillPaymentWidget.routeName,
          path: BillPaymentWidget.routePath,
          builder: (context, params) => BillPaymentWidget(
            phoneno: params.getParam(
              'phoneno',
              ParamType.String,
            ),
            amount: params.getParam(
              'amount',
              ParamType.String,
            ),
            description: params.getParam(
              'description',
              ParamType.String,
            ),
            id: params.getParam(
              'id',
              ParamType.String,
            ),
            sendername: params.getParam(
              'sendername',
              ParamType.String,
            ),
            senderphone: params.getParam(
              'senderphone',
              ParamType.String,
            ),
            receiverName: params.getParam(
              'receiverName',
              ParamType.String,
            ),
            receiveraccountno: params.getParam(
              'receiveraccountno',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: AppSettingsWidget.routeName,
          path: AppSettingsWidget.routePath,
          builder: (context, params) => AppSettingsWidget(),
        ),
        FFRoute(
          name: EmptyProfileWidget.routeName,
          path: EmptyProfileWidget.routePath,
          builder: (context, params) => EmptyProfileWidget(
            phoneno: params.getParam(
              'phoneno',
              ParamType.String,
            ),
            registerwith: params.getParam(
              'registerwith',
              ParamType.String,
            ),
            photos: params.getParam(
              'photos',
              ParamType.FFUploadedFile,
            ),
          ),
        ),
        FFRoute(
          name: ProfileWidget.routeName,
          path: ProfileWidget.routePath,
          builder: (context, params) => ProfileWidget(
            phonenumber: params.getParam(
              'phonenumber',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: PaymentReceiptWidget.routeName,
          path: PaymentReceiptWidget.routePath,
          builder: (context, params) => PaymentReceiptWidget(
            sender: params.getParam(
              'sender',
              ParamType.String,
            ),
            amount: params.getParam(
              'amount',
              ParamType.double,
            ),
            date: params.getParam(
              'date',
              ParamType.String,
            ),
            paymentref: params.getParam(
              'paymentref',
              ParamType.String,
            ),
            description: params.getParam(
              'description',
              ParamType.String,
            ),
            receiver: params.getParam(
              'receiver',
              ParamType.String,
            ),
            receiveraccount: params.getParam(
              'receiveraccount',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: AccountSettingsWidget.routeName,
          path: AccountSettingsWidget.routePath,
          builder: (context, params) => AccountSettingsWidget(
            phoneNumber: params.getParam(
              'phoneNumber',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: QuestionaireWidget.routeName,
          path: QuestionaireWidget.routePath,
          builder: (context, params) => QuestionaireWidget(
            phone: params.getParam(
              'phone',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: GrantAccessWidget.routeName,
          path: GrantAccessWidget.routePath,
          builder: (context, params) => GrantAccessWidget(
            phoneno: params.getParam(
              'phoneno',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: ViewbatchWidget.routeName,
          path: ViewbatchWidget.routePath,
          builder: (context, params) => ViewbatchWidget(),
        ),
        FFRoute(
          name: BatchsingleWidget.routeName,
          path: BatchsingleWidget.routePath,
          builder: (context, params) => BatchsingleWidget(),
        ),
        FFRoute(
          name: AirtimeformWidget.routeName,
          path: AirtimeformWidget.routePath,
          builder: (context, params) => AirtimeformWidget(
            phonenumber: params.getParam(
              'phonenumber',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: NewhomeWidget.routeName,
          path: NewhomeWidget.routePath,
          builder: (context, params) => NewhomeWidget(),
        ),
        FFRoute(
          name: BillnewWidget.routeName,
          path: BillnewWidget.routePath,
          builder: (context, params) => BillnewWidget(),
        ),
        FFRoute(
          name: BillPostingWidget.routeName,
          path: BillPostingWidget.routePath,
          builder: (context, params) => BillPostingWidget(
            accountno: params.getParam(
              'accountno',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: ViewmyaccesWidget.routeName,
          path: ViewmyaccesWidget.routePath,
          builder: (context, params) => ViewmyaccesWidget(
            phoneno: params.getParam(
              'phoneno',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: Upgradetotier2Widget.routeName,
          path: Upgradetotier2Widget.routePath,
          builder: (context, params) => Upgradetotier2Widget(
            phoneno: params.getParam(
              'phoneno',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: Upgradetotier3Widget.routeName,
          path: Upgradetotier3Widget.routePath,
          builder: (context, params) => Upgradetotier3Widget(
            phoneno: params.getParam(
              'phoneno',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: TransactionHistoryWidget.routeName,
          path: TransactionHistoryWidget.routePath,
          builder: (context, params) => TransactionHistoryWidget(
            accountno: params.getParam(
              'accountno',
              ParamType.String,
            ),
            accountname: params.getParam(
              'accountname',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: BilllelectricityWidget.routeName,
          path: BilllelectricityWidget.routePath,
          builder: (context, params) => BilllelectricityWidget(
            id: params.getParam(
              'id',
              ParamType.String,
            ),
            name: params.getParam(
              'name',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: AccountdetailsWidget.routeName,
          path: AccountdetailsWidget.routePath,
          builder: (context, params) => AccountdetailsWidget(),
        ),
        FFRoute(
          name: ResetpasswordWidget.routeName,
          path: ResetpasswordWidget.routePath,
          builder: (context, params) => ResetpasswordWidget(),
        ),
        FFRoute(
          name: SettingpageWidget.routeName,
          path: SettingpageWidget.routePath,
          builder: (context, params) => SettingpageWidget(),
        ),
        FFRoute(
          name: BilllexamWidget.routeName,
          path: BilllexamWidget.routePath,
          builder: (context, params) => BilllexamWidget(
            id: params.getParam(
              'id',
              ParamType.String,
            ),
            name: params.getParam(
              'name',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: BilllbettingWidget.routeName,
          path: BilllbettingWidget.routePath,
          builder: (context, params) => BilllbettingWidget(
            id: params.getParam(
              'id',
              ParamType.String,
            ),
            name: params.getParam(
              'name',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: BilllcabletvWidget.routeName,
          path: BilllcabletvWidget.routePath,
          builder: (context, params) => BilllcabletvWidget(
            id: params.getParam(
              'id',
              ParamType.String,
            ),
            name: params.getParam(
              'name',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: BilllinternetWidget.routeName,
          path: BilllinternetWidget.routePath,
          builder: (context, params) => BilllinternetWidget(
            id: params.getParam(
              'id',
              ParamType.String,
            ),
            name: params.getParam(
              'name',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: NointernetWidget.routeName,
          path: NointernetWidget.routePath,
          builder: (context, params) => NointernetWidget(),
        ),
        FFRoute(
          name: MainteinanceWidget.routeName,
          path: MainteinanceWidget.routePath,
          builder: (context, params) => MainteinanceWidget(),
        ),
        FFRoute(
          name: TransactionHistorybatchesWidget.routeName,
          path: TransactionHistorybatchesWidget.routePath,
          builder: (context, params) => TransactionHistorybatchesWidget(
            accountno: params.getParam(
              'accountno',
              ParamType.String,
            ),
            accountname: params.getParam(
              'accountname',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: LotteryWidget.routeName,
          path: LotteryWidget.routePath,
          builder: (context, params) => LotteryWidget(
            gametype: params.getParam(
              'gametype',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: LottoguessWidget.routeName,
          path: LottoguessWidget.routePath,
          builder: (context, params) => LottoguessWidget(
            selectedplan: params.getParam(
              'selectedplan',
              ParamType.String,
            ),
            paymentref: params.getParam(
              'paymentref',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: HistoryguessWidget.routeName,
          path: HistoryguessWidget.routePath,
          builder: (context, params) => HistoryguessWidget(),
        ),
        FFRoute(
          name: AllwinnersWidget.routeName,
          path: AllwinnersWidget.routePath,
          builder: (context, params) => AllwinnersWidget(
            planamount: params.getParam(
              'planamount',
              ParamType.String,
            ),
            datein: params.getParam(
              'datein',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: LottoflipWidget.routeName,
          path: LottoflipWidget.routePath,
          builder: (context, params) => LottoflipWidget(
            selectedplan: params.getParam(
              'selectedplan',
              ParamType.String,
            ),
            paymentref: params.getParam(
              'paymentref',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: LottoquizWidget.routeName,
          path: LottoquizWidget.routePath,
          builder: (context, params) => LottoquizWidget(
            selectedplan: params.getParam(
              'selectedplan',
              ParamType.String,
            ),
            paymentref: params.getParam(
              'paymentref',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: ResultsummaryWidget.routeName,
          path: ResultsummaryWidget.routePath,
          builder: (context, params) => ResultsummaryWidget(
            timer: params.getParam(
              'timer',
              ParamType.String,
            ),
            totalcorrect: params.getParam(
              'totalcorrect',
              ParamType.int,
            ),
            useroption: params.getParam<String>(
              'useroption',
              ParamType.String,
              isList: true,
            ),
            correctoption: params.getParam<String>(
              'correctoption',
              ParamType.String,
              isList: true,
            ),
            position: params.getParam(
              'position',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: LottohomeWidget.routeName,
          path: LottohomeWidget.routePath,
          builder: (context, params) => LottohomeWidget(),
        ),
        FFRoute(
          name: LottospinWidget.routeName,
          path: LottospinWidget.routePath,
          builder: (context, params) => LottospinWidget(
            playedamount: params.getParam(
              'playedamount',
              ParamType.String,
            ),
            paymentref: params.getParam(
              'paymentref',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: HistoryflipWidget.routeName,
          path: HistoryflipWidget.routePath,
          builder: (context, params) => HistoryflipWidget(),
        ),
        FFRoute(
          name: HistoryspinWidget.routeName,
          path: HistoryspinWidget.routePath,
          builder: (context, params) => HistoryspinWidget(),
        ),
        FFRoute(
          name: HistoryquizWidget.routeName,
          path: HistoryquizWidget.routePath,
          builder: (context, params) => HistoryquizWidget(),
        ),
        FFRoute(
          name: TickectbookingWidget.routeName,
          path: TickectbookingWidget.routePath,
          builder: (context, params) => TickectbookingWidget(),
        ),
        FFRoute(
          name: SecureuserWidget.routeName,
          path: SecureuserWidget.routePath,
          builder: (context, params) => SecureuserWidget(),
        ),
        FFRoute(
          name: StreetjobWidget.routeName,
          path: StreetjobWidget.routePath,
          builder: (context, params) => StreetjobWidget(),
        ),
        FFRoute(
          name: Streetjob2Widget.routeName,
          path: Streetjob2Widget.routePath,
          builder: (context, params) => Streetjob2Widget(),
        ),
        FFRoute(
          name: CouponpayWidget.routeName,
          path: CouponpayWidget.routePath,
          builder: (context, params) => CouponpayWidget(),
        ),
        FFRoute(
          name: CouponreceiptWidget.routeName,
          path: CouponreceiptWidget.routePath,
          builder: (context, params) => CouponreceiptWidget(),
        ),
        FFRoute(
          name: AutodicoverWidget.routeName,
          path: AutodicoverWidget.routePath,
          builder: (context, params) => AutodicoverWidget(),
        ),
        FFRoute(
          name: Autodiscover1Widget.routeName,
          path: Autodiscover1Widget.routePath,
          builder: (context, params) => Autodiscover1Widget(),
        ),
        FFRoute(
          name: TeirpageWidget.routeName,
          path: TeirpageWidget.routePath,
          builder: (context, params) => TeirpageWidget(),
        ),
        FFRoute(
          name: EditprofileWidget.routeName,
          path: EditprofileWidget.routePath,
          builder: (context, params) => EditprofileWidget(),
        ),
        FFRoute(
          name: RetrivedetailsWidget.routeName,
          path: RetrivedetailsWidget.routePath,
          builder: (context, params) => RetrivedetailsWidget(),
        ),
        FFRoute(
          name: ChatWidget.routeName,
          path: ChatWidget.routePath,
          builder: (context, params) => ChatWidget(),
        ),
        FFRoute(
          name: YarnChatPageWidget.routeName,
          path: YarnChatPageWidget.routePath,
          builder: (context, params) => YarnChatPageWidget(
            phoneNumber: params.getParam(
              'phoneNumber',
              ParamType.String,
            ),
            email: params.getParam(
              'email',
              ParamType.String,
            ),
            name: params.getParam(
              'name',
              ParamType.String,
            ),
            widgetKey: params.getParam(
              'widgetKey',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: CreateofferWidget.routeName,
          path: CreateofferWidget.routePath,
          builder: (context, params) => CreateofferWidget(),
        ),
        FFRoute(
          name: OfferdetailWidget.routeName,
          path: OfferdetailWidget.routePath,
          builder: (context, params) => OfferdetailWidget(
            companyname: params.getParam(
              'companyname',
              ParamType.String,
            ),
            timeaway: params.getParam(
              'timeaway',
              ParamType.String,
            ),
            offername: params.getParam(
              'offername',
              ParamType.String,
            ),
            address: params.getParam(
              'address',
              ParamType.String,
            ),
            instagram: params.getParam(
              'instagram',
              ParamType.String,
            ),
            expiredate: params.getParam(
              'expiredate',
              ParamType.String,
            ),
            amount: params.getParam(
              'amount',
              ParamType.String,
            ),
            mode: params.getParam(
              'mode',
              ParamType.String,
            ),
            whatsapp: params.getParam(
              'whatsapp',
              ParamType.String,
            ),
            discount: params.getParam(
              'discount',
              ParamType.String,
            ),
            offerdescription: params.getParam(
              'offerdescription',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: ConsentfieldWidget.routeName,
          path: ConsentfieldWidget.routePath,
          builder: (context, params) => ConsentfieldWidget(
            phone: params.getParam(
              'phone',
              ParamType.String,
            ),
            registerwith: params.getParam(
              'registerwith',
              ParamType.String,
            ),
            radio: params.getParam(
              'radio',
              ParamType.String,
            ),
            bvn: params.getParam(
              'bvn',
              ParamType.String,
            ),
            nin: params.getParam(
              'nin',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: FaceverifyWidget.routeName,
          path: FaceverifyWidget.routePath,
          builder: (context, params) => FaceverifyWidget(
            phone: params.getParam(
              'phone',
              ParamType.String,
            ),
            registerwith: params.getParam(
              'registerwith',
              ParamType.String,
            ),
            cardnumber: params.getParam(
              'cardnumber',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: EmptyProfilefaceWidget.routeName,
          path: EmptyProfilefaceWidget.routePath,
          builder: (context, params) => EmptyProfilefaceWidget(
            phoneno: params.getParam(
              'phoneno',
              ParamType.String,
            ),
            registerwith: params.getParam(
              'registerwith',
              ParamType.String,
            ),
            photos: params.getParam(
              'photos',
              ParamType.FFUploadedFile,
            ),
          ),
        ),
        FFRoute(
          name: FundsharingWidget.routeName,
          path: FundsharingWidget.routePath,
          builder: (context, params) => FundsharingWidget(),
        ),
        FFRoute(
          name: StreetpollpayWidget.routeName,
          path: StreetpollpayWidget.routePath,
          builder: (context, params) => StreetpollpayWidget(
            amount: params.getParam(
              'amount',
              ParamType.String,
            ),
            title: params.getParam(
              'title',
              ParamType.String,
            ),
            participant: params.getParam(
              'participant',
              ParamType.String,
            ),
            gameid: params.getParam(
              'gameid',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: StreetpoolresultWidget.routeName,
          path: StreetpoolresultWidget.routePath,
          builder: (context, params) => StreetpoolresultWidget(
            gameid: params.getParam(
              'gameid',
              ParamType.String,
            ),
            title: params.getParam(
              'title',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: PremiumconsentWidget.routeName,
          path: PremiumconsentWidget.routePath,
          builder: (context, params) => PremiumconsentWidget(
            phone: params.getParam(
              'phone',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: ChangepasswordWidget.routeName,
          path: ChangepasswordWidget.routePath,
          builder: (context, params) => ChangepasswordWidget(
            phone: params.getParam(
              'phone',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: ContactusWidget.routeName,
          path: ContactusWidget.routePath,
          builder: (context, params) => ContactusWidget(
            email: params.getParam(
              'email',
              ParamType.String,
            ),
            phone: params.getParam(
              'phone',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: StreetshareintoWidget.routeName,
          path: StreetshareintoWidget.routePath,
          builder: (context, params) => StreetshareintoWidget(),
        ),
        FFRoute(
          name: KeyboardnewWidget.routeName,
          path: KeyboardnewWidget.routePath,
          builder: (context, params) => KeyboardnewWidget(),
        ),
        FFRoute(
          name: TestpageWidget.routeName,
          path: TestpageWidget.routePath,
          builder: (context, params) => TestpageWidget(),
        ),
        FFRoute(
          name: DatapaymentWidget.routeName,
          path: DatapaymentWidget.routePath,
          builder: (context, params) => DatapaymentWidget(
            phonenumber: params.getParam(
              'phonenumber',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: Login1Widget.routeName,
          path: Login1Widget.routePath,
          builder: (context, params) => Login1Widget(),
        ),
        FFRoute(
          name: OnboardingWidget.routeName,
          path: OnboardingWidget.routePath,
          builder: (context, params) => OnboardingWidget(),
        ),
        FFRoute(
          name: OpenwalletWidget.routeName,
          path: OpenwalletWidget.routePath,
          builder: (context, params) => OpenwalletWidget(
            openwith: params.getParam(
              'openwith',
              ParamType.String,
            ),
            phone: params.getParam(
              'phone',
              ParamType.String,
            ),
            bvn: params.getParam(
              'bvn',
              ParamType.String,
            ),
            nin: params.getParam(
              'nin',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: LoginbiometricWidget.routeName,
          path: LoginbiometricWidget.routePath,
          builder: (context, params) => LoginbiometricWidget(),
        ),
        FFRoute(
          name: BvnverificationWidget.routeName,
          path: BvnverificationWidget.routePath,
          builder: (context, params) => BvnverificationWidget(
            phoneNumber: params.getParam(
              'phoneNumber',
              ParamType.String,
            ),
            sessionid: params.getParam(
              'sessionid',
              ParamType.String,
            ),
            bvn: params.getParam(
              'bvn',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: PhonereVerificationWidget.routeName,
          path: PhonereVerificationWidget.routePath,
          builder: (context, params) => PhonereVerificationWidget(
            phoneNumber: params.getParam(
              'phoneNumber',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: PhoneVerificationWidget.routeName,
          path: PhoneVerificationWidget.routePath,
          builder: (context, params) => PhoneVerificationWidget(
            phoneNumber: params.getParam(
              'phoneNumber',
              ParamType.String,
            ),
            registerwith: params.getParam(
              'registerwith',
              ParamType.String,
            ),
            bvn: params.getParam(
              'bvn',
              ParamType.String,
            ),
            nin: params.getParam(
              'nin',
              ParamType.String,
            ),
            isface: params.getParam(
              'isface',
              ParamType.bool,
            ),
          ),
        ),
        FFRoute(
          name: PinCodeSetupWidget.routeName,
          path: PinCodeSetupWidget.routePath,
          builder: (context, params) => PinCodeSetupWidget(
            phoneNumber: params.getParam(
              'phoneNumber',
              ParamType.String,
            ),
            registerwith: params.getParam(
              'registerwith',
              ParamType.String,
            ),
            bvn: params.getParam(
              'bvn',
              ParamType.String,
            ),
            nin: params.getParam(
              'nin',
              ParamType.String,
            ),
            isface: params.getParam(
              'isface',
              ParamType.bool,
            ),
          ),
        ),
        FFRoute(
          name: RegistrationsuccessWidget.routeName,
          path: RegistrationsuccessWidget.routePath,
          builder: (context, params) => RegistrationsuccessWidget(),
        ),
        FFRoute(
          name: ErrorpageWidget.routeName,
          path: ErrorpageWidget.routePath,
          builder: (context, params) => ErrorpageWidget(),
        ),
        FFRoute(
          name: EarnwithusWidget.routeName,
          path: EarnwithusWidget.routePath,
          builder: (context, params) => EarnwithusWidget(),
        ),
        FFRoute(
          name: KycpagggeWidget.routeName,
          path: KycpagggeWidget.routePath,
          builder: (context, params) => KycpagggeWidget(
            targetTier: params.getParam(
              'targetTier',
              ParamType.String,
            ),
            phoneno: params.getParam(
              'phoneno',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: UplooaaadWidget.routeName,
          path: UplooaaadWidget.routePath,
          builder: (context, params) => UplooaaadWidget(),
        ),
        FFRoute(
          name: GivwawayWidget.routeName,
          path: GivwawayWidget.routePath,
          builder: (context, params) => GivwawayWidget(),
        ),
        FFRoute(
          name: PublicofferWidget.routeName,
          path: PublicofferWidget.routePath,
          builder: (context, params) => PublicofferWidget(),
        ),
        FFRoute(
          name: SpeakingGameWidget.routeName,
          path: SpeakingGameWidget.routePath,
          builder: (context, params) => const SpeakingGameWidget(),
        ),
      ].map((r) => r.toRoute(appStateNotifier)).toList(),
    );

extension NavParamExtensions on Map<String, String?> {
  Map<String, String> get withoutNulls => Map.fromEntries(
        entries
            .where((e) => e.value != null)
            .map((e) => MapEntry(e.key, e.value!)),
      );
}

extension NavigationExtensions on BuildContext {
  void goNamedAuth(
    String name,
    bool mounted, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, String> queryParameters = const <String, String>{},
    Object? extra,
    bool ignoreRedirect = false,
  }) =>
      !mounted || GoRouter.of(this).shouldRedirect(ignoreRedirect)
          ? null
          : goNamed(
              name,
              pathParameters: pathParameters,
              queryParameters: queryParameters,
              extra: extra,
            );

  void pushNamedAuth(
    String name,
    bool mounted, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, String> queryParameters = const <String, String>{},
    Object? extra,
    bool ignoreRedirect = false,
  }) =>
      !mounted || GoRouter.of(this).shouldRedirect(ignoreRedirect)
          ? null
          : pushNamed(
              name,
              pathParameters: pathParameters,
              queryParameters: queryParameters,
              extra: extra,
            );

  void safePop() {
    // If there is only one route on the stack, navigate to the initial
    // page instead of popping.
    if (canPop()) {
      pop();
    } else {
      go('/');
    }
  }
}

extension GoRouterExtensions on GoRouter {
  AppStateNotifier get appState => AppStateNotifier.instance;
  void prepareAuthEvent([bool ignoreRedirect = false]) =>
      appState.hasRedirect() && !ignoreRedirect
          ? null
          : appState.updateNotifyOnAuthChange(false);
  bool shouldRedirect(bool ignoreRedirect) =>
      !ignoreRedirect && appState.hasRedirect();
  void clearRedirectLocation() => appState.clearRedirectLocation();
  void setRedirectLocationIfUnset(String location) =>
      appState.updateNotifyOnAuthChange(false);
}

extension _GoRouterStateExtensions on GoRouterState {
  Map<String, dynamic> get extraMap =>
      extra != null ? extra as Map<String, dynamic> : {};
  Map<String, dynamic> get allParams => <String, dynamic>{}
    ..addAll(pathParameters)
    ..addAll(uri.queryParameters)
    ..addAll(extraMap);
  TransitionInfo get transitionInfo => extraMap.containsKey(kTransitionInfoKey)
      ? extraMap[kTransitionInfoKey] as TransitionInfo
      : TransitionInfo.appDefault();
}

class FFParameters {
  FFParameters(this.state, [this.asyncParams = const {}]);

  final GoRouterState state;
  final Map<String, Future<dynamic> Function(String)> asyncParams;

  Map<String, dynamic> futureParamValues = {};

  // Parameters are empty if the params map is empty or if the only parameter
  // present is the special extra parameter reserved for the transition info.
  bool get isEmpty =>
      state.allParams.isEmpty ||
      (state.allParams.length == 1 &&
          state.extraMap.containsKey(kTransitionInfoKey));
  bool isAsyncParam(MapEntry<String, dynamic> param) =>
      asyncParams.containsKey(param.key) && param.value is String;
  bool get hasFutures => state.allParams.entries.any(isAsyncParam);
  Future<bool> completeFutures() => Future.wait(
        state.allParams.entries.where(isAsyncParam).map(
          (param) async {
            final doc = await asyncParams[param.key]!(param.value)
                .onError((_, __) => null);
            if (doc != null) {
              futureParamValues[param.key] = doc;
              return true;
            }
            return false;
          },
        ),
      ).onError((_, __) => [false]).then((v) => v.every((e) => e));

  dynamic getParam<T>(
    String paramName,
    ParamType type, {
    bool isList = false,
    StructBuilder<T>? structBuilder,
  }) {
    if (futureParamValues.containsKey(paramName)) {
      return futureParamValues[paramName];
    }
    if (!state.allParams.containsKey(paramName)) {
      return null;
    }
    final param = state.allParams[paramName];
    // Got parameter from `extras`, so just directly return it.
    if (param is! String) {
      return param;
    }
    // Return serialized value.
    return deserializeParam<T>(
      param,
      type,
      isList,
      structBuilder: structBuilder,
    );
  }
}

class FFRoute {
  const FFRoute({
    required this.name,
    required this.path,
    required this.builder,
    this.requireAuth = false,
    this.asyncParams = const {},
    this.routes = const [],
  });

  final String name;
  final String path;
  final bool requireAuth;
  final Map<String, Future<dynamic> Function(String)> asyncParams;
  final Widget Function(BuildContext, FFParameters) builder;
  final List<GoRoute> routes;

  GoRoute toRoute(AppStateNotifier appStateNotifier) => GoRoute(
        name: name,
        path: path,
        redirect: (context, state) {
          if (appStateNotifier.shouldRedirect) {
            final redirectLocation = appStateNotifier.getRedirectLocation();
            appStateNotifier.clearRedirectLocation();
            return redirectLocation;
          }

          if (requireAuth && !appStateNotifier.loggedIn) {
            appStateNotifier.setRedirectLocationIfUnset(state.uri.toString());
            return '/splash_screen';
          }
          return null;
        },
        pageBuilder: (context, state) {
          fixStatusBarOniOS16AndBelow(context);
          final ffParams = FFParameters(state, asyncParams);
          final page = ffParams.hasFutures
              ? FutureBuilder(
                  future: ffParams.completeFutures(),
                  builder: (context, _) => builder(context, ffParams),
                )
              : builder(context, ffParams);
          final child = appStateNotifier.loading
              ? Container(
                  color: FlutterFlowTheme.of(context).primaryBackground,
                  child: Image.asset(
                    'assets/images/Streetpay1.png',
                    fit: BoxFit.contain,
                  ),
                )
              : page;

          final transitionInfo = state.transitionInfo;
          return transitionInfo.hasTransition
              ? CustomTransitionPage(
                  key: state.pageKey,
                  name: state.name,
                  child: child,
                  transitionDuration: transitionInfo.duration,
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) =>
                          PageTransition(
                    type: transitionInfo.transitionType,
                    duration: transitionInfo.duration,
                    reverseDuration: transitionInfo.duration,
                    alignment: transitionInfo.alignment,
                    child: child,
                  ).buildTransitions(
                    context,
                    animation,
                    secondaryAnimation,
                    child,
                  ),
                )
              : MaterialPage(
                  key: state.pageKey, name: state.name, child: child);
        },
        routes: routes,
      );
}

class TransitionInfo {
  const TransitionInfo({
    required this.hasTransition,
    this.transitionType = PageTransitionType.fade,
    this.duration = const Duration(milliseconds: 300),
    this.alignment,
  });

  final bool hasTransition;
  final PageTransitionType transitionType;
  final Duration duration;
  final Alignment? alignment;

  static TransitionInfo appDefault() => TransitionInfo(hasTransition: false);
}

class RootPageContext {
  const RootPageContext(this.isRootPage, [this.errorRoute]);
  final bool isRootPage;
  final String? errorRoute;

  static bool isInactiveRootPage(BuildContext context) {
    final rootPageContext = context.read<RootPageContext?>();
    final isRootPage = rootPageContext?.isRootPage ?? false;
    final location = GoRouterState.of(context).uri.toString();
    return isRootPage &&
        location != '/' &&
        location != rootPageContext?.errorRoute;
  }

  static Widget wrap(Widget child, {String? errorRoute}) => Provider.value(
        value: RootPageContext(true, errorRoute),
        child: child,
      );
}

extension GoRouterLocationExtension on GoRouter {
  String getCurrentLocation() {
    final RouteMatch lastMatch = routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : routerDelegate.currentConfiguration;
    return matchList.uri.toString();
  }
}
