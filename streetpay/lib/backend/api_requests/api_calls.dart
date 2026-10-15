import 'dart:convert';

import 'package:flutter/foundation.dart';

import '/flutter_flow/flutter_flow_util.dart';
import '/config/secrets.dart';
import 'api_manager.dart';
import 'interceptors.dart';
import '/services/image_compress_service.dart';

export 'api_manager.dart' show ApiCallResponse;

/// Escapes a value for safe embedding inside a JSON string literal.
/// Prevents JSON injection when user-controlled data is interpolated into
/// hand-crafted request bodies.
String _esc(String? s) {
  if (s == null) return '';
  return jsonEncode(s).replaceAll(RegExp(r'^"|"$'), '');
}

/// Logs an upgrade request body to the Send DM (CHAT02) API.
Future<ApiCallResponse?> logUpgradeToDm({
  required String body,
  String? accessToken,
  String? phone,
  String? upgradeType,
}) async {
  try {
    final token = (accessToken != null && accessToken.isNotEmpty)
        ? accessToken
        : (FFAppState().bsptoken.isNotEmpty ? FFAppState().bsptoken : FFAppState().streetauth);
    final userPhone = (phone != null && phone.isNotEmpty)
        ? phone
        : FFAppState().phonenumber;
    final deviceId = FFAppState().deviceid.isNotEmpty
        ? FFAppState().deviceid
        : (userPhone.isNotEmpty ? userPhone : 'UPGRADE_LOG');

    debugPrint('[DM Log] Sending $upgradeType payload to Send DM API (theKey: CHAT02)...');
    final res = await SendmessageCall.call(
      accessToken: token,
      tempid: deviceId,
      messagetext: body,
      sender: userPhone.isNotEmpty ? userPhone : 'User',
      messagetype: upgradeType ?? 'UPGRADE_LOG',
      regphone: userPhone,
    );
    debugPrint('[DM Log] Send DM response: ${res.statusCode}');
    return res;
  } catch (e) {
    debugPrint('[DM Log] Failed to log upgrade to DM API: $e');
    return null;
  }
}

const _kPrivateApiFunctionName = 'ffPrivateApiCall';

/// Start WALLET AS A SERVICE Group Code

class WalletAsAServiceGroup {
  static String getBaseUrl({
    String? authToken = '',
  }) =>
      'https://api.mypingapi.com/sp/myhandler/waas/api/v1/';
  static Map<String, String> headers = {
    'Authorization': 'Bearer [authToken]',
  };
  static AuthenticationCall authenticationCall = AuthenticationCall();
  static InitiateidentityCall initiateidentityCall = InitiateidentityCall();
  static OpenwalletCall openwalletCall = OpenwalletCall();
  static WalletEnquiryCall walletEnquiryCall = WalletEnquiryCall();
  static WalletrequeryCall walletrequeryCall = WalletrequeryCall();
  static GetBankListCall getBankListCall = GetBankListCall();
  static OtherBankTransferCall otherBankTransferCall = OtherBankTransferCall();
  static DebitwalletCall debitwalletCall = DebitwalletCall();
  static CreditwalletCall creditwalletCall = CreditwalletCall();
  static WallethistoryCall wallethistoryCall = WallethistoryCall();
  static GetwalletCall getwalletCall = GetwalletCall();
  static UpgradetotiertwoCall upgradetotiertwoCall = UpgradetotiertwoCall();
  static UpgradetoteirthreeCall upgradetoteirthreeCall =
      UpgradetoteirthreeCall();
  static OtherbankenquiryCall otherbankenquiryCall = OtherbankenquiryCall();
  static UpgradestatusCall upgradestatusCall = UpgradestatusCall();
}

class AuthenticationCall {
  Future<ApiCallResponse> call({
    String? authToken = '',
  }) async {
    final baseUrl = WalletAsAServiceGroup.getBaseUrl(
      authToken: authToken,
    );

    final ffApiRequestBody = '''
{
  "username": "streetpay",
  "password": "LLKqNa29l1AuX1IXFjPgc1jrSfPSXsYC1635WaKYAq9zztQOBS",
  "clientId": "waas",
  "clientSecret": "cRAwnWElcNMUZpALdnlve6PubUkCPOQR"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'authentication',
      apiUrl: '${baseUrl}authenticate',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${authToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  dynamic fulldata(dynamic response) => getJsonField(
        response,
        r'''$''',
      );
  String? accesstoken(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.accessToken''',
      ));
  String? refreshToken(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.refreshToken''',
      ));
}

class InitiateidentityCall {
  Future<ApiCallResponse> call({
    String? authToken = '',
  }) async {
    final baseUrl = WalletAsAServiceGroup.getBaseUrl(
      authToken: authToken,
    );

    final ffApiRequestBody = '''
{
  "transactionRef": "street-6CA5158",
  "bvn": "22222222220",
  "nin": "12345678910",
  "phoneNo": "09024706049",
  "type": "OTP",
  "image": "{{base64Image}}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'initiateidentity',
      apiUrl: '${baseUrl}identity/initiate',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${authToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  dynamic fulldata(dynamic response) => getJsonField(
        response,
        r'''$''',
      );
  String? status(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.status''',
      ));
  String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.message''',
      ));
}

class OpenwalletCall {
  Future<ApiCallResponse> call({
    String? bvn = '',
    String? dob = '',
    int? gender,
    String? lastName = '',
    String? otherName = '',
    String? phoneNo = '',
    String? transactionTrackingRef = '',
    String? accountName = '',
    String? placeOfBirth = '',
    String? address = '',
    String? nationalIdentityNo = '',
    String? nextOfKinPhoneNo = '',
    String? nextOfKinName = '',
    String? email = '',
    String? ninUserId = '',
    String? authToken = '',
  }) async {
    final baseUrl = WalletAsAServiceGroup.getBaseUrl(
      authToken: authToken,
    );

    final ffApiRequestBody = '''
{
  "bvn": "${bvn}",
  "dateOfBirth": "${dob}",
  "gender": "${gender}",
  "lastName": "${lastName}",
  "otherNames": "${otherName}",
  "phoneNo": "${phoneNo}",
  "transactionTrackingRef": "${transactionTrackingRef}",
  "accountName": "${accountName}",
  "address": "${address}",
  "ninUserId": "${ninUserId}",
  "nationalIdentityNo": "${nationalIdentityNo}",
  "nextOfKinPhoneNo": "${nextOfKinPhoneNo}",
  "nextOfKinName": "${nextOfKinName}",
  "email": "${email}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'openwallet',
      apiUrl: '${baseUrl}open_wallet',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${authToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  String? status(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.status''',
      ));
  String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.message''',
      ));
  String? customerid(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.customerID''',
      ));
  String? accountno(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.accountNumber''',
      ));
  String? fullname(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.fullName''',
      ));
  dynamic fielderror(dynamic response) => getJsonField(
        response,
        r'''$.fieldErrors''',
      );
}

class WalletEnquiryCall {
  Future<ApiCallResponse> call({
    String? accountNo = '',
    String? authToken = '',
  }) async {
    final baseUrl = WalletAsAServiceGroup.getBaseUrl(
      authToken: authToken,
    );

    final ffApiRequestBody = '''
{
  "accountNo": "${accountNo}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'wallet enquiry',
      apiUrl: '${baseUrl}wallet_enquiry',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${authToken}',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  dynamic fulldata(dynamic response) => getJsonField(
        response,
        r'''$''',
      );
  String? status(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.status''',
      ));
  double? availablebalance(dynamic response) => castToType<double>(getJsonField(
        response,
        r'''$.data.availableBalance''',
      ));
  String? accountno(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.nuban''',
      ));
  String? phonenumber(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.phoneNo''',
      ));
  String? tier(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.tier''',
      ));
  String? accountname(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.name''',
      ));
  String? accountstatus(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.status''',
      ));
}

class WalletrequeryCall {
  Future<ApiCallResponse> call({
    String? accountNo = '',
    String? id = '',
    String? authToken = '',
  }) async {
    final baseUrl = WalletAsAServiceGroup.getBaseUrl(
      authToken: authToken,
    );

    final ffApiRequestBody = '''
{
  "accountNumber": "${accountNo}",
  "sessionID": "${id}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'walletrequery',
      apiUrl: '${baseUrl}notification_requery',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${authToken}',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  dynamic fulldata(dynamic response) => getJsonField(
        response,
        r'''$''',
      );
  String? status(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.status''',
      ));
  double? availablebalance(dynamic response) => castToType<double>(getJsonField(
        response,
        r'''$.data.availableBalance''',
      ));
  String? accountno(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.nuban''',
      ));
  String? phonenumber(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.phoneNo''',
      ));
  String? tier(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.tier''',
      ));
  String? accountname(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.name''',
      ));
  String? accountstatus(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.status''',
      ));
}

