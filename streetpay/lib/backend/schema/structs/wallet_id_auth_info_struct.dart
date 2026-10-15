// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class WalletIdAuthInfoStruct extends BaseStruct {
  WalletIdAuthInfoStruct({
    String? walletId,
    String? pinCode,
  })  : _walletId = walletId,
        _pinCode = pinCode;

  // "walletId" field.
  String? _walletId;
  String get walletId => _walletId ?? '';
  set walletId(String? val) => _walletId = val;

  bool hasWalletId() => _walletId != null;

  // "pinCode" field.
  String? _pinCode;
  String get pinCode => _pinCode ?? '';
  set pinCode(String? val) => _pinCode = val;

  bool hasPinCode() => _pinCode != null;

  static WalletIdAuthInfoStruct fromMap(Map<String, dynamic> data) =>
      WalletIdAuthInfoStruct(
        walletId: data['walletId'] as String?,
        pinCode: data['pinCode'] as String?,
      );

  static WalletIdAuthInfoStruct? maybeFromMap(dynamic data) => data is Map
      ? WalletIdAuthInfoStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'walletId': _walletId,
        'pinCode': _pinCode,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'walletId': serializeParam(
          _walletId,
          ParamType.String,
        ),
        'pinCode': serializeParam(
          _pinCode,
          ParamType.String,
        ),
      }.withoutNulls;

  static WalletIdAuthInfoStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      WalletIdAuthInfoStruct(
        walletId: deserializeParam(
          data['walletId'],
          ParamType.String,
          false,
        ),
        pinCode: deserializeParam(
          data['pinCode'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'WalletIdAuthInfoStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is WalletIdAuthInfoStruct &&
        walletId == other.walletId &&
        pinCode == other.pinCode;
  }

  @override
  int get hashCode => const ListEquality().hash([walletId, pinCode]);
}

WalletIdAuthInfoStruct createWalletIdAuthInfoStruct({
  String? walletId,
  String? pinCode,
}) =>
    WalletIdAuthInfoStruct(
      walletId: walletId,
      pinCode: pinCode,
    );
