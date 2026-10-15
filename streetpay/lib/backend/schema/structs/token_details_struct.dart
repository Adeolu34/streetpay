// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class TokenDetailsStruct extends BaseStruct {
  TokenDetailsStruct({
    String? accessToken,
    String? refreshToken,
    String? expiresIn,
    String? refresExpiresIn,
  })  : _accessToken = accessToken,
        _refreshToken = refreshToken,
        _expiresIn = expiresIn,
        _refresExpiresIn = refresExpiresIn;

  // "accessToken" field.
  String? _accessToken;
  String get accessToken => _accessToken ?? '';
  set accessToken(String? val) => _accessToken = val;

  bool hasAccessToken() => _accessToken != null;

  // "refreshToken" field.
  String? _refreshToken;
  String get refreshToken => _refreshToken ?? '';
  set refreshToken(String? val) => _refreshToken = val;

  bool hasRefreshToken() => _refreshToken != null;

  // "expiresIn" field.
  String? _expiresIn;
  String get expiresIn => _expiresIn ?? '';
  set expiresIn(String? val) => _expiresIn = val;

  bool hasExpiresIn() => _expiresIn != null;

  // "refresExpiresIn" field.
  String? _refresExpiresIn;
  String get refresExpiresIn => _refresExpiresIn ?? '';
  set refresExpiresIn(String? val) => _refresExpiresIn = val;

  bool hasRefresExpiresIn() => _refresExpiresIn != null;

  static TokenDetailsStruct fromMap(Map<String, dynamic> data) =>
      TokenDetailsStruct(
        accessToken: data['accessToken'] as String?,
        refreshToken: data['refreshToken'] as String?,
        expiresIn: data['expiresIn'] as String?,
        refresExpiresIn: data['refresExpiresIn'] as String?,
      );

  static TokenDetailsStruct? maybeFromMap(dynamic data) => data is Map
      ? TokenDetailsStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'accessToken': _accessToken,
        'refreshToken': _refreshToken,
        'expiresIn': _expiresIn,
        'refresExpiresIn': _refresExpiresIn,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'accessToken': serializeParam(
          _accessToken,
          ParamType.String,
        ),
        'refreshToken': serializeParam(
          _refreshToken,
          ParamType.String,
        ),
        'expiresIn': serializeParam(
          _expiresIn,
          ParamType.String,
        ),
        'refresExpiresIn': serializeParam(
          _refresExpiresIn,
          ParamType.String,
        ),
      }.withoutNulls;

  static TokenDetailsStruct fromSerializableMap(Map<String, dynamic> data) =>
      TokenDetailsStruct(
        accessToken: deserializeParam(
          data['accessToken'],
          ParamType.String,
          false,
        ),
        refreshToken: deserializeParam(
          data['refreshToken'],
          ParamType.String,
          false,
        ),
        expiresIn: deserializeParam(
          data['expiresIn'],
          ParamType.String,
          false,
        ),
        refresExpiresIn: deserializeParam(
          data['refresExpiresIn'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'TokenDetailsStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is TokenDetailsStruct &&
        accessToken == other.accessToken &&
        refreshToken == other.refreshToken &&
        expiresIn == other.expiresIn &&
        refresExpiresIn == other.refresExpiresIn;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([accessToken, refreshToken, expiresIn, refresExpiresIn]);
}

TokenDetailsStruct createTokenDetailsStruct({
  String? accessToken,
  String? refreshToken,
  String? expiresIn,
  String? refresExpiresIn,
}) =>
    TokenDetailsStruct(
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiresIn: expiresIn,
      refresExpiresIn: refresExpiresIn,
    );
