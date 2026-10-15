// ignore_for_file: constant_identifier_names, depend_on_referenced_packages, prefer_final_fields

import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:http/http.dart' as http;
import 'package:equatable/equatable.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime_type/mime_type.dart';
import 'package:flutter/foundation.dart';
import 'package:http/browser_client.dart'
    if (dart.library.io) 'browser_client_stub.dart';

import '/flutter_flow/uploaded_file.dart';
import '/services/image_compress_service.dart';

import 'get_streamed_response.dart';

enum ApiCallType {
  GET,
  POST,
  DELETE,
  PUT,
  PATCH,
}

enum BodyType {
  NONE,
  JSON,
  TEXT,
  X_WWW_FORM_URL_ENCODED,
  MULTIPART,
}

class ApiCallOptions extends Equatable {
  const ApiCallOptions({
    this.callName = '',
    required this.callType,
    required this.apiUrl,
    required this.headers,
    required this.params,
    this.bodyType,
    this.body,
    this.returnBody = true,
    this.encodeBodyUtf8 = false,
    this.decodeUtf8 = false,
    this.alwaysAllowBody = false,
    this.cache = false,
    this.isStreamingApi = false,
  });

  final String callName;
  final ApiCallType callType;
  final String apiUrl;
  final Map<String, dynamic> headers;
  final Map<String, dynamic> params;
  final BodyType? bodyType;
  final String? body;
  final bool returnBody;
  final bool encodeBodyUtf8;
  final bool decodeUtf8;
  final bool alwaysAllowBody;
  final bool cache;
  final bool isStreamingApi;

  /// Creates a new [ApiCallOptions] with optionally updated parameters.
  ///
  /// This helper function allows creating a copy of the current options while
  /// selectively modifying specific fields. Any parameter that is not provided
  /// will retain its original value from the current instance.
  ApiCallOptions copyWith({
    String? callName,
    ApiCallType? callType,
    String? apiUrl,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? params,
    BodyType? bodyType,
    String? body,
    bool? returnBody,
    bool? encodeBodyUtf8,
    bool? decodeUtf8,
    bool? alwaysAllowBody,
    bool? cache,
    bool? isStreamingApi,
  }) {
    return ApiCallOptions(
      callName: callName ?? this.callName,
      callType: callType ?? this.callType,
      apiUrl: apiUrl ?? this.apiUrl,
      headers: headers ?? _cloneMap(this.headers),
      params: params ?? _cloneMap(this.params),
      bodyType: bodyType ?? this.bodyType,
      body: body ?? this.body,
      returnBody: returnBody ?? this.returnBody,
      encodeBodyUtf8: encodeBodyUtf8 ?? this.encodeBodyUtf8,
      decodeUtf8: decodeUtf8 ?? this.decodeUtf8,
      alwaysAllowBody: alwaysAllowBody ?? this.alwaysAllowBody,
      cache: cache ?? this.cache,
      isStreamingApi: isStreamingApi ?? this.isStreamingApi,
    );
  }

  ApiCallOptions clone() => ApiCallOptions(
        callName: callName,
        callType: callType,
        apiUrl: apiUrl,
        headers: _cloneMap(headers),
        params: _cloneMap(params),
        bodyType: bodyType,
        body: body,
        returnBody: returnBody,
        encodeBodyUtf8: encodeBodyUtf8,
        decodeUtf8: decodeUtf8,
        alwaysAllowBody: alwaysAllowBody,
        cache: cache,
        isStreamingApi: isStreamingApi,
      );

  @override
  List<Object?> get props => [
        callName,
        callType.name,
        apiUrl,
        headers,
        params,
        bodyType,
        body,
        returnBody,
        encodeBodyUtf8,
        decodeUtf8,
        alwaysAllowBody,
        cache,
        isStreamingApi,
      ];

  static Map<String, dynamic> _cloneMap(Map<String, dynamic> map) {
    try {
      return json.decode(json.encode(map)) as Map<String, dynamic>;
    } catch (_) {
      return Map.from(map);
    }
  }
}

