// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class TransactionStatusStruct extends BaseStruct {
  TransactionStatusStruct({
    String? transactionReference,
    String? status,
  })  : _transactionReference = transactionReference,
        _status = status;

  // "transactionReference" field.
  String? _transactionReference;
  String get transactionReference => _transactionReference ?? '';
  set transactionReference(String? val) => _transactionReference = val;

  bool hasTransactionReference() => _transactionReference != null;

  // "status" field.
  String? _status;
  String get status => _status ?? '';
  set status(String? val) => _status = val;

  bool hasStatus() => _status != null;

  static TransactionStatusStruct fromMap(Map<String, dynamic> data) =>
      TransactionStatusStruct(
        transactionReference: data['transactionReference'] as String?,
        status: data['status'] as String?,
      );

  static TransactionStatusStruct? maybeFromMap(dynamic data) => data is Map
      ? TransactionStatusStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'transactionReference': _transactionReference,
        'status': _status,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'transactionReference': serializeParam(
          _transactionReference,
          ParamType.String,
        ),
        'status': serializeParam(
          _status,
          ParamType.String,
        ),
      }.withoutNulls;

  static TransactionStatusStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      TransactionStatusStruct(
        transactionReference: deserializeParam(
          data['transactionReference'],
          ParamType.String,
          false,
        ),
        status: deserializeParam(
          data['status'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'TransactionStatusStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is TransactionStatusStruct &&
        transactionReference == other.transactionReference &&
        status == other.status;
  }

  @override
  int get hashCode => const ListEquality().hash([transactionReference, status]);
}

TransactionStatusStruct createTransactionStatusStruct({
  String? transactionReference,
  String? status,
}) =>
    TransactionStatusStruct(
      transactionReference: transactionReference,
      status: status,
    );
