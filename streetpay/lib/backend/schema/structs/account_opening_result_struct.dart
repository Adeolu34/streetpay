// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class AccountOpeningResultStruct extends BaseStruct {
  AccountOpeningResultStruct({
    String? orderRef,
    String? customerID,
    String? fullName,
    String? accountNumber,
  })  : _orderRef = orderRef,
        _customerID = customerID,
        _fullName = fullName,
        _accountNumber = accountNumber;

  // "orderRef" field.
  String? _orderRef;
  String get orderRef => _orderRef ?? '';
  set orderRef(String? val) => _orderRef = val;

  bool hasOrderRef() => _orderRef != null;

  // "customerID" field.
  String? _customerID;
  String get customerID => _customerID ?? '';
  set customerID(String? val) => _customerID = val;

  bool hasCustomerID() => _customerID != null;

  // "fullName" field.
  String? _fullName;
  String get fullName => _fullName ?? '';
  set fullName(String? val) => _fullName = val;

  bool hasFullName() => _fullName != null;

  // "accountNumber" field.
  String? _accountNumber;
  String get accountNumber => _accountNumber ?? '';
  set accountNumber(String? val) => _accountNumber = val;

  bool hasAccountNumber() => _accountNumber != null;

  static AccountOpeningResultStruct fromMap(Map<String, dynamic> data) =>
      AccountOpeningResultStruct(
        orderRef: data['orderRef'] as String?,
        customerID: data['customerID'] as String?,
        fullName: data['fullName'] as String?,
        accountNumber: data['accountNumber'] as String?,
      );

  static AccountOpeningResultStruct? maybeFromMap(dynamic data) => data is Map
      ? AccountOpeningResultStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'orderRef': _orderRef,
        'customerID': _customerID,
        'fullName': _fullName,
        'accountNumber': _accountNumber,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'orderRef': serializeParam(
          _orderRef,
          ParamType.String,
        ),
        'customerID': serializeParam(
          _customerID,
          ParamType.String,
        ),
        'fullName': serializeParam(
          _fullName,
          ParamType.String,
        ),
        'accountNumber': serializeParam(
          _accountNumber,
          ParamType.String,
        ),
      }.withoutNulls;

  static AccountOpeningResultStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      AccountOpeningResultStruct(
        orderRef: deserializeParam(
          data['orderRef'],
          ParamType.String,
          false,
        ),
        customerID: deserializeParam(
          data['customerID'],
          ParamType.String,
          false,
        ),
        fullName: deserializeParam(
          data['fullName'],
          ParamType.String,
          false,
        ),
        accountNumber: deserializeParam(
          data['accountNumber'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'AccountOpeningResultStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is AccountOpeningResultStruct &&
        orderRef == other.orderRef &&
        customerID == other.customerID &&
        fullName == other.fullName &&
        accountNumber == other.accountNumber;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([orderRef, customerID, fullName, accountNumber]);
}

AccountOpeningResultStruct createAccountOpeningResultStruct({
  String? orderRef,
  String? customerID,
  String? fullName,
  String? accountNumber,
}) =>
    AccountOpeningResultStruct(
      orderRef: orderRef,
      customerID: customerID,
      fullName: fullName,
      accountNumber: accountNumber,
    );