class ApiCallResponse {
  const ApiCallResponse(
    this.jsonBody,
    this.headers,
    this.statusCode, {
    this.response,
    this.streamedResponse,
    this.exception,
    this.requestOptions,
  });
  final dynamic jsonBody;
  final Map<String, String> headers;
  final int statusCode;
  final http.Response? response;
  final http.StreamedResponse? streamedResponse;
  final Object? exception;

  /// The original request options used to make the API call.
  /// Available in interceptor's onResponse callback to access request details
  /// like URL, HTTP method, headers, params, and request body.
  final ApiCallOptions? requestOptions;
  // Whether we received a 2xx status (which generally marks success).
  bool get succeeded => statusCode >= 200 && statusCode < 300;
  String getHeader(String headerName) => headers[headerName] ?? '';
  // Return the raw body from the response, or if this came from a cloud call
  // and the body is not a string, then the json encoded body.
  String get bodyText =>
      response?.body ??
      (jsonBody is String ? jsonBody as String : jsonEncode(jsonBody));
  String get exceptionMessage => exception.toString();

  /// Universal backend response message extractor.
  /// Handles: Message, message, error, Error, data.message, responseMessage, etc.
  /// Falls back to connection / timeout descriptions when network fails.
  String get responseMessage {
    if (jsonBody != null) {
      if (jsonBody is Map) {
        final map = jsonBody as Map;
        for (final k in [
          'Message',
          'message',
          'msg',
          'Msg',
          'error',
          'Error',
          'responseMessage',
          'statusDescription',
          'description',
          'details'
        ]) {
          final v = map[k];
          if (v != null && v.toString().trim().isNotEmpty) {
            return v.toString().trim();
          }
        }
        if (map['data'] is Map) {
          final dataMap = map['data'] as Map;
          for (final k in ['Message', 'message', 'msg', 'Msg', 'error', 'Error']) {
            final v = dataMap[k];
            if (v != null && v.toString().trim().isNotEmpty) {
              return v.toString().trim();
            }
          }
        }
        final statusVal = map['status'] ?? map['Status'];
        if (statusVal is String &&
            statusVal.trim().isNotEmpty &&
            statusVal.toLowerCase() != 'success' &&
            statusVal != '00' &&
            statusVal != '100') {
          return statusVal.trim();
        }
      } else if (jsonBody is String && (jsonBody as String).trim().isNotEmpty) {
        final str = (jsonBody as String).trim();
        if (str.startsWith('{') && str.endsWith('}')) {
          try {
            final decoded = jsonDecode(str);
            if (decoded is Map) {
              for (final k in ['Message', 'message', 'error', 'Error']) {
                if (decoded[k] != null && decoded[k].toString().trim().isNotEmpty) {
                  return decoded[k].toString().trim();
                }
              }
            }
          } catch (_) {}
        }
        return str;
      }
    }

    if (exception != null) {
      final excStr = exception.toString().toLowerCase();
      if (excStr.contains('socketexception') ||
          excStr.contains('connection refused') ||
          excStr.contains('network is unreachable') ||
          excStr.contains('failed host lookup')) {
        return 'Network connection error. Please check your internet connection.';
      }
      if (excStr.contains('timeoutexception') || excStr.contains('timed out')) {
        return 'Connection timed out. Please try again.';
      }
      return 'Request failed: $exception';
    }

    if (!succeeded) {
      return 'Server error ($statusCode). Please try again.';
    }

    return '';
  }

