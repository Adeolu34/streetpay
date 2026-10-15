// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class AccountOpeningInfoStruct extends BaseStruct {
  AccountOpeningInfoStruct({
    String? lastName,
    String? otherNames,
    String? phoneNo,
    int? gender,
    String? dateOfBirth,
    String? bvn,
    String? walletType,
    String? apistatus,
  })  : _lastName = lastName,
        _otherNames = otherNames,
        _phoneNo = phoneNo,
        _gender = gender,
        _dateOfBirth = dateOfBirth,
        _bvn = bvn,
        _walletType = walletType,
        _apistatus = apistatus;

  // "lastName" field.
  String? _lastName;
  String get lastName => _lastName ?? '';
  set lastName(String? val) => _lastName = val;

  bool hasLastName() => _lastName != null;

  // "otherNames" field.
  String? _otherNames;
  String get otherNames => _otherNames ?? '';
  set otherNames(String? val) => _otherNames = val;

  bool hasOtherNames() => _otherNames != null;

  // "phoneNo" field.
  String? _phoneNo;
  String get phoneNo => _phoneNo ?? '';
  set phoneNo(String? val) => _phoneNo = val;

  bool hasPhoneNo() => _phoneNo != null;

  // "gender" field.
  int? _gender;
  int get gender => _gender ?? 0;
  set gender(int? val) => _gender = val;

  void incrementGender(int amount) => gender = gender + amount;

  bool hasGender() => _gender != null;

  // "dateOfBirth" field.
  String? _dateOfBirth;
  String get dateOfBirth => _dateOfBirth ?? '';
  set dateOfBirth(String? val) => _dateOfBirth = val;

  bool hasDateOfBirth() => _dateOfBirth != null;

  // "bvn" field.
  String? _bvn;
  String get bvn => _bvn ?? '';
  set bvn(String? val) => _bvn = val;

  bool hasBvn() => _bvn != null;

  // "walletType" field.
  String? _walletType;
  String get walletType => _walletType ?? 'INDIVIDUAL';
  set walletType(String? val) => _walletType = val;

  bool hasWalletType() => _walletType != null;

  // "apistatus" field.
  String? _apistatus;
  String get apistatus => _apistatus ?? 'SUCCESS';
  set apistatus(String? val) => _apistatus = val;

  bool hasApistatus() => _apistatus != null;

  static AccountOpeningInfoStruct fromMap(Map<String, dynamic> data) =>
      AccountOpeningInfoStruct(
        lastName: data['lastName'] as String?,
        otherNames: data['otherNames'] as String?,
        phoneNo: data['phoneNo'] as String?,
        gender: castToType<int>(data['gender']),
        dateOfBirth: data['dateOfBirth'] as String?,
        bvn: data['bvn'] as String?,
        walletType: data['walletType'] as String?,
        apistatus: data['apistatus'] as String?,
      );

  static AccountOpeningInfoStruct? maybeFromMap(dynamic data) => data is Map
      ? AccountOpeningInfoStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'lastName': _lastName,
        'otherNames': _otherNames,
        'phoneNo': _phoneNo,
        'gender': _gender,
        'dateOfBirth': _dateOfBirth,
        'bvn': _bvn,
        'walletType': _walletType,
        'apistatus': _apistatus,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'lastName': serializeParam(
          _lastName,
          ParamType.String,
        ),
        'otherNames': serializeParam(
          _otherNames,
          ParamType.String,
        ),
        'phoneNo': serializeParam(
          _phoneNo,
          ParamType.String,
        ),
        'gender': serializeParam(
          _gender,
          ParamType.int,
        ),
        'dateOfBirth': serializeParam(
          _dateOfBirth,
          ParamType.String,
        ),
        'bvn': serializeParam(
          _bvn,
          ParamType.String,
        ),
        'walletType': serializeParam(
          _walletType,
          ParamType.String,
        ),
        'apistatus': serializeParam(
          _apistatus,
          ParamType.String,
        ),
      }.withoutNulls;

  static AccountOpeningInfoStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      AccountOpeningInfoStruct(
        lastName: deserializeParam(
          data['lastName'],
          ParamType.String,
          false,
        ),
        otherNames: deserializeParam(
          data['otherNames'],
          ParamType.String,
          false,
        ),
        phoneNo: deserializeParam(
          data['phoneNo'],
          ParamType.String,
          false,
        ),
        gender: deserializeParam(
          data['gender'],
          ParamType.int,
          false,
        ),
        dateOfBirth: deserializeParam(
          data['dateOfBirth'],
          ParamType.String,
          false,
        ),
        bvn: deserializeParam(
          data['bvn'],
          ParamType.String,
          false,
        ),
        walletType: deserializeParam(
          data['walletType'],
          ParamType.String,
          false,
        ),
        apistatus: deserializeParam(
          data['apistatus'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'AccountOpeningInfoStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is AccountOpeningInfoStruct &&
        lastName == other.lastName &&
        otherNames == other.otherNames &&
        phoneNo == other.phoneNo &&
        gender == other.gender &&
        dateOfBirth == other.dateOfBirth &&
        bvn == other.bvn &&
        walletType == other.walletType &&
        apistatus == other.apistatus;
  }

  @override
  int get hashCode => const ListEquality().hash([
        lastName,
        otherNames,
        phoneNo,
        gender,
        dateOfBirth,
        bvn,
        walletType,
        apistatus
      ]);
}

AccountOpeningInfoStruct createAccountOpeningInfoStruct({
  String? lastName,
  String? otherNames,
  String? phoneNo,
  int? gender,
  String? dateOfBirth,
  String? bvn,
  String? walletType,
  String? apistatus,
}) =>
    AccountOpeningInfoStruct(
      lastName: lastName,
      otherNames: otherNames,
      phoneNo: phoneNo,
      gender: gender,
      dateOfBirth: dateOfBirth,
      bvn: bvn,
      walletType: walletType,
      apistatus: apistatus,
    );