class GetBankListCall {
  Future<ApiCallResponse> call({
    String? authToken = '',
  }) async {
    final baseUrl = WalletAsAServiceGroup.getBaseUrl(
      authToken: authToken,
    );

    final ffApiRequestBody = '''
{
  "merchantID": ""
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'get bank list',
      apiUrl: '${baseUrl}get_banks',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${authToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  List<String>? bankname(dynamic response) => (getJsonField(
        response,
        r'''$.data.bankList[:].bankName''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  dynamic data(dynamic response) => getJsonField(
        response,
        r'''$.data''',
      );
}

class OtherBankTransferCall {
  Future<ApiCallResponse> call({
    String? customeraccount = '',
    String? customername = '',
    String? customeraccountno = '',
    String? senderaccountno = '',
    String? sendername = '',
    String? narration = '',
    String? amount = '',
    String? description = '',
    String? refrence = '',
    String? sectionid = '',
    String? refid = '',
    String? authToken = '',
  }) async {
    final baseUrl = WalletAsAServiceGroup.getBaseUrl(
      authToken: authToken,
    );

    // Normalize bank code (must be 3-6 digits; default to '120001' for StreetPay / 9PSB)
    String cleanBank = (customeraccount ?? '').trim();
    if (cleanBank.isEmpty ||
        cleanBank.toLowerCase().contains('streetpay') ||
        cleanBank.toLowerCase().contains('street pay') ||
        cleanBank == '000000' ||
        !RegExp(r'^\d{3,6}$').hasMatch(cleanBank)) {
      cleanBank = '120001';
    }

    // Normalize account number: extract digits only, strip leading 0 if 11 digits
    String cleanAccountNo = (customeraccountno ?? '').replaceAll(RegExp(r'\D'), '');
    if (cleanAccountNo.length == 11 && cleanAccountNo.startsWith('0')) {
      cleanAccountNo = cleanAccountNo.substring(1);
    }
    if (cleanAccountNo.isEmpty) {
      cleanAccountNo = (customeraccountno ?? '').trim();
    }

    final ffApiRequestBody = '''
{
  "customer": {
    "account": {
      "bank": "${_esc(cleanBank)}",
      "name": "${_esc(customername)}",
      "number": "${_esc(cleanAccountNo)}",
      "senderaccountnumber": "${_esc(senderaccountno)}",
      "sendername": "${_esc(sendername)}"
    }
  },
  "narration": "${_esc(narration)}",
  "order": {
    "amount": "${_esc(amount)}",
    "country": "NGA",
    "currency": "NGN",
    "description": "${_esc(description)}"
  },
  "transaction": {
    "reference": "${_esc(refrence)}",
    "sessionId": "${_esc(sectionid)}"
  },
  "merchant": {
    "isFee": false,
    "merchantFeeAccount": "",
    "merchantFeeAmount": ""
  }
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'other bank transfer',
      apiUrl: '${baseUrl}wallet_other_banks',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${authToken}',
        'refID': '${refid}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.message''',
      ));
  dynamic fulldata(dynamic response) => getJsonField(
        response,
        r'''$''',
      );
  bool? success(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.success''',
      ));
}

class DebitwalletCall {
  Future<ApiCallResponse> call({
    String? narration = '',
    String? amount = '',
    String? transactionid = '',
    String? accountno = '',
    String? refid = '',
    String? authToken = '',
  }) async {
    final baseUrl = WalletAsAServiceGroup.getBaseUrl(
      authToken: authToken,
    );

    final ffApiRequestBody = '''
{
  "accountNo": "${_esc(accountno)}",
  "narration": "${_esc(narration)}",
  "totalAmount": "${_esc(amount)}",
  "transactionId": "${_esc(transactionid)}",
  "merchant": {
    "isFee": false,
    "merchantFeeAccount": "",
    "merchantFeeAmount": ""
  }
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'debitwallet',
      apiUrl: '${baseUrl}debit/transfer',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${authToken}',
        'refID': '${refid}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.message''',
      ));
  dynamic fulldata(dynamic response) => getJsonField(
        response,
        r'''$''',
      );
  String? status(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.status''',
      ));
  dynamic fielderror(dynamic response) => getJsonField(
        response,
        r'''$.fieldErrors''',
      );
  String? succcessmessage(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.message''',
      ));
  bool? success(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.success''',
      ));
}

class CreditwalletCall {
  Future<ApiCallResponse> call({
    String? narration = '',
    String? amount = '',
    String? transactionid = '',
    String? accountno = '',
    String? refid = '',
    String? authToken = '',
  }) async {
    final baseUrl = WalletAsAServiceGroup.getBaseUrl(
      authToken: authToken,
    );

    final ffApiRequestBody = '''
{
  "accountNo": "${accountno}",
  "narration": "${narration}",
  "totalAmount": "${amount}",
  "transactionId": "${transactionid}",
  "merchant": {
    "isFee": false,
    "merchantFeeAccount": "",
    "merchantFeeAmount": ""
  }
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'creditwallet',
      apiUrl: '${baseUrl}credit/transfer',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${authToken}',
        'refID': '${refid}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.message''',
      ));
  dynamic fulldata(dynamic response) => getJsonField(
        response,
        r'''$''',
      );
  String? status(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.status''',
      ));
  dynamic fielderror(dynamic response) => getJsonField(
        response,
        r'''$.fieldErrors''',
      );
  String? succcessmessage(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.message''',
      ));
  bool? success(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.success''',
      ));
}

class WallethistoryCall {
  Future<ApiCallResponse> call({
    String? accountno = '',
    String? fromdate = '2024-10-24',
    String? todate = '2024-10-26',
    String? authToken = '',
  }) async {
    final baseUrl = WalletAsAServiceGroup.getBaseUrl(
      authToken: authToken,
    );

    final ffApiRequestBody = '''
{
  "accountNumber": "${accountno}",
  "fromDate": "${fromdate}",
  "toDate": "${todate}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'wallethistory',
      apiUrl: '${baseUrl}wallet_transactions',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${authToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  List? message(dynamic response) => getJsonField(
        response,
        r'''$.data.message''',
        true,
      ) as List?;
  List<String>? credit(dynamic response) => (getJsonField(
        response,
        r'''$.data.message[:].credit''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  List<String>? debit(dynamic response) => (getJsonField(
        response,
        r'''$.data.message[:].debit''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  dynamic fulldata(dynamic response) => getJsonField(
        response,
        r'''$''',
      );
}

class GetwalletCall {
  Future<ApiCallResponse> call({
    String? bvn = '',
    String? authToken = '',
  }) async {
    final baseUrl = WalletAsAServiceGroup.getBaseUrl(
      authToken: authToken,
    );

    final ffApiRequestBody = '''
{
  "bvn": "${bvn}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getwallet',
      apiUrl: '${baseUrl}get_wallet',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${authToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  String? accountno(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.wallet[:].accountNumber''',
      ));
}

class UpgradetotiertwoCall {
  Future<ApiCallResponse> call({
    String? accountno = '',
    String? bvn = '',
    String? accountname = '',
    String? channeltype = '',
    String? phonenumber = '',
    String? nin = '',
    String? tier = '',
    String? email = '',
    FFUploadedFile? userphotobase64,
    String? idType = '',
    String? idnumber = '',
    FFUploadedFile? idcardfront,
    String? housenumber = '',
    String? streetname = '',
    String? state = '',
    String? city = '',
    String? lga = '',
    String? approvalstatus = '',
    FFUploadedFile? customersignature,
    FFUploadedFile? utilitybill,
    String? nearestlandmark = '',
    String? dateissue = '',
    String? pep = '',
    String? expirydate = '',
    String? placeorbirth = '',
    FFUploadedFile? proofofaddress,
    FFUploadedFile? idcardback,
    String? authToken = '',
  }) async {
    // Ensure proof of address & utility bill are valid images at actual size
    FFUploadedFile? compressedProof = proofofaddress;
    if (proofofaddress != null &&
        proofofaddress.bytes != null &&
        proofofaddress.bytes!.isNotEmpty) {
      if (ImageCompressService.isPdf(proofofaddress.bytes, proofofaddress.name)) {
        compressedProof = await ImageCompressService.convertPdfOrDocToJpeg(proofofaddress);
      } else {
        compressedProof = await ImageCompressService.compressUploadedFile(
          proofofaddress,
          maxSizeKB: 150,
          minSizeKB: 0,
          isProof: true,
        );
      }
    }
    FFUploadedFile? compressedUtility = utilitybill;
    if (utilitybill != null &&
        utilitybill.bytes != null &&
        utilitybill.bytes!.isNotEmpty) {
      if (ImageCompressService.isPdf(utilitybill.bytes, utilitybill.name)) {
        compressedUtility = await ImageCompressService.convertPdfOrDocToJpeg(utilitybill);
      } else {
        compressedUtility = await ImageCompressService.compressUploadedFile(
          utilitybill,
          maxSizeKB: 150,
          minSizeKB: 100,
          isProof: false,
        );
      }
    }

    String validToken = (authToken != null && authToken.isNotEmpty)
        ? authToken
        : (FFAppState().bsptoken.isNotEmpty
            ? FFAppState().bsptoken
            : FFAppState().streetauth);
    if (validToken.isEmpty) {
      final auth = await StreetauthCall.call();
      final fresh = StreetauthCall.streettoken(auth.jsonBody);
      if (fresh != null && fresh.isNotEmpty) {
        validToken = fresh;
        FFAppState().bsptoken = fresh;
        FFAppState().streetauth = fresh;
      }
    }

    final logParams = <String, dynamic>{
      'theKey': '10000',
      'tier': tier,
      'accountNumber': accountno,
      'accountName': accountname,
      'bvn': bvn,
      'nin': nin,
      'phoneNumber': phonenumber,
      'email': email,
      'idType': idType,
      'idNumber': idnumber,
      'idIssueDate': dateissue,
      'idExpiryDate': expirydate,
      'houseNumber': housenumber,
      'streetName': streetname,
      'state': state,
      'city': city,
      'localGovernment': lga,
      'pep': pep,
      'nearestLandmark': nearestlandmark,
      'placeOfBirth': placeorbirth,
      'userPhoto': userphotobase64 != null
          ? '[File: ${userphotobase64.name} (${userphotobase64.bytes?.length ?? 0} bytes)]'
          : null,
      'idCardFront': idcardfront != null
          ? '[File: ${idcardfront.name} (${idcardfront.bytes?.length ?? 0} bytes)]'
          : null,
      'utilityBill': compressedUtility != null
          ? '[File: ${compressedUtility.name} (${compressedUtility.bytes?.length ?? 0} bytes)]'
          : null,
      'customerSignature': customersignature != null
          ? '[File: ${customersignature.name} (${customersignature.bytes?.length ?? 0} bytes)]'
          : null,
    };
    logUpgradeToDm(
      body: jsonEncode(logParams),
      accessToken: validToken,
      phone: phonenumber,
      upgradeType: 'UPGRADE_TIER_2',
    );

    return ApiManager.instance.makeApiCall(
      callName: 'upgradetotiertwo',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${validToken}',
      },
      params: {
        'theKey': '10000',
        'accountName': accountname,
        'accountNumber': accountno,
        'bvn': bvn,
        'city': city,
        'email': email,
        'houseNumber': housenumber,
        'idIssueDate': dateissue,
        'idNumber': idnumber,
        'idType': idType,
        'localGovernment': lga,
        'pep': pep,
        'phoneNumber': phonenumber,
        'state': state,
        'streetName': streetname,
        'tier': tier,
        'channelType': channeltype,
        'idExpiryDate': expirydate,
        'approvalStatus': approvalstatus,
        'nearestLandmark': nearestlandmark,
        'placeOfBirth': placeorbirth,
        'utilityBill': compressedUtility,
        'proofOfAddressVerification': compressedProof,
        'userPhoto': userphotobase64,
        'customerSignature': customersignature,
        'idCardFront': idcardfront,
        'idCardBack': idcardback,
      },
      bodyType: BodyType.MULTIPART,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.message''',
      ));
  String? status(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.status''',
      ));
  String? messagesss(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.message''',
      ));
}

class UpgradetoteirthreeCall {
  Future<ApiCallResponse> call({
    String? accountno = '',
    String? bvn = '',
    String? nin = '',
    String? profforaddressbase64 = '',
    String? channel = '',
    String? accountname = '',
    String? customerSignature = '',
    String? customerSignatureBase64 = '',
    String? authToken = '',
    String? addressDescription = '',
    String? residentialDescription = '',
  }) async {
    if (profforaddressbase64 == null || profforaddressbase64.isEmpty) {
      return const ApiCallResponse(
        {
          'Success': false,
          'Message':
              'Proof of address has not been generated. Please provide or generate proof of address to proceed.',
        },
        {},
        400,
      );
    }
    final sig = (customerSignatureBase64 != null && customerSignatureBase64.isNotEmpty)
        ? customerSignatureBase64
        : customerSignature;
    final resolvedAddressDesc = (addressDescription != null && addressDescription.isNotEmpty)
        ? (addressDescription.contains('from the app')
            ? addressDescription
            : '$addressDescription (from the app)')
        : (residentialDescription != null && residentialDescription.isNotEmpty)
            ? (residentialDescription.contains('from the app')
                ? residentialDescription
                : '$residentialDescription (from the app)')
            : 'Verified residential address (from the app)';

    final ffApiRequestBody = '''
{
  "accountNumber": "${escapeStringForJson(accountno)}",
  "bvn": "${escapeStringForJson(bvn)}",
  "nin": "${escapeStringForJson(nin)}",
  "proofOfAddressVerification": "${escapeStringForJson(profforaddressbase64)}",
  "proofaddress": "${escapeStringForJson(profforaddressbase64)}",
  "customerSignature": "${escapeStringForJson(sig)}",
  "customerSignatureBase64": "${escapeStringForJson(sig)}",
  "channel": "${escapeStringForJson(channel)}",
  "accountName": "${escapeStringForJson(accountname)}",
  "addressDescription": "${escapeStringForJson(resolvedAddressDesc)}",
  "residentialDescription": "${escapeStringForJson(resolvedAddressDesc)}",
  "theKey": "10000",
  "tier": "3"
}''';
    logUpgradeToDm(
      body: ffApiRequestBody,
      accessToken: authToken,
      upgradeType: 'UPGRADE_TIER_3',
    );
    return ApiManager.instance.makeApiCall(
      callName: 'upgradetoteirthree',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${authToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  dynamic errors(dynamic response) => getJsonField(
        response,
        r'''$.fieldErrors''',
      );
}

class OtherbankenquiryCall {
  Future<ApiCallResponse> call({
    String? accountNo = '',
    String? bank = '',
    String? bankcode = '',
    String? authToken = '',
  }) async {
    final baseUrl = WalletAsAServiceGroup.getBaseUrl(
      authToken: authToken,
    );

    final ffApiRequestBody = '''
{
  "customer": {
    "account": {
      "number": "${escapeStringForJson(accountNo)}",
      "bank": "${escapeStringForJson(bankcode)}"
    }
  }
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'otherbankenquiry',
      apiUrl: '${baseUrl}other_banks_enquiry',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${authToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.message''',
      ));
  String? accountname(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.customer.account.name''',
      ));
}

class UpgradestatusCall {
  Future<ApiCallResponse> call({
    String? account = '',
    String? authToken = '',
  }) async {
    final baseUrl = WalletAsAServiceGroup.getBaseUrl(
      authToken: authToken,
    );

    final ffApiRequestBody = '''
{
  "accountNumber": "${escapeStringForJson(account)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'upgradestatus',
      apiUrl: '${baseUrl}upgrade_status',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${authToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.message''',
      ));
  String? reason(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.reason''',
      ));
}

/// End WALLET AS A SERVICE Group Code

/// Start vas collection Group Code

class VasCollectionGroup {
  static String getBaseUrl({
    String? accessToken = '',
  }) =>
      'https://api.mypingapi.com/sp/myhandler/vas/api/v1';
  static Map<String, String> headers = {
    'Authorization': 'Bearer [accessToken]',
  };
  static TopupgetCall topupgetCall = TopupgetCall();
  static GetdataplanCall getdataplanCall = GetdataplanCall();
  static BuyairtimeCall buyairtimeCall = BuyairtimeCall();
  static DatatopupCall datatopupCall = DatatopupCall();
  static BillcategoryCall billcategoryCall = BillcategoryCall();
  static BillercategoryCall billercategoryCall = BillercategoryCall();
  static GetbillerinputCall getbillerinputCall = GetbillerinputCall();
  static ValidateddatainputCall validateddatainputCall =
      ValidateddatainputCall();
  static InitaitebillpaymentCall initaitebillpaymentCall =
      InitaitebillpaymentCall();
}

class TopupgetCall {
  Future<ApiCallResponse> call({
    String? phonenumber = '',
    String? accessToken = '',
  }) async {
    final baseUrl = VasCollectionGroup.getBaseUrl(
      accessToken: accessToken,
    );

    return ApiManager.instance.makeApiCall(
      callName: 'topupget',
      apiUrl: '${baseUrl}/topup/network?phone=${phonenumber}',
      callType: ApiCallType.GET,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  dynamic fulldata(dynamic response) => getJsonField(
        response,
        r'''$''',
      );
  String? accesstoken(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.accessToken''',
      ));
  String? refreshToken(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.refreshToken''',
      ));
  String? network(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.network''',
      ));
  String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.message''',
      ));
}

class GetdataplanCall {
  Future<ApiCallResponse> call({
    String? phoneNumber = '',
    String? accessToken = '',
  }) async {
    final baseUrl = VasCollectionGroup.getBaseUrl(
      accessToken: accessToken,
    );

    return ApiManager.instance.makeApiCall(
      callName: 'getdataplan',
      apiUrl: '${baseUrl}/topup/dataPlans?phone=${phoneNumber}',
      callType: ApiCallType.GET,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.message''',
      ));
  List? dataplans(dynamic response) => getJsonField(
        response,
        r'''$.data''',
        true,
      ) as List?;
  List<String>? validity(dynamic response) => (getJsonField(
        response,
        r'''$.data[:].validity''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  dynamic productid(dynamic response) => getJsonField(
        response,
        r'''$''',
      );
}

class BuyairtimeCall {
  Future<ApiCallResponse> call({
    String? network = '',
    String? amount = '',
    String? transferref = '',
    String? debitaccount = '',
    String? phonenumber = '',
    String? refid = '',
    String? accessToken = '',
  }) async {
    final baseUrl = VasCollectionGroup.getBaseUrl(
      accessToken: accessToken,
    );

    // Normalize phone number to standard 11-digit NGN phone number
    String cleanPhone = (phonenumber ?? '').replaceAll(RegExp(r'\D'), '');
    if (cleanPhone.length >= 10) {
      cleanPhone = '0${cleanPhone.substring(cleanPhone.length - 10)}';
    } else {
      cleanPhone = (phonenumber ?? '').trim();
    }

    final ffApiRequestBody = '''
{
  "phoneNumber": "${cleanPhone}",
  "network": "${network}",
  "amount": "${amount}",
  "debitAccount": "${debitaccount}",
  "transactionReference": "${transferref}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'buyairtime',
      apiUrl: '${baseUrl}/topup/airtime',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
        'Content-Type': 'application/json',
        'refID': '${refid}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  dynamic fulldata(dynamic response) => getJsonField(
        response,
        r'''$''',
      );
  String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.message''',
      ));
  bool? status(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.success''',
      ));
}

class DatatopupCall {
  Future<ApiCallResponse> call({
    String? debitaccount = '',
    String? productid = '',
    String? network = '',
    String? transferref = '',
    String? amount = '',
    String? phonenumber = '',
    String? refid = '',
    String? accessToken = '',
  }) async {
    final baseUrl = VasCollectionGroup.getBaseUrl(
      accessToken: accessToken,
    );

    // Normalize phone number to standard 11-digit NGN phone number
    String cleanPhone = (phonenumber ?? '').replaceAll(RegExp(r'\D'), '');
    if (cleanPhone.length >= 10) {
      cleanPhone = '0${cleanPhone.substring(cleanPhone.length - 10)}';
    } else {
      cleanPhone = (phonenumber ?? '').trim();
    }

    final ffApiRequestBody = '''
{
  "phoneNumber": "${cleanPhone}",
  "amount": "${amount}",
  "debitAccount": "${debitaccount}",
  "network": "${network}",
  "productId": "${productid}",
  "transactionReference": "${transferref}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'datatopup',
      apiUrl: '${baseUrl}/topup/data',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
        'refID': '${refid}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  bool? status(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.success''',
      ));
  String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.message''',
      ));
}

class BillcategoryCall {
  Future<ApiCallResponse> call({
    String? accessToken = '',
  }) async {
    final baseUrl = VasCollectionGroup.getBaseUrl(
      accessToken: accessToken,
    );

    return ApiManager.instance.makeApiCall(
      callName: 'billcategory',
      apiUrl: '${baseUrl}/billspayment/categories',
      callType: ApiCallType.GET,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.message''',
      ));
  dynamic fulldata(dynamic response) => getJsonField(
        response,
        r'''$''',
      );
  String? status(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.status''',
      ));
  List? data(dynamic response) => getJsonField(
        response,
        r'''$.data''',
        true,
      ) as List?;
}

class BillercategoryCall {
  Future<ApiCallResponse> call({
    String? id = '',
    String? accessToken = '',
  }) async {
    final baseUrl = VasCollectionGroup.getBaseUrl(
      accessToken: accessToken,
    );

    return ApiManager.instance.makeApiCall(
      callName: 'billercategory',
      apiUrl: '${baseUrl}/billspayment/billers/${id}',
      callType: ApiCallType.GET,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  List? data(dynamic response) => getJsonField(
        response,
        r'''$.data''',
        true,
      ) as List?;
  List<String>? name(dynamic response) => (getJsonField(
        response,
        r'''$.data[:].name''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  List<String>? id(dynamic response) => (getJsonField(
        response,
        r'''$.data[:].id''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
}

class GetbillerinputCall {
  Future<ApiCallResponse> call({
    String? id = '',
    String? accessToken = '',
  }) async {
    final baseUrl = VasCollectionGroup.getBaseUrl(
      accessToken: accessToken,
    );

    return ApiManager.instance.makeApiCall(
      callName: 'getbillerinput',
      apiUrl: '${baseUrl}/billspayment/fields/${id}',
      callType: ApiCallType.GET,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  List? fulldata(dynamic response) => getJsonField(
        response,
        r'''$.data''',
        true,
      ) as List?;
  String? status(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.status''',
      ));
  List<String>? fieldname(dynamic response) => (getJsonField(
        response,
        r'''$.data[:].fieldName''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  List<String>? fielddescription(dynamic response) => (getJsonField(
        response,
        r'''$.data[:].fieldDescription''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  List<String>? itemname(dynamic response) => (getJsonField(
        response,
        r'''$.data[:].items[:].itemName''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
}

class ValidateddatainputCall {
  Future<ApiCallResponse> call({
    String? billerid = '',
    String? customerid = '',
    String? itemid = '',
    String? amount = '',
    String? email = '',
    String? phone = '',
    String? accessToken = '',
  }) async {
    final baseUrl = VasCollectionGroup.getBaseUrl(
      accessToken: accessToken,
    );

    final ffApiRequestBody = '''
{
  "customerId": "${escapeStringForJson(customerid)}",
  "billerId": "${escapeStringForJson(billerid)}",
  "amount": "${escapeStringForJson(amount)}",
  "email": "${escapeStringForJson(email)}",
  "phone": "${escapeStringForJson(phone)}",
  "itemId": "${escapeStringForJson(itemid)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'validateddatainput',
      apiUrl: '${baseUrl}/billspayment/validate',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.message''',
      ));
  String? customername(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.customerName''',
      ));
  String? otherfield(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.otherField''',
      ));
  String? status(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.status''',
      ));
}

class InitaitebillpaymentCall {
  Future<ApiCallResponse> call({
    String? customerID = '',
    String? billerId = '',
    String? itemId = '',
    String? custormername = '',
    String? debitaccount = '',
    String? amount = '',
    String? transactionref = '',
    String? phone = '',
    String? email = '',
    String? refid = '',
    String? accessToken = '',
  }) async {
    final baseUrl = VasCollectionGroup.getBaseUrl(
      accessToken: accessToken,
    );

    // Normalize phone number to standard 11-digit NGN phone number (e.g. 080..., 081...)
    String cleanPhone = (phone ?? '').replaceAll(RegExp(r'\D'), '');
    if (cleanPhone.length >= 10) {
      cleanPhone = '0${cleanPhone.substring(cleanPhone.length - 10)}';
    } else {
      cleanPhone = (phone ?? '').trim();
    }

    final ffApiRequestBody = '''
{
  "customerId": "${escapeStringForJson(customerID)}",
  "billerId": "${escapeStringForJson(billerId)}",
  "itemId": "${escapeStringForJson(itemId)}",
  "customerPhone": "${escapeStringForJson(cleanPhone)}",
  "customerName": "${escapeStringForJson(custormername)}",
  "otherField": "${escapeStringForJson(email)}",
  "debitAccount": "${escapeStringForJson(debitaccount)}",
  "amount": "${escapeStringForJson(amount)}",
  "transactionReference": "${escapeStringForJson(transactionref)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'initaitebillpayment',
      apiUrl: '${baseUrl}/billspayment/pay',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
        'refID': '${refid}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.message''',
      ));
  String? status(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.status''',
      ));
  bool? success(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.success''',
      ));
}