  /// Universal business logic success check.
  /// Validates both HTTP status and payload business flags:
  /// (IsValid, Success, success, status, IsActivated, etc.)
  bool get isSuccessful {
    if (!succeeded) return false;
    if (jsonBody == null) return false;

    if (jsonBody is Map) {
      final map = jsonBody as Map;

      // Explicit failure flags
      if (map['IsValid'] == false || map['isValid'] == false) return false;
      if (map['Success'] == false || map['success'] == false) return false;
      if (map['status'] == false || map['Status'] == false) return false;
      if (map['IsActivated'] == false) return false;

      final statusStr = (map['status'] ?? map['Status'])?.toString().toLowerCase().trim();
      if (statusStr == 'failed' || statusStr == 'error' || statusStr == 'false') return false;

      // Explicit success flags
      if (map['IsValid'] == true || map['isValid'] == true) return true;
      if (map['Success'] == true || map['success'] == true) return true;
      if (map['status'] == true || map['Status'] == true) return true;
      if (statusStr == 'success' ||
          statusStr == '00' ||
          statusStr == '100' ||
          statusStr == 'true' ||
          statusStr == 'completed') {
        return true;
      }
      if (map['IsActivated'] == true) return true;

      // Token or session-bearing responses without error flags
      if (map.containsKey('token') && map['token'] != null && map['token'].toString().isNotEmpty) {
        return true;
      }
      if (map.containsKey('SessionID') && map['SessionID'] != null) return true;
      if (map.containsKey('Profile') && map['Profile'] != null) return true;
    }

    return succeeded;
  }

  /// Creates a new [ApiCallResponse] with optionally updated parameters.
  ///
  /// This helper function allows creating a copy of the current response while
  /// selectively modifying specific fields. Any parameter that is not provided
  /// will retain its original value from the current instance.
  ApiCallResponse copyWith({
    dynamic jsonBody,
    Map<String, String>? headers,
    int? statusCode,
    http.Response? response,
    http.StreamedResponse? streamedResponse,
    Object? exception,
    ApiCallOptions? requestOptions,
  }) {
    return ApiCallResponse(
      jsonBody ?? this.jsonBody,
      headers ?? this.headers,
      statusCode ?? this.statusCode,
      response: response ?? this.response,
      streamedResponse: streamedResponse ?? this.streamedResponse,
      exception: exception ?? this.exception,
      requestOptions: requestOptions ?? this.requestOptions,
    );
  }

  static ApiCallResponse fromHttpResponse(
    http.Response response,
    bool returnBody,
    bool decodeUtf8,
  ) {
    dynamic jsonBody;
    try {
      final responseBody = decodeUtf8 && returnBody
          ? const Utf8Decoder().convert(response.bodyBytes)
          : response.body;
      jsonBody = returnBody ? json.decode(responseBody) : null;
    } catch (_) {}
    return ApiCallResponse(
      jsonBody,
      response.headers,
      response.statusCode,
      response: response,
    );
  }

  static ApiCallResponse fromCloudCallResponse(Map<String, dynamic> response) =>
      ApiCallResponse(
        response['body'],
        ApiManager.toStringMap(response['headers'] ?? {}),
        response['statusCode'] ?? 400,
      );
}

class _ResponseCacheEntry {
  final ApiCallResponse response;
  final DateTime timestamp;
  _ResponseCacheEntry(this.response, this.timestamp);
}

class ApiManager {
  ApiManager._();

  // Cache that will ensure identical calls are not repeatedly made.
  static Map<ApiCallOptions, ApiCallResponse> _apiCache = {};

  // In-flight deduplication: map canonical request key -> Future<ApiCallResponse>
  static final Map<String, Future<ApiCallResponse>> _inFlightRequests = {};

  // Short-lived and explicit response cache: canonical request key -> _ResponseCacheEntry
  static final Map<String, _ResponseCacheEntry> _responseCache = {};

  // Concurrency limiter: maximum active concurrent HTTP requests
  static const int _maxConcurrentHttpRequests = 6;
  static int _activeHttpRequests = 0;
  static final List<Completer<void>> _concurrencyQueue = [];

  // Circuit breaker / Rate limiter: track endpoint call timestamps to prevent runaway spam
  static final Map<String, List<int>> _endpointCallTimestamps = {};
  static const int _rateLimitWindowMs = 5000; // 5-second window
  static const int _maxCallsPerWindow = 15; // Max 15 calls per endpoint in 5 seconds
  static const int _cooldownDelayMs = 400; // Cooldown delay if approaching limit

