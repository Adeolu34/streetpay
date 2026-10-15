// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class TokenStruct extends BaseStruct {
  TokenStruct({
    String? accessToken,
  }) : _accessToken = accessToken;

  // "accessToken" field.
  String? _accessToken;
  String get accessToken => _accessToken ?? '';
  set accessToken(String? val) => _accessToken = val;

  bool hasAccessToken() => _accessToken != null;

  static TokenStruct fromMap(Map<String, dynamic> data) => TokenStruct(
        accessToken: data['accessToken'] as String?,
      );

  static TokenStruct? maybeFromMap(dynamic data) =>
      data is Map ? TokenStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'accessToken': _accessToken,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'accessToken': serializeParam(
          _accessToken,
          ParamType.String,
        ),
      }.withoutNulls;

  static TokenStruct fromSerializableMap(Map<String, dynamic> data) =>
      TokenStruct(
        accessToken: deserializeParam(
          data['accessToken'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'TokenStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is TokenStruct && accessToken == other.accessToken;
  }

  @override
  int get hashCode => const ListEquality().hash([accessToken]);
}

TokenStruct createTokenStruct({
  String? accessToken,
}) =>
    TokenStruct(
      accessToken: accessToken,
    );
