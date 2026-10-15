// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class PhoneNumberAuthInfoStruct extends BaseStruct {
  PhoneNumberAuthInfoStruct({
    String? phoneNumber,
    String? pinCode,
  })  : _phoneNumber = phoneNumber,
        _pinCode = pinCode;

  // "phoneNumber" field.
  String? _phoneNumber;
  String get phoneNumber => _phoneNumber ?? '';
  set phoneNumber(String? val) => _phoneNumber = val;

  bool hasPhoneNumber() => _phoneNumber != null;

  // "pinCode" field.
  String? _pinCode;
  String get pinCode => _pinCode ?? '';
  set pinCode(String? val) => _pinCode = val;

  bool hasPinCode() => _pinCode != null;

  static PhoneNumberAuthInfoStruct fromMap(Map<String, dynamic> data) =>
      PhoneNumberAuthInfoStruct(
        phoneNumber: data['phoneNumber'] as String?,
        pinCode: data['pinCode'] as String?,
      );

  static PhoneNumberAuthInfoStruct? maybeFromMap(dynamic data) => data is Map
      ? PhoneNumberAuthInfoStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'phoneNumber': _phoneNumber,
        'pinCode': _pinCode,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'phoneNumber': serializeParam(
          _phoneNumber,
          ParamType.String,
        ),
        'pinCode': serializeParam(
          _pinCode,
          ParamType.String,
        ),
      }.withoutNulls;

  static PhoneNumberAuthInfoStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      PhoneNumberAuthInfoStruct(
        phoneNumber: deserializeParam(
          data['phoneNumber'],
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
  String toString() => 'PhoneNumberAuthInfoStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is PhoneNumberAuthInfoStruct &&
        phoneNumber == other.phoneNumber &&
        pinCode == other.pinCode;
  }

  @override
  int get hashCode => const ListEquality().hash([phoneNumber, pinCode]);
}

PhoneNumberAuthInfoStruct createPhoneNumberAuthInfoStruct({
  String? phoneNumber,
  String? pinCode,
}) =>
    PhoneNumberAuthInfoStruct(
      phoneNumber: phoneNumber,
      pinCode: pinCode,
    );