  /// Canonical key for identifying duplicate or cacheable requests
  static String getRequestKey({
    required String callName,
    required ApiCallType callType,
    required String apiUrl,
    Map<String, dynamic> params = const {},
    String? body,
  }) {
    final queryStr = params.isNotEmpty ? asQueryParams(params) : '';
    final bodyStr = body ?? '';
    return '$callName:${callType.name}:$apiUrl:$queryStr:$bodyStr';
  }

  /// Endpoint key for rate limiting
  static String getEndpointKey(ApiCallType callType, String apiUrl) {
    return '${callType.name}:$apiUrl';
  }

  /// Acquire a slot in the concurrency limiter
  static Future<void> _acquireConcurrencySlot() async {
    if (_activeHttpRequests < _maxConcurrentHttpRequests) {
      _activeHttpRequests++;
      return;
    }
    final completer = Completer<void>();
    _concurrencyQueue.add(completer);
    await completer.future;
  }

  /// Release a slot in the concurrency limiter
  static void _releaseConcurrencySlot() {
    if (_concurrencyQueue.isNotEmpty) {
      final next = _concurrencyQueue.removeAt(0);
      next.complete();
    } else {
      _activeHttpRequests =
          (_activeHttpRequests - 1).clamp(0, _maxConcurrentHttpRequests);
    }
  }

  /// Circuit breaker: inspect call rate for runaway loops.
  /// Returns a cached response if runaway loop is detected and cache is available,
  /// or delays execution to throttle the caller.
  static Future<ApiCallResponse?> _checkCircuitBreaker(
    String endpointKey,
    String requestKey,
  ) async {
    final nowMs = DateTime.now().millisecondsSinceEpoch;
    final timestamps =
        _endpointCallTimestamps.putIfAbsent(endpointKey, () => []);
    timestamps.removeWhere((t) => nowMs - t > _rateLimitWindowMs);
    timestamps.add(nowMs);

    if (timestamps.length > _maxCallsPerWindow) {
      final cached = _responseCache[requestKey];
      if (cached != null) {
        if (kDebugMode) {
          debugPrint(
            '[ApiManager] Circuit breaker: Throttling runaway calls to $endpointKey '
            '(${timestamps.length} calls in ${_rateLimitWindowMs}ms). Returning cached response.',
          );
        }
        return cached.response;
      }
      if (kDebugMode) {
        debugPrint(
          '[ApiManager] Circuit breaker: Throttling runaway calls to $endpointKey. Applying cooldown.',
        );
      }
      await Future.delayed(const Duration(milliseconds: _cooldownDelayMs));
    }
    return null;
  }

  static ApiManager? _instance;
  static ApiManager get instance => _instance ??= ApiManager._();

  /// Get HTTP client with optional credentials support for web
  ///
  /// Parameters:
  ///   - withCredentials: Whether to include credentials (cookies) with requests
  ///     Only applies to web platform (BrowserClient)
  ///     Default: false
  ///
  /// Returns a platform-specific HTTP client:
  ///   - Web: BrowserClient with credentials setting applied
  ///   - Mobile/Desktop: Standard http.Client
  static http.Client getClient({bool withCredentials = false}) {
    // For web platform, return BrowserClient with appropriate settings
    if (kIsWeb) {
      return BrowserClient()..withCredentials = withCredentials;
    }

    // For mobile/desktop, return standard http.Client
    // (credentials are handled differently on these platforms)
    return http.Client();
  }

  // If your API calls need authentication, populate this field once
  // the user has authenticated. Alter this as needed.
  static String? _accessToken;
  // You may want to call this if, for example, you make a change to the
  // database and no longer want the cached result of a call that may
  // have changed.
  static void clearCache(String callName) {
    _apiCache.keys
        .toSet()
        .forEach((k) => k.callName == callName ? _apiCache.remove(k) : null);
    _responseCache.removeWhere((k, _) => k.startsWith('$callName:'));
  }