/// End vas collection Group Code

/// Start streetpayreal Group Code

class StreetpayrealGroup {
  static String getBaseUrl() => 'wwww.yuyuuuu.com';
  static Map<String, String> headers = {};
}

/// End streetpayreal Group Code

class GetAPIAccessTokenCall {
  static Future<ApiCallResponse> call() async {
    final ffApiRequestBody = '''
{
  "username": "streetpay",
  "password": "LLKqNa29l1AuX1IXFjPgc1jrSfPSXsYC1635WaKYAq9zztQOBS"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Get API Access Token',
      apiUrl:
          'https://us-central1-streetpay-dev.cloudfunctions.net/api/wallet/api_token',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class CheckregisrationCall {
  static Future<ApiCallResponse> call({
    String? phonenumber = '',
    String? accessToken = '',
    String? radio = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "100",
  "radio": "${radio}",
  "Phone": "${phonenumber}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'checkregisration',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.Message''',
      ));
  static bool? success(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.Success''',
      ));
}

class RequestconnectCall {
  static Future<ApiCallResponse> call({
    String? vphone = '',
    String? accessToken = '',
    String? hphone = '',
    String? vdatein = '',
    String? meetingdetails = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "239",
  "Vphone": "${vphone}",
  "Hphone": "${hphone}",
  "VDatein": "${vdatein}",
  "reqtext": "${meetingdetails}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'requestconnect',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.Message''',
      ));
  static bool? success(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.Success''',
      ));
}

class JoinstreetjobCall {
  static Future<ApiCallResponse> call({
    String? phone = '',
    String? accessToken = '',
    String? fullname = '',
    String? category = '',
    String? videocv = '',
    String? textcv = '',
    String? otherlinks = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "248",
  "Phone": "${phone}",
  "Fullname": "${fullname}",
  "Category": "${category}",
  "VideoCV": "${videocv}",
  "TextCV": "${textcv}",
  "Otherlinks": "${otherlinks}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'joinstreetjob',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.Message''',
      ));
  static bool? success(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.Success''',
      ));
}

class StreetSHBalanceCall {
  static Future<ApiCallResponse> call({
    String? phone = '',
    String? accessToken = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "SH01",
  "Phone": "${phone}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'StreetSHBalance',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static int? totalamount(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.TotalAmount''',
      ));
  static int? totalwin(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.TotalWinAmount''',
      ));
  static int? winrage(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.WinRate''',
      ));
  static double? percentincrease(dynamic response) =>
      castToType<double>(getJsonField(
        response,
        r'''$.IncreasePercentThisMonth''',
      ));
}

class GetpointsCall {
  static Future<ApiCallResponse> call({
    String? phone = '',
    String? accessToken = '',
    String? year = '',
    String? month = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "P1",
  "Phone": "${phone}",
  "YYYY": "${year}",
  "MM": "${month}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getpoints',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static bool? status(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.success''',
      ));
  static List? data(dynamic response) => getJsonField(
        response,
        r'''$.data''',
        true,
      ) as List?;
}

class SavetokenCall {
  static Future<ApiCallResponse> call({
    String? phone = '',
    String? accessToken = '',
    String? dtoken = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "DTK",
  "Phone": "${phone}",
  "DToken": "${dtoken}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'savetoken',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static bool? status(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.success''',
      ));
  static List? data(dynamic response) => getJsonField(
        response,
        r'''$.data''',
        true,
      ) as List?;
}

class TestnotiCall {
  static Future<ApiCallResponse> call({
    String? phone = '',
    String? accessToken = '',
    String? dtoken = '',
    String? body = '',
  }) async {
    final ffApiRequestBody = '''
{
 "theKey":"TTEST",
  "Phone": "2349024706049",
  "Title": "Hello",
  "Body": "This is a test notification",
  "route": "/transactionHistory",
   "nextpage": "transactionHistory"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'testnoti',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static bool? status(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.success''',
      ));
  static List? data(dynamic response) => getJsonField(
        response,
        r'''$.data''',
        true,
      ) as List?;
}

class GeturlCall {
  static Future<ApiCallResponse> call({
    String? phone = '',
    String? accessToken = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "P3",
  "Phone": "${phone}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'geturl',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static bool? status(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.success''',
      ));
  static String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.invite''',
      ));
}

class GetUPDATECall {
  static Future<ApiCallResponse> call({
    String? version = '',
    String? accessToken = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "UPS",
  "VVV": "${version}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getUPDATE',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static bool? status(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.success''',
      ));
  static String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.message''',
      ));
  static bool? ismacth(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.isMatch''',
      ));
}

class GetradioCall {
  static Future<ApiCallResponse> call({
    String? accessToken = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "RADIO"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getradio',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static bool? status(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.success''',
      ));
  static List<String>? radiolist(dynamic response) => (getJsonField(
        response,
        r'''$.data''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
}

class GetcashbackCall {
  static Future<ApiCallResponse> call({
    String? phone = '',
    String? accessToken = '',
    String? year = '',
    String? month = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "P2",
  "Phone": "${phone}",
  "YYYY": "${year}",
  "MM": "${month}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getcashback',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static bool? status(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.success''',
      ));
  static List? data(dynamic response) => getJsonField(
        response,
        r'''$.data''',
        true,
      ) as List?;
}

class GetcashbackallCall {
  static Future<ApiCallResponse> call({
    String? phone = '',
    String? accessToken = '',
    String? year = '',
    String? month = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "P1.1",
  "MM": "${month}",
  "YYYY": "${year}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getcashbackall',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static bool? status(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.success''',
      ));
  static List? data(dynamic response) => getJsonField(
        response,
        r'''$.data''',
        true,
      ) as List?;
}

class SavewhatsappCall {
  static Future<ApiCallResponse> call({
    String? phone = '',
    String? accessToken = '',
    String? whatsapp = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "WWW",
  "Phone": "${phone}",
  "WhatsAppPhone": "${whatsapp}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'savewhatsapp',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static bool? status(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.Success''',
      ));
  static String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.Message''',
      ));
}

class GetshareplanCall {
  static Future<ApiCallResponse> call({
    String? accessToken = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "SH00"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getshareplan',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static bool? status(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.Message''',
      ));
  static List<int>? plans(dynamic response) => (getJsonField(
        response,
        r'''$.Plans''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<int>(x))
          .withoutNulls
          .toList();
}

class GetnewCall {
  static Future<ApiCallResponse> call({
    String? accessToken = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "NEWS"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getnew',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static bool? success(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.success''',
      ));
  static String? news(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.message''',
      ));
}

class GetCONTACTCall {
  static Future<ApiCallResponse> call({
    String? accessToken = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "CALL"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getCONTACT',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static String? email(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.Email''',
      ));
  static String? phone(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.Phone''',
      ));
}

class StreetSHHistoryCall {
  static Future<ApiCallResponse> call({
    String? phone = '',
    String? accessToken = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "SH02",
  "Phone": "${phone}"
}
''';
    return ApiManager.instance.makeApiCall(
      callName: 'StreetSHHistory',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static bool? hasgame(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.HasGame''',
      ));
  static List? history(dynamic response) => getJsonField(
        response,
        r'''$.History''',
        true,
      ) as List?;
}

class StreetSHEntriesCall {
  static Future<ApiCallResponse> call({
    String? accessToken = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "SH03"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'StreetSHEntries',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static List? result(dynamic response) => getJsonField(
        response,
        r'''$.Results''',
        true,
      ) as List?;
  static String? status(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.Status''',
      ));
}

class StreetSHGameDetailsCall {
  static Future<ApiCallResponse> call({
    String? gameid = '',
    String? accessToken = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "SH04",
  "GameID": "${gameid}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'StreetSHGameDetails',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static int? totalamount(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.TotalAmount''',
      ));
  static int? noofpeople(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.NumPeople''',
      ));
  static int? amountperperson(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.AmountPerPerson''',
      ));
  static List? playersdetails(dynamic response) => getJsonField(
        response,
        r'''$.Players''',
        true,
      ) as List?;
}

class StreetSHStoreCall {
  static Future<ApiCallResponse> call({
    String? phone = '',
    String? accessToken = '',
    String? amount = '',
    String? gameid = '',
    String? transid = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "SH05",
  "Phone": "${phone}",
  "Amount": "${amount}",
  "Plan": "${gameid}",
  "TransactionID": "${transid}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'StreetSHStore',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static String? status(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.Status''',
      ));
  static int? needed(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.Needed''',
      ));
  static int? current(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.Current''',
      ));
  static String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.Info''',
      ));
}

class RateprofileCall {
  static Future<ApiCallResponse> call({
    String? sender = '',
    String? accessToken = '',
    String? receiver = '',
    String? flagtext = '',
    String? rateflag = '',
    String? ratetype = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "251",
  "Sender": "${sender}",
  "Receiver": "${receiver}",
  "RateType": "${ratetype}",
  "RateFlag": "${rateflag}",
  "FlagText": "${flagtext}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'rateprofile',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.Message''',
      ));
  static bool? success(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.Success''',
      ));
}

class RetrieveprofileCall {
  static Future<ApiCallResponse> call({
    String? sender = '',
    String? accessToken = '',
    String? receiver = '',
    String? flagtext = '',
    String? rateflag = '',
    String? ratetype = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "251.1",
  "Receiver": "${receiver}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'retrieveprofile',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.Message''',
      ));
  static bool? success(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.Success''',
      ));
  static int? ratingcount(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.ratingCount''',
      ));
  static double? average(dynamic response) => castToType<double>(getJsonField(
        response,
        r'''$.averageRating''',
      ));
}

class GetwalletnewCall {
  static Future<ApiCallResponse> call({
    String? phone = '',
    String? accessToken = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "925",
  "Phone": "${phone}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getwalletnew',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static String? walletid(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.walletID''',
      ));
  static bool? status(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.success''',
      ));
}

class StoreGiftCall {
  static Future<ApiCallResponse> call({
    String? phone = '',
    String? accessToken = '',
    String? amount = '',
    String? brandname = '',
    String? state = '',
    String? payref = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "G100",
    "phone": "${phone}",
    "amount": "${amount}",
    "brandname": "${brandname}",
    "state": "${state}",
    "payref": "${payref}"
}
''';
    return ApiManager.instance.makeApiCall(
      callName: 'StoreGift',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static bool? status(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.Success''',
      ));
  static String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.Message''',
      ));
}

class AddofferCall {
  static Future<ApiCallResponse> call({
    String? phone = '',
    String? accessToken = '',
    String? amount = '',
    String? address = '',
    String? lat = '',
    String? long = '',
    String? category = '',
    String? offername = '',
    String? companyname = '',
    String? discount = '',
    String? whatsapp = '',
    String? expire = '',
    String? instagram = '',
    String? offerdescription = '',
    String? bonanzaprice = '',
    String? enddate = '',
    String? special = '',
    String? accessmode = '',
    String? willexpire = '',
    String? startdate = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "PUB01",
  "RegPhone": "${phone}",
  "BusinessTextAddress": "${address}",
  "LocLong": "${long}",
  "LocLat": "${lat}",
  "Category": "${category}",
  "OfferName": "${offername}",
  "CompanyName": "${companyname}",
  "Discount": "${discount}",
  "Amount": "${amount}",
  "WhatsAppNo": "${whatsapp}",
  "Instagram": "${instagram}",
  "OfferDescription": "${offerdescription}",
  "BonanzaPrice": "${bonanzaprice}",
  "EndDate": "${enddate}",
  "Special": "${special}",
  "AccessMode": "${accessmode}",
  "willexpire": "${willexpire}",
  "StartDate": "${startdate}"
}
''';
    return ApiManager.instance.makeApiCall(
      callName: 'addoffer',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.msg''',
      ));
  static bool? status(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.success''',
      ));
}

class RateofferCall {
  static Future<ApiCallResponse> call({
    String? phone = '',
    String? accessToken = '',
    String? bizid = '',
    double? rate,
    String? flag = '',
    String? comment = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "PUB06",
  "RegPhone": "${phone}",
  "BusinessID": ${bizid},
  "Flag": "${flag}",
  "Rate": ${rate},
  "Comment": "${comment}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'rateoffer',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static bool? status(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.Success''',
      ));
  static String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.Message''',
      ));
}

class ListnearbyCall {
  static Future<ApiCallResponse> call({
    double? lat,
    String? accessToken = '',
    double? long,
    String? radius = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "PUB02",
  "Lat": ${lat},
  "Long": ${long},
  "Radius": "${radius}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'LISTNEARBY',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static List? offerlist(dynamic response) => getJsonField(
        response,
        r'''$.offers''',
        true,
      ) as List?;
}

class GetbanknameCall {
  static Future<ApiCallResponse> call({
    String? accessToken = '',
    String? accountnumber = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "FF100",
  "accountNumber": "${accountnumber}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getbankname',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static List? offerlist(dynamic response) => getJsonField(
        response,
        r'''$.offers''',
        true,
      ) as List?;
}

class GetnearbybycategoryCall {
  static Future<ApiCallResponse> call({
    double? lat,
    String? accessToken = '',
    double? long,
    String? radius = '',
    String? category = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "PUB09",
  "Category":"${category}",
  "Lat": ${lat},
  "Long": ${long},
  "Radius": "${radius}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getnearbybycategory',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static List? offerlist(dynamic response) => getJsonField(
        response,
        r'''$.offers''',
        true,
      ) as List?;
}

class GetstoredofferCall {
  static Future<ApiCallResponse> call({
    String? phone = '',
    String? accessToken = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "PUB04",
  "RegPhone": "${phone}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getstoredoffer',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static List? mysavedoffer(dynamic response) => getJsonField(
        response,
        r'''$.offers''',
        true,
      ) as List?;
}

class UnlockofferCall {
  static Future<ApiCallResponse> call({
    String? phone = '',
    String? accessToken = '',
    String? busizid = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "PUB03",
  "RegPhone": "${phone}",
  "BusinessID": "${busizid}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'unlockoffer',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static bool? status(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.success''',
      ));
  static String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.msg''',
      ));
}

class EnableofferCall {
  static Future<ApiCallResponse> call({
    String? phone = '',
    String? accessToken = '',
    String? userstatus = '',
    String? busizid = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "PUB05",
  "RegPhone": "${phone}",
  "UserStatus": "${userstatus}",
  "BusinessID": "${busizid}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'enableoffer',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static bool? status(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.Success''',
      ));
  static String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.Message''',
      ));
}

class GetoffercategoryCall {
  static Future<ApiCallResponse> call({
    String? accessToken = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "PUB07"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getoffercategory',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static List<String>? category(dynamic response) => (getJsonField(
        response,
        r'''$.Categories''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
}

