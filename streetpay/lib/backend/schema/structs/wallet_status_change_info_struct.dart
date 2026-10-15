// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class WalletStatusChangeInfoStruct extends BaseStruct {
  WalletStatusChangeInfoStruct({
    String? accountNumber,
    String? accountStatus,
  })  : _accountNumber = accountNumber,
        _accountStatus = accountStatus;

  // "accountNumber" field.
  String? _accountNumber;
  String get accountNumber => _accountNumber ?? '';
  set accountNumber(String? val) => _accountNumber = val;

  bool hasAccountNumber() => _accountNumber != null;

  // "accountStatus" field.
  String? _accountStatus;
  String get accountStatus => _accountStatus ?? '';
  set accountStatus(String? val) => _accountStatus = val;

  bool hasAccountStatus() => _accountStatus != null;

  static WalletStatusChangeInfoStruct fromMap(Map<String, dynamic> data) =>
      WalletStatusChangeInfoStruct(
        accountNumber: data['accountNumber'] as String?,
        accountStatus: data['accountStatus'] as String?,
      );

  static WalletStatusChangeInfoStruct? maybeFromMap(dynamic data) => data is Map
      ? WalletStatusChangeInfoStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'accountNumber': _accountNumber,
        'accountStatus': _accountStatus,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'accountNumber': serializeParam(
          _accountNumber,
          ParamType.String,
        ),
        'accountStatus': serializeParam(
          _accountStatus,
          ParamType.String,
        ),
      }.withoutNulls;

  static WalletStatusChangeInfoStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      WalletStatusChangeInfoStruct(
        accountNumber: deserializeParam(
          data['accountNumber'],
          ParamType.String,
          false,
        ),
        accountStatus: deserializeParam(
          data['accountStatus'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'WalletStatusChangeInfoStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is WalletStatusChangeInfoStruct &&
        accountNumber == other.accountNumber &&
        accountStatus == other.accountStatus;
  }

  @override
  int get hashCode => const ListEquality().hash([accountNumber, accountStatus]);
}

WalletStatusChangeInfoStruct createWalletStatusChangeInfoStruct({
  String? accountNumber,
  String? accountStatus,
}) =>
    WalletStatusChangeInfoStruct(
      accountNumber: accountNumber,
      accountStatus: accountStatus,
    );