  static Map<String, String> toStringMap(Map map) =>
      map.map((key, value) => MapEntry(key.toString(), value.toString()));

  static String asQueryParams(Map<String, dynamic> map) => map.entries
      .map((e) =>
          "${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value.toString())}")
      .join('&');

  static Future<ApiCallResponse> urlRequest(
    ApiCallType callType,
    String apiUrl,
    Map<String, dynamic> headers,
    Map<String, dynamic> params,
    bool returnBody,
    bool decodeUtf8,
    bool isStreamingApi, {
    http.Client? client,
  }) async {
    if (params.isNotEmpty) {
      final specifier =
          Uri.parse(apiUrl).queryParameters.isNotEmpty ? '&' : '?';
      apiUrl = '$apiUrl$specifier${asQueryParams(params)}';
    }
    if (isStreamingApi) {
      client ??= http.Client();
      final request =
          http.Request(callType.toString().split('.').last, Uri.parse(apiUrl))
            ..headers.addAll(toStringMap(headers));
      final streamedResponse = await getStreamedResponse(request);
      return ApiCallResponse(
        null,
        streamedResponse.headers,
        streamedResponse.statusCode,
        streamedResponse: streamedResponse,
      );
    }

    final makeRequest = callType == ApiCallType.GET
        ? (client != null ? client.get : http.get)
        : (client != null ? client.delete : http.delete);
    final response =
        await makeRequest(Uri.parse(apiUrl), headers: toStringMap(headers));
    return ApiCallResponse.fromHttpResponse(response, returnBody, decodeUtf8);
  }

  static Future<ApiCallResponse> requestWithBody(
    ApiCallType type,
    String apiUrl,
    Map<String, dynamic> headers,
    Map<String, dynamic> params,
    String? body,
    BodyType? bodyType,
    bool returnBody,
    bool encodeBodyUtf8,
    bool decodeUtf8,
    bool alwaysAllowBody,
    bool isStreamingApi, {
    http.Client? client,
  }) async {
    assert(
      {ApiCallType.POST, ApiCallType.PUT, ApiCallType.PATCH}.contains(type) ||
          (alwaysAllowBody && type == ApiCallType.DELETE),
      'Invalid ApiCallType $type for request with body',
    );
    final postBody =
        createBody(headers, params, body, bodyType, encodeBodyUtf8);
    if (isStreamingApi) {
      client ??= http.Client();
      final request =
          http.Request(type.toString().split('.').last, Uri.parse(apiUrl))
            ..headers.addAll(toStringMap(headers));
      request.body = postBody;
      final streamedResponse = await getStreamedResponse(request);
      return ApiCallResponse(
        null,
        streamedResponse.headers,
        streamedResponse.statusCode,
        streamedResponse: streamedResponse,
      );
    }

    if (bodyType == BodyType.MULTIPART) {
      return multipartRequest(type, apiUrl, headers, params, returnBody,
          decodeUtf8, alwaysAllowBody, client);
    }

    final requestFn = {
      ApiCallType.POST: client != null ? client.post : http.post,
      ApiCallType.PUT: client != null ? client.put : http.put,
      ApiCallType.PATCH: client != null ? client.patch : http.patch,
      ApiCallType.DELETE: client != null ? client.delete : http.delete,
    }[type]!;
    final response = await requestFn(Uri.parse(apiUrl),
        headers: toStringMap(headers), body: postBody);
    return ApiCallResponse.fromHttpResponse(response, returnBody, decodeUtf8);
  }