class LogpremiumCall {
  static Future<ApiCallResponse> call({
    String? accessToken = '',
    String? phone = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "LPRE",
  "Phone": "${phone}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'logpremium',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static List<String>? category(dynamic response) => (getJsonField(
        response,
        r'''$.Categories''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
}

class GettempidCall {
  static Future<ApiCallResponse> call({
    String? accessToken = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "CHAT01"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'gettempid',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static String? tempid(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.TempID''',
      ));
}

class SendmessageCall {
  static Future<ApiCallResponse> call({
    String? accessToken = '',
    String? tempid = '',
    String? messagetext = '',
    String? sender = '',
    String? messagetype = '',
    String? regphone = '',
  }) async {
    final ffApiRequestBody = jsonEncode({
      'theKey': 'CHAT02',
      'TempID': tempid ?? '',
      'Sender': sender ?? '',
      'MessageText': messagetext ?? '',
      'MessageType': messagetype ?? '',
      'RegPhone': regphone ?? '',
    });
    return ApiManager.instance.makeApiCall(
      callName: 'sendmessage',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static bool? status(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.success''',
      ));
  static String? msg(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.msg''',
      ));
}

class GetmessageCall {
  static Future<ApiCallResponse> call({
    String? accessToken = '',
    String? tempid = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "CHAT05",
  "TempID": "${tempid}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getmessage',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static List? messages(dynamic response) => getJsonField(
        response,
        r'''$.messages''',
        true,
      ) as List?;
}

class GetquestionCall {
  static Future<ApiCallResponse> call({
    String? accessToken = '',
    String? phone = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "DSS",
  "Phone": "${phone}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getquestion',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static String? question(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.Question''',
      ));
  static String? answer1(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.Answer1''',
      ));
  static String? answer2(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.Answer2''',
      ));
  static bool? status(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.success''',
      ));
}

class GetofferchargesCall {
  static Future<ApiCallResponse> call({
    String? accessToken = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "PUB08"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getoffercharges',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static String? storefees(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.Fees.StoreFee''',
      ));
  static String? accessfee(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.Fees.AccessFee''',
      ));
  static String? specialstorefees(dynamic response) =>
      castToType<String>(getJsonField(
        response,
        r'''$.Fees.SpecialStoreFee''',
      ));
  static String? specialaccessfee(dynamic response) =>
      castToType<String>(getJsonField(
        response,
        r'''$.Fees.SpecialAccessFee''',
      ));
}

class LockGiftCall {
  static Future<ApiCallResponse> call({
    String? phone = '',
    String? accessToken = '',
    String? id = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "G200",
  "id": "${id}",
  "phone": "${phone}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'LockGift',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static bool? status(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.Success''',
      ));
  static String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.Message''',
      ));
}

class ClaimByLockIdCall {
  static Future<ApiCallResponse> call({
    String? phone = '',
    String? accessToken = '',
    String? id = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "G300",
    "id": "${id}",
    "phone": "${phone}"
}
''';
    return ApiManager.instance.makeApiCall(
      callName: 'ClaimByLockId',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static bool? status(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.Success''',
      ));
  static String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.Message''',
      ));
  static String? id(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.Id''',
      ));
  static int? amount(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.Amount''',
      ));
}

class ShowGiftIDAvailableToLockCall {
  static Future<ApiCallResponse> call({
    String? phone = '',
    String? accessToken = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "G400",
  "phone": "${phone}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'ShowGiftIDAvailableToLock',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static bool? status(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.Success''',
      ));
  static List? gifts(dynamic response) => getJsonField(
        response,
        r'''$.Gifts''',
        true,
      ) as List?;
}

class ShowMyLockedIDCall {
  static Future<ApiCallResponse> call({
    String? phone = '',
    String? accessToken = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "G500",
  "phone": "${phone}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'ShowMyLockedID',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static bool? status(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.Success''',
      ));
  static int? count(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.Count''',
      ));
  static List? lockedgifts(dynamic response) => getJsonField(
        response,
        r'''$.LockedGifts''',
        true,
      ) as List?;
}

class ClaimedByPaidInCall {
  static Future<ApiCallResponse> call({
    String? phone = '',
    String? accessToken = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "G600",
  "phone": "${phone}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'ClaimedByPaidIn',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static bool? status(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.Success''',
      ));
  static int? paidincount(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.PaidInCount''',
      ));
  static List? paidinjson(dynamic response) => getJsonField(
        response,
        r'''$.PaidInGifts''',
        true,
      ) as List?;
  static int? claimedcount(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.ClaimedCount''',
      ));
  static List? claimedgifts(dynamic response) => getJsonField(
        response,
        r'''$.ClaimedGifts''',
        true,
      ) as List?;
}

class GetwalletdetailCall {
  static Future<ApiCallResponse> call({
    String? walletID = '',
    String? accessToken = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "926",
  "WalletID": "${walletID}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getwalletdetail',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static bool? status(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.success''',
      ));
  static String? surname(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.surname''',
      ));
  static String? othername(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.otherNames''',
      ));
  static String? accountno(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.accountNo''',
      ));
}

class DeletemoneycodeCall {
  static Future<ApiCallResponse> call({
    String? accessToken = '',
    String? code = '',
    String? phone = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "264",
  "Code": "${code}",
  "UserPhone": "${phone}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'deletemoneycode',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.Message''',
      ));
  static bool? success(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.Success''',
      ));
  static int? ratingcount(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.ratingCount''',
      ));
  static double? average(dynamic response) => castToType<double>(getJsonField(
        response,
        r'''$.averageRating''',
      ));
}

class JoinstreetjobmultipartCall {
  static Future<ApiCallResponse> call({
    String? phone = '',
    String? accessToken = '',
    String? fullname = '',
    String? category = '',
    String? videocv = '',
    String? textcv = '',
    String? otherlinks = '',
    String? datein = '',
    String? timein = '',
    FFUploadedFile? pix,
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'joinstreetjobmultipart',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {
        'Phone': phone,
        'Fullname': fullname,
        'Category': category,
        'VideoCV': videocv,
        'TextCV': textcv,
        'OtherLinks': otherlinks,
        'Datein': datein,
        'Timein': timein,
        'pix': pix,
        'theKey': "2000",
      },
      bodyType: BodyType.MULTIPART,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.Message''',
      ));
  static bool? success(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.Success''',
      ));
}

class UpdatestreetjobCall {
  static Future<ApiCallResponse> call({
    String? phone = '',
    String? accessToken = '',
    String? fullname = '',
    String? category = '',
    String? videocv = '',
    String? textcv = '',
    String? otherlinks = '',
    String? datein = '',
    String? timein = '',
    FFUploadedFile? pix,
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'updatestreetjob',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {
        'Phone': phone,
        'Fullname': fullname,
        'Category': category,
        'VideoCV': videocv,
        'TextCV': textcv,
        'OtherLinks': otherlinks,
        'Datein': datein,
        'Timein': timein,
        'pix': pix,
        'theKey': "5000",
      },
      bodyType: BodyType.MULTIPART,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.Message''',
      ));
  static bool? success(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.Success''',
      ));
}

class RetrievejobprofileCall {
  static Future<ApiCallResponse> call({
    String? id = '',
    String? accessToken = '',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'retrievejobprofile',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {
        'id': id,
        'theKey': "3500",
      },
      bodyType: BodyType.MULTIPART,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.Message''',
      ));
  static bool? success(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.Success''',
      ));
  static List? fulldata(dynamic response) => getJsonField(
        response,
        r'''$.Data''',
        true,
      ) as List?;
  static List<String>? phones(dynamic response) => (getJsonField(
        response,
        r'''$.Data[:].Phone''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
}

class SearchbycategoryCall {
  static Future<ApiCallResponse> call({
    String? accessToken = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "265"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'searchbycategory',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static List<String>? category(dynamic response) => (getJsonField(
        response,
        r'''$.categories''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
}

class ClaimcodCall {
  static Future<ApiCallResponse> call({
    String? accessToken = '',
    String? phone = '',
    String? code = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "261",
  "UserPhone": "${phone}",
  "Code": "${code}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'claimcod',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static bool? success(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.success''',
      ));
  static String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.message''',
      ));
}

class LoginntokenCall {
  static Future<ApiCallResponse> call({
    String? accessToken = '',
    String? phone = '',
    String? pincode = '',
    String? deviceid = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "200",
  "phoneNumber": "${phone}",
  "pinCode": "${pincode}",
"deviceid":"${deviceid}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'loginntoken',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static bool? success(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.success''',
      ));
  static String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.message''',
      ));
}

class FaceverifyCall {
  static Future<ApiCallResponse> call({
    String? accessToken = '',
    FFUploadedFile? selfie,
    String? idtype = '',
    String? idNumber = '',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'faceverify',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {
        'theKey': "9000",
        'idNumber': idNumber,
        'idType': idtype,
        'selfie': selfie,
      },
      bodyType: BodyType.MULTIPART,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static bool? success(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.data.success''',
      ));
  static String? firstname(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.firstName''',
      ));
  static String? middlename(dynamic response) =>
      castToType<String>(getJsonField(
        response,
        r'''$.data.middleName''',
      ));
  static String? gender(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.gender''',
      ));
  static String? phoneno(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.phoneNumber''',
      ));
  static bool? match(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.data.match''',
      ));
  static dynamic dob(dynamic response) => getJsonField(
        response,
        r'''$.dateOfBirth''',
      );
  static int? confidence(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.data.confidenceLevel''',
      ));
  static String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.message''',
      ));
  static String? lastname(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.lastName''',
      ));
}

class GetemailcodeCall {
  static Future<ApiCallResponse> call({
    String? accessToken = '',
    String? email = '',
    String? accountno = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "2002",
  "Email": "${email}",
  "AccountNo": "${accountno}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getemailcode',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static bool? success(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.success''',
      ));
  static String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.message''',
      ));
}

class VerifyemailcodeCall {
  static Future<ApiCallResponse> call({
    String? accessToken = '',
    String? email = '',
    String? accountno = '',
    String? pin = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "2003",
  "Email": "${email}",
  "AccountNo": "${accountno}",
  "PIN": "${pin}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'verifyemailcode',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static bool? success(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.success''',
      ));
  static String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.message''',
      ));
}

class GettransactiontokenCall {
  static Future<ApiCallResponse> call({
    String? accessToken = '',
    String? accountno = '',
    String? deviceid = '',
    String? sessionid = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "1001",
  "sessionToken": "${sessionid}",
  "accountNo": "${accountno}",
  "deviceId": "${deviceid}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'gettransactiontoken',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static bool? success(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.success''',
      ));
  static String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.message''',
      ));
  static String? transtoken(dynamic response) =>
      castToType<String>(getJsonField(
        response,
        r'''$.trans_token''',
      ));
}

class CreatecuponcodeCall {
  static Future<ApiCallResponse> call({
    String? accessToken = '',
    String? phone = '',
    String? refid = '',
    String? unit = '',
    String? amount = '',
    String? total = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "259",
  "RefId": "${refid}",
  "Amount": "${amount}",
  "Unit": "${unit}",
  "Total": "${total}",
  "UserPhone": "${phone}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'createcuponcode',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.Message''',
      ));
  static bool? success(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.Success''',
      ));
  static List? fulldata(dynamic response) => getJsonField(
        response,
        r'''$.Data''',
        true,
      ) as List?;
  static List<String>? phones(dynamic response) => (getJsonField(
        response,
        r'''$.Data[:].Phone''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
}

class CheckcuponcodeCall {
  static Future<ApiCallResponse> call({
    String? accessToken = '',
    String? phone = '',
    String? code = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "260",
  "UserPhone": "${phone}",
  "Code": "${code}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'checkcuponcode',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.message''',
      ));
  static String? amount(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.amount''',
      ));
  static bool? success(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.success''',
      ));
  static String? generatedby(dynamic response) =>
      castToType<String>(getJsonField(
        response,
        r'''$.GeneratedBy''',
      ));
}

class GetcuponcodehistoryCall {
  static Future<ApiCallResponse> call({
    String? accessToken = '',
    String? phone = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "262",
  "UserPhone": "${phone}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getcuponcodehistory',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static List? fulldata(dynamic response) => getJsonField(
        response,
        r'''$.data''',
        true,
      ) as List?;
  static List<String>? status(dynamic response) => (getJsonField(
        response,
        r'''$.data[:].Status''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? claimedby(dynamic response) => (getJsonField(
        response,
        r'''$.data[:].ClaimedBy''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List? availablelist(dynamic response) => getJsonField(
        response,
        r'''$.data.available''',
        true,
      ) as List?;
  static List? claimedlist(dynamic response) => getJsonField(
        response,
        r'''$.data.claimed''',
        true,
      ) as List?;
}

class RetrievesinglejobprofileCall {
  static Future<ApiCallResponse> call({
    String? id = '',
    String? accessToken = '',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'retrievesinglejobprofile',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {
        'id': id,
        'theKey': "4500",
      },
      bodyType: BodyType.MULTIPART,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.Message''',
      ));
  static bool? success(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.Success''',
      ));
  static List? fulldata(dynamic response) => getJsonField(
        response,
        r'''$.Data''',
        true,
      ) as List?;
}

class UpdateStreetJobProfileCall {
  static Future<ApiCallResponse> call({
    String? phone = '',
    String? accessToken = '',
    String? fullname = '',
    String? category = '',
    String? videocv = '',
    String? textcv = '',
    String? otherlinks = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "252",
  "Phone": "${phone}",
  "Fullname": "${fullname}",
  "Category": "${category}",
  "VideoCV": "${videocv}",
  "TextCV": "${textcv}",
  "Otherlinks": "${otherlinks}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'UpdateStreetJobProfile',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.Message''',
      ));
  static bool? success(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.Success''',
      ));
}

class SearchRatingCall {
  static Future<ApiCallResponse> call({
    String? phone = '',
    String? accessToken = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "249",
  "Phone": "${phone}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'SearchRating',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.Message''',
      ));
  static bool? success(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.Success''',
      ));
}

class SearchJobByCategoryCall {
  static Future<ApiCallResponse> call({
    String? category = '',
    String? accessToken = '',
    String? lat = '',
    String? long = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "250",
  "Category": "${category}",
  "userLat": "${lat}",
  "userLong": "${long}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'SearchJobByCategory',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.Message''',
      ));
  static bool? success(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.Success''',
      ));
  static List? fulldata(dynamic response) => getJsonField(
        response,
        r'''$.jobs''',
        true,
      ) as List?;
}

class InsertIntoTblRatingCall {
  static Future<ApiCallResponse> call({
    String? sender = '',
    String? accessToken = '',
    String? receiver = '',
    String? rateflag = '',
    String? flagtext = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "249",
  "Sender": "string",
  "Receiver": "string",
  "RateFlag": "string",
  "FlagText": "string"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'InsertIntoTblRating',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.Message''',
      ));
  static bool? success(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.Success''',
      ));
}

class GetrequestlistCall {
  static Future<ApiCallResponse> call({
    String? phonenumber = '',
    String? accessToken = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "240",
  "Hphone": "${phonenumber}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getrequestlist',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.Message''',
      ));
  static bool? success(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.Success''',
      ));
  static List? fulldata(dynamic response) => getJsonField(
        response,
        r'''$.Data''',
        true,
      ) as List?;
}

class GetsecurehistoryCall {
  static Future<ApiCallResponse> call({
    String? phonenumber = '',
    String? accessToken = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "242",
  "Phone1": "${phonenumber}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getsecurehistory',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.Message''',
      ));
  static bool? success(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.Success''',
      ));
  static List? fulldata(dynamic response) => getJsonField(
        response,
        r'''$.Data''',
        true,
      ) as List?;
  static List<String>? direction(dynamic response) => (getJsonField(
        response,
        r'''$.Data[:].Direction''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
}

