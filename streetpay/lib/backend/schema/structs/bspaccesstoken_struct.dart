// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class BspaccesstokenStruct extends BaseStruct {
  BspaccesstokenStruct({
    String? accesstoken,
  }) : _accesstoken = accesstoken;

  // "accesstoken" field.
  String? _accesstoken;
  String get accesstoken => _accesstoken ?? '';
  set accesstoken(String? val) => _accesstoken = val;

  bool hasAccesstoken() => _accesstoken != null;

  static BspaccesstokenStruct fromMap(Map<String, dynamic> data) =>
      BspaccesstokenStruct(
        accesstoken: data['accesstoken'] as String?,
      );

  static BspaccesstokenStruct? maybeFromMap(dynamic data) => data is Map
      ? BspaccesstokenStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'accesstoken': _accesstoken,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'accesstoken': serializeParam(
          _accesstoken,
          ParamType.String,
        ),
      }.withoutNulls;

  static BspaccesstokenStruct fromSerializableMap(Map<String, dynamic> data) =>
      BspaccesstokenStruct(
        accesstoken: deserializeParam(
          data['accesstoken'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'BspaccesstokenStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is BspaccesstokenStruct && accesstoken == other.accesstoken;
  }

  @override
  int get hashCode => const ListEquality().hash([accesstoken]);
}

BspaccesstokenStruct createBspaccesstokenStruct({
  String? accesstoken,
}) =>
    BspaccesstokenStruct(
      accesstoken: accesstoken,
    );