  static Future<ApiCallResponse> multipartRequest(
    ApiCallType? type,
    String apiUrl,
    Map<String, dynamic> headers,
    Map<String, dynamic> params,
    bool returnBody,
    bool decodeUtf8,
    bool alwaysAllowBody,
    http.Client? client,
  ) async {
    assert(
      {ApiCallType.POST, ApiCallType.PUT, ApiCallType.PATCH}.contains(type) ||
          (alwaysAllowBody && type == ApiCallType.DELETE),
      'Invalid ApiCallType $type for request with body',
    );

    bool isFile(dynamic e) =>
        e is FFUploadedFile ||
        e is List<FFUploadedFile> ||
        (e is List && e.firstOrNull is FFUploadedFile);

    final nonFileParams = toStringMap(
        Map.fromEntries(params.entries.where((e) =>
            !isFile(e.value) &&
            e.value != null &&
            e.value.toString() != 'null')));

    final files = <http.MultipartFile>[];
    for (var e in params.entries.where((e) => isFile(e.value))) {
      final param = e.value;
      if (param == null) continue;
      final uploadedFiles = param is List
          ? param.whereType<FFUploadedFile>().toList()
          : [param as FFUploadedFile];
      for (var uploadedFile in uploadedFiles) {
        if (uploadedFile.bytes == null || uploadedFile.bytes!.isEmpty) {
          continue;
        }
        var finalFile = uploadedFile;
        final isProofField = e.key == 'proofOfAddressVerification' ||
            e.key == 'proofofaddress' ||
            e.key == 'proofaddress';
        const maxAllowedKB = 150;
        const minAllowedKB = 100;
        final maxAllowedBytes = maxAllowedKB * 1024;

        if (ImageCompressService.isPdf(uploadedFile.bytes, uploadedFile.name)) {
          // Document MUST strictly be an image, NEVER a PDF!
          finalFile = await ImageCompressService.convertPdfOrDocToPng(
            uploadedFile,
            maxSizeKB: maxAllowedKB,
          );
        } else if (uploadedFile.bytes!.length > maxAllowedBytes) {
          // Only compress if the file exceeds the maximum allowed size
          finalFile = await ImageCompressService.compressUploadedFile(
            uploadedFile,
            maxSizeKB: maxAllowedKB,
            minSizeKB: isProofField ? 0 : minAllowedKB,
            isProof: isProofField,
          );
        }

        if (finalFile.bytes != null && finalFile.bytes!.length > maxAllowedBytes) {
          final clampedBytes = await ImageCompressService.compressImageBytes(
            finalFile.bytes!,
            maxSizeKB: maxAllowedKB,
            minSizeKB: 0,
          );
          if (clampedBytes.isNotEmpty && clampedBytes.length <= maxAllowedBytes) {
            finalFile = FFUploadedFile(
              name: finalFile.name,
              bytes: clampedBytes,
              originalFilename: finalFile.originalFilename,
            );
          }
        }

        String uploadName = (finalFile.name != null && finalFile.name!.isNotEmpty)
            ? finalFile.name!
            : (isProofField ? '${e.key}.jpg' : '${e.key}.jpg');
        MediaType? mediaType = _getMediaType(uploadName);
        if (ImageCompressService.isPng(finalFile.bytes) || uploadName.toLowerCase().endsWith('.png')) {
          mediaType = MediaType('image', 'png');
          if (!uploadName.toLowerCase().endsWith('.png')) {
            final dot = uploadName.lastIndexOf('.');
            uploadName = (dot != -1 ? uploadName.substring(0, dot) : uploadName) + '.png';
          }
        } else if (ImageCompressService.isJpeg(finalFile.bytes)) {
          mediaType = MediaType('image', 'jpeg');
          if (!uploadName.toLowerCase().endsWith('.jpg') && !uploadName.toLowerCase().endsWith('.jpeg')) {
            final dot = uploadName.lastIndexOf('.');
            uploadName = (dot != -1 ? uploadName.substring(0, dot) : uploadName) + '.jpg';
          }
        }

        files.add(http.MultipartFile.fromBytes(
          e.key,
          finalFile.bytes ?? Uint8List.fromList([]),
          filename: uploadName,
          contentType: mediaType,
        ));
      }
    }

    final request = http.MultipartRequest(
        type.toString().split('.').last, Uri.parse(apiUrl))
      ..headers.addAll(toStringMap(headers))
      ..files.addAll(files);
    nonFileParams.forEach((key, value) => request.fields[key] = value);

    final streamedResponse = await (client != null ? client.send(request) : request.send())
        .timeout(const Duration(seconds: 60));
    final response = await http.Response.fromStream(streamedResponse)
        .timeout(const Duration(seconds: 60));
    return ApiCallResponse.fromHttpResponse(response, returnBody, decodeUtf8);
  }