class AcceptconnectionCall {
  static Future<ApiCallResponse> call({
    String? hphonenumber = '',
    String? accessToken = '',
    String? hdatein = '',
    String? hstatus = '',
    String? id = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "243",
  "Id": "${id}",
  "HPhone": "${hphonenumber}",
  "HDatein": "${hdatein}",
  "HStatus": "${hstatus}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'acceptconnection',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.Message''',
      ));
  static bool? success(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.Success''',
      ));
}

class VerifyphoneCall {
  static Future<ApiCallResponse> call({
    String? phoneno = '',
    String? accessToken = '',
    String? otp = '',
  }) async {
    final ffApiRequestBody = '''

{
  "theKey": "600",
  "Phone": "${phoneno}",
  "OTP": "${otp}"
}
''';
    return ApiManager.instance.makeApiCall(
      callName: 'verifyphone',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static bool? status(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.status''',
      ));
  static String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.message''',
      ));
}

class GetnetworkCall {
  static Future<ApiCallResponse> call({
    String? phoneno = '',
    String? accessToken = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "245",
  "Phone": "${phoneno}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getnetwork',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static bool? status(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.status''',
      ));
  static String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.message''',
      ));
  static String? network(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.Network''',
      ));
}

class GethistroyCall {
  static Future<ApiCallResponse> call({
    String? phoneno = '',
    String? accessToken = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "9444",
  "Phone": "${phoneno}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'gethistroy',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.message''',
      ));
  static List? fulldata(dynamic response) => getJsonField(
        response,
        r'''$.data''',
        true,
      ) as List?;
}

class GetsinglehistoryCall {
  static Future<ApiCallResponse> call({
    String? source = '',
    String? accessToken = '',
    String? id = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "9445",
  "Source": "${source}",
  "ID": "${id}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getsinglehistory',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static bool? status(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.status''',
      ));
  static String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.message''',
      ));
  static String? network(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.Network''',
      ));
}

class GetlottoquestionCall {
  static Future<ApiCallResponse> call({
    String? phoneno = '',
    String? accessToken = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "229",
  "UserPhone": "${phoneno}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getlottoquestion',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static int? questionid(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.question.ID''',
      ));
  static String? question(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.question.QText''',
      ));
  static String? optiona(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.question.OptA''',
      ));
  static String? optionb(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.question.OptB''',
      ));
  static String? optionc(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.question.OptC''',
      ));
  static String? correct(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.question.Ans''',
      ));
  static dynamic questionjson(dynamic response) => getJsonField(
        response,
        r'''$.question''',
      );
}

class GetlottonumberCall {
  static Future<ApiCallResponse> call({
    String? playedamount = '',
    String? accessToken = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "225",
  "PlayAmount": "${playedamount}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getlottonumber',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static int? number(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.number''',
      ));
  static bool? status(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.success''',
      ));
}

class AutodiscoveryCall {
  static Future<ApiCallResponse> call({
    String? phone = '',
    String? accessToken = '',
    bool? status,
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "237",
  "Phone": "${phone}",
  "Status": "${status}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'autodiscovery',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static int? number(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.number''',
      ));
  static bool? status(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.success''',
      ));
}

class SecureupdaterecordCall {
  static Future<ApiCallResponse> call({
    String? phone = '',
    String? accessToken = '',
    String? status = '',
    String? id = '',
    String? originator = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "241",
  "Id": "${id}",
  "Phone": "${phone}",
  "Originator": "${originator}",
  "Status": "${status}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'secureupdaterecord',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static int? number(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.number''',
      ));
  static bool? status(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.success''',
      ));
}

class PlayquizCall {
  static Future<ApiCallResponse> call({
    String? userphone = '',
    String? accessToken = '',
    String? sessionID = '',
    String? playamount = '',
    String? paymentref = '',
    List<int>? qidList,
    List<String>? useroptionList,
    List<String>? correctoptionsList,
    int? totalscore,
    double? duration,
  }) async {
    final qid = _serializeList(qidList);
    final useroption = _serializeList(useroptionList);
    final correctoptions = _serializeList(correctoptionsList);

    final ffApiRequestBody = '''
{
  "theKey": "230",
  "UserPhone": "${userphone}",
  "SessionID": "${sessionID}",
  "PaymentRef": "${paymentref}",
  "PlayAmount": "${playamount}",
  "QIDS": ${qid},
  "UserOptions": ${useroption},
  "CorrectOptions": ${correctoptions},
  "TotalScore": ${totalscore},
  "TotalDuration": ${duration}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'playquiz',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static int? number(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.number''',
      ));
  static bool? status(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.success''',
      ));
  static String? useroption(dynamic response) =>
      castToType<String>(getJsonField(
        response,
        r'''$.UserOptions''',
      ));
  static int? totalscore(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.TotalScore''',
      ));
  static String? playamount(dynamic response) =>
      castToType<String>(getJsonField(
        response,
        r'''$.PlayAmount''',
      ));
  static String? datein(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.DateIn''',
      ));
  static int? finalposition(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.FinalPosition''',
      ));
  static String? correctoption(dynamic response) =>
      castToType<String>(getJsonField(
        response,
        r'''$.CorrectOptions''',
      ));
  static int? totalduration(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.TotalDuration''',
      ));
  static double? scorepersecond(dynamic response) =>
      castToType<double>(getJsonField(
        response,
        r'''$.scorePerSecond''',
      ));
}

class GetreceipentCall {
  static Future<ApiCallResponse> call({
    String? accountno = '',
    String? accessToken = '',
    String? bankcode = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "256",
  "customer": {
    "account": {
      "number": "${accountno}",
      "bank": "${bankcode}"
    }
  }
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getreceipent',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static bool? status(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.success''',
      ));
  static String? accountname(dynamic response) =>
      castToType<String>(getJsonField(
        response,
        r'''$.customer.account.name''',
      ));
}

class LogtransactionCall {
  static Future<ApiCallResponse> call({
    String? phoneno = '',
    String? accountId = '',
    String? reqtype = '',
    String? sSid = '',
    String? passorfail = '',
    String? balBefore = '',
    String? balafter = '',
    String? beneficiary = '',
    String? tammt = '',
    String? extra = '',
    String? transREF = '',
    String? accessToken = '',
    String? ttype = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "943",
  "Phone": "${phoneno}",
  "AccountID": "${accountId}",
  "REQTYPE": "${reqtype}",
  "REQ_REF": "${transREF}",
  "SSID": "${sSid}",
  "PASSORFAIL": "${passorfail}",
  "BAL_BEFORE": "${balBefore}",
  "BAL_AFTER": "${balafter}",
  "BENEFICIARY": "${beneficiary}",
  "TAMMT": "${tammt}",
"ttype":"${ttype}",
  "extra": "${extra}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'logtransaction',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static bool? status(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.status''',
      ));
  static String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.message''',
      ));
}

class RetrievetransactionCall {
  static Future<ApiCallResponse> call({
    String? phoneno = '',
    String? accessToken = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "944",
  "Phone": "${phoneno}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'retrievetransaction',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static bool? status(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.status''',
      ));
  static String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.message''',
      ));
  static List? list(dynamic response) => getJsonField(
        response,
        r'''$.Data''',
        true,
      ) as List?;
  static dynamic fulldata(dynamic response) => getJsonField(
        response,
        r'''$''',
      );
}

class VerifysecretquestionCall {
  static Future<ApiCallResponse> call({
    String? phoneno = '',
    String? question = '',
    String? answer1 = '',
    String? answer2 = '',
    String? accessToken = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "901",
  "Phone": "${phoneno}",
  "Question": "${question}",
  "Answer1": "${answer1}",
  "Answer2": "${answer2}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'verifysecretquestion',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.message''',
      ));
  static bool? status(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.success''',
      ));
}

class IspincodevalidCall {
  static Future<ApiCallResponse> call({
    String? phoneno = '',
    String? pincode = '',
    String? accessToken = '',
    String? deviceid = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "200",
  "PhoneNo": "${phoneno}",
  "PinCode": "${pincode}",
  "DeviceID": "${deviceid}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'ispincodevalid',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static bool? success(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.IsValid''',
      ));
  static String? status(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.status''',
      ));
  static String? sessionid(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.SessionID''',
      ));
  static String? message(dynamic response) => castToType<String>(
        getJsonField(response, r'''$.Message''') ??
        getJsonField(response, r'''$.message''') ??
        getJsonField(response, r'''$.data.message''') ??
        getJsonField(response, r'''$.error'''),
      );
  static bool? profileactive(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.Profile.success''',
      ));
  static String? phone(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.Profile.PhoneNo''',
      ));
  static String? surname(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.Profile.Surname''',
      ));
  static String? bvn(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.Profile.BVN''',
      ));
  static String? dob(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.Profile.DOB''',
      ));
  static String? isautodiscover(dynamic response) =>
      castToType<String>(getJsonField(
        response,
        r'''$.Profile.IsAutoDiscoverOn''',
      ));
  static String? email(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.Profile.Useremail''',
      ));
  static String? fullname(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.Profile.Fullname''',
      ));
  static String? accountno(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.Profile.AccountNo''',
      ));
  static String? gender(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.Profile.Gender''',
      ));
  static bool? hassecurity(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.Profile.HasSecurityAnswers''',
      ));
  static String? accountbalanace(dynamic response) =>
      castToType<String>(getJsonField(
        response,
        r'''$.CoreB''',
      ));
  static String? walletid(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.Profile.WalletID''',
      ));
}

class IgnorebillCall {
  static Future<ApiCallResponse> call({
    String? billid = '',
    String? tophone = '',
    String? accessToken = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "933",
  "ToPhone": "${tophone}",
  "BillID": "${billid}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'ignorebill',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static bool? success(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.IsValid''',
      ));
}

class GetwinnersCall {
  static Future<ApiCallResponse> call({
    String? accessToken = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "220"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getwinners',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static bool? success(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.IsValid''',
      ));
  static List<String>? winners(dynamic response) => (getJsonField(
        response,
        r'''$.data''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
}

class SetpincodeCall {
  static Future<ApiCallResponse> call({
    String? phoneno = '',
    String? pincode = '',
    String? accessToken = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "700",
  "Phone": "${phoneno}",
  "Pincode": "${pincode}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'setpincode',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static bool? status(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.status''',
      ));
}

class BvnlookupCall {
  static Future<ApiCallResponse> call({
    String? bvn = '',
    String? accessToken = '',
    String? phone = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "266",
  "bvn": "${bvn}",
  "validatedphone": "${phone}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'bvnlookup',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static String? firstname(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.firstName''',
      ));
  static String? middlename(dynamic response) =>
      castToType<String>(getJsonField(
        response,
        r'''$.data.middleName''',
      ));
  static String? lastname(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.lastName''',
      ));
  static String? gender(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.gender''',
      ));
  static String? dob(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.dateOfBirth''',
      ));
  static String? phonenumber(dynamic response) =>
      castToType<String>(getJsonField(
        response,
        r'''$.data.phoneNumber''',
      ));
  static bool? success(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.data.success''',
      ));
  static String? bvn(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.sessionId''',
      ));
  static String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.message''',
      ));
}

class GetNINDetailsCall {
  static Future<ApiCallResponse> call({
    String? nin = '',
    String? accessToken = '',
    String? phone = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "269",
  "NIN": "${nin}",
  "validatedphone": "${phone}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'GetNINDetails',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static String? gender(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.gender''',
      ));
  static bool? success(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.data.success''',
      ));
  static String? firstname(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.firstName''',
      ));
  static String? nin(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.sessionId''',
      ));
  static String? middlename(dynamic response) =>
      castToType<String>(getJsonField(
        response,
        r'''$.data.middleName''',
      ));
  static String? lastname(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.lastName''',
      ));
  static String? dob(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.dateOfBirth''',
      ));
  static String? phone(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.phoneNumber''',
      ));
  static String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.message''',
      ));
}

class ResetpincodeCall {
  static Future<ApiCallResponse> call({
    String? phoneno = '',
    String? pincode = '',
    String? accessToken = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "224",
  "Phone": "${phoneno}",
  "Pincode": "${pincode}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'resetpincode',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static bool? status(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.status''',
      ));
}

class IstieroneactivatedCall {
  static Future<ApiCallResponse> call({
    String? phoneno = '',
    String? accessToken = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "300",
  "Phone": "${phoneno}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'istieroneactivated',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static bool? status(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.IsActivated''',
      ));
}

class CreateNewIdCall {
  static Future<ApiCallResponse> call({
    String? phoneno = '',
    String? accountno = '',
    String? customerno = '',
    String? accessToken = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "500",
  "AccountNo": "${accountno}",
  "CustomerNo": "${customerno}",
  "Phone": "${phoneno}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'createNewId',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static bool? status(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.success''',
      ));
  static String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.message''',
      ));
}

class GetsecretquestionsCall {
  static Future<ApiCallResponse> call({
    String? accessToken = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "800"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getsecretquestions',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static List<String>? fulldata(dynamic response) => (getJsonField(
        response,
        r'''$''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
}

class InsertintotieroneCall {
  static Future<ApiCallResponse> call({
    String? phoneno = '',
    String? surname = '',
    String? othernames = '',
    String? dob = '',
    String? bvn = '',
    String? altno = '',
    String? gender = '',
    String? base4Dp = '',
    String? accessToken = '',
    String? useremail = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "400",
  "Phone": "${phoneno}",
  "Surname": "${surname}",
  "Othernames": "${othernames}",
  "BVN": "${bvn}",
  "DOB": "${dob}",
  "Gender": "${gender}",
  "AlternatePhone": "${altno}",
  "base4Dp": "${base4Dp}",
  "Useremail": "${useremail}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'insertintotierone',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static bool? status(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.Success''',
      ));
  static String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.Message''',
      ));
}

class BsptokenCall {
  static Future<ApiCallResponse> call() async {
    final ffApiRequestBody = '''
{
  "username": "streetpay",
  "password": "vLYQNa6fUNIlkJT7BB5GJAGmPwD8txv08c9mw7nukHq3CzMcFl",
  "clientId": "waas",
  "clientSecret": "vU92FQrUPGr9Z8djZu76f0l1uJQlohAv"
}''';
    return FFApiInterceptor.makeApiCall(
      // ignore: prefer_const_constructors - can be mutated by interceptors
      ApiCallOptions(
        callName: 'bsptoken',
        apiUrl: 'https://api.mypingapi.com/sp/Dial/waas/api/v1/authenticate',
        callType: ApiCallType.POST,
        // ignore: prefer_const_literals_to_create_immutables - can be mutated by interceptors
        headers: {},
        // ignore: prefer_const_literals_to_create_immutables - can be mutated by interceptors
        params: {},
        body: ffApiRequestBody,
        bodyType: BodyType.JSON,
        returnBody: true,
        encodeBodyUtf8: false,
        decodeUtf8: false,
        cache: false,
        isStreamingApi: false,
        alwaysAllowBody: false,
      ),

      interceptors,
    );
  }

  static final interceptors = [
    ExampleInterceptor(),
  ];

  static String? accesstoken(dynamic response) =>
      castToType<String>(getJsonField(
        response,
        r'''$.accessToken''',
      ));
}

class GetaccountnoCall {
  static Future<ApiCallResponse> call({
    String? phoneno = '',
    String? accessToken = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "922",
  "Phone": "${phoneno}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getaccountno',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static String? accountno(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.account''',
      ));
  static bool? status(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.success''',
      ));
}

class InsertpindataCall {
  static Future<ApiCallResponse> call({
    String? hostphone = '',
    String? guestphone = '',
    String? datein = '',
    String? timein = '',
    String? accessToken = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "909",
  "HostPhoneNo": "${hostphone}",
  "GuestPhoneNo": "${guestphone}",
  "Datein": "${datein}",
  "Timein": "${timein}",
  "PinStatus": "Active"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'insertpindata',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GrantaccessCall {
  static Future<ApiCallResponse> call({
    String? hostno = '',
    String? guestno = '',
    String? accessToken = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "913",
  "HostPhone": "${hostno}",
  "GuestPhone": "${guestno}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'grantaccess',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static bool? status(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.success''',
      ));
  static String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.message''',
      ));
}

class ListguestprofileCall {
  static Future<ApiCallResponse> call({
    String? hostphone = '',
    String? accessToken = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "916",
  "Phone": "${hostphone}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'listguestprofile',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static List<String>? guests(dynamic response) => (getJsonField(
        response,
        r'''$.GuestProfiles''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
}

