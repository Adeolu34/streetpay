// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class WalletAccountStruct extends BaseStruct {
  WalletAccountStruct({
    String? bvn,
    String? nuban,
    String? phoneNo,
    String? tier,
    String? status,
    String? name,
    String? pndstatus,
    String? lienStatus,
    String? freezeStatus,
    double? availableBalance,
    double? maximumBalance,
    double? ledgerBalance,
    String? number,
  })  : _bvn = bvn,
        _nuban = nuban,
        _phoneNo = phoneNo,
        _tier = tier,
        _status = status,
        _name = name,
        _pndstatus = pndstatus,
        _lienStatus = lienStatus,
        _freezeStatus = freezeStatus,
        _availableBalance = availableBalance,
        _maximumBalance = maximumBalance,
        _ledgerBalance = ledgerBalance,
        _number = number;

  // "bvn" field.
  String? _bvn;
  String get bvn => _bvn ?? '';
  set bvn(String? val) => _bvn = val;

  bool hasBvn() => _bvn != null;

  // "nuban" field.
  String? _nuban;
  String get nuban => _nuban ?? '';
  set nuban(String? val) => _nuban = val;

  bool hasNuban() => _nuban != null;

  // "phoneNo" field.
  String? _phoneNo;
  String get phoneNo => _phoneNo ?? '';
  set phoneNo(String? val) => _phoneNo = val;

  bool hasPhoneNo() => _phoneNo != null;

  // "tier" field.
  String? _tier;
  String get tier => _tier ?? '';
  set tier(String? val) => _tier = val;

  bool hasTier() => _tier != null;

  // "status" field.
  String? _status;
  String get status => _status ?? '';
  set status(String? val) => _status = val;

  bool hasStatus() => _status != null;

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  set name(String? val) => _name = val;

  bool hasName() => _name != null;

  // "pndstatus" field.
  String? _pndstatus;
  String get pndstatus => _pndstatus ?? '';
  set pndstatus(String? val) => _pndstatus = val;

  bool hasPndstatus() => _pndstatus != null;

  // "lienStatus" field.
  String? _lienStatus;
  String get lienStatus => _lienStatus ?? '';
  set lienStatus(String? val) => _lienStatus = val;

  bool hasLienStatus() => _lienStatus != null;

  // "freezeStatus" field.
  String? _freezeStatus;
  String get freezeStatus => _freezeStatus ?? '';
  set freezeStatus(String? val) => _freezeStatus = val;

  bool hasFreezeStatus() => _freezeStatus != null;

  // "availableBalance" field.
  double? _availableBalance;
  double get availableBalance => _availableBalance ?? 0.0;
  set availableBalance(double? val) => _availableBalance = val;

  void incrementAvailableBalance(double amount) =>
      availableBalance = availableBalance + amount;

  bool hasAvailableBalance() => _availableBalance != null;

  // "maximumBalance" field.
  double? _maximumBalance;
  double get maximumBalance => _maximumBalance ?? 0.0;
  set maximumBalance(double? val) => _maximumBalance = val;

  void incrementMaximumBalance(double amount) =>
      maximumBalance = maximumBalance + amount;

  bool hasMaximumBalance() => _maximumBalance != null;

  // "ledgerBalance" field.
  double? _ledgerBalance;
  double get ledgerBalance => _ledgerBalance ?? 0.0;
  set ledgerBalance(double? val) => _ledgerBalance = val;

  void incrementLedgerBalance(double amount) =>
      ledgerBalance = ledgerBalance + amount;

  bool hasLedgerBalance() => _ledgerBalance != null;

  // "number" field.
  String? _number;
  String get number => _number ?? '';
  set number(String? val) => _number = val;

  bool hasNumber() => _number != null;

  static WalletAccountStruct fromMap(Map<String, dynamic> data) =>
      WalletAccountStruct(
        bvn: data['bvn'] as String?,
        nuban: data['nuban'] as String?,
        phoneNo: data['phoneNo'] as String?,
        tier: data['tier'] as String?,
        status: data['status'] as String?,
        name: data['name'] as String?,
        pndstatus: data['pndstatus'] as String?,
        lienStatus: data['lienStatus'] as String?,
        freezeStatus: data['freezeStatus'] as String?,
        availableBalance: castToType<double>(data['availableBalance']),
        maximumBalance: castToType<double>(data['maximumBalance']),
        ledgerBalance: castToType<double>(data['ledgerBalance']),
        number: data['number'] as String?,
      );

  static WalletAccountStruct? maybeFromMap(dynamic data) => data is Map
      ? WalletAccountStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'bvn': _bvn,
        'nuban': _nuban,
        'phoneNo': _phoneNo,
        'tier': _tier,
        'status': _status,
        'name': _name,
        'pndstatus': _pndstatus,
        'lienStatus': _lienStatus,
        'freezeStatus': _freezeStatus,
        'availableBalance': _availableBalance,
        'maximumBalance': _maximumBalance,
        'ledgerBalance': _ledgerBalance,
        'number': _number,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'bvn': serializeParam(
          _bvn,
          ParamType.String,
        ),
        'nuban': serializeParam(
          _nuban,
          ParamType.String,
        ),
        'phoneNo': serializeParam(
          _phoneNo,
          ParamType.String,
        ),
        'tier': serializeParam(
          _tier,
          ParamType.String,
        ),
        'status': serializeParam(
          _status,
          ParamType.String,
        ),
        'name': serializeParam(
          _name,
          ParamType.String,
        ),
        'pndstatus': serializeParam(
          _pndstatus,
          ParamType.String,
        ),
        'lienStatus': serializeParam(
          _lienStatus,
          ParamType.String,
        ),
        'freezeStatus': serializeParam(
          _freezeStatus,
          ParamType.String,
        ),
        'availableBalance': serializeParam(
          _availableBalance,
          ParamType.double,
        ),
        'maximumBalance': serializeParam(
          _maximumBalance,
          ParamType.double,
        ),
        'ledgerBalance': serializeParam(
          _ledgerBalance,
          ParamType.double,
        ),
        'number': serializeParam(
          _number,
          ParamType.String,
        ),
      }.withoutNulls;

  static WalletAccountStruct fromSerializableMap(Map<String, dynamic> data) =>
      WalletAccountStruct(
        bvn: deserializeParam(
          data['bvn'],
          ParamType.String,
          false,
        ),
        nuban: deserializeParam(
          data['nuban'],
          ParamType.String,
          false,
        ),
        phoneNo: deserializeParam(
          data['phoneNo'],
          ParamType.String,
          false,
        ),
        tier: deserializeParam(
          data['tier'],
          ParamType.String,
          false,
        ),
        status: deserializeParam(
          data['status'],
          ParamType.String,
          false,
        ),
        name: deserializeParam(
          data['name'],
          ParamType.String,
          false,
        ),
        pndstatus: deserializeParam(
          data['pndstatus'],
          ParamType.String,
          false,
        ),
        lienStatus: deserializeParam(
          data['lienStatus'],
          ParamType.String,
          false,
        ),
        freezeStatus: deserializeParam(
          data['freezeStatus'],
          ParamType.String,
          false,
        ),
        availableBalance: deserializeParam(
          data['availableBalance'],
          ParamType.double,
          false,
        ),
        maximumBalance: deserializeParam(
          data['maximumBalance'],
          ParamType.double,
          false,
        ),
        ledgerBalance: deserializeParam(
          data['ledgerBalance'],
          ParamType.double,
          false,
        ),
        number: deserializeParam(
          data['number'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'WalletAccountStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is WalletAccountStruct &&
        bvn == other.bvn &&
        nuban == other.nuban &&
        phoneNo == other.phoneNo &&
        tier == other.tier &&
        status == other.status &&
        name == other.name &&
        pndstatus == other.pndstatus &&
        lienStatus == other.lienStatus &&
        freezeStatus == other.freezeStatus &&
        availableBalance == other.availableBalance &&
        maximumBalance == other.maximumBalance &&
        ledgerBalance == other.ledgerBalance &&
        number == other.number;
  }

  @override
  int get hashCode => const ListEquality().hash([
        bvn,
        nuban,
        phoneNo,
        tier,
        status,
        name,
        pndstatus,
        lienStatus,
        freezeStatus,
        availableBalance,
        maximumBalance,
        ledgerBalance,
        number
      ]);
}

WalletAccountStruct createWalletAccountStruct({
  String? bvn,
  String? nuban,
  String? phoneNo,
  String? tier,
  String? status,
  String? name,
  String? pndstatus,
  String? lienStatus,
  String? freezeStatus,
  double? availableBalance,
  double? maximumBalance,
  double? ledgerBalance,
  String? number,
}) =>
    WalletAccountStruct(
      bvn: bvn,
      nuban: nuban,
      phoneNo: phoneNo,
      tier: tier,
      status: status,
      name: name,
      pndstatus: pndstatus,
      lienStatus: lienStatus,
      freezeStatus: freezeStatus,
      availableBalance: availableBalance,
      maximumBalance: maximumBalance,
      ledgerBalance: ledgerBalance,
      number: number,
    );