  static MediaType? _getMediaType(String? filename) {
    final contentType = mime(filename);
    if (contentType == null) {
      return null;
    }
    final parts = contentType.split('/');
    if (parts.length != 2) {
      return null;
    }
    return MediaType(parts.first, parts.last);
  }

  static dynamic createBody(
    Map<String, dynamic> headers,
    Map<String, dynamic>? params,
    String? body,
    BodyType? bodyType,
    bool encodeBodyUtf8,
  ) {
    String? contentType;
    dynamic postBody;
    switch (bodyType) {
      case BodyType.JSON:
        contentType = 'application/json';
        postBody = body ?? json.encode(params ?? {});
        break;
      case BodyType.TEXT:
        contentType = 'text/plain';
        postBody = body ?? json.encode(params ?? {});
        break;
      case BodyType.X_WWW_FORM_URL_ENCODED:
        contentType = 'application/x-www-form-urlencoded';
        postBody = toStringMap(params ?? {});
        break;
      case BodyType.MULTIPART:
        contentType = 'multipart/form-data';
        postBody = params;
        break;
      case BodyType.NONE:
      case null:
        break;
    }
    // Set "Content-Type" header if it was previously unset.
    if (contentType != null &&
        !headers.keys.any((h) => h.toLowerCase() == 'content-type')) {
      headers['Content-Type'] = contentType;
    }
    return encodeBodyUtf8 && postBody is String
        ? utf8.encode(postBody)
        : postBody;
  }

  Future<ApiCallResponse> call(
    ApiCallOptions options, {
    http.Client? client,
  }) =>
      makeApiCall(
        callName: options.callName,
        apiUrl: options.apiUrl,
        callType: options.callType,
        headers: options.headers,
        params: options.params,
        body: options.body,
        bodyType: options.bodyType,
        returnBody: options.returnBody,
        encodeBodyUtf8: options.encodeBodyUtf8,
        decodeUtf8: options.decodeUtf8,
        alwaysAllowBody: options.alwaysAllowBody,
        cache: options.cache,
        isStreamingApi: options.isStreamingApi,
        options: options,
        client: client,
      );