class ListhostprofileCall {
  static Future<ApiCallResponse> call({
    String? guestphone = '',
    String? accessToken = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "915",
  "GuestPhone": "${guestphone}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'listhostprofile',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static List<String>? hostprofile(dynamic response) => (getJsonField(
        response,
        r'''$.HostProfiles''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
}

class ReturntierprofileCall {
  static Future<ApiCallResponse> call({
    String? phoneno = '',
    String? accessToken = '',
  }) async {
    String validToken = (accessToken != null && accessToken.isNotEmpty)
        ? accessToken
        : (FFAppState().bsptoken.isNotEmpty
            ? FFAppState().bsptoken
            : FFAppState().streetauth);
    if (validToken.isEmpty) {
      final auth = await StreetauthCall.call(forceRefresh: true);
      final fresh = StreetauthCall.streettoken(auth.jsonBody);
      if (fresh != null && fresh.isNotEmpty) {
        validToken = fresh;
        FFAppState().bsptoken = fresh;
        FFAppState().streetauth = fresh;
      }
    }

    final ffApiRequestBody = '''
{
  "theKey": "902",
  "Phone": "${phoneno}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'returntierprofile',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${validToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static dynamic fulldata(dynamic response) => getJsonField(
        response,
        r'''$''',
      );
  static String? bvn(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.BVN''',
      ));
  static String? phone(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.PhoneNo''',
      ));
  static String? othername(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.Othernames''',
      ));
  static bool? securitystatus(dynamic response) =>
      castToType<bool>(getJsonField(
        response,
        r'''$.HasSecurityAnswers''',
      ));
  static String? accountNo(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.AccountNo''',
      ));
  static String? walletID(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.WalletID''',
      ));
  static String? autodicovery(dynamic response) =>
      castToType<String>(getJsonField(
        response,
        r'''$.IsAutoDiscoverOn''',
      ));
  static String? fullname(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.Fullname''',
      ));
  static bool? success(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.success''',
      ));
  static String? wasstoken(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.WAAS''',
      ));
  static String? vas(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.VAS''',
      ));
  static String? email(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.Useremail''',
      ));
  static String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.message''',
      ));
  static String? dob(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.DOB''',
      ));
}

class GettokenCall {
  static Future<ApiCallResponse> call({
    String? phoneno = '',
    String? accessToken = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "247"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'gettoken',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static dynamic fulldata(dynamic response) => getJsonField(
        response,
        r'''$''',
      );
  static String? bvn(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.BVN''',
      ));
  static String? phone(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.PhoneNo''',
      ));
  static String? othername(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.Othernames''',
      ));
  static bool? securitystatus(dynamic response) =>
      castToType<bool>(getJsonField(
        response,
        r'''$.HasSecurityAnswers''',
      ));
  static String? accountNo(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.AccountNo''',
      ));
  static String? walletID(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.WalletID''',
      ));
  static String? autodicovery(dynamic response) =>
      castToType<String>(getJsonField(
        response,
        r'''$.IsAutoDiscoverOn''',
      ));
  static String? fullname(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.Fullname''',
      ));
  static bool? success(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.success''',
      ));
}

class GetphonenCall {
  static Future<ApiCallResponse> call({
    String? accountNo = '',
    String? accessToken = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "924",
  "AccountNo": "${accountNo}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getphonen',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static String? phoneno(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.phone''',
      ));
}

