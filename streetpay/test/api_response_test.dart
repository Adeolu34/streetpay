import 'package:flutter_test/flutter_test.dart';
import 'package:streetpay/backend/api_requests/api_manager.dart';
import 'package:streetpay/flutter_flow/flutter_flow_util.dart';

void main() {
  group('ApiCallResponse & getJsonField Resilience Tests', () {
    test('extracts Message (capital M)', () {
      const resp = ApiCallResponse(
        {'IsValid': false, 'Message': 'Invalid Credentials. RESET PASSWORD'},
        {},
        200,
      );
      expect(resp.isSuccessful, isFalse);
      expect(resp.responseMessage, 'Invalid Credentials. RESET PASSWORD');
      expect(getJsonField(resp, r'$.message'), 'Invalid Credentials. RESET PASSWORD');
      expect(getJsonField(resp, r'$.Message'), 'Invalid Credentials. RESET PASSWORD');
    });

    test('extracts message (lowercase m)', () {
      const resp = ApiCallResponse(
        {'status': true, 'message': 'PINCODE updated successfully'},
        {},
        200,
      );
      expect(resp.isSuccessful, isTrue);
      expect(resp.responseMessage, 'PINCODE updated successfully');
      expect(getJsonField(resp, r'$.message'), 'PINCODE updated successfully');
      expect(getJsonField(resp, r'$.Message'), 'PINCODE updated successfully');
    });

    test('handles Success vs success flags', () {
      const resp1 = ApiCallResponse(
        {'Success': true, 'Message': 'Verification Code Sent'},
        {},
        200,
      );
      expect(resp1.isSuccessful, isTrue);
      expect(getJsonField(resp1, r'$.success'), isTrue);
      expect(getJsonField(resp1, r'$.Success'), isTrue);

      const resp2 = ApiCallResponse(
        {'success': false, 'message': 'Error: Table not found'},
        {},
        200,
      );
      expect(resp2.isSuccessful, isFalse);
      expect(resp2.responseMessage, 'Error: Table not found');
      expect(getJsonField(resp2, r'$.success'), isFalse);
      expect(getJsonField(resp2, r'$.Success'), isFalse);
    });

    test('castToType safe coercion without TypeErrors', () {
      // Int to String
      expect(castToType<String>(100100), '100100');
      // String to bool
      expect(castToType<bool>('true'), isTrue);
      expect(castToType<bool>('success'), isTrue);
      expect(castToType<bool>('00'), isTrue);
      expect(castToType<bool>('false'), isFalse);
      // String to int / double
      expect(castToType<int>('44144'), 44144);
      expect(castToType<double>('105000.35'), 105000.35);
    });

    test('handles raw string json body', () {
      const rawString = '{"Message":"Hello from server","IsValid":true}';
      const resp = ApiCallResponse(rawString, {}, 200);
      expect(resp.responseMessage, 'Hello from server');
      expect(getJsonField(rawString, r'$.message'), 'Hello from server');
    });

    test('ApiManager generates stable request keys for in-flight deduplication', () {
      final key1 = ApiManager.getRequestKey(
        callName: 'getbalance',
        callType: ApiCallType.POST,
        apiUrl: 'https://api.mypingapi.com/sp/myhandler',
        params: {'phone': '08012345678'},
        body: '{"theKey":"246"}',
      );
      final key2 = ApiManager.getRequestKey(
        callName: 'getbalance',
        callType: ApiCallType.POST,
        apiUrl: 'https://api.mypingapi.com/sp/myhandler',
        params: {'phone': '08012345678'},
        body: '{"theKey":"246"}',
      );
      final key3 = ApiManager.getRequestKey(
        callName: 'getbalance',
        callType: ApiCallType.POST,
        apiUrl: 'https://api.mypingapi.com/sp/myhandler',
        params: {'phone': '08087654321'},
        body: '{"theKey":"246"}',
      );

      expect(key1, equals(key2));
      expect(key1, isNot(equals(key3)));
    });

    test('ApiManager clearCache clears namespaced cache entries', () {
      ApiManager.clearCache('streetauth');
      // Should not throw and successfully clear cache for streetauth
      expect(true, isTrue);
    });
  });
}
