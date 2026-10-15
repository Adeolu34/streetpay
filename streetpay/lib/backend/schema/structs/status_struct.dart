// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class StatusStruct extends BaseStruct {
  StatusStruct({
    String? failed,
    String? success,
  })  : _failed = failed,
        _success = success;

  // "Failed" field.
  String? _failed;
  String get failed => _failed ?? 'FAILED';
  set failed(String? val) => _failed = val;

  bool hasFailed() => _failed != null;

  // "SUCCESS" field.
  String? _success;
  String get success => _success ?? 'SUCCESS';
  set success(String? val) => _success = val;

  bool hasSuccess() => _success != null;

  static StatusStruct fromMap(Map<String, dynamic> data) => StatusStruct(
        failed: data['Failed'] as String?,
        success: data['SUCCESS'] as String?,
      );

  static StatusStruct? maybeFromMap(dynamic data) =>
      data is Map ? StatusStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'Failed': _failed,
        'SUCCESS': _success,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'Failed': serializeParam(
          _failed,
          ParamType.String,
        ),
        'SUCCESS': serializeParam(
          _success,
          ParamType.String,
        ),
      }.withoutNulls;

  static StatusStruct fromSerializableMap(Map<String, dynamic> data) =>
      StatusStruct(
        failed: deserializeParam(
          data['Failed'],
          ParamType.String,
          false,
        ),
        success: deserializeParam(
          data['SUCCESS'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'StatusStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is StatusStruct &&
        failed == other.failed &&
        success == other.success;
  }

  @override
  int get hashCode => const ListEquality().hash([failed, success]);
}

StatusStruct createStatusStruct({
  String? failed,
  String? success,
}) =>
    StatusStruct(
      failed: failed,
      success: success,
    );