class GetpinnedphonesCall {
  static Future<ApiCallResponse> call({
    String? hostphone = '',
    String? accessToken = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "910",
  "HostPhoneNo": "${hostphone}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getpinnedphones',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static List<String>? phones(dynamic response) => (getJsonField(
        response,
        r'''$.phones''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
}

class RevokeguestCall {
  static Future<ApiCallResponse> call({
    String? hostphone = '',
    String? guestphone = '',
    String? accessToken = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "914",
  "HostPhone": "${hostphone}",
  "GuestPhone": "${guestphone}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'revokeguest',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetreceivedbillCall {
  static Future<ApiCallResponse> call({
    String? tophome = '',
    String? accessToken = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "930",
  "ToPhone": "${tophome}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getreceivedbill',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static List? fulldata(dynamic response) => getJsonField(
        response,
        r'''$''',
        true,
      ) as List?;
  static int? amount(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$[:].Amount''',
      ));
  static String? descriptiomn(dynamic response) =>
      castToType<String>(getJsonField(
        response,
        r'''$[:].Description''',
      ));
  static String? phonw(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$[:].FromPhone''',
      ));
  static String? accountno(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$[:].AccountNo''',
      ));
  static String? name(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$[:].Fullname''',
      ));
}

class GetsentbillsCall {
  static Future<ApiCallResponse> call({
    String? fromphome = '',
    String? accessToken = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "929",
  "FromPhone": "${fromphome}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getsentbills',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static List? fulldata(dynamic response) => getJsonField(
        response,
        r'''$''',
        true,
      ) as List?;
  static List<int>? id(dynamic response) => (getJsonField(
        response,
        r'''$[:].ID''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<int>(x))
          .withoutNulls
          .toList();
  static List<int>? amount(dynamic response) => (getJsonField(
        response,
        r'''$[:].Amount''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<int>(x))
          .withoutNulls
          .toList();
  static List<String>? tophone(dynamic response) => (getJsonField(
        response,
        r'''$[:].ToPhone''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
}

class PostbillCall {
  static Future<ApiCallResponse> call({
    String? fromphome = '',
    String? tophone = '',
    String? amount = '',
    String? description = '',
    String? accessToken = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "931",
  "FromPhone": "${fromphome}",
  "ToPhone": "${tophone}",
  "Amount": "${amount}",
  "Description": "${description}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'postbill',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static bool? status(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.success''',
      ));
  static String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.message''',
      ));
}

class SendmailCall {
  static Future<ApiCallResponse> call({
    String? email = '',
    String? description = '',
    String? amount = '',
    String? type = '',
    String? accessToken = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "940",
  "ToEmail": "${email}",
  "TDesc": "${description}",
  "TAmnt": "${amount}",
  "TType": "${type}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'sendmail',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static bool? status(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.success''',
      ));
  static String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.message''',
      ));
}

class GetpinlistCall {
  static Future<ApiCallResponse> call({
    String? fromphone = '',
    String? accessToken = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "910",
  "HostPhoneNo": "${fromphone}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getpinlist',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static bool? status(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.success''',
      ));
  static List<String>? phones(dynamic response) => (getJsonField(
        response,
        r'''$.phones''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
}

class PostquestionsCall {
  static Future<ApiCallResponse> call({
    String? question = '',
    String? answer1 = '',
    String? answer2 = '',
    String? phone = '',
    String? accessToken = '',
    String? hostphone = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "900",
  "Phone": "${phone}",
  "HostPhone": "${hostphone}",
  "Question": "${question}",
  "Answer1": "${answer1}",
  "Answer2": "${answer2}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'postquestions',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class LocationdetectCall {
  static Future<ApiCallResponse> call({
    String? phoneno = '',
    String? lat = '',
    String? longi = '',
    String? accessToken = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "938",
  "Phone": "${phoneno}",
  "longi": "${longi}",
  "lati": "${lat}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'locationdetect',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static dynamic fulldata(dynamic response) => getJsonField(
        response,
        r'''$''',
      );
}

class PaidbillCall {
  static Future<ApiCallResponse> call({
    String? tophome = '',
    String? billid = '',
    String? accessToken = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "934",
  "ToPhone": "${tophome}",
  "BillID": "${billid}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'paidbill',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class WithdrawbillsCall {
  static Future<ApiCallResponse> call({
    String? fromphome = '',
    String? billid = '',
    String? accessToken = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "932",
  "FromPhone": "${fromphome}",
  "BillID": "${billid}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'withdrawbills',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetlottoplansCall {
  static Future<ApiCallResponse> call({
    String? accessToken = '',
    String? gametype = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "216",
  "GameType": "${gametype}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getlottoplans',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static List<String>? plans(dynamic response) => (getJsonField(
        response,
        r'''$.data''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
}

class GetanglesCall {
  static Future<ApiCallResponse> call({
    String? accessToken = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "233"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getangles',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static List<String>? plans(dynamic response) => (getJsonField(
        response,
        r'''$.data''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
}

class GetlottohistoryCall {
  static Future<ApiCallResponse> call({
    String? accessToken = '',
    String? userphone = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "222",
"UserPhone":"${userphone}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getlottohistory',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static List? fulldata(dynamic response) => getJsonField(
        response,
        r'''$.Data''',
        true,
      ) as List?;
  static List? winstatus(dynamic response) => getJsonField(
        response,
        r'''$.Data[:].WinStatus''',
        true,
      ) as List?;
}

class GethistoryflipCall {
  static Future<ApiCallResponse> call({
    String? accessToken = '',
    String? userphone = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "227",
  "UserPhone": "${userphone}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'gethistoryflip',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static List? fulldata(dynamic response) => getJsonField(
        response,
        r'''$.Data''',
        true,
      ) as List?;
  static List? winstatus(dynamic response) => getJsonField(
        response,
        r'''$.Data[:].WinStatus''',
        true,
      ) as List?;
}

class GethistoryquizCall {
  static Future<ApiCallResponse> call({
    String? accessToken = '',
    String? userphone = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "231",
  "UserPhone": "${userphone}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'gethistoryquiz',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static List? listofdata(dynamic response) => getJsonField(
        response,
        r'''$.data''',
        true,
      ) as List?;
  static List<String>? useroption(dynamic response) => (getJsonField(
        response,
        r'''$.data[:].UserOptions''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? correctoption(dynamic response) => (getJsonField(
        response,
        r'''$.data[:].CorrectOptions''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? finalposition(dynamic response) => (getJsonField(
        response,
        r'''$.data[:].finalposition''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? totalscore(dynamic response) => (getJsonField(
        response,
        r'''$.data[:].TotalScore''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? qids(dynamic response) => (getJsonField(
        response,
        r'''$.data[:].QIDS''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? playamount(dynamic response) => (getJsonField(
        response,
        r'''$.data[:].playamount''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? winamount(dynamic response) => (getJsonField(
        response,
        r'''$.data[:].winamount''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? datein(dynamic response) => (getJsonField(
        response,
        r'''$.data[:].datein''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? winstatus(dynamic response) => (getJsonField(
        response,
        r'''$.data[:].WinStatus''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
}

class GethistoryspinCall {
  static Future<ApiCallResponse> call({
    String? accessToken = '',
    String? userphone = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "235",
  "UserPhone": "${userphone}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'gethistoryspin',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static List? winstatus(dynamic response) => getJsonField(
        response,
        r'''$.Data[:].WinStatus''',
        true,
      ) as List?;
  static List? fulldata(dynamic response) => getJsonField(
        response,
        r'''$.data''',
        true,
      ) as List?;
}

class GetallwinnersCall {
  static Future<ApiCallResponse> call({
    String? accessToken = '',
    String? planamount = '',
    String? datein = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "223",
  "DateIn": "${datein}",
  "PlanAmount": "${planamount}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getallwinners',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static List? fulldata(dynamic response) => getJsonField(
        response,
        r'''$.Data''',
        true,
      ) as List?;
  static List? winstatus(dynamic response) => getJsonField(
        response,
        r'''$.Data[:].WinStatus''',
        true,
      ) as List?;
  static List<String>? phonenumber(dynamic response) => (getJsonField(
        response,
        r'''$.Data[:].UserPhone''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? amount(dynamic response) => (getJsonField(
        response,
        r'''$.Data[:].PlanAmount''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
}

class GetsingletransCall {
  static Future<ApiCallResponse> call({
    String? userphone = '',
    String? amount = '',
    String? accessToken = '',
    String? datein = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "219",
  "PlanAmount": "${amount}",
  "DateIn": "${datein}",
  "UserPhone": "${userphone}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getsingletrans',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static List<String>? plans(dynamic response) => (getJsonField(
        response,
        r'''$.data''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
}

class LottopayCall {
  static Future<ApiCallResponse> call({
    String? userphone = '',
    String? code1 = '',
    String? accessToken = '',
    String? code2 = '',
    String? gameid = '',
    String? sessionref = '',
    String? paymentref = '',
    String? planamount = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "218",
  "UserPhone": "${userphone}",
  "Code1": "${code1}",
  "Code2": "${code2}",
  "PlanAmount": "${planamount}",
  "GameID": "${gameid}",
  "SessionID": "${sessionref}",
  "PaymentRef": "${paymentref}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'lottopay',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class PlayangleCall {
  static Future<ApiCallResponse> call({
    String? userphone = '',
    String? angle = '',
    String? accessToken = '',
    String? sessionref = '',
    String? paymentref = '',
    String? planamount = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "234",
  "UserPhone": "${userphone}",
  "SessionID": "${sessionref}",
  "PaymentRef": "${paymentref}",
  "PlayAmount": "${planamount}",
  "YourDegree": "${angle}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'playangle',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class PlaysumCall {
  static Future<ApiCallResponse> call({
    String? userphone = '',
    String? no1 = '',
    String? accessToken = '',
    String? gameid = '',
    String? sessionref = '',
    String? paymentref = '',
    String? planamount = '',
    String? no2 = '',
    String? no3 = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "226",
  "UserPhone": "${userphone}",
  "No1": "${no1}",
  "No2": "${no2}",
  "No3": "${no3}",
  "PlayAmount": "${planamount}",
  "SessionID": "${sessionref}",
  "PaymentRef": "${paymentref}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'playsum',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetlottocodeCall {
  static Future<ApiCallResponse> call({
    String? planamount = '',
    String? accessToken = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "217",
  "PlanAmount": "${planamount}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getlottocode',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static String? id(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.ID''',
      ));
  static String? dayoftheweek(dynamic response) =>
      castToType<String>(getJsonField(
        response,
        r'''$.DayOfWeek''',
      ));
  static String? amount(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.PlanAmount''',
      ));
  static List<String>? lottocode(dynamic response) => (getJsonField(
        response,
        r'''$.LottoCodes''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
}

class VasauthenticationCall {
  static Future<ApiCallResponse> call() async {
    final ffApiRequestBody = '''
{
  "username": "STREETPAY_LIVE_9B29XDkLbF99DEcwyIt4",
  "password": "D1fIvOuShuO19PQGp3sE2qBn2yAIacESPYa8cZy9"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'vasauthentication',
      apiUrl: 'https://api.mypingapi.com/sp/Dial/identity/api/v1/authenticate',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static String? authToken(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.accessToken''',
      ));
  static bool? status(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.success''',
      ));
  static String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.message''',
      ));
}

class GetallstatesCall {
  static Future<ApiCallResponse> call() async {
    return ApiManager.instance.makeApiCall(
      callName: 'getallstates',
      apiUrl: 'https://nga-states-lga.onrender.com/fetch',
      callType: ApiCallType.GET,
      headers: {},
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static dynamic allstates(dynamic response) => getJsonField(
        response,
        r'''$''',
      );
}

class GetlgaCall {
  static Future<ApiCallResponse> call({
    String? lga = '',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'getlga',
      apiUrl: 'https://nga-states-lga.onrender.com/?state=${lga}',
      callType: ApiCallType.GET,
      headers: {},
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static dynamic lgas(dynamic response) => getJsonField(
        response,
        r'''$''',
      );
}

class StreetauthCall {
  static ApiCallResponse? _cachedResponse;
  static DateTime? _cacheTimestamp;
  static const Duration _cacheTtl = Duration(minutes: 10);

  /// Invalidate the cached authentication token
  static void clearCache() {
    _cachedResponse = null;
    _cacheTimestamp = null;
  }

  static Future<ApiCallResponse> call({bool forceRefresh = false}) async {
    final now = DateTime.now();
    if (!forceRefresh &&
        _cachedResponse != null &&
        _cacheTimestamp != null &&
        now.difference(_cacheTimestamp!) < _cacheTtl) {
      return _cachedResponse!;
    }

    final ffApiRequestBody = jsonEncode({
      'userId': AppSecrets.streetauthUserId,
      'secretKey': AppSecrets.streetauthSecretKey,
    });
    final response = await ApiManager.instance.makeApiCall(
      callName: 'streetauth',
      apiUrl: 'https://api.mypingapi.com/sp/AuthSP',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );

    if (response.succeeded && streettoken(response.jsonBody) != null) {
      _cachedResponse = response;
      _cacheTimestamp = now;
    }
    return response;
  }

  static String? streettoken(dynamic response) =>
      castToType<String>(getJsonField(
        response,
        r'''$.token''',
      ));
  static String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.message''',
      ));
  static String? status(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.status''',
      ));
}

class GetotpfromphoneCall {
  static Future<ApiCallResponse> call({
    String? phone = '',
    String? accessToken = '',
    String? oldphone = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "947",
  "Phone": "${escapeStringForJson(phone)}",
  "OldPhone": "${escapeStringForJson(oldphone)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getotpfromphone',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static bool? status(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.Success''',
      ));
}

class ReverifyotpCall {
  static Future<ApiCallResponse> call({
    String? phone = '',
    String? accessToken = '',
    String? otp = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "948",
  "Phone": "${escapeStringForJson(phone)}",
"OTP":"${escapeStringForJson(otp)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'reverifyotp',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static bool? status(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.Success''',
      ));
}

class RetriveaccountfromwalletidCall {
  static Future<ApiCallResponse> call({
    String? accessToken = '',
    String? walletid = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "952",
  "WalletID": "${escapeStringForJson(walletid)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'retriveaccountfromwalletid',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static bool? success(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.success''',
      ));
  static String? accountno(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.AccountNo''',
      ));
  static String? phone(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.Phone''',
      ));
  static String? surname(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.Surname''',
      ));
  static String? othername(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.Othernames''',
      ));
}

class RetrivewalletidfromphoneCall {
  static Future<ApiCallResponse> call({
    String? accessToken = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "951",
  "Phone": "2348164568803"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'retrivewalletidfromphone',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class BvnvalidationCall {
  static Future<ApiCallResponse> call({
    String? bVNName = '',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'bvnvalidation',
      apiUrl: 'https://api.flutterwave.com/v3/bvn/verifications/${bVNName}',
      callType: ApiCallType.GET,
      headers: {
        'Authorization':
            'Bearer ',
        'Content-Type': 'application/json',
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class BVNConsentCall {
  static Future<ApiCallResponse> call({
    String? bvn = '',
    String? firstName = '',
    String? lastName = '',
  }) async {
    final ffApiRequestBody = '''
{
	"bvn": "12347832332",
	"firstname": "Lyra",
	"lastname": "Balacqua",
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'BVNConsent',
      apiUrl: 'https://api.flutterwave.com/v3/bvn/verifications',
      callType: ApiCallType.POST,
      headers: {
        'Authorization':
            'Bearer ',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetaccountbalanceCall {
  static Future<ApiCallResponse> call({
    String? phone = '',
    String? accessToken = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "246",
  "Phone":"${escapeStringForJson(phone)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getaccountbalance',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static bool? success(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.success''',
      ));
  static double? avalbal(dynamic response) => castToType<double>(getJsonField(
        response,
        r'''$.data.availableBalance''',
      ));
  static String? tier(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.tier''',
      ));
  static String? bvn(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.bvn''',
      ));
}

class GethistoryCall {
  static Future<ApiCallResponse> call({
    String? account = '',
    String? accessToken = '',
  }) async {
    final ffApiRequestBody = '''
{
  "theKey": "2533",
  "accountnumber":"${escapeStringForJson(account)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'gethistory',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static bool? success(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.success''',
      ));
  static double? avalbal(dynamic response) => castToType<double>(getJsonField(
        response,
        r'''$.data.availableBalance''',
      ));
  static String? tier(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.tier''',
      ));
  static String? bvn(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.bvn''',
      ));
}

class UpgradetoteirtwoCall {
  static Map<String, dynamic>? lastCallRequestBody;
  static ApiCallResponse? lastCallResponse;
  static String? lastCallResponseBody;
  static String? lastCallError;
  static DateTime? lastCallTimestamp;
  static int? lastCallStatusCode;

  static Future<ApiCallResponse> call({
    String? accountNumber = '',
    String? bvn = '',
    String? accountName = '',
    String? phoneNumber = '',
    String? tier = '',
    String? email = '',
    FFUploadedFile? userPhoto,
    String? idType = '',
    String? idNumber = '',
    String? idIssueDate = '',
    String? idExpiryDate = '',
    FFUploadedFile? idCardFront,
    String? houseNumber = '',
    String? streetName = '',
    String? state = '',
    String? city = '',
    String? localGovernment = '',
    String? pep = '',
    FFUploadedFile? customerSignature,
    FFUploadedFile? utilityBill,
    FFUploadedFile? proofaddress,
    String? nearestLandmark = '',
    String? accessToken = '',
    String? nin = '',
  }) async {
    final targetTier = (tier != null && tier.isNotEmpty) ? tier : '2';
    if (targetTier == '3' &&
        (proofaddress == null ||
            proofaddress.bytes == null ||
            proofaddress.bytes!.isEmpty)) {
      return const ApiCallResponse(
        {
          'Success': false,
          'Message':
              'Proof of address has not been generated. Please provide or generate proof of address to proceed.',
        },
        {},
        400,
      );
    }
    final resolvedUtilityBill = (utilityBill?.bytes?.isNotEmpty ?? false) ? utilityBill : null;
    final logParams = <String, dynamic>{
      'theKey': '10000',
      'tier': targetTier,
      'accountNumber': accountNumber,
      'accountName': accountName,
      'bvn': bvn,
      'nin': nin,
      'phoneNumber': phoneNumber,
      'email': email,
      'idType': idType,
      'idNumber': idNumber,
      'idIssueDate': idIssueDate,
      'idExpiryDate': idExpiryDate,
      'houseNumber': houseNumber,
      'streetName': streetName,
      'state': state,
      'city': city,
      'localGovernment': localGovernment,
      'pep': pep,
      'nearestLandmark': nearestLandmark,
      'userPhoto': userPhoto != null
          ? '[File: ${userPhoto.name} (${userPhoto.bytes?.length ?? 0} bytes)]'
          : null,
      'idCardFront': idCardFront != null
          ? '[File: ${idCardFront.name} (${idCardFront.bytes?.length ?? 0} bytes)]'
          : null,
      'utilityBill': resolvedUtilityBill != null
          ? '[File: ${resolvedUtilityBill.name} (${resolvedUtilityBill.bytes?.length ?? 0} bytes)]'
          : null,
      'proofaddress': proofaddress != null
          ? '[File: ${proofaddress.name} (${proofaddress.bytes?.length ?? 0} bytes)]'
          : null,
      'customerSignature': customerSignature != null
          ? '[File: ${customerSignature.name} (${customerSignature.bytes?.length ?? 0} bytes)]'
          : null,
    };
    String validToken = (accessToken != null && accessToken.isNotEmpty)
        ? accessToken
        : (FFAppState().bsptoken.isNotEmpty
            ? FFAppState().bsptoken
            : FFAppState().streetauth);
    if (validToken.isEmpty) {
      final auth = await StreetauthCall.call();
      final fresh = StreetauthCall.streettoken(auth.jsonBody);
      if (fresh != null && fresh.isNotEmpty) {
        validToken = fresh;
        FFAppState().bsptoken = fresh;
        FFAppState().streetauth = fresh;
      }
    }

    final effectiveAccountNo = (accountNumber != null && accountNumber.isNotEmpty)
        ? accountNumber
        : FFAppState().accountno;

    logUpgradeToDm(
      body: jsonEncode(logParams),
      accessToken: validToken,
      phone: phoneNumber,
      upgradeType: targetTier == '3' ? 'UPGRADE_TIER_3' : 'UPGRADE_TIER_2',
    );

    final sanitizedLandmark = UpgradetotierthreeCall.sanitizeLandmark(nearestLandmark);

    final requestParams = <String, dynamic>{
      'theKey': '10000',
      'tier': targetTier,
      'accountNumber': effectiveAccountNo,
      'bvn': bvn ?? '',
      'nin': nin ?? '',
      'accountName': accountName ?? '',
      'phoneNumber': phoneNumber ?? '',
      'email': email ?? '',
      'idType': (idType != null && idType.isNotEmpty) ? idType : '1',
      'idNumber': (idNumber != null && idNumber.isNotEmpty) ? idNumber : (nin ?? ''),
      'idIssueDate': idIssueDate ?? '',
      'houseNumber': houseNumber ?? '',
      'streetName': streetName ?? '',
      'state': state ?? '',
      'city': city ?? '',
      'localGovernment': localGovernment ?? '',
      'pep': (pep != null && pep.isNotEmpty) ? pep : 'No',
      'nearestLandmark': sanitizedLandmark,
    };

    if (idExpiryDate != null && idExpiryDate.isNotEmpty) {
      requestParams['idExpiryDate'] = idExpiryDate;
    }
    if (userPhoto != null && (userPhoto.bytes?.isNotEmpty ?? false)) {
      requestParams['userPhoto'] = userPhoto;
    }
    if (idCardFront != null && (idCardFront.bytes?.isNotEmpty ?? false)) {
      requestParams['idCardFront'] = idCardFront;
    }
    if (customerSignature != null && (customerSignature.bytes?.isNotEmpty ?? false)) {
      requestParams['customerSignature'] = customerSignature;
    }
    if (resolvedUtilityBill != null && (resolvedUtilityBill.bytes?.isNotEmpty ?? false)) {
      requestParams['utilityBill'] = resolvedUtilityBill;
    }
    if (proofaddress != null && (proofaddress.bytes?.isNotEmpty ?? false)) {
      requestParams['proofaddress'] = proofaddress;
      requestParams['proofOfAddressVerification'] = proofaddress;
    }

    final debugBody = Map<String, dynamic>.from(requestParams);
    if (proofaddress != null && proofaddress.bytes?.isNotEmpty == true) {
      debugBody['proofOfAddressVerification'] =
          '[File: ${proofaddress.name} (${((proofaddress.bytes?.length ?? 0) / 1024).toStringAsFixed(1)} KB)]';
    }
    if (resolvedUtilityBill != null && resolvedUtilityBill.bytes?.isNotEmpty == true) {
      debugBody['utilityBill'] =
          '[File: ${resolvedUtilityBill.name} (${((resolvedUtilityBill.bytes?.length ?? 0) / 1024).toStringAsFixed(1)} KB)]';
    }
    if (userPhoto != null && userPhoto.bytes?.isNotEmpty == true) {
      debugBody['userPhoto'] =
          '[File: ${userPhoto.name} (${((userPhoto.bytes?.length ?? 0) / 1024).toStringAsFixed(1)} KB)]';
    }
    if (idCardFront != null && idCardFront.bytes?.isNotEmpty == true) {
      debugBody['idCardFront'] =
          '[File: ${idCardFront.name} (${((idCardFront.bytes?.length ?? 0) / 1024).toStringAsFixed(1)} KB)]';
    }
    if (customerSignature != null && customerSignature.bytes?.isNotEmpty == true) {
      debugBody['customerSignature'] =
          '[File: ${customerSignature.name} (${((customerSignature.bytes?.length ?? 0) / 1024).toStringAsFixed(1)} KB)]';
    }
    debugBody.forEach((key, value) {
      if (value is FFUploadedFile) {
        debugBody[key] =
            '[File: ${value.name} (${((value.bytes?.length ?? 0) / 1024).toStringAsFixed(1)} KB)]';
      }
    });
    lastCallRequestBody = debugBody;
    lastCallTimestamp = DateTime.now();

    try {
      final res = await ApiManager.instance.makeApiCall(
        callName: 'upgradetoteirtwo',
        apiUrl: 'https://api.mypingapi.com/sp/myhandler',
        callType: ApiCallType.POST,
        headers: {
          'Authorization': 'Bearer ${validToken}',
        },
        params: requestParams,
        bodyType: BodyType.MULTIPART,
        returnBody: true,
        encodeBodyUtf8: false,
        decodeUtf8: false,
        cache: false,
        isStreamingApi: false,
        alwaysAllowBody: false,
      );
      lastCallResponse = res;
      lastCallStatusCode = res.statusCode;
      lastCallResponseBody = res.response?.body ??
          (res.jsonBody != null ? jsonEncode(res.jsonBody) : res.responseMessage);
      lastCallError = (res.isSuccessful || status(res.jsonBody) == true)
          ? null
          : (message(res.jsonBody) ?? (res.responseMessage.isNotEmpty ? res.responseMessage : 'HTTP ${res.statusCode}'));
      return res;
    } catch (e) {
      lastCallError = '$e';
      lastCallResponseBody = 'Exception: $e';
      rethrow;
    }
  }

  static bool? status(dynamic response) => castToType<bool>(
        getJsonField(response, r'''$.Success''') ??
        getJsonField(response, r'''$.success'''),
      );
  static bool? success(dynamic response) => status(response);
  static String? message(dynamic response) => castToType<String>(
        getJsonField(response, r'''$.Message''') ??
        getJsonField(response, r'''$.message'''),
      );
}

class UpgradetotierthreeCall {
  static Map<String, dynamic>? lastCallRequestBody;
  static ApiCallResponse? lastCallResponse;
  static String? lastCallResponseBody;
  static String? lastCallError;
  static DateTime? lastCallTimestamp;
  static int? lastCallStatusCode;

  /// Sanitizes and extracts a concise, compliant landmark for KYC/banking APIs.
  /// Strict maximum of 60 characters to prevent API rejection when users or UI
  /// pass full address route descriptions or duplicate narratives.
  static String sanitizeLandmark(String? raw) {
    if (raw == null) return '';
    var text = raw.trim();
    if (text.isEmpty) return '';

    // 1. If text starts with a route phrase (e.g. "Starting from ..."), extract the landmark entity
    final startingFromMatch = RegExp(
      r'^(?:Starting\s+from|From|Beginning\s+at)\s+([^,.;\n]+)',
      caseSensitive: false,
    ).firstMatch(text);
    if (startingFromMatch != null) {
      final extracted = startingFromMatch.group(1)?.trim() ?? '';
      if (extracted.isNotEmpty) {
        text = extracted;
      }
    } else {
      // 2. If it's a long narrative (> 60 chars), check if it references a prominent building/landmark
      if (text.length > 60) {
        final besideMatch = RegExp(
          r'(?:situated directly beside|situated in close proximity to|close proximity to|directly beside|opposite|beside|near)\s+([^,.;\n]+)',
          caseSensitive: false,
        ).firstMatch(text);
        if (besideMatch != null) {
          final extracted = besideMatch.group(1)?.trim() ?? '';
          if (extracted.isNotEmpty && extracted.length <= 60) {
            text = extracted;
          }
        }
      }
    }

    // 3. If text still has commas and is longer than 50 chars, take the first short phrase
    if (text.contains(',') && text.length > 50) {
      final firstPart = text.split(',').first.trim();
      if (firstPart.isNotEmpty) {
        text = firstPart;
      }
    }
    // 4. If text still has periods and is longer than 50 chars, take the first sentence
    if (text.contains('.') && text.length > 50) {
      final firstPart = text.split('.').first.trim();
      if (firstPart.isNotEmpty) {
        text = firstPart;
      }
    }

    // Clean any leading/trailing punctuation or non-alphanumeric noise
    text = text.replaceAll(RegExp(r'^[\s,.;:\-_/]+|[\s,.;:\-_/]+$'), '').trim();

    // 5. Strictly enforce length <= 60 chars (banking gateways typically max 50-100)
    if (text.length > 60) {
      final truncated = text.substring(0, 60);
      final lastSpace = truncated.lastIndexOf(' ');
      if (lastSpace > 20) {
        text = truncated.substring(0, lastSpace).trim();
      } else {
        text = truncated.trim();
      }
      text = text.replaceAll(RegExp(r'[\s,.;:\-_/]+$'), '').trim();
    }

    return text;
  }

  static Future<ApiCallResponse> call({
    String? accountNumber = '',
    FFUploadedFile? proofofaddress,
    FFUploadedFile? utilityBill,
    String? accessToken = '',
    String? bvn = '',
    String? nin = '',
    String? accountName = '',
    String? phoneNumber = '',
    String? email = '',
    String? idType = '1',
    String? idNumber = '',
    String? idIssueDate = '',
    String? idExpiryDate = '',
    String? houseNumber = '',
    String? streetName = '',
    String? city = '',
    String? state = '',
    String? localGovernment = '',
    String? pep = 'No',
    String? nearestLandmark = '',
    String? addressDescription = '',
    String? residentialDescription = '',
    FFUploadedFile? userPhoto,
    FFUploadedFile? idCardFront,
    FFUploadedFile? customerSignature,
    String? channelType = '',
    String? tier = '3',
  }) async {
    // Proof of address MUST be generated and provided — DO NOT bypass with utility bill
    if (proofofaddress == null ||
        proofofaddress.bytes == null ||
        proofofaddress.bytes!.isEmpty) {
      return const ApiCallResponse(
        {
          'Success': false,
          'Message':
              'Proof of address has not been generated. Please provide or generate proof of address to proceed.',
        },
        {},
        400,
      );
    }

    final resolvedProof = proofofaddress;
    final resolvedUtility = (utilityBill != null &&
            utilityBill.bytes != null &&
            utilityBill.bytes!.isNotEmpty)
        ? utilityBill
        : null;

    // Ensure proof of address is a valid image strictly <= 150 KB
    FFUploadedFile compressedProof = resolvedProof;
    if (ImageCompressService.isPdf(compressedProof.bytes, compressedProof.name)) {
      compressedProof = await ImageCompressService.convertPdfOrDocToJpeg(compressedProof);
    } else {
      compressedProof = await ImageCompressService.compressUploadedFile(
        compressedProof,
        maxSizeKB: 150,
        minSizeKB: 0,
        isProof: true,
      );
    }

    // Ensure utility bill is processed if provided (strictly <= 150 KB)
    FFUploadedFile? compressedUtility = resolvedUtility;
    if (compressedUtility != null &&
        compressedUtility.bytes != null &&
        compressedUtility.bytes!.isNotEmpty) {
      if (ImageCompressService.isPdf(compressedUtility.bytes, compressedUtility.name)) {
        compressedUtility = await ImageCompressService.convertPdfOrDocToJpeg(compressedUtility);
      } else {
        compressedUtility = await ImageCompressService.compressUploadedFile(
          compressedUtility,
          maxSizeKB: 150,
          minSizeKB: 0,
          isProof: true,
        );
      }
    }

    String validToken = (accessToken != null && accessToken.isNotEmpty)
        ? accessToken
        : (FFAppState().bsptoken.isNotEmpty
            ? FFAppState().bsptoken
            : FFAppState().streetauth);
    if (validToken.isEmpty) {
      final auth = await StreetauthCall.call(forceRefresh: true);
      final fresh = StreetauthCall.streettoken(auth.jsonBody);
      if (fresh != null && fresh.isNotEmpty) {
        validToken = fresh;
        FFAppState().bsptoken = fresh;
        FFAppState().streetauth = fresh;
      }
    }

    final effectiveAccountNo = (accountNumber != null && accountNumber.isNotEmpty)
        ? accountNumber
        : (FFAppState().accountno.isNotEmpty
            ? FFAppState().accountno
            : (FFAppState().walletid.isNotEmpty ? FFAppState().walletid : ''));

    final effectiveAccountName = (accountName != null && accountName.isNotEmpty)
        ? accountName
        : FFAppState().accountname;

    final effectivePhone = (phoneNumber != null && phoneNumber.isNotEmpty)
        ? phoneNumber
        : (FFAppState().phonenumber.isNotEmpty
            ? (FFAppState().phonenumber.startsWith('234')
                ? FFAppState().phonenumber
                : '234${FFAppState().phonenumber.replaceFirst(RegExp(r'^0'), '')}')
            : '');

    final effectiveEmail = (email != null && email.isNotEmpty)
        ? email
        : FFAppState().email;

    final effectiveIdType = (idType != null && idType.isNotEmpty) ? idType : '1';
    final effectiveIdNumber = (idNumber != null && idNumber.isNotEmpty)
        ? idNumber
        : ((nin != null && nin.isNotEmpty) ? nin : '');

    final targetTier = (tier != null && tier.isNotEmpty) ? tier : '3';

    // Resolve a concise nearestLandmark (sanitize to <= 60 chars, never narrative)
    final candidateLandmark = (nearestLandmark != null && nearestLandmark.trim().isNotEmpty)
        ? nearestLandmark.trim()
        : (FFAppState().userLandmark.isNotEmpty
            ? FFAppState().userLandmark
            : (FFAppState().userBusStop.isNotEmpty
                ? FFAppState().userBusStop
                : (FFAppState().userFillingStation.isNotEmpty
                    ? FFAppState().userFillingStation
                    : (FFAppState().userNearestBuilding.isNotEmpty
                        ? FFAppState().userNearestBuilding
                        : ''))));
    final sanitizedLandmark = sanitizeLandmark(candidateLandmark);

    final logParams = <String, dynamic>{
      'theKey': '10000',
      'tier': targetTier,
      'accountNumber': effectiveAccountNo,
      'bvn': bvn,
      'nin': nin,
      'idType': effectiveIdType,
      'idNumber': effectiveIdNumber,
      'accountName': effectiveAccountName,
      'phoneNumber': effectivePhone,
      'email': effectiveEmail,
      'idIssueDate': idIssueDate,
      'idExpiryDate': idExpiryDate,
      'houseNumber': houseNumber,
      'streetName': streetName,
      'city': city,
      'state': state,
      'localGovernment': localGovernment,
      'pep': (pep != null && pep.isNotEmpty) ? pep : 'No',
      'nearestLandmark': sanitizedLandmark,
      'utilityBill': compressedUtility != null
          ? '[File: ${compressedUtility.name} (${compressedUtility.bytes?.length ?? 0} bytes)]'
          : null,
      'proofOfAddressVerification': compressedProof != null
          ? '[File: ${compressedProof.name} (${compressedProof.bytes?.length ?? 0} bytes)]'
          : null,
      'userPhoto': userPhoto != null
          ? '[File: ${userPhoto.name} (${userPhoto.bytes?.length ?? 0} bytes)]'
          : null,
      'idCardFront': idCardFront != null
          ? '[File: ${idCardFront.name} (${idCardFront.bytes?.length ?? 0} bytes)]'
          : null,
      'customerSignature': customerSignature != null
          ? '[File: ${customerSignature.name} (${customerSignature.bytes?.length ?? 0} bytes)]'
          : null,
    };
    logUpgradeToDm(
      body: jsonEncode(logParams),
      accessToken: validToken,
      upgradeType: 'UPGRADE_TIER_3',
    );

    // Build strictly valid multipart form fields per Tier 3 specification
    final requestParams = <String, dynamic>{
      'theKey': '10000',
      'tier': targetTier,
      'accountNumber': effectiveAccountNo,
      'bvn': bvn ?? '',
      'nin': nin ?? '',
      'idType': effectiveIdType,
      'idNumber': effectiveIdNumber,
      'accountName': effectiveAccountName,
      'phoneNumber': effectivePhone,
      'email': effectiveEmail ?? '',
      'idIssueDate': idIssueDate ?? '',
      'idExpiryDate': idExpiryDate ?? '',
      'houseNumber': houseNumber ?? '',
      'streetName': streetName ?? '',
      'city': city ?? '',
      'state': state ?? '',
      'localGovernment': localGovernment ?? '',
      'pep': (pep != null && pep.isNotEmpty) ? pep : 'No',
      'nearestLandmark': sanitizedLandmark,
    };

    if (compressedProof != null) {
      requestParams['proofOfAddressVerification'] = compressedProof;
    }
    if (compressedUtility != null) {
      requestParams['utilityBill'] = compressedUtility;
    }
    if (userPhoto != null && userPhoto.bytes?.isNotEmpty == true) {
      requestParams['userPhoto'] = userPhoto;
    }
    if (idCardFront != null && idCardFront.bytes?.isNotEmpty == true) {
      requestParams['idCardFront'] = idCardFront;
    }
    if (customerSignature != null && customerSignature.bytes?.isNotEmpty == true) {
      requestParams['customerSignature'] = customerSignature;
    }

    final debugBody = Map<String, dynamic>.from(requestParams);
    if (compressedProof != null && compressedProof.bytes?.isNotEmpty == true) {
      debugBody['proofOfAddressVerification'] =
          '[File: ${compressedProof.name} (${((compressedProof.bytes?.length ?? 0) / 1024).toStringAsFixed(1)} KB)]';
    }
    if (compressedUtility != null && compressedUtility.bytes?.isNotEmpty == true) {
      debugBody['utilityBill'] =
          '[File: ${compressedUtility.name} (${((compressedUtility.bytes?.length ?? 0) / 1024).toStringAsFixed(1)} KB)]';
    }
    if (userPhoto != null && userPhoto.bytes?.isNotEmpty == true) {
      debugBody['userPhoto'] =
          '[File: ${userPhoto.name} (${((userPhoto.bytes?.length ?? 0) / 1024).toStringAsFixed(1)} KB)]';
    }
    if (idCardFront != null && idCardFront.bytes?.isNotEmpty == true) {
      debugBody['idCardFront'] =
          '[File: ${idCardFront.name} (${((idCardFront.bytes?.length ?? 0) / 1024).toStringAsFixed(1)} KB)]';
    }
    if (customerSignature != null && customerSignature.bytes?.isNotEmpty == true) {
      debugBody['customerSignature'] =
          '[File: ${customerSignature.name} (${((customerSignature.bytes?.length ?? 0) / 1024).toStringAsFixed(1)} KB)]';
    }
    debugBody.forEach((key, value) {
      if (value is FFUploadedFile) {
        debugBody[key] =
            '[File: ${value.name} (${((value.bytes?.length ?? 0) / 1024).toStringAsFixed(1)} KB)]';
      }
    });
    lastCallRequestBody = debugBody;
    lastCallTimestamp = DateTime.now();

    try {
      final res = await ApiManager.instance.makeApiCall(
        callName: 'upgradetotierthree',
        apiUrl: 'https://api.mypingapi.com/sp/myhandler',
        callType: ApiCallType.POST,
        headers: {
          'Authorization': 'Bearer ${validToken}',
        },
        params: requestParams,
        bodyType: BodyType.MULTIPART,
        returnBody: true,
        encodeBodyUtf8: false,
        decodeUtf8: false,
        cache: false,
        isStreamingApi: false,
        alwaysAllowBody: false,
      );
      lastCallResponse = res;
      lastCallStatusCode = res.statusCode;
      lastCallResponseBody = res.response?.body ??
          (res.jsonBody != null ? jsonEncode(res.jsonBody) : res.responseMessage);
      lastCallError = (res.isSuccessful || success(res.jsonBody) == true)
          ? null
          : (message(res.jsonBody) ?? (res.responseMessage.isNotEmpty ? res.responseMessage : 'HTTP ${res.statusCode}'));
      return res;
    } catch (e) {
      lastCallError = '$e';
      lastCallResponseBody = 'Exception: $e';
      rethrow;
    }
  }

  static bool? success(dynamic response) {
    final status = getJsonField(response, r'''$.Success''') ??
        getJsonField(response, r'''$.success''') ??
        getJsonField(response, r'''$.status''');
    if (status is bool) return status;
    if (status is String) {
      return status.toLowerCase() == 'true' || status.toLowerCase() == 'success';
    }
    return null;
  }

  static bool? status(dynamic response) => success(response);

  static String? message(dynamic response) {
    final msg = getJsonField(response, r'''$.Message''') ??
        getJsonField(response, r'''$.message''') ??
        getJsonField(response, r'''$.data.message''') ??
        getJsonField(response, r'''$.responseMessage''');
    if (msg != null) return msg.toString();
    return null;
  }
}

class WassopenCall {
  static Future<ApiCallResponse> call({
    String? accessToken = '',
    String? bvn = '',
    String? dob = '',
    int? gender,
    String? phone = '',
    String? lastname = '',
    String? othername = '',
    String? email = '',
    String? tracking = '',
  }) async {
    final ffApiRequestBody = '''
{
  "transactionTrackingRef": "${escapeStringForJson(tracking)}",
  "lastName": "${escapeStringForJson(lastname)}",
  "otherNames": "${escapeStringForJson(othername)}",
  "phoneNo": "${escapeStringForJson(phone)}",
  "gender": "${gender}",
  "dateOfBirth": "${escapeStringForJson(dob)}",
  "bvn": "${escapeStringForJson(bvn)}",
  "walletType": "INDIVIDUAL"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'wassopen',
      apiUrl: 'https://api.mypingapi.com/sp/myhandler/waas/api/v1/open_wallet',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static String? status(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.status''',
      ));
  static String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.message''',
      ));
  static String? accountname(dynamic response) =>
      castToType<String>(getJsonField(
        response,
        r'''$.data.fullName''',
      ));
  static String? accountno(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.accountNumber''',
      ));
  static String? custormerid(dynamic response) =>
      castToType<String>(getJsonField(
        response,
        r'''$.data.customerID''',
      ));
}

class ApiPagingParams {
  int nextPageNumber = 0;
  int numItems = 0;
  dynamic lastResponse;

  ApiPagingParams({
    required this.nextPageNumber,
    required this.numItems,
    required this.lastResponse,
  });

  @override
  String toString() =>
      'PagingParams(nextPageNumber: $nextPageNumber, numItems: $numItems, lastResponse: $lastResponse,)';
}

String _toEncodable(dynamic item) {
  return item;
}

String _serializeList(List? list) {
  list ??= <String>[];
  try {
    return json.encode(list, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("List serialization failed. Returning empty list.");
    }
    return '[]';
  }
}

String _serializeJson(dynamic jsonVar, [bool isList = false]) {
  jsonVar ??= (isList ? [] : {});
  try {
    return json.encode(jsonVar, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("Json serialization failed. Returning empty json.");
    }
    return isList ? '[]' : '{}';
  }
}

String? escapeStringForJson(String? input) {
  if (input == null) {
    return null;
  }
  return input
      .replaceAll('\\', '\\\\')
      .replaceAll('"', '\\"')
      .replaceAll('\n', '\\n')
      .replaceAll('\t', '\\t');
}
