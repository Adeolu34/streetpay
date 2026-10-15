// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class DatavalidityStruct extends BaseStruct {
  DatavalidityStruct({
    String? oneday,
  }) : _oneday = oneday;

  // "oneday" field.
  String? _oneday;
  String get oneday => _oneday ?? '1day';
  set oneday(String? val) => _oneday = val;

  bool hasOneday() => _oneday != null;

  static DatavalidityStruct fromMap(Map<String, dynamic> data) =>
      DatavalidityStruct(
        oneday: data['oneday'] as String?,
      );

  static DatavalidityStruct? maybeFromMap(dynamic data) => data is Map
      ? DatavalidityStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'oneday': _oneday,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'oneday': serializeParam(
          _oneday,
          ParamType.String,
        ),
      }.withoutNulls;

  static DatavalidityStruct fromSerializableMap(Map<String, dynamic> data) =>
      DatavalidityStruct(
        oneday: deserializeParam(
          data['oneday'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'DatavalidityStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is DatavalidityStruct && oneday == other.oneday;
  }

  @override
  int get hashCode => const ListEquality().hash([oneday]);
}

DatavalidityStruct createDatavalidityStruct({
  String? oneday,
}) =>
    DatavalidityStruct(
      oneday: oneday,
    );