  Future<ApiCallResponse> makeApiCall({
    required String callName,
    required String apiUrl,
    required ApiCallType callType,
    Map<String, dynamic> headers = const {},
    Map<String, dynamic> params = const {},
    String? body,
    BodyType? bodyType,
    bool returnBody = true,
    bool encodeBodyUtf8 = false,
    bool decodeUtf8 = false,
    bool alwaysAllowBody = false,
    bool cache = false,
    bool isStreamingApi = false,
    ApiCallOptions? options,
    http.Client? client,
  }) async {
    final callOptions = options ??
        ApiCallOptions(
          callName: callName,
          callType: callType,
          apiUrl: apiUrl,
          headers: headers,
          params: params,
          bodyType: bodyType,
          body: body,
          returnBody: returnBody,
          encodeBodyUtf8: encodeBodyUtf8,
          decodeUtf8: decodeUtf8,
          alwaysAllowBody: alwaysAllowBody,
          cache: cache,
          isStreamingApi: isStreamingApi,
        );
    // Modify for your specific needs if this differs from your API.
    if (_accessToken != null) {
      headers[HttpHeaders.authorizationHeader] = 'Bearer $_accessToken';
    }
    if (!apiUrl.startsWith('http')) {
      apiUrl = 'https://$apiUrl';
    }

    final requestKey = getRequestKey(
      callName: callName,
      callType: callType,
      apiUrl: apiUrl,
      params: params,
      body: body,
    );

    // 1. Check local response cache (handles explicit cache and 2.5s micro-cache for read/auth requests)
    final now = DateTime.now();
    final cached = _responseCache[requestKey];
    if (cached != null) {
      final age = now.difference(cached.timestamp);
      final isMicroValid = (callType == ApiCallType.GET || callName == 'streetauth') &&
          age.inMilliseconds < 2500;
      if (cache || isMicroValid) {
        return cached.response;
      }
    }

    // Also check legacy _apiCache
    if (cache && _apiCache.containsKey(callOptions)) {
      return _apiCache[callOptions]!;
    }

    // 2. In-flight deduplication: if identical call is already active, return the existing future
    if (_inFlightRequests.containsKey(requestKey)) {
      return _inFlightRequests[requestKey]!;
    }

    // 3. Circuit breaker & runaway loop protector
    final endpointKey = getEndpointKey(callType, apiUrl);
    final circuitResponse = await _checkCircuitBreaker(endpointKey, requestKey);
    if (circuitResponse != null) {
      return circuitResponse;
    }

    // 4. Dispatch request guarded by concurrency limiter and in-flight tracking
    final callFuture = _executeApiCall(
      callName: callName,
      apiUrl: apiUrl,
      callType: callType,
      headers: headers,
      params: params,
      body: body,
      bodyType: bodyType,
      returnBody: returnBody,
      encodeBodyUtf8: encodeBodyUtf8,
      decodeUtf8: decodeUtf8,
      alwaysAllowBody: alwaysAllowBody,
      cache: cache,
      isStreamingApi: isStreamingApi,
      callOptions: callOptions,
      client: client,
      requestKey: requestKey,
    );

    _inFlightRequests[requestKey] = callFuture;
    return callFuture;
  }

  Future<ApiCallResponse> _executeApiCall({
    required String callName,
    required String apiUrl,
    required ApiCallType callType,
    required Map<String, dynamic> headers,
    required Map<String, dynamic> params,
    required String? body,
    required BodyType? bodyType,
    required bool returnBody,
    required bool encodeBodyUtf8,
    required bool decodeUtf8,
    required bool alwaysAllowBody,
    required bool cache,
    required bool isStreamingApi,
    required ApiCallOptions callOptions,
    required http.Client? client,
    required String requestKey,
  }) async {
    await _acquireConcurrencySlot();
    ApiCallResponse result;
    try {
      switch (callType) {
        case ApiCallType.GET:
          result = await urlRequest(
            callType,
            apiUrl,
            headers,
            params,
            returnBody,
            decodeUtf8,
            isStreamingApi,
            client: client,
          );
          break;
        case ApiCallType.DELETE:
          result = alwaysAllowBody
              ? await requestWithBody(
                  callType,
                  apiUrl,
                  headers,
                  params,
                  body,
                  bodyType,
                  returnBody,
                  encodeBodyUtf8,
                  decodeUtf8,
                  alwaysAllowBody,
                  isStreamingApi,
                  client: client,
                )
              : await urlRequest(
                  callType,
                  apiUrl,
                  headers,
                  params,
                  returnBody,
                  decodeUtf8,
                  isStreamingApi,
                  client: client,
                );
          break;
        case ApiCallType.POST:
        case ApiCallType.PUT:
        case ApiCallType.PATCH:
          result = await requestWithBody(
            callType,
            apiUrl,
            headers,
            params,
            body,
            bodyType,
            returnBody,
            encodeBodyUtf8,
            decodeUtf8,
            alwaysAllowBody,
            isStreamingApi,
            client: client,
          );
          break;
      }

      if (result.succeeded) {
        _responseCache[requestKey] =
            _ResponseCacheEntry(result, DateTime.now());
      }

      if (cache) {
        _apiCache[callOptions] = result;
      }
    } catch (e) {
      result = ApiCallResponse(null, {}, -1, exception: e);
    } finally {
      _releaseConcurrencySlot();
      _inFlightRequests.remove(requestKey);
    }

    return result;
  }
}
