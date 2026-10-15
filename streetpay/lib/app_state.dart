import 'package:flutter/material.dart';
import '/backend/schema/structs/index.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:csv/csv.dart';
import 'package:synchronized/synchronized.dart';
import 'flutter_flow/flutter_flow_util.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {
    secureStorage = FlutterSecureStorage();
  await Future.wait([
    _safeInitAsync(() async {
      _isRegistered =
          await secureStorage.getBool('ff_isRegistered') ?? _isRegistered;
    }),
    _safeInitAsync(() async {
      _isLoggedIn = await secureStorage.getBool('ff_isLoggedIn') ?? _isLoggedIn;
    }),
    _safeInitAsync(() async {
      _isPasswordReset =
          await secureStorage.getBool('ff_isPasswordReset') ?? _isPasswordReset;
    }),
    _safeInitAsync(() async {
      if (await secureStorage.read(key: 'ff_apiToken') != null) {
        try {
          final serializedData =
              await secureStorage.getString('ff_apiToken') ?? '{}';
          _apiToken = TokenDetailsStruct.fromSerializableMap(
              jsonDecode(serializedData));
        } catch (e) {
          debugPrint("Can't decode persisted data type: ${e.runtimeType}");
        }
      }
    }),
    _safeInitAsync(() async {
      _bspaccesstoken =
          await secureStorage.getString('ff_bspaccesstoken') ?? _bspaccesstoken;
    }),
    _safeInitAsync(() async {
      _apistatus = await secureStorage.getString('ff_apistatus') ?? _apistatus;
    }),
    _safeInitAsync(() async {
      _bsptoken = await secureStorage.getString('ff_bsptoken') ?? _bsptoken;
    }),
    _safeInitAsync(() async {
      _accountno = await secureStorage.getString('ff_accountno') ?? _accountno;
    }),
    _safeInitAsync(() async {
      _hidden = await secureStorage.getBool('ff_hidden') ?? _hidden;
    }),
    _safeInitAsync(() async {
      _show = await secureStorage.getBool('ff_show') ?? _show;
    }),
    _safeInitAsync(() async {
      _phonenumber =
          await secureStorage.getString('ff_phonenumber') ?? _phonenumber;
    }),
    _safeInitAsync(() async {
      _vasaccesstoken =
          await secureStorage.getString('ff_vasaccesstoken') ?? _vasaccesstoken;
    }),
    _safeInitAsync(() async {
      _accountname =
          await secureStorage.getString('ff_accountname') ?? _accountname;
    }),
    _safeInitAsync(() async {
      _listofaccounts =
          await secureStorage.getStringList('ff_listofaccounts') ??
              _listofaccounts;
    }),
    _safeInitAsync(() async {
      _biometric = await secureStorage.getBool('ff_biometric') ?? _biometric;
    }),
    _safeInitAsync(() async {
      _email = await secureStorage.getString('ff_email') ?? _email;
    }),
    _safeInitAsync(() async {
      _walletid = await secureStorage.getString('ff_walletid') ?? _walletid;
    }),
    _safeInitAsync(() async {
      _lotteryplan =
          await secureStorage.getStringList('ff_lotteryplan') ?? _lotteryplan;
    }),
    _safeInitAsync(() async {
      _lottohistroy =
          (await secureStorage.getStringList('ff_lottohistroy'))?.map((x) {
                try {
                  return jsonDecode(x);
                } catch (e) {
                  debugPrint("Can't decode persisted json: ${e.runtimeType}");
                  return {};
                }
              }).toList() ??
              _lottohistroy;
    }),
    _safeInitAsync(() async {
      _transactionhistory =
          (await secureStorage.getStringList('ff_transactionhistory'))
                  ?.map((x) {
                try {
                  return jsonDecode(x);
                } catch (e) {
                  debugPrint("Can't decode persisted json: ${e.runtimeType}");
                  return {};
                }
              }).toList() ??
              _transactionhistory;
    }),
    _safeInitAsync(() async {
      _lottoangle =
          await secureStorage.getStringList('ff_lottoangle') ?? _lottoangle;
    }),
    _safeInitAsync(() async {
      _autodiscovery =
          await secureStorage.getBool('ff_autodiscovery') ?? _autodiscovery;
    }),
    _safeInitAsync(() async {
      final cached = await secureStorage.getStringList('ff_electricbillerid');
      if (cached != null && cached.length > 3) {
        _electricbillerid = cached;
      }
    }),
    _safeInitAsync(() async {
      final cached = await secureStorage.getStringList('ff_bettingbillerid');
      if (cached != null && !cached.any((b) => b.contains('EDC') || b.contains('Electric'))) {
        _bettingbillerid = cached;
      }
    }),
    _safeInitAsync(() async {
      final cached = await secureStorage.getStringList('ff_cablebillerid');
      if (cached != null && !cached.any((b) => b.contains('EDC') || b.contains('Electric'))) {
        _cablebillerid = cached;
      }
    }),
    _safeInitAsync(() async {
      final cached = await secureStorage.getStringList('ff_exambillerid');
      if (cached != null && !cached.any((b) => b.contains('EDC') || b.contains('Electric'))) {
        _exambillerid = cached;
      }
    }),
    _safeInitAsync(() async {
      final cached = await secureStorage.getStringList('ff_internetbillerid');
      if (cached != null && !cached.any((b) => b.contains('EDC') || b.contains('Electric'))) {
        _internetbillerid = cached;
      }
    }),
    _safeInitAsync(() async {
      _progressvalue =
          await secureStorage.getDouble('ff_progressvalue') ?? _progressvalue;
    }),
    _safeInitAsync(() async {
      _avalbal = await secureStorage.getString('ff_avalbal') ?? _avalbal;
    }),
    _safeInitAsync(() async {
      _cableitemlist = await secureStorage.getStringList('ff_cableitemlist') ??
          _cableitemlist;
    }),
    _safeInitAsync(() async {
      _examinput =
          (await secureStorage.getStringList('ff_examinput'))?.map((x) {
                try {
                  return jsonDecode(x);
                } catch (e) {
                  debugPrint("Can't decode persisted json: ${e.runtimeType}");
                  return {};
                }
              }).toList() ??
              _examinput;
    }),
    _safeInitAsync(() async {
      _examitemlist =
          await secureStorage.getStringList('ff_examitemlist') ?? _examitemlist;
    }),
    _safeInitAsync(() async {
      if (await secureStorage.read(key: 'ff_mtnplans') != null) {
        try {
          _mtnplans =
              jsonDecode(await secureStorage.getString('ff_mtnplans') ?? '');
        } catch (e) {
          debugPrint("Can't decode persisted json: ${e.runtimeType}");
        }
      }
    }),
    _safeInitAsync(() async {
      if (await secureStorage.read(key: 'ff_gloplans') != null) {
        try {
          _gloplans =
              jsonDecode(await secureStorage.getString('ff_gloplans') ?? '');
        } catch (e) {
          debugPrint("Can't decode persisted json: ${e.runtimeType}");
        }
      }
    }),
    _safeInitAsync(() async {
      if (await secureStorage.read(key: 'ff_airtel') != null) {
        try {
          _airtel =
              jsonDecode(await secureStorage.getString('ff_airtel') ?? '');
        } catch (e) {
          debugPrint("Can't decode persisted json: ${e.runtimeType}");
        }
      }
    }),
    _safeInitAsync(() async {
      _dstvitemlist =
          await secureStorage.getStringList('ff_dstvitemlist') ?? _dstvitemlist;
    }),
    _safeInitAsync(() async {
      _gotvitemlist =
          await secureStorage.getStringList('ff_gotvitemlist') ?? _gotvitemlist;
    }),
    _safeInitAsync(() async {
      _showmaxitemlist =
          await secureStorage.getStringList('ff_showmaxitemlist') ??
              _showmaxitemlist;
    }),
    _safeInitAsync(() async {
      _startimes =
          await secureStorage.getStringList('ff_startimes') ?? _startimes;
    }),
    _safeInitAsync(() async {
      _mtndataplans =
          (await secureStorage.getStringList('ff_mtndataplans'))?.map((x) {
                try {
                  return jsonDecode(x);
                } catch (e) {
                  debugPrint("Can't decode persisted json: ${e.runtimeType}");
                  return {};
                }
              }).toList() ??
              _mtndataplans;
    }),
    _safeInitAsync(() async {
      _glodataplans =
          (await secureStorage.getStringList('ff_glodataplans'))?.map((x) {
                try {
                  return jsonDecode(x);
                } catch (e) {
                  debugPrint("Can't decode persisted json: ${e.runtimeType}");
                  return {};
                }
              }).toList() ??
              _glodataplans;
    }),
    _safeInitAsync(() async {
      _airteldataplans =
          (await secureStorage.getStringList('ff_airteldataplans'))?.map((x) {
                try {
                  return jsonDecode(x);
                } catch (e) {
                  debugPrint("Can't decode persisted json: ${e.runtimeType}");
                  return {};
                }
              }).toList() ??
              _airteldataplans;
    }),
    _safeInitAsync(() async {
      _jambitem = await secureStorage.getStringList('ff_jambitem') ?? _jambitem;
    }),
    _safeInitAsync(() async {
      _weacitem = await secureStorage.getStringList('ff_weacitem') ?? _weacitem;
    }),
    _safeInitAsync(() async {
      _bankname = await secureStorage.getStringList('ff_bankname') ?? _bankname;
    }),
    _safeInitAsync(() async {
      _jamblist = (await secureStorage.getStringList('ff_jamblist'))?.map((x) {
            try {
              return jsonDecode(x);
            } catch (e) {
              debugPrint("Can't decode persisted json: ${e.runtimeType}");
              return {};
            }
          }).toList() ??
          _jamblist;
    }),
    _safeInitAsync(() async {
      _weaclist = (await secureStorage.getStringList('ff_weaclist'))?.map((x) {
            try {
              return jsonDecode(x);
            } catch (e) {
              debugPrint("Can't decode persisted json: ${e.runtimeType}");
              return {};
            }
          }).toList() ??
          _weaclist;
    }),
    _safeInitAsync(() async {
      _jamb = (await secureStorage.getStringList('ff_jamb'))?.map((x) {
            try {
              return jsonDecode(x);
            } catch (e) {
              debugPrint("Can't decode persisted json: ${e.runtimeType}");
              return {};
            }
          }).toList() ??
          _jamb;
    }),
    _safeInitAsync(() async {
      _weacinput =
          await secureStorage.getStringList('ff_weacinput') ?? _weacinput;
    }),
    _safeInitAsync(() async {
      _waecdescription =
          await secureStorage.getStringList('ff_waecdescription') ??
              _waecdescription;
    }),
    _safeInitAsync(() async {
      _weacitems =
          await secureStorage.getStringList('ff_weacitems') ?? _weacitems;
    }),
    _safeInitAsync(() async {
      _jambinput =
          await secureStorage.getStringList('ff_jambinput') ?? _jambinput;
    }),
    _safeInitAsync(() async {
      _jambdescription =
          await secureStorage.getStringList('ff_jambdescription') ??
              _jambdescription;
    }),
    _safeInitAsync(() async {
      _jambitems =
          await secureStorage.getStringList('ff_jambitems') ?? _jambitems;
    }),
    _safeInitAsync(() async {
      _examprogress =
          await secureStorage.getDouble('ff_examprogress') ?? _examprogress;
    }),
    _safeInitAsync(() async {
      _internetitems = await secureStorage.getStringList('ff_internetitems') ??
          _internetitems;
    }),
    _safeInitAsync(() async {
      _pendinglist =
          await secureStorage.getInt('ff_pendinglist') ?? _pendinglist;
    }),
    _safeInitAsync(() async {
      _lottocode =
          await secureStorage.getStringList('ff_lottocode') ?? _lottocode;
    }),
    _safeInitAsync(() async {
      _SPECTRANETITEMS =
          await secureStorage.getStringList('ff_SPECTRANETITEMS') ??
              _SPECTRANETITEMS;
    }),
    _safeInitAsync(() async {
      _SMILEITEMS =
          await secureStorage.getStringList('ff_SMILEITEMS') ?? _SMILEITEMS;
    }),
    _safeInitAsync(() async {
      _winners = await secureStorage.getStringList('ff_winners') ?? _winners;
    }),
    _safeInitAsync(() async {
      _jobprofiles =
          (await secureStorage.getStringList('ff_jobprofiles'))?.map((x) {
                try {
                  return jsonDecode(x);
                } catch (e) {
                  debugPrint("Can't decode persisted json: ${e.runtimeType}");
                  return {};
                }
              }).toList() ??
              _jobprofiles;
    }),
    _safeInitAsync(() async {
      _listofjobphones =
          await secureStorage.getStringList('ff_listofjobphones') ??
              _listofjobphones;
    }),
    _safeInitAsync(() async {
      _securehistory =
          (await secureStorage.getStringList('ff_securehistory'))?.map((x) {
                try {
                  return jsonDecode(x);
                } catch (e) {
                  debugPrint("Can't decode persisted json: ${e.runtimeType}");
                  return {};
                }
              }).toList() ??
              _securehistory;
    }),
    _safeInitAsync(() async {
      _sessionid = await secureStorage.getString('ff_sessionid') ?? _sessionid;
    }),
    _safeInitAsync(() async {
      _pinphones =
          await secureStorage.getStringList('ff_pinphones') ?? _pinphones;
    }),
    _safeInitAsync(() async {
      _receivedbilled =
          (await secureStorage.getStringList('ff_receivedbilled'))?.map((x) {
                try {
                  return jsonDecode(x);
                } catch (e) {
                  debugPrint("Can't decode persisted json: ${e.runtimeType}");
                  return {};
                }
              }).toList() ??
              _receivedbilled;
    }),
    _safeInitAsync(() async {
      _sentbills =
          (await secureStorage.getStringList('ff_sentbills'))?.map((x) {
                try {
                  return jsonDecode(x);
                } catch (e) {
                  debugPrint("Can't decode persisted json: ${e.runtimeType}");
                  return {};
                }
              }).toList() ??
              _sentbills;
    }),
    _safeInitAsync(() async {
      _guestprofile =
          await secureStorage.getStringList('ff_guestprofile') ?? _guestprofile;
    }),
    _safeInitAsync(() async {
      _hostprofile =
          await secureStorage.getStringList('ff_hostprofile') ?? _hostprofile;
    }),
    _safeInitAsync(() async {
      if (await secureStorage.read(key: 'ff_allbankjson') != null) {
        try {
          _allbankjson =
              jsonDecode(await secureStorage.getString('ff_allbankjson') ?? '');
        } catch (e) {
          debugPrint("Can't decode persisted json: ${e.runtimeType}");
        }
      }
    }),
    _safeInitAsync(() async {
      _hidebal = await secureStorage.getBool('ff_hidebal') ?? _hidebal;
    }),
    _safeInitAsync(() async {
      _tempid = await secureStorage.getString('ff_tempid') ?? _tempid;
    }),
    _safeInitAsync(() async {
      _deviceid = await secureStorage.getString('ff_deviceid') ?? _deviceid;
    }),
    _safeInitAsync(() async {
      _news = await secureStorage.getString('ff_news') ?? _news;
    }),
    _safeInitAsync(() async {
      _cachedFcmToken =
          await secureStorage.getString('ff_cachedFcmToken') ?? _cachedFcmToken;
    }),
    _safeInitAsync(() async {
      _pendingRoute =
          await secureStorage.getString('ff_pendingRoute') ?? _pendingRoute;
    }),
    _safeInitAsync(() async {
      _pendingId = await secureStorage.getString('ff_pendingId') ?? _pendingId;
    }),
    _safeInitAsync(() async {
      _pendingNextPage = await secureStorage.getString('ff_pendingNextPage') ??
          _pendingNextPage;
    }),
    _safeInitAsync(() async {
      _whatsapp = await secureStorage.getString('ff_whatsapp') ?? _whatsapp;
    }),
    _safeInitAsync(() async {
      _password = await secureStorage.getString('ff_password') ?? _password;
    }),
    _safeInitAsync(() async {
      _updatereq = await secureStorage.getBool('ff_updatereq') ?? _updatereq;
    }),
    _safeInitAsync(() async {
      _signature = await secureStorage.getString('ff_signature') ?? _signature;
    }),
    _safeInitAsync(() async {
      _userState = await secureStorage.getString('ff_userState') ?? _userState;
    }),
    _safeInitAsync(() async {
      _userCity = await secureStorage.getString('ff_userCity') ?? _userCity;
    }),
    _safeInitAsync(() async {
      _userLGA = await secureStorage.getString('ff_userLGA') ?? _userLGA;
    }),
    _safeInitAsync(() async {
      _userStreet = await secureStorage.getString('ff_userStreet') ?? _userStreet;
    }),
    _safeInitAsync(() async {
      _userHouseNo = await secureStorage.getString('ff_userHouseNo') ?? _userHouseNo;
    }),
    _safeInitAsync(() async {
      _userLandmark = await secureStorage.getString('ff_userLandmark') ?? _userLandmark;
    }),
    _safeInitAsync(() async {
      _userLandmarkDesc = await secureStorage.getString('ff_userLandmarkDesc') ?? _userLandmarkDesc;
    }),
    _safeInitAsync(() async {
      _userBusStop = await secureStorage.getString('ff_userBusStop') ?? _userBusStop;
    }),
    _safeInitAsync(() async {
      _userFillingStation = await secureStorage.getString('ff_userFillingStation') ?? _userFillingStation;
    }),
    _safeInitAsync(() async {
      _userNearestBuilding = await secureStorage.getString('ff_userNearestBuilding') ?? _userNearestBuilding;
    }),
    _safeInitAsync(() async {
      _userHouseColor = await secureStorage.getString('ff_userHouseColor') ?? _userHouseColor;
    }),
    _safeInitAsync(() async {
      _userRouteDesc = await secureStorage.getString('ff_userRouteDesc') ?? _userRouteDesc;
    }),
    _safeInitAsync(() async {
      _userBVN = await secureStorage.getString('ff_userBVN') ?? _userBVN;
    }),
    _safeInitAsync(() async {
      _userNIN = await secureStorage.getString('ff_userNIN') ?? _userNIN;
    }),
    _safeInitAsync(() async {
      _userPEP = await secureStorage.getString('ff_userPEP') ?? _userPEP;
    }),
    _safeInitAsync(() async {
      _userIdType = await secureStorage.getString('ff_userIdType') ?? _userIdType;
    }),
    _safeInitAsync(() async {
      _userIdIssueDate = await secureStorage.getString('ff_userIdIssueDate') ?? _userIdIssueDate;
    }),
    _safeInitAsync(() async {
      _userGender = await secureStorage.getString('ff_userGender') ?? _userGender;
    }),
    _safeInitAsync(() async {
      _userDOB = await secureStorage.getString('ff_userDOB') ?? _userDOB;
    }),
    _safeInitAsync(() async {
      _nearbylist =
          (await secureStorage.getStringList('ff_nearbylist'))?.map((x) {
                try {
                  return jsonDecode(x);
                } catch (e) {
                  debugPrint("Can't decode persisted json: ${e.runtimeType}");
                  return {};
                }
              }).toList() ??
              _nearbylist;
    }),
    _safeInitAsync(() async {
      _discoverme = await secureStorage.getBool('ff_discoverme') ?? _discoverme;
    }),
    _safeInitAsync(() async {
      // Voice announcements are OFF by default unless explicitly activated by the user.
      final explicitlyActivated =
          await secureStorage.getBool('ff_voiceAnnouncementsActivated');
      if (explicitlyActivated == true) {
        _voiceAnnouncementsActivated = true;
        _disableVoiceBalance = false;
      } else {
        _voiceAnnouncementsActivated = false;
        _disableVoiceBalance = true;
      }
    }),
  ]);
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  bool _isRegistered = false;
  bool get isRegistered => _isRegistered;
  set isRegistered(bool value) {
    _isRegistered = value;
    secureStorage.setBool('ff_isRegistered', value);
  }

  void deleteIsRegistered() {
    secureStorage.delete(key: 'ff_isRegistered');
  }

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;
  set isLoggedIn(bool value) {
    _isLoggedIn = value;
    secureStorage.setBool('ff_isLoggedIn', value);
  }

  void deleteIsLoggedIn() {
    secureStorage.delete(key: 'ff_isLoggedIn');
  }

  bool _isPasswordReset = false;
  bool get isPasswordReset => _isPasswordReset;
  set isPasswordReset(bool value) {
    _isPasswordReset = value;
    secureStorage.setBool('ff_isPasswordReset', value);
  }

  void deleteIsPasswordReset() {
    secureStorage.delete(key: 'ff_isPasswordReset');
  }

  TokenDetailsStruct _apiToken = TokenDetailsStruct();
  TokenDetailsStruct get apiToken => _apiToken;
  set apiToken(TokenDetailsStruct value) {
    _apiToken = value;
    secureStorage.setString('ff_apiToken', value.serialize());
  }

  void deleteApiToken() {
    secureStorage.delete(key: 'ff_apiToken');
  }

  void updateApiTokenStruct(Function(TokenDetailsStruct) updateFn) {
    updateFn(_apiToken);
    secureStorage.setString('ff_apiToken', _apiToken.serialize());
  }

  WalletAccountStruct _walletAccount = WalletAccountStruct();
  WalletAccountStruct get walletAccount => _walletAccount;
  set walletAccount(WalletAccountStruct value) {
    _walletAccount = value;
  }

  void updateWalletAccountStruct(Function(WalletAccountStruct) updateFn) {
    updateFn(_walletAccount);
  }

  WalletIdAuthInfoStruct _userAuth = WalletIdAuthInfoStruct();
  WalletIdAuthInfoStruct get userAuth => _userAuth;
  set userAuth(WalletIdAuthInfoStruct value) {
    _userAuth = value;
  }

  void updateUserAuthStruct(Function(WalletIdAuthInfoStruct) updateFn) {
    updateFn(_userAuth);
  }

  bool _isAuthCalled = false;
  bool get isAuthCalled => _isAuthCalled;
  set isAuthCalled(bool value) {
    _isAuthCalled = value;
  }

  String _bspaccesstoken = '';
  String get bspaccesstoken => _bspaccesstoken;
  set bspaccesstoken(String value) {
    _bspaccesstoken = value;
    secureStorage.setString('ff_bspaccesstoken', value);
  }

  void deleteBspaccesstoken() {
    secureStorage.delete(key: 'ff_bspaccesstoken');
  }

  String _apistatus = 'SUCCESS';
  String get apistatus => _apistatus;
  set apistatus(String value) {
    _apistatus = value;
    secureStorage.setString('ff_apistatus', value);
  }

  void deleteApistatus() {
    secureStorage.delete(key: 'ff_apistatus');
  }

  String _bsptoken = '';
  String get bsptoken => _bsptoken;
  set bsptoken(String value) {
    _bsptoken = value;
    secureStorage.setString('ff_bsptoken', value);
  }

  void deleteBsptoken() {
    secureStorage.delete(key: 'ff_bsptoken');
  }

  String _accountno = '';
  String get accountno => _accountno;
  set accountno(String value) {
    _accountno = value;
    secureStorage.setString('ff_accountno', value);
  }

  void deleteAccountno() {
    secureStorage.delete(key: 'ff_accountno');
  }

  bool _hidden = false;
  bool get hidden => _hidden;
  set hidden(bool value) {
    _hidden = value;
    secureStorage.setBool('ff_hidden', value);
  }

  void deleteHidden() {
    secureStorage.delete(key: 'ff_hidden');
  }

  bool _belong = false;
  bool get belong => _belong;
  set belong(bool value) {
    _belong = value;
  }

  bool _show = true;
  bool get show => _show;
  set show(bool value) {
    _show = value;
    secureStorage.setBool('ff_show', value);
    notifyListeners();
  }

  bool _adddate = false;
  bool get adddate => _adddate;
  set adddate(bool value) {
    _adddate = value;
  }

  bool _connectionoff = true;
  bool get connectionoff => _connectionoff;
  set connectionoff(bool value) {
    _connectionoff = value;
  }

  String _phonenumber = '';
  String get phonenumber => _phonenumber;
  set phonenumber(String value) {
    _phonenumber = value;
    secureStorage.setString('ff_phonenumber', value);
  }

  void deletePhonenumber() {
    secureStorage.delete(key: 'ff_phonenumber');
  }

  String _vasaccesstoken = '';
  String get vasaccesstoken => _vasaccesstoken;
  set vasaccesstoken(String value) {
    _vasaccesstoken = value;
    secureStorage.setString('ff_vasaccesstoken', value);
  }

  void deleteVasaccesstoken() {
    secureStorage.delete(key: 'ff_vasaccesstoken');
  }

  bool _networkshow = false;
  bool get networkshow => _networkshow;
  set networkshow(bool value) {
    _networkshow = value;
  }

  List<String> _idlists = [];
  List<String> get idlists => _idlists;
  set idlists(List<String> value) {
    _idlists = value;
  }

  void addToIdlists(String value) {
    idlists.add(value);
  }

  void removeFromIdlists(String value) {
    idlists.remove(value);
  }

  void removeAtIndexFromIdlists(int index) {
    idlists.removeAt(index);
  }

  void updateIdlistsAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    idlists[index] = updateFn(_idlists[index]);
  }

  void insertAtIndexInIdlists(int index, String value) {
    idlists.insert(index, value);
  }

  List<String> _itemlist = [];
  List<String> get itemlist => _itemlist;
  set itemlist(List<String> value) {
    _itemlist = value;
  }

  void addToItemlist(String value) {
    itemlist.add(value);
  }

  void removeFromItemlist(String value) {
    itemlist.remove(value);
  }

  void removeAtIndexFromItemlist(int index) {
    itemlist.removeAt(index);
  }

  void updateItemlistAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    itemlist[index] = updateFn(_itemlist[index]);
  }

  void insertAtIndexInItemlist(int index, String value) {
    itemlist.insert(index, value);
  }

  String _customerid = '';
  String get customerid => _customerid;
  set customerid(String value) {
    _customerid = value;
  }

  String _bvn = '';
  String get bvn => _bvn;
  set bvn(String value) {
    _bvn = value;
  }

  String _tier = '';
  String get tier => _tier;
  set tier(String value) {
    _tier = value;
  }

  String _accountname = '';
  String get accountname => _accountname;
  set accountname(String value) {
    _accountname = value;
    secureStorage.setString('ff_accountname', value);
  }

  void deleteAccountname() {
    secureStorage.delete(key: 'ff_accountname');
  }

  String _fromdate = '';
  String get fromdate => _fromdate;
  set fromdate(String value) {
    _fromdate = value;
  }

  String _todate = '';
  String get todate => _todate;
  set todate(String value) {
    _todate = value;
  }

  List<String> _allstates = [];
  List<String> get allstates => _allstates;
  set allstates(List<String> value) {
    _allstates = value;
  }

  void addToAllstates(String value) {
    allstates.add(value);
  }

  void removeFromAllstates(String value) {
    allstates.remove(value);
  }

  void removeAtIndexFromAllstates(int index) {
    allstates.removeAt(index);
  }

  void updateAllstatesAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    allstates[index] = updateFn(_allstates[index]);
  }

  void insertAtIndexInAllstates(int index, String value) {
    allstates.insert(index, value);
  }

  List<String> _alllga = [];
  List<String> get alllga => _alllga;
  set alllga(List<String> value) {
    _alllga = value;
  }

  void addToAlllga(String value) {
    alllga.add(value);
  }

  void removeFromAlllga(String value) {
    alllga.remove(value);
  }

  void removeAtIndexFromAlllga(int index) {
    alllga.removeAt(index);
  }

  void updateAlllgaAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    alllga[index] = updateFn(_alllga[index]);
  }

  void insertAtIndexInAlllga(int index, String value) {
    alllga.insert(index, value);
  }

  List<String> _listofaccounts = [];
  List<String> get listofaccounts => _listofaccounts;
  set listofaccounts(List<String> value) {
    _listofaccounts = value;
    secureStorage.setStringList('ff_listofaccounts', value);
  }

  void deleteListofaccounts() {
    secureStorage.delete(key: 'ff_listofaccounts');
  }

  void addToListofaccounts(String value) {
    listofaccounts.add(value);
    secureStorage.setStringList('ff_listofaccounts', _listofaccounts);
  }

  void removeFromListofaccounts(String value) {
    listofaccounts.remove(value);
    secureStorage.setStringList('ff_listofaccounts', _listofaccounts);
  }

  void removeAtIndexFromListofaccounts(int index) {
    listofaccounts.removeAt(index);
    secureStorage.setStringList('ff_listofaccounts', _listofaccounts);
  }

  void updateListofaccountsAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    listofaccounts[index] = updateFn(_listofaccounts[index]);
    secureStorage.setStringList('ff_listofaccounts', _listofaccounts);
  }

  void insertAtIndexInListofaccounts(int index, String value) {
    listofaccounts.insert(index, value);
    secureStorage.setStringList('ff_listofaccounts', _listofaccounts);
  }

  bool _accountvalidation = false;
  bool get accountvalidation => _accountvalidation;
  set accountvalidation(bool value) {
    _accountvalidation = value;
  }

  bool _questionvalidation = false;
  bool get questionvalidation => _questionvalidation;
  set questionvalidation(bool value) {
    _questionvalidation = value;
  }

  bool _biometric = false;
  bool get biometric => _biometric;
  set biometric(bool value) {
    _biometric = value;
    secureStorage.setBool('ff_biometric', value);
  }

  void deleteBiometric() {
    secureStorage.delete(key: 'ff_biometric');
  }

  String _billphone = '';
  String get billphone => _billphone;
  set billphone(String value) {
    _billphone = value;
  }

  String _billemail = '';
  String get billemail => _billemail;
  set billemail(String value) {
    _billemail = value;
  }

  List<String> _examlist = [];
  List<String> get examlist => _examlist;
  set examlist(List<String> value) {
    _examlist = value;
  }

  void addToExamlist(String value) {
    examlist.add(value);
  }

  void removeFromExamlist(String value) {
    examlist.remove(value);
  }

  void removeAtIndexFromExamlist(int index) {
    examlist.removeAt(index);
  }

  void updateExamlistAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    examlist[index] = updateFn(_examlist[index]);
  }

  void insertAtIndexInExamlist(int index, String value) {
    examlist.insert(index, value);
  }

  List<String> _electricitylist = [];
  List<String> get electricitylist => _electricitylist;
  set electricitylist(List<String> value) {
    _electricitylist = value;
  }

  void addToElectricitylist(String value) {
    electricitylist.add(value);
  }

  void removeFromElectricitylist(String value) {
    electricitylist.remove(value);
  }

  void removeAtIndexFromElectricitylist(int index) {
    electricitylist.removeAt(index);
  }

  void updateElectricitylistAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    electricitylist[index] = updateFn(_electricitylist[index]);
  }

  void insertAtIndexInElectricitylist(int index, String value) {
    electricitylist.insert(index, value);
  }

  List<String> _bettinglist = [];
  List<String> get bettinglist => _bettinglist;
  set bettinglist(List<String> value) {
    _bettinglist = value;
  }

  void addToBettinglist(String value) {
    bettinglist.add(value);
  }

  void removeFromBettinglist(String value) {
    bettinglist.remove(value);
  }

  void removeAtIndexFromBettinglist(int index) {
    bettinglist.removeAt(index);
  }

  void updateBettinglistAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    bettinglist[index] = updateFn(_bettinglist[index]);
  }

  void insertAtIndexInBettinglist(int index, String value) {
    bettinglist.insert(index, value);
  }

  List<String> _cabletvlist = [];
  List<String> get cabletvlist => _cabletvlist;
  set cabletvlist(List<String> value) {
    _cabletvlist = value;
  }

  void addToCabletvlist(String value) {
    cabletvlist.add(value);
  }

  void removeFromCabletvlist(String value) {
    cabletvlist.remove(value);
  }

  void removeAtIndexFromCabletvlist(int index) {
    cabletvlist.removeAt(index);
  }

  void updateCabletvlistAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    cabletvlist[index] = updateFn(_cabletvlist[index]);
  }

  void insertAtIndexInCabletvlist(int index, String value) {
    cabletvlist.insert(index, value);
  }

  String _email = '';
  String get email => _email;
  set email(String value) {
    _email = value;
    secureStorage.setString('ff_email', value);
  }

  void deleteEmail() {
    secureStorage.delete(key: 'ff_email');
  }

  String _streetauth = '';
  String get streetauth => _streetauth;
  set streetauth(String value) {
    _streetauth = value;
  }

  Color _errorstate = Color(4278484994);
  Color get errorstate => _errorstate;
  set errorstate(Color value) {
    _errorstate = value;
  }

  String _walletid = '';
  String get walletid => _walletid;
  set walletid(String value) {
    _walletid = value;
    secureStorage.setString('ff_walletid', value);
  }

  void deleteWalletid() {
    secureStorage.delete(key: 'ff_walletid');
  }

  bool _searchid = false;
  bool get searchid => _searchid;
  set searchid(bool value) {
    _searchid = value;
  }

  List<String> _lottoselect = [];
  List<String> get lottoselect => _lottoselect;
  set lottoselect(List<String> value) {
    _lottoselect = value;
  }

  void addToLottoselect(String value) {
    lottoselect.add(value);
  }

  void removeFromLottoselect(String value) {
    lottoselect.remove(value);
  }

  void removeAtIndexFromLottoselect(int index) {
    lottoselect.removeAt(index);
  }

  void updateLottoselectAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    lottoselect[index] = updateFn(_lottoselect[index]);
  }

  void insertAtIndexInLottoselect(int index, String value) {
    lottoselect.insert(index, value);
  }

  List<dynamic> _discoveredphone = [];
  List<dynamic> get discoveredphone => _discoveredphone;
  set discoveredphone(List<dynamic> value) {
    _discoveredphone = value;
  }

  void addToDiscoveredphone(dynamic value) {
    discoveredphone.add(value);
  }

  void removeFromDiscoveredphone(dynamic value) {
    discoveredphone.remove(value);
  }

  void removeAtIndexFromDiscoveredphone(int index) {
    discoveredphone.removeAt(index);
  }

  void updateDiscoveredphoneAtIndex(
    int index,
    dynamic Function(dynamic) updateFn,
  ) {
    discoveredphone[index] = updateFn(_discoveredphone[index]);
  }

  void insertAtIndexInDiscoveredphone(int index, dynamic value) {
    discoveredphone.insert(index, value);
  }

  List<String> _lotteryplan = [];
  List<String> get lotteryplan => _lotteryplan;
  set lotteryplan(List<String> value) {
    _lotteryplan = value;
    secureStorage.setStringList('ff_lotteryplan', value);
  }

  void deleteLotteryplan() {
    secureStorage.delete(key: 'ff_lotteryplan');
  }

  void addToLotteryplan(String value) {
    lotteryplan.add(value);
    secureStorage.setStringList('ff_lotteryplan', _lotteryplan);
  }

  void removeFromLotteryplan(String value) {
    lotteryplan.remove(value);
    secureStorage.setStringList('ff_lotteryplan', _lotteryplan);
  }

  void removeAtIndexFromLotteryplan(int index) {
    lotteryplan.removeAt(index);
    secureStorage.setStringList('ff_lotteryplan', _lotteryplan);
  }

  void updateLotteryplanAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    lotteryplan[index] = updateFn(_lotteryplan[index]);
    secureStorage.setStringList('ff_lotteryplan', _lotteryplan);
  }

  void insertAtIndexInLotteryplan(int index, String value) {
    lotteryplan.insert(index, value);
    secureStorage.setStringList('ff_lotteryplan', _lotteryplan);
  }

  List<dynamic> _lottohistroy = [];
  List<dynamic> get lottohistroy => _lottohistroy;
  set lottohistroy(List<dynamic> value) {
    _lottohistroy = value;
    secureStorage.setStringList(
        'ff_lottohistroy', value.map((x) => jsonEncode(x)).toList());
  }

  void deleteLottohistroy() {
    secureStorage.delete(key: 'ff_lottohistroy');
  }

  void addToLottohistroy(dynamic value) {
    lottohistroy.add(value);
    secureStorage.setStringList(
        'ff_lottohistroy', _lottohistroy.map((x) => jsonEncode(x)).toList());
  }

  void removeFromLottohistroy(dynamic value) {
    lottohistroy.remove(value);
    secureStorage.setStringList(
        'ff_lottohistroy', _lottohistroy.map((x) => jsonEncode(x)).toList());
  }

  void removeAtIndexFromLottohistroy(int index) {
    lottohistroy.removeAt(index);
    secureStorage.setStringList(
        'ff_lottohistroy', _lottohistroy.map((x) => jsonEncode(x)).toList());
  }

  void updateLottohistroyAtIndex(
    int index,
    dynamic Function(dynamic) updateFn,
  ) {
    lottohistroy[index] = updateFn(_lottohistroy[index]);
    secureStorage.setStringList(
        'ff_lottohistroy', _lottohistroy.map((x) => jsonEncode(x)).toList());
  }

  void insertAtIndexInLottohistroy(int index, dynamic value) {
    lottohistroy.insert(index, value);
    secureStorage.setStringList(
        'ff_lottohistroy', _lottohistroy.map((x) => jsonEncode(x)).toList());
  }

  List<dynamic> _getallwinners = [];
  List<dynamic> get getallwinners => _getallwinners;
  set getallwinners(List<dynamic> value) {
    _getallwinners = value;
  }

  void addToGetallwinners(dynamic value) {
    getallwinners.add(value);
  }

  void removeFromGetallwinners(dynamic value) {
    getallwinners.remove(value);
  }

  void removeAtIndexFromGetallwinners(int index) {
    getallwinners.removeAt(index);
  }

  void updateGetallwinnersAtIndex(
    int index,
    dynamic Function(dynamic) updateFn,
  ) {
    getallwinners[index] = updateFn(_getallwinners[index]);
  }

  void insertAtIndexInGetallwinners(int index, dynamic value) {
    getallwinners.insert(index, value);
  }

  List<dynamic> _transactionhistory = [];
  List<dynamic> get transactionhistory => _transactionhistory;
  set transactionhistory(List<dynamic> value) {
    _transactionhistory = value;
    secureStorage.setStringList(
        'ff_transactionhistory', value.map((x) => jsonEncode(x)).toList());
  }

  void deleteTransactionhistory() {
    secureStorage.delete(key: 'ff_transactionhistory');
  }

  void addToTransactionhistory(dynamic value) {
    transactionhistory.add(value);
    secureStorage.setStringList('ff_transactionhistory',
        _transactionhistory.map((x) => jsonEncode(x)).toList());
  }

  void removeFromTransactionhistory(dynamic value) {
    transactionhistory.remove(value);
    secureStorage.setStringList('ff_transactionhistory',
        _transactionhistory.map((x) => jsonEncode(x)).toList());
  }

  void removeAtIndexFromTransactionhistory(int index) {
    transactionhistory.removeAt(index);
    secureStorage.setStringList('ff_transactionhistory',
        _transactionhistory.map((x) => jsonEncode(x)).toList());
  }

  void updateTransactionhistoryAtIndex(
    int index,
    dynamic Function(dynamic) updateFn,
  ) {
    transactionhistory[index] = updateFn(_transactionhistory[index]);
    secureStorage.setStringList('ff_transactionhistory',
        _transactionhistory.map((x) => jsonEncode(x)).toList());
  }

  void insertAtIndexInTransactionhistory(int index, dynamic value) {
    transactionhistory.insert(index, value);
    secureStorage.setStringList('ff_transactionhistory',
        _transactionhistory.map((x) => jsonEncode(x)).toList());
  }

  List<dynamic> _guesttransactionhistory = [];
  List<dynamic> get guesttransactionhistory => _guesttransactionhistory;
  set guesttransactionhistory(List<dynamic> value) {
    _guesttransactionhistory = value;
  }

  void addToGuesttransactionhistory(dynamic value) {
    guesttransactionhistory.add(value);
  }

  void removeFromGuesttransactionhistory(dynamic value) {
    guesttransactionhistory.remove(value);
  }

  void removeAtIndexFromGuesttransactionhistory(int index) {
    guesttransactionhistory.removeAt(index);
  }

  void updateGuesttransactionhistoryAtIndex(
    int index,
    dynamic Function(dynamic) updateFn,
  ) {
    guesttransactionhistory[index] = updateFn(_guesttransactionhistory[index]);
  }

  void insertAtIndexInGuesttransactionhistory(int index, dynamic value) {
    guesttransactionhistory.insert(index, value);
  }

  List<int> _lottonumbers = [];
  List<int> get lottonumbers => _lottonumbers;
  set lottonumbers(List<int> value) {
    _lottonumbers = value;
  }

  void addToLottonumbers(int value) {
    lottonumbers.add(value);
  }

  void removeFromLottonumbers(int value) {
    lottonumbers.remove(value);
  }

  void removeAtIndexFromLottonumbers(int index) {
    lottonumbers.removeAt(index);
  }

  void updateLottonumbersAtIndex(
    int index,
    int Function(int) updateFn,
  ) {
    lottonumbers[index] = updateFn(_lottonumbers[index]);
  }

  void insertAtIndexInLottonumbers(int index, int value) {
    lottonumbers.insert(index, value);
  }

  List<String> _answerspicked = [];
  List<String> get answerspicked => _answerspicked;
  set answerspicked(List<String> value) {
    _answerspicked = value;
  }

  void addToAnswerspicked(String value) {
    answerspicked.add(value);
  }

  void removeFromAnswerspicked(String value) {
    answerspicked.remove(value);
  }

  void removeAtIndexFromAnswerspicked(int index) {
    answerspicked.removeAt(index);
  }

  void updateAnswerspickedAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    answerspicked[index] = updateFn(_answerspicked[index]);
  }

  void insertAtIndexInAnswerspicked(int index, String value) {
    answerspicked.insert(index, value);
  }

  int _totalcorrect = 0;
  int get totalcorrect => _totalcorrect;
  set totalcorrect(int value) {
    _totalcorrect = value;
  }

  dynamic _questionjson;
  dynamic get questionjson => _questionjson;
  set questionjson(dynamic value) {
    _questionjson = value;
  }

  bool _iscorrect = false;
  bool get iscorrect => _iscorrect;
  set iscorrect(bool value) {
    _iscorrect = value;
  }

  Color _boadercolor = Color(4282012433);
  Color get boadercolor => _boadercolor;
  set boadercolor(Color value) {
    _boadercolor = value;
  }

  bool _isselect = false;
  bool get isselect => _isselect;
  set isselect(bool value) {
    _isselect = value;
  }

  String _correctans = '';
  String get correctans => _correctans;
  set correctans(String value) {
    _correctans = value;
  }

  List<String> _listofquestion = [];
  List<String> get listofquestion => _listofquestion;
  set listofquestion(List<String> value) {
    _listofquestion = value;
  }

  void addToListofquestion(String value) {
    listofquestion.add(value);
  }

  void removeFromListofquestion(String value) {
    listofquestion.remove(value);
  }

  void removeAtIndexFromListofquestion(int index) {
    listofquestion.removeAt(index);
  }

  void updateListofquestionAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    listofquestion[index] = updateFn(_listofquestion[index]);
  }

  void insertAtIndexInListofquestion(int index, String value) {
    listofquestion.insert(index, value);
  }

  List<String> _correctanswer = [];
  List<String> get correctanswer => _correctanswer;
  set correctanswer(List<String> value) {
    _correctanswer = value;
  }

  void addToCorrectanswer(String value) {
    correctanswer.add(value);
  }

  void removeFromCorrectanswer(String value) {
    correctanswer.remove(value);
  }

  void removeAtIndexFromCorrectanswer(int index) {
    correctanswer.removeAt(index);
  }

  void updateCorrectanswerAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    correctanswer[index] = updateFn(_correctanswer[index]);
  }

  void insertAtIndexInCorrectanswer(int index, String value) {
    correctanswer.insert(index, value);
  }

  List<int> _questionid = [];
  List<int> get questionid => _questionid;
  set questionid(List<int> value) {
    _questionid = value;
  }

  void addToQuestionid(int value) {
    questionid.add(value);
  }

  void removeFromQuestionid(int value) {
    questionid.remove(value);
  }

  void removeAtIndexFromQuestionid(int index) {
    questionid.removeAt(index);
  }

  void updateQuestionidAtIndex(
    int index,
    int Function(int) updateFn,
  ) {
    questionid[index] = updateFn(_questionid[index]);
  }

  void insertAtIndexInQuestionid(int index, int value) {
    questionid.insert(index, value);
  }

  List<String> _lottoangle = [
    '45',
    '135',
    '955',
    '330',
    '270',
    '90',
    '35',
    '45',
    '15',
    '315'
  ];
  List<String> get lottoangle => _lottoangle;
  set lottoangle(List<String> value) {
    _lottoangle = value;
    secureStorage.setStringList('ff_lottoangle', value);
  }

  void deleteLottoangle() {
    secureStorage.delete(key: 'ff_lottoangle');
  }

  void addToLottoangle(String value) {
    lottoangle.add(value);
    secureStorage.setStringList('ff_lottoangle', _lottoangle);
  }

  void removeFromLottoangle(String value) {
    lottoangle.remove(value);
    secureStorage.setStringList('ff_lottoangle', _lottoangle);
  }

  void removeAtIndexFromLottoangle(int index) {
    lottoangle.removeAt(index);
    secureStorage.setStringList('ff_lottoangle', _lottoangle);
  }

  void updateLottoangleAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    lottoangle[index] = updateFn(_lottoangle[index]);
    secureStorage.setStringList('ff_lottoangle', _lottoangle);
  }

  void insertAtIndexInLottoangle(int index, String value) {
    lottoangle.insert(index, value);
    secureStorage.setStringList('ff_lottoangle', _lottoangle);
  }

  List<String> _questionlist = [];
  List<String> get questionlist => _questionlist;
  set questionlist(List<String> value) {
    _questionlist = value;
  }

  void addToQuestionlist(String value) {
    questionlist.add(value);
  }

  void removeFromQuestionlist(String value) {
    questionlist.remove(value);
  }

  void removeAtIndexFromQuestionlist(int index) {
    questionlist.removeAt(index);
  }

  void updateQuestionlistAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    questionlist[index] = updateFn(_questionlist[index]);
  }

  void insertAtIndexInQuestionlist(int index, String value) {
    questionlist.insert(index, value);
  }

  bool _autodiscovery = false;
  bool get autodiscovery => _autodiscovery;
  set autodiscovery(bool value) {
    _autodiscovery = value;
    secureStorage.setBool('ff_autodiscovery', value);
  }

  void deleteAutodiscovery() {
    secureStorage.delete(key: 'ff_autodiscovery');
  }

  bool _isauto = false;
  bool get isauto => _isauto;
  set isauto(bool value) {
    _isauto = value;
  }

  List<String> _electricbillerid = [
    'AEDC (Abuja)',
    'EKEDC (Eko)',
    'IKEDC (Ikeja)',
    'IBEDC (Ibadan)',
    'EEDC (Enugu)',
    'PHEDC (Port Harcourt)',
    'KEDCO (Kano)',
    'JEDC (Jos)',
    'KAEDCO (Kaduna)',
    'BEDC (Benin)',
    'YEDC (Yola)',
    'Aba Power (APLE)',
  ];
  List<String> get electricbillerid => _electricbillerid;
  set electricbillerid(List<String> value) {
    _electricbillerid = value;
    secureStorage.setStringList('ff_electricbillerid', value);
  }

  void deleteElectricbillerid() {
    secureStorage.delete(key: 'ff_electricbillerid');
  }

  void addToElectricbillerid(String value) {
    electricbillerid.add(value);
    secureStorage.setStringList('ff_electricbillerid', _electricbillerid);
  }

  void removeFromElectricbillerid(String value) {
    electricbillerid.remove(value);
    secureStorage.setStringList('ff_electricbillerid', _electricbillerid);
  }

  void removeAtIndexFromElectricbillerid(int index) {
    electricbillerid.removeAt(index);
    secureStorage.setStringList('ff_electricbillerid', _electricbillerid);
  }

  void updateElectricbilleridAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    electricbillerid[index] = updateFn(_electricbillerid[index]);
    secureStorage.setStringList('ff_electricbillerid', _electricbillerid);
  }

  void insertAtIndexInElectricbillerid(int index, String value) {
    electricbillerid.insert(index, value);
    secureStorage.setStringList('ff_electricbillerid', _electricbillerid);
  }

  List<String> _bettingbillerid = [
    'Bet9ja',
    'SportyBet',
    '1xBet',
    'Betway',
    'MSport',
    'BangBet',
    'Merrybet',
    'NairaBet',
  ];
  List<String> get bettingbillerid => _bettingbillerid;
  set bettingbillerid(List<String> value) {
    _bettingbillerid = value;
    secureStorage.setStringList('ff_bettingbillerid', value);
  }

  void deleteBettingbillerid() {
    secureStorage.delete(key: 'ff_bettingbillerid');
  }

  void addToBettingbillerid(String value) {
    bettingbillerid.add(value);
    secureStorage.setStringList('ff_bettingbillerid', _bettingbillerid);
  }

  void removeFromBettingbillerid(String value) {
    bettingbillerid.remove(value);
    secureStorage.setStringList('ff_bettingbillerid', _bettingbillerid);
  }

  void removeAtIndexFromBettingbillerid(int index) {
    bettingbillerid.removeAt(index);
    secureStorage.setStringList('ff_bettingbillerid', _bettingbillerid);
  }

  void updateBettingbilleridAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    bettingbillerid[index] = updateFn(_bettingbillerid[index]);
    secureStorage.setStringList('ff_bettingbillerid', _bettingbillerid);
  }

  void insertAtIndexInBettingbillerid(int index, String value) {
    bettingbillerid.insert(index, value);
    secureStorage.setStringList('ff_bettingbillerid', _bettingbillerid);
  }

  List<String> _cablebillerid = ['DSTV', 'GOTV', 'STARTIMES', 'SHOWMAX'];
  List<String> get cablebillerid => _cablebillerid;
  set cablebillerid(List<String> value) {
    _cablebillerid = value;
    secureStorage.setStringList('ff_cablebillerid', value);
  }

  void deleteCablebillerid() {
    secureStorage.delete(key: 'ff_cablebillerid');
  }

  void addToCablebillerid(String value) {
    cablebillerid.add(value);
    secureStorage.setStringList('ff_cablebillerid', _cablebillerid);
  }

  void removeFromCablebillerid(String value) {
    cablebillerid.remove(value);
    secureStorage.setStringList('ff_cablebillerid', _cablebillerid);
  }

  void removeAtIndexFromCablebillerid(int index) {
    cablebillerid.removeAt(index);
    secureStorage.setStringList('ff_cablebillerid', _cablebillerid);
  }

  void updateCablebilleridAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    cablebillerid[index] = updateFn(_cablebillerid[index]);
    secureStorage.setStringList('ff_cablebillerid', _cablebillerid);
  }

  void insertAtIndexInCablebillerid(int index, String value) {
    cablebillerid.insert(index, value);
    secureStorage.setStringList('ff_cablebillerid', _cablebillerid);
  }

  List<String> _exambillerid = ['WAEC', 'JAMB', 'NECO', 'NABTEB'];
  List<String> get exambillerid => _exambillerid;
  set exambillerid(List<String> value) {
    _exambillerid = value;
    secureStorage.setStringList('ff_exambillerid', value);
  }

  void deleteExambillerid() {
    secureStorage.delete(key: 'ff_exambillerid');
  }

  void addToExambillerid(String value) {
    exambillerid.add(value);
    secureStorage.setStringList('ff_exambillerid', _exambillerid);
  }

  void removeFromExambillerid(String value) {
    exambillerid.remove(value);
    secureStorage.setStringList('ff_exambillerid', _exambillerid);
  }

  void removeAtIndexFromExambillerid(int index) {
    exambillerid.removeAt(index);
    secureStorage.setStringList('ff_exambillerid', _exambillerid);
  }

  void updateExambilleridAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    exambillerid[index] = updateFn(_exambillerid[index]);
    secureStorage.setStringList('ff_exambillerid', _exambillerid);
  }

  void insertAtIndexInExambillerid(int index, String value) {
    exambillerid.insert(index, value);
    secureStorage.setStringList('ff_exambillerid', _exambillerid);
  }

  List<String> _internetbillerid = [
    'SPECTRANET',
    'SMILE',
    'IPNX',
    'FIBRONIX',
    'SWIFT',
  ];
  List<String> get internetbillerid => _internetbillerid;
  set internetbillerid(List<String> value) {
    _internetbillerid = value;
    secureStorage.setStringList('ff_internetbillerid', value);
  }

  void deleteInternetbillerid() {
    secureStorage.delete(key: 'ff_internetbillerid');
  }

  void addToInternetbillerid(String value) {
    internetbillerid.add(value);
    secureStorage.setStringList('ff_internetbillerid', _internetbillerid);
  }

  void removeFromInternetbillerid(String value) {
    internetbillerid.remove(value);
    secureStorage.setStringList('ff_internetbillerid', _internetbillerid);
  }

  void removeAtIndexFromInternetbillerid(int index) {
    internetbillerid.removeAt(index);
    secureStorage.setStringList('ff_internetbillerid', _internetbillerid);
  }

  void updateInternetbilleridAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    internetbillerid[index] = updateFn(_internetbillerid[index]);
    secureStorage.setStringList('ff_internetbillerid', _internetbillerid);
  }

  void insertAtIndexInInternetbillerid(int index, String value) {
    internetbillerid.insert(index, value);
    secureStorage.setStringList('ff_internetbillerid', _internetbillerid);
  }

  double _progressvalue = 0.0;
  double get progressvalue => _progressvalue;
  set progressvalue(double value) {
    _progressvalue = value;
    secureStorage.setDouble('ff_progressvalue', value);
  }

  void deleteProgressvalue() {
    secureStorage.delete(key: 'ff_progressvalue');
  }

  String _avalbal = '';
  String get avalbal => _avalbal;
  set avalbal(String value) {
    _avalbal = value;
    secureStorage.setString('ff_avalbal', value);
  }

  void deleteAvalbal() {
    secureStorage.delete(key: 'ff_avalbal');
  }

  List<String> _cableitemlist = [];
  List<String> get cableitemlist => _cableitemlist;
  set cableitemlist(List<String> value) {
    _cableitemlist = value;
    secureStorage.setStringList('ff_cableitemlist', value);
  }

  void deleteCableitemlist() {
    secureStorage.delete(key: 'ff_cableitemlist');
  }

  void addToCableitemlist(String value) {
    cableitemlist.add(value);
    secureStorage.setStringList('ff_cableitemlist', _cableitemlist);
  }

  void removeFromCableitemlist(String value) {
    cableitemlist.remove(value);
    secureStorage.setStringList('ff_cableitemlist', _cableitemlist);
  }

  void removeAtIndexFromCableitemlist(int index) {
    cableitemlist.removeAt(index);
    secureStorage.setStringList('ff_cableitemlist', _cableitemlist);
  }

  void updateCableitemlistAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    cableitemlist[index] = updateFn(_cableitemlist[index]);
    secureStorage.setStringList('ff_cableitemlist', _cableitemlist);
  }

  void insertAtIndexInCableitemlist(int index, String value) {
    cableitemlist.insert(index, value);
    secureStorage.setStringList('ff_cableitemlist', _cableitemlist);
  }

  List<dynamic> _examinput = [];
  List<dynamic> get examinput => _examinput;
  set examinput(List<dynamic> value) {
    _examinput = value;
    secureStorage.setStringList(
        'ff_examinput', value.map((x) => jsonEncode(x)).toList());
  }

  void deleteExaminput() {
    secureStorage.delete(key: 'ff_examinput');
  }

  void addToExaminput(dynamic value) {
    examinput.add(value);
    secureStorage.setStringList(
        'ff_examinput', _examinput.map((x) => jsonEncode(x)).toList());
  }

  void removeFromExaminput(dynamic value) {
    examinput.remove(value);
    secureStorage.setStringList(
        'ff_examinput', _examinput.map((x) => jsonEncode(x)).toList());
  }

  void removeAtIndexFromExaminput(int index) {
    examinput.removeAt(index);
    secureStorage.setStringList(
        'ff_examinput', _examinput.map((x) => jsonEncode(x)).toList());
  }

  void updateExaminputAtIndex(
    int index,
    dynamic Function(dynamic) updateFn,
  ) {
    examinput[index] = updateFn(_examinput[index]);
    secureStorage.setStringList(
        'ff_examinput', _examinput.map((x) => jsonEncode(x)).toList());
  }

  void insertAtIndexInExaminput(int index, dynamic value) {
    examinput.insert(index, value);
    secureStorage.setStringList(
        'ff_examinput', _examinput.map((x) => jsonEncode(x)).toList());
  }

  List<String> _examitemlist = [];
  List<String> get examitemlist => _examitemlist;
  set examitemlist(List<String> value) {
    _examitemlist = value;
    secureStorage.setStringList('ff_examitemlist', value);
  }

  void deleteExamitemlist() {
    secureStorage.delete(key: 'ff_examitemlist');
  }

  void addToExamitemlist(String value) {
    examitemlist.add(value);
    secureStorage.setStringList('ff_examitemlist', _examitemlist);
  }

  void removeFromExamitemlist(String value) {
    examitemlist.remove(value);
    secureStorage.setStringList('ff_examitemlist', _examitemlist);
  }

  void removeAtIndexFromExamitemlist(int index) {
    examitemlist.removeAt(index);
    secureStorage.setStringList('ff_examitemlist', _examitemlist);
  }

  void updateExamitemlistAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    examitemlist[index] = updateFn(_examitemlist[index]);
    secureStorage.setStringList('ff_examitemlist', _examitemlist);
  }

  void insertAtIndexInExamitemlist(int index, String value) {
    examitemlist.insert(index, value);
    secureStorage.setStringList('ff_examitemlist', _examitemlist);
  }

  dynamic _mtnplans;
  dynamic get mtnplans => _mtnplans;
  set mtnplans(dynamic value) {
    _mtnplans = value;
    secureStorage.setString('ff_mtnplans', jsonEncode(value));
  }

  void deleteMtnplans() {
    secureStorage.delete(key: 'ff_mtnplans');
  }

  dynamic _gloplans;
  dynamic get gloplans => _gloplans;
  set gloplans(dynamic value) {
    _gloplans = value;
    secureStorage.setString('ff_gloplans', jsonEncode(value));
  }

  void deleteGloplans() {
    secureStorage.delete(key: 'ff_gloplans');
  }

  dynamic _airtel;
  dynamic get airtel => _airtel;
  set airtel(dynamic value) {
    _airtel = value;
    secureStorage.setString('ff_airtel', jsonEncode(value));
  }

  void deleteAirtel() {
    secureStorage.delete(key: 'ff_airtel');
  }

  List<String> _dstvitemlist = [
    'DStv Compact - N19,000',
    'DStv Compact + Great Wall Africa - N22,800',
    'DStv Compact + ExtraView - N25,000'
  ];
  List<String> get dstvitemlist => _dstvitemlist;
  set dstvitemlist(List<String> value) {
    _dstvitemlist = value;
    secureStorage.setStringList('ff_dstvitemlist', value);
  }

  void deleteDstvitemlist() {
    secureStorage.delete(key: 'ff_dstvitemlist');
  }

  void addToDstvitemlist(String value) {
    dstvitemlist.add(value);
    secureStorage.setStringList('ff_dstvitemlist', _dstvitemlist);
  }

  void removeFromDstvitemlist(String value) {
    dstvitemlist.remove(value);
    secureStorage.setStringList('ff_dstvitemlist', _dstvitemlist);
  }

  void removeAtIndexFromDstvitemlist(int index) {
    dstvitemlist.removeAt(index);
    secureStorage.setStringList('ff_dstvitemlist', _dstvitemlist);
  }

  void updateDstvitemlistAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    dstvitemlist[index] = updateFn(_dstvitemlist[index]);
    secureStorage.setStringList('ff_dstvitemlist', _dstvitemlist);
  }

  void insertAtIndexInDstvitemlist(int index, String value) {
    dstvitemlist.insert(index, value);
    secureStorage.setStringList('ff_dstvitemlist', _dstvitemlist);
  }

  List<String> _gotvitemlist = [
    'GOtv Smallie-monthly - N1,900',
    'GOtv Jinja - N3,900',
    'GOtv Smallie - quarterly - N5,100'
  ];
  List<String> get gotvitemlist => _gotvitemlist;
  set gotvitemlist(List<String> value) {
    _gotvitemlist = value;
    secureStorage.setStringList('ff_gotvitemlist', value);
  }

  void deleteGotvitemlist() {
    secureStorage.delete(key: 'ff_gotvitemlist');
  }

  void addToGotvitemlist(String value) {
    gotvitemlist.add(value);
    secureStorage.setStringList('ff_gotvitemlist', _gotvitemlist);
  }

  void removeFromGotvitemlist(String value) {
    gotvitemlist.remove(value);
    secureStorage.setStringList('ff_gotvitemlist', _gotvitemlist);
  }

  void removeAtIndexFromGotvitemlist(int index) {
    gotvitemlist.removeAt(index);
    secureStorage.setStringList('ff_gotvitemlist', _gotvitemlist);
  }

  void updateGotvitemlistAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    gotvitemlist[index] = updateFn(_gotvitemlist[index]);
    secureStorage.setStringList('ff_gotvitemlist', _gotvitemlist);
  }

  void insertAtIndexInGotvitemlist(int index, String value) {
    gotvitemlist.insert(index, value);
    secureStorage.setStringList('ff_gotvitemlist', _gotvitemlist);
  }

  List<String> _showmaxitemlist = [
    'Showmax Mobile 1 month - N1,200',
    'Showmax 1 month - N2,900',
    'Showmax Pro Mobile 1 month - N3,200'
  ];
  List<String> get showmaxitemlist => _showmaxitemlist;
  set showmaxitemlist(List<String> value) {
    _showmaxitemlist = value;
    secureStorage.setStringList('ff_showmaxitemlist', value);
  }

  void deleteShowmaxitemlist() {
    secureStorage.delete(key: 'ff_showmaxitemlist');
  }

  void addToShowmaxitemlist(String value) {
    showmaxitemlist.add(value);
    secureStorage.setStringList('ff_showmaxitemlist', _showmaxitemlist);
  }

  void removeFromShowmaxitemlist(String value) {
    showmaxitemlist.remove(value);
    secureStorage.setStringList('ff_showmaxitemlist', _showmaxitemlist);
  }

  void removeAtIndexFromShowmaxitemlist(int index) {
    showmaxitemlist.removeAt(index);
    secureStorage.setStringList('ff_showmaxitemlist', _showmaxitemlist);
  }

  void updateShowmaxitemlistAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    showmaxitemlist[index] = updateFn(_showmaxitemlist[index]);
    secureStorage.setStringList('ff_showmaxitemlist', _showmaxitemlist);
  }

  void insertAtIndexInShowmaxitemlist(int index, String value) {
    showmaxitemlist.insert(index, value);
    secureStorage.setStringList('ff_showmaxitemlist', _showmaxitemlist);
  }

  List<String> _startimes = [
    'DTTBasicWeekly - N1,250',
    'DTHBasicWeekly - N1,550',
    'ComboBasicWeekly - N1,550'
  ];
  List<String> get startimes => _startimes;
  set startimes(List<String> value) {
    _startimes = value;
    secureStorage.setStringList('ff_startimes', value);
  }

  void deleteStartimes() {
    secureStorage.delete(key: 'ff_startimes');
  }

  void addToStartimes(String value) {
    startimes.add(value);
    secureStorage.setStringList('ff_startimes', _startimes);
  }

  void removeFromStartimes(String value) {
    startimes.remove(value);
    secureStorage.setStringList('ff_startimes', _startimes);
  }

  void removeAtIndexFromStartimes(int index) {
    startimes.removeAt(index);
    secureStorage.setStringList('ff_startimes', _startimes);
  }

  void updateStartimesAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    startimes[index] = updateFn(_startimes[index]);
    secureStorage.setStringList('ff_startimes', _startimes);
  }

  void insertAtIndexInStartimes(int index, String value) {
    startimes.insert(index, value);
    secureStorage.setStringList('ff_startimes', _startimes);
  }

  List<dynamic> _mtndataplans = [
    jsonDecode(
        '{\"productId\":\"MTN-110MB-11\",\"dataBundle\":\"110MB\",\"amount\":\"100\",\"validity\":\"1 Day\"}'),
    jsonDecode(
        '{\"productId\":\"MTN-200MB-2\",\"dataBundle\":\"230MB\",\"amount\":\"200\",\"validity\":\"1 Day\"}'),
    jsonDecode(
        '{\"productId\":\"MTN-500MB-35\",\"dataBundle\":\"500MB\",\"amount\":\"350\",\"validity\":\"1 Day\"}'),
    jsonDecode(
        '{\"productId\":\"MTN-1GB-11\",\"dataBundle\":\"1GB Daily Plan + 1.5mins.\",\"amount\":\"500\",\"validity\":\"1 Day\"}')
  ];
  List<dynamic> get mtndataplans => _mtndataplans;
  set mtndataplans(List<dynamic> value) {
    _mtndataplans = value;
    secureStorage.setStringList(
        'ff_mtndataplans', value.map((x) => jsonEncode(x)).toList());
  }

  void deleteMtndataplans() {
    secureStorage.delete(key: 'ff_mtndataplans');
  }

  void addToMtndataplans(dynamic value) {
    mtndataplans.add(value);
    secureStorage.setStringList(
        'ff_mtndataplans', _mtndataplans.map((x) => jsonEncode(x)).toList());
  }

  void removeFromMtndataplans(dynamic value) {
    mtndataplans.remove(value);
    secureStorage.setStringList(
        'ff_mtndataplans', _mtndataplans.map((x) => jsonEncode(x)).toList());
  }

  void removeAtIndexFromMtndataplans(int index) {
    mtndataplans.removeAt(index);
    secureStorage.setStringList(
        'ff_mtndataplans', _mtndataplans.map((x) => jsonEncode(x)).toList());
  }

  void updateMtndataplansAtIndex(
    int index,
    dynamic Function(dynamic) updateFn,
  ) {
    mtndataplans[index] = updateFn(_mtndataplans[index]);
    secureStorage.setStringList(
        'ff_mtndataplans', _mtndataplans.map((x) => jsonEncode(x)).toList());
  }

  void insertAtIndexInMtndataplans(int index, dynamic value) {
    mtndataplans.insert(index, value);
    secureStorage.setStringList(
        'ff_mtndataplans', _mtndataplans.map((x) => jsonEncode(x)).toList());
  }

  List<dynamic> _glodataplans = [
    jsonDecode(
        '{\"productId\":\"GLO-100MB-28\",\"dataBundle\":\"100MB\",\"amount\":\"25\",\"validity\":\"1day\"}'),
    jsonDecode(
        '{\"productId\":\"GLO-20MB-29\",\"dataBundle\":\"20MB\",\"amount\":\"25\",\"validity\":\"1day\"}'),
    jsonDecode(
        '{\"productId\":\"GLO-20MB-30\",\"dataBundle\":\"20MB\",\"amount\":\"25\",\"validity\":\"1day\"}')
  ];
  List<dynamic> get glodataplans => _glodataplans;
  set glodataplans(List<dynamic> value) {
    _glodataplans = value;
    secureStorage.setStringList(
        'ff_glodataplans', value.map((x) => jsonEncode(x)).toList());
  }

  void deleteGlodataplans() {
    secureStorage.delete(key: 'ff_glodataplans');
  }

  void addToGlodataplans(dynamic value) {
    glodataplans.add(value);
    secureStorage.setStringList(
        'ff_glodataplans', _glodataplans.map((x) => jsonEncode(x)).toList());
  }

  void removeFromGlodataplans(dynamic value) {
    glodataplans.remove(value);
    secureStorage.setStringList(
        'ff_glodataplans', _glodataplans.map((x) => jsonEncode(x)).toList());
  }

  void removeAtIndexFromGlodataplans(int index) {
    glodataplans.removeAt(index);
    secureStorage.setStringList(
        'ff_glodataplans', _glodataplans.map((x) => jsonEncode(x)).toList());
  }

  void updateGlodataplansAtIndex(
    int index,
    dynamic Function(dynamic) updateFn,
  ) {
    glodataplans[index] = updateFn(_glodataplans[index]);
    secureStorage.setStringList(
        'ff_glodataplans', _glodataplans.map((x) => jsonEncode(x)).toList());
  }

  void insertAtIndexInGlodataplans(int index, dynamic value) {
    glodataplans.insert(index, value);
    secureStorage.setStringList(
        'ff_glodataplans', _glodataplans.map((x) => jsonEncode(x)).toList());
  }

  List<dynamic> _airteldataplans = [
    jsonDecode(
        '{\"productId\":\"AIR-250MB-43\",\"dataBundle\":\"250MB\",\"amount\":\"50\",\"validity\":\"Night 12am \"}'),
    jsonDecode(
        '{\"productId\":\"AIR-40MB-1\",\"dataBundle\":\"75MB \",\"amount\":\"75\",\"validity\":\"1 Day\"}'),
    jsonDecode(
        '{\"productId\":\"AIR-100MB-2\",\"dataBundle\":\"100MB\",\"amount\":\"100\",\"validity\":\"1 Day\"}')
  ];
  List<dynamic> get airteldataplans => _airteldataplans;
  set airteldataplans(List<dynamic> value) {
    _airteldataplans = value;
    secureStorage.setStringList(
        'ff_airteldataplans', value.map((x) => jsonEncode(x)).toList());
  }

  void deleteAirteldataplans() {
    secureStorage.delete(key: 'ff_airteldataplans');
  }

  void addToAirteldataplans(dynamic value) {
    airteldataplans.add(value);
    secureStorage.setStringList('ff_airteldataplans',
        _airteldataplans.map((x) => jsonEncode(x)).toList());
  }

  void removeFromAirteldataplans(dynamic value) {
    airteldataplans.remove(value);
    secureStorage.setStringList('ff_airteldataplans',
        _airteldataplans.map((x) => jsonEncode(x)).toList());
  }

  void removeAtIndexFromAirteldataplans(int index) {
    airteldataplans.removeAt(index);
    secureStorage.setStringList('ff_airteldataplans',
        _airteldataplans.map((x) => jsonEncode(x)).toList());
  }

  void updateAirteldataplansAtIndex(
    int index,
    dynamic Function(dynamic) updateFn,
  ) {
    airteldataplans[index] = updateFn(_airteldataplans[index]);
    secureStorage.setStringList('ff_airteldataplans',
        _airteldataplans.map((x) => jsonEncode(x)).toList());
  }

  void insertAtIndexInAirteldataplans(int index, dynamic value) {
    airteldataplans.insert(index, value);
    secureStorage.setStringList('ff_airteldataplans',
        _airteldataplans.map((x) => jsonEncode(x)).toList());
  }

  List<String> _jambitem = [];
  List<String> get jambitem => _jambitem;
  set jambitem(List<String> value) {
    _jambitem = value;
    secureStorage.setStringList('ff_jambitem', value);
  }

  void deleteJambitem() {
    secureStorage.delete(key: 'ff_jambitem');
  }

  void addToJambitem(String value) {
    jambitem.add(value);
    secureStorage.setStringList('ff_jambitem', _jambitem);
  }

  void removeFromJambitem(String value) {
    jambitem.remove(value);
    secureStorage.setStringList('ff_jambitem', _jambitem);
  }

  void removeAtIndexFromJambitem(int index) {
    jambitem.removeAt(index);
    secureStorage.setStringList('ff_jambitem', _jambitem);
  }

  void updateJambitemAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    jambitem[index] = updateFn(_jambitem[index]);
    secureStorage.setStringList('ff_jambitem', _jambitem);
  }

  void insertAtIndexInJambitem(int index, String value) {
    jambitem.insert(index, value);
    secureStorage.setStringList('ff_jambitem', _jambitem);
  }

  List<String> _weacitem = [];
  List<String> get weacitem => _weacitem;
  set weacitem(List<String> value) {
    _weacitem = value;
    secureStorage.setStringList('ff_weacitem', value);
  }

  void deleteWeacitem() {
    secureStorage.delete(key: 'ff_weacitem');
  }

  void addToWeacitem(String value) {
    weacitem.add(value);
    secureStorage.setStringList('ff_weacitem', _weacitem);
  }

  void removeFromWeacitem(String value) {
    weacitem.remove(value);
    secureStorage.setStringList('ff_weacitem', _weacitem);
  }

  void removeAtIndexFromWeacitem(int index) {
    weacitem.removeAt(index);
    secureStorage.setStringList('ff_weacitem', _weacitem);
  }

  void updateWeacitemAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    weacitem[index] = updateFn(_weacitem[index]);
    secureStorage.setStringList('ff_weacitem', _weacitem);
  }

  void insertAtIndexInWeacitem(int index, String value) {
    weacitem.insert(index, value);
    secureStorage.setStringList('ff_weacitem', _weacitem);
  }

  List<String> _bankname = [];
  List<String> get bankname => _bankname;
  set bankname(List<String> value) {
    _bankname = value;
    secureStorage.setStringList('ff_bankname', value);
  }

  void deleteBankname() {
    secureStorage.delete(key: 'ff_bankname');
  }

  void addToBankname(String value) {
    bankname.add(value);
    secureStorage.setStringList('ff_bankname', _bankname);
  }

  void removeFromBankname(String value) {
    bankname.remove(value);
    secureStorage.setStringList('ff_bankname', _bankname);
  }

  void removeAtIndexFromBankname(int index) {
    bankname.removeAt(index);
    secureStorage.setStringList('ff_bankname', _bankname);
  }

  void updateBanknameAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    bankname[index] = updateFn(_bankname[index]);
    secureStorage.setStringList('ff_bankname', _bankname);
  }

  void insertAtIndexInBankname(int index, String value) {
    bankname.insert(index, value);
    secureStorage.setStringList('ff_bankname', _bankname);
  }

  List<dynamic> _jamblist = [
    jsonDecode(
        '{\"itemId\":\"UTME_MOCK\",\"itemName\":\"JAMB UTME_MOCK (N7,700)\",\"amount\":\"7700\"}'),
    jsonDecode(
        '{\"itemId\":\"UTME\",\"itemName\":\"JAMB UTME (N6,200)\",\"amount\":\"6200\"}'),
    jsonDecode(
        '{\"itemId\":\"DE\",\"itemName\":\"JAMB DE (N6,200)\",\"amount\":\"6200\"}')
  ];
  List<dynamic> get jamblist => _jamblist;
  set jamblist(List<dynamic> value) {
    _jamblist = value;
    secureStorage.setStringList(
        'ff_jamblist', value.map((x) => jsonEncode(x)).toList());
  }

  void deleteJamblist() {
    secureStorage.delete(key: 'ff_jamblist');
  }

  void addToJamblist(dynamic value) {
    jamblist.add(value);
    secureStorage.setStringList(
        'ff_jamblist', _jamblist.map((x) => jsonEncode(x)).toList());
  }

  void removeFromJamblist(dynamic value) {
    jamblist.remove(value);
    secureStorage.setStringList(
        'ff_jamblist', _jamblist.map((x) => jsonEncode(x)).toList());
  }

  void removeAtIndexFromJamblist(int index) {
    jamblist.removeAt(index);
    secureStorage.setStringList(
        'ff_jamblist', _jamblist.map((x) => jsonEncode(x)).toList());
  }

  void updateJamblistAtIndex(
    int index,
    dynamic Function(dynamic) updateFn,
  ) {
    jamblist[index] = updateFn(_jamblist[index]);
    secureStorage.setStringList(
        'ff_jamblist', _jamblist.map((x) => jsonEncode(x)).toList());
  }

  void insertAtIndexInJamblist(int index, dynamic value) {
    jamblist.insert(index, value);
    secureStorage.setStringList(
        'ff_jamblist', _jamblist.map((x) => jsonEncode(x)).toList());
  }

  List<dynamic> _weaclist = [
    jsonDecode(
        '{\"itemId\":\"WAEC GCE Form\",\"itemName\":\"WAEC GCE FORM - N18,750\",\"amount\":\"18750\"}'),
    jsonDecode(
        '{\"itemId\":\"WAEC Checker\",\"itemName\":\"WAEC CHECKER - N3,950\",\"amount\":\"3950\"}'),
    jsonDecode(
        '{\"itemId\":\"WAEC Verification\",\"itemName\":\"WAEC VERIFICATION - N4,050\",\"amount\":\"4050\"}')
  ];
  List<dynamic> get weaclist => _weaclist;
  set weaclist(List<dynamic> value) {
    _weaclist = value;
    secureStorage.setStringList(
        'ff_weaclist', value.map((x) => jsonEncode(x)).toList());
  }

  void deleteWeaclist() {
    secureStorage.delete(key: 'ff_weaclist');
  }

  void addToWeaclist(dynamic value) {
    weaclist.add(value);
    secureStorage.setStringList(
        'ff_weaclist', _weaclist.map((x) => jsonEncode(x)).toList());
  }

  void removeFromWeaclist(dynamic value) {
    weaclist.remove(value);
    secureStorage.setStringList(
        'ff_weaclist', _weaclist.map((x) => jsonEncode(x)).toList());
  }

  void removeAtIndexFromWeaclist(int index) {
    weaclist.removeAt(index);
    secureStorage.setStringList(
        'ff_weaclist', _weaclist.map((x) => jsonEncode(x)).toList());
  }

  void updateWeaclistAtIndex(
    int index,
    dynamic Function(dynamic) updateFn,
  ) {
    weaclist[index] = updateFn(_weaclist[index]);
    secureStorage.setStringList(
        'ff_weaclist', _weaclist.map((x) => jsonEncode(x)).toList());
  }

  void insertAtIndexInWeaclist(int index, dynamic value) {
    weaclist.insert(index, value);
    secureStorage.setStringList(
        'ff_weaclist', _weaclist.map((x) => jsonEncode(x)).toList());
  }

  List<dynamic> _jamb = [];
  List<dynamic> get jamb => _jamb;
  set jamb(List<dynamic> value) {
    _jamb = value;
    secureStorage.setStringList(
        'ff_jamb', value.map((x) => jsonEncode(x)).toList());
  }

  void deleteJamb() {
    secureStorage.delete(key: 'ff_jamb');
  }

  void addToJamb(dynamic value) {
    jamb.add(value);
    secureStorage.setStringList(
        'ff_jamb', _jamb.map((x) => jsonEncode(x)).toList());
  }

  void removeFromJamb(dynamic value) {
    jamb.remove(value);
    secureStorage.setStringList(
        'ff_jamb', _jamb.map((x) => jsonEncode(x)).toList());
  }

  void removeAtIndexFromJamb(int index) {
    jamb.removeAt(index);
    secureStorage.setStringList(
        'ff_jamb', _jamb.map((x) => jsonEncode(x)).toList());
  }

  void updateJambAtIndex(
    int index,
    dynamic Function(dynamic) updateFn,
  ) {
    jamb[index] = updateFn(_jamb[index]);
    secureStorage.setStringList(
        'ff_jamb', _jamb.map((x) => jsonEncode(x)).toList());
  }

  void insertAtIndexInJamb(int index, dynamic value) {
    jamb.insert(index, value);
    secureStorage.setStringList(
        'ff_jamb', _jamb.map((x) => jsonEncode(x)).toList());
  }

  List<String> _weacinput = ['customerName', 'customerId'];
  List<String> get weacinput => _weacinput;
  set weacinput(List<String> value) {
    _weacinput = value;
    secureStorage.setStringList('ff_weacinput', value);
  }

  void deleteWeacinput() {
    secureStorage.delete(key: 'ff_weacinput');
  }

  void addToWeacinput(String value) {
    weacinput.add(value);
    secureStorage.setStringList('ff_weacinput', _weacinput);
  }

  void removeFromWeacinput(String value) {
    weacinput.remove(value);
    secureStorage.setStringList('ff_weacinput', _weacinput);
  }

  void removeAtIndexFromWeacinput(int index) {
    weacinput.removeAt(index);
    secureStorage.setStringList('ff_weacinput', _weacinput);
  }

  void updateWeacinputAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    weacinput[index] = updateFn(_weacinput[index]);
    secureStorage.setStringList('ff_weacinput', _weacinput);
  }

  void insertAtIndexInWeacinput(int index, String value) {
    weacinput.insert(index, value);
    secureStorage.setStringList('ff_weacinput', _weacinput);
  }

  List<String> _waecdescription = [
    'Candidate\'s Fullname',
    'Candidate\'s Phone Number'
  ];
  List<String> get waecdescription => _waecdescription;
  set waecdescription(List<String> value) {
    _waecdescription = value;
    secureStorage.setStringList('ff_waecdescription', value);
  }

  void deleteWaecdescription() {
    secureStorage.delete(key: 'ff_waecdescription');
  }

  void addToWaecdescription(String value) {
    waecdescription.add(value);
    secureStorage.setStringList('ff_waecdescription', _waecdescription);
  }

  void removeFromWaecdescription(String value) {
    waecdescription.remove(value);
    secureStorage.setStringList('ff_waecdescription', _waecdescription);
  }

  void removeAtIndexFromWaecdescription(int index) {
    waecdescription.removeAt(index);
    secureStorage.setStringList('ff_waecdescription', _waecdescription);
  }

  void updateWaecdescriptionAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    waecdescription[index] = updateFn(_waecdescription[index]);
    secureStorage.setStringList('ff_waecdescription', _waecdescription);
  }

  void insertAtIndexInWaecdescription(int index, String value) {
    waecdescription.insert(index, value);
    secureStorage.setStringList('ff_waecdescription', _waecdescription);
  }

  List<String> _weacitems = [
    'WAEC GCE FORM - N18,750',
    'WAEC CHECKER - N3,950',
    'WAEC VERIFICATION - N4,050'
  ];
  List<String> get weacitems => _weacitems;
  set weacitems(List<String> value) {
    _weacitems = value;
    secureStorage.setStringList('ff_weacitems', value);
  }

  void deleteWeacitems() {
    secureStorage.delete(key: 'ff_weacitems');
  }

  void addToWeacitems(String value) {
    weacitems.add(value);
    secureStorage.setStringList('ff_weacitems', _weacitems);
  }

  void removeFromWeacitems(String value) {
    weacitems.remove(value);
    secureStorage.setStringList('ff_weacitems', _weacitems);
  }

  void removeAtIndexFromWeacitems(int index) {
    weacitems.removeAt(index);
    secureStorage.setStringList('ff_weacitems', _weacitems);
  }

  void updateWeacitemsAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    weacitems[index] = updateFn(_weacitems[index]);
    secureStorage.setStringList('ff_weacitems', _weacitems);
  }

  void insertAtIndexInWeacitems(int index, String value) {
    weacitems.insert(index, value);
    secureStorage.setStringList('ff_weacitems', _weacitems);
  }

  List<String> _jambinput = ['customerId', 'email', 'phone'];
  List<String> get jambinput => _jambinput;
  set jambinput(List<String> value) {
    _jambinput = value;
    secureStorage.setStringList('ff_jambinput', value);
  }

  void deleteJambinput() {
    secureStorage.delete(key: 'ff_jambinput');
  }

  void addToJambinput(String value) {
    jambinput.add(value);
    secureStorage.setStringList('ff_jambinput', _jambinput);
  }

  void removeFromJambinput(String value) {
    jambinput.remove(value);
    secureStorage.setStringList('ff_jambinput', _jambinput);
  }

  void removeAtIndexFromJambinput(int index) {
    jambinput.removeAt(index);
    secureStorage.setStringList('ff_jambinput', _jambinput);
  }

  void updateJambinputAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    jambinput[index] = updateFn(_jambinput[index]);
    secureStorage.setStringList('ff_jambinput', _jambinput);
  }

  void insertAtIndexInJambinput(int index, String value) {
    jambinput.insert(index, value);
    secureStorage.setStringList('ff_jambinput', _jambinput);
  }

  List<String> _jambdescription = [
    'Candidate\'s Jamb Code',
    'Candidate\'s Email',
    'Candidate\'s Phone Number'
  ];
  List<String> get jambdescription => _jambdescription;
  set jambdescription(List<String> value) {
    _jambdescription = value;
    secureStorage.setStringList('ff_jambdescription', value);
  }

  void deleteJambdescription() {
    secureStorage.delete(key: 'ff_jambdescription');
  }

  void addToJambdescription(String value) {
    jambdescription.add(value);
    secureStorage.setStringList('ff_jambdescription', _jambdescription);
  }

  void removeFromJambdescription(String value) {
    jambdescription.remove(value);
    secureStorage.setStringList('ff_jambdescription', _jambdescription);
  }

  void removeAtIndexFromJambdescription(int index) {
    jambdescription.removeAt(index);
    secureStorage.setStringList('ff_jambdescription', _jambdescription);
  }

  void updateJambdescriptionAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    jambdescription[index] = updateFn(_jambdescription[index]);
    secureStorage.setStringList('ff_jambdescription', _jambdescription);
  }

  void insertAtIndexInJambdescription(int index, String value) {
    jambdescription.insert(index, value);
    secureStorage.setStringList('ff_jambdescription', _jambdescription);
  }

  List<String> _jambitems = [
    'JAMB UTME_MOCK (N7,700)',
    'JAMB UTME (N6,200)',
    'JAMB DE (N6,200)'
  ];
  List<String> get jambitems => _jambitems;
  set jambitems(List<String> value) {
    _jambitems = value;
    secureStorage.setStringList('ff_jambitems', value);
  }

  void deleteJambitems() {
    secureStorage.delete(key: 'ff_jambitems');
  }

  void addToJambitems(String value) {
    jambitems.add(value);
    secureStorage.setStringList('ff_jambitems', _jambitems);
  }

  void removeFromJambitems(String value) {
    jambitems.remove(value);
    secureStorage.setStringList('ff_jambitems', _jambitems);
  }

  void removeAtIndexFromJambitems(int index) {
    jambitems.removeAt(index);
    secureStorage.setStringList('ff_jambitems', _jambitems);
  }

  void updateJambitemsAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    jambitems[index] = updateFn(_jambitems[index]);
    secureStorage.setStringList('ff_jambitems', _jambitems);
  }

  void insertAtIndexInJambitems(int index, String value) {
    jambitems.insert(index, value);
    secureStorage.setStringList('ff_jambitems', _jambitems);
  }

  double _examprogress = 0.0;
  double get examprogress => _examprogress;
  set examprogress(double value) {
    _examprogress = value;
    secureStorage.setDouble('ff_examprogress', value);
  }

  void deleteExamprogress() {
    secureStorage.delete(key: 'ff_examprogress');
  }

  List<String> _internetitems = [];
  List<String> get internetitems => _internetitems;
  set internetitems(List<String> value) {
    _internetitems = value;
    secureStorage.setStringList('ff_internetitems', value);
  }

  void deleteInternetitems() {
    secureStorage.delete(key: 'ff_internetitems');
  }

  void addToInternetitems(String value) {
    internetitems.add(value);
    secureStorage.setStringList('ff_internetitems', _internetitems);
  }

  void removeFromInternetitems(String value) {
    internetitems.remove(value);
    secureStorage.setStringList('ff_internetitems', _internetitems);
  }

  void removeAtIndexFromInternetitems(int index) {
    internetitems.removeAt(index);
    secureStorage.setStringList('ff_internetitems', _internetitems);
  }

  void updateInternetitemsAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    internetitems[index] = updateFn(_internetitems[index]);
    secureStorage.setStringList('ff_internetitems', _internetitems);
  }

  void insertAtIndexInInternetitems(int index, String value) {
    internetitems.insert(index, value);
    secureStorage.setStringList('ff_internetitems', _internetitems);
  }

  int _pendinglist = 0;
  int get pendinglist => _pendinglist;
  set pendinglist(int value) {
    _pendinglist = value;
    secureStorage.setInt('ff_pendinglist', value);
  }

  void deletePendinglist() {
    secureStorage.delete(key: 'ff_pendinglist');
  }

  List<String> _lottocode = [];
  List<String> get lottocode => _lottocode;
  set lottocode(List<String> value) {
    _lottocode = value;
    secureStorage.setStringList('ff_lottocode', value);
  }

  void deleteLottocode() {
    secureStorage.delete(key: 'ff_lottocode');
  }

  void addToLottocode(String value) {
    lottocode.add(value);
    secureStorage.setStringList('ff_lottocode', _lottocode);
  }

  void removeFromLottocode(String value) {
    lottocode.remove(value);
    secureStorage.setStringList('ff_lottocode', _lottocode);
  }

  void removeAtIndexFromLottocode(int index) {
    lottocode.removeAt(index);
    secureStorage.setStringList('ff_lottocode', _lottocode);
  }

  void updateLottocodeAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    lottocode[index] = updateFn(_lottocode[index]);
    secureStorage.setStringList('ff_lottocode', _lottocode);
  }

  void insertAtIndexInLottocode(int index, String value) {
    lottocode.insert(index, value);
    secureStorage.setStringList('ff_lottocode', _lottocode);
  }

  List<String> _SPECTRANETITEMS = ['SPECTRANET-10X (N1,000)', 'Hello World'];
  List<String> get SPECTRANETITEMS => _SPECTRANETITEMS;
  set SPECTRANETITEMS(List<String> value) {
    _SPECTRANETITEMS = value;
    secureStorage.setStringList('ff_SPECTRANETITEMS', value);
  }

  void deleteSPECTRANETITEMS() {
    secureStorage.delete(key: 'ff_SPECTRANETITEMS');
  }

  void addToSPECTRANETITEMS(String value) {
    SPECTRANETITEMS.add(value);
    secureStorage.setStringList('ff_SPECTRANETITEMS', _SPECTRANETITEMS);
  }

  void removeFromSPECTRANETITEMS(String value) {
    SPECTRANETITEMS.remove(value);
    secureStorage.setStringList('ff_SPECTRANETITEMS', _SPECTRANETITEMS);
  }

  void removeAtIndexFromSPECTRANETITEMS(int index) {
    SPECTRANETITEMS.removeAt(index);
    secureStorage.setStringList('ff_SPECTRANETITEMS', _SPECTRANETITEMS);
  }

  void updateSPECTRANETITEMSAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    SPECTRANETITEMS[index] = updateFn(_SPECTRANETITEMS[index]);
    secureStorage.setStringList('ff_SPECTRANETITEMS', _SPECTRANETITEMS);
  }

  void insertAtIndexInSPECTRANETITEMS(int index, String value) {
    SPECTRANETITEMS.insert(index, value);
    secureStorage.setStringList('ff_SPECTRANETITEMS', _SPECTRANETITEMS);
  }

  List<String> _SMILEITEMS = [
    '1GB 1DAY - N300',
    '2.5GB 1DAY - N500',
    '1GB 1WEEK - N500'
  ];
  List<String> get SMILEITEMS => _SMILEITEMS;
  set SMILEITEMS(List<String> value) {
    _SMILEITEMS = value;
    secureStorage.setStringList('ff_SMILEITEMS', value);
  }

  void deleteSMILEITEMS() {
    secureStorage.delete(key: 'ff_SMILEITEMS');
  }

  void addToSMILEITEMS(String value) {
    SMILEITEMS.add(value);
    secureStorage.setStringList('ff_SMILEITEMS', _SMILEITEMS);
  }

  void removeFromSMILEITEMS(String value) {
    SMILEITEMS.remove(value);
    secureStorage.setStringList('ff_SMILEITEMS', _SMILEITEMS);
  }

  void removeAtIndexFromSMILEITEMS(int index) {
    SMILEITEMS.removeAt(index);
    secureStorage.setStringList('ff_SMILEITEMS', _SMILEITEMS);
  }

  void updateSMILEITEMSAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    SMILEITEMS[index] = updateFn(_SMILEITEMS[index]);
    secureStorage.setStringList('ff_SMILEITEMS', _SMILEITEMS);
  }

  void insertAtIndexInSMILEITEMS(int index, String value) {
    SMILEITEMS.insert(index, value);
    secureStorage.setStringList('ff_SMILEITEMS', _SMILEITEMS);
  }

  List<String> _winners = [];
  List<String> get winners => _winners;
  set winners(List<String> value) {
    _winners = value;
    secureStorage.setStringList('ff_winners', value);
  }

  void deleteWinners() {
    secureStorage.delete(key: 'ff_winners');
  }

  void addToWinners(String value) {
    winners.add(value);
    secureStorage.setStringList('ff_winners', _winners);
  }

  void removeFromWinners(String value) {
    winners.remove(value);
    secureStorage.setStringList('ff_winners', _winners);
  }

  void removeAtIndexFromWinners(int index) {
    winners.removeAt(index);
    secureStorage.setStringList('ff_winners', _winners);
  }

  void updateWinnersAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    winners[index] = updateFn(_winners[index]);
    secureStorage.setStringList('ff_winners', _winners);
  }

  void insertAtIndexInWinners(int index, String value) {
    winners.insert(index, value);
    secureStorage.setStringList('ff_winners', _winners);
  }

  List<dynamic> _jobprofiles = [];
  List<dynamic> get jobprofiles => _jobprofiles;
  set jobprofiles(List<dynamic> value) {
    _jobprofiles = value;
    secureStorage.setStringList(
        'ff_jobprofiles', value.map((x) => jsonEncode(x)).toList());
  }

  void deleteJobprofiles() {
    secureStorage.delete(key: 'ff_jobprofiles');
  }

  void addToJobprofiles(dynamic value) {
    jobprofiles.add(value);
    secureStorage.setStringList(
        'ff_jobprofiles', _jobprofiles.map((x) => jsonEncode(x)).toList());
  }

  void removeFromJobprofiles(dynamic value) {
    jobprofiles.remove(value);
    secureStorage.setStringList(
        'ff_jobprofiles', _jobprofiles.map((x) => jsonEncode(x)).toList());
  }

  void removeAtIndexFromJobprofiles(int index) {
    jobprofiles.removeAt(index);
    secureStorage.setStringList(
        'ff_jobprofiles', _jobprofiles.map((x) => jsonEncode(x)).toList());
  }

  void updateJobprofilesAtIndex(
    int index,
    dynamic Function(dynamic) updateFn,
  ) {
    jobprofiles[index] = updateFn(_jobprofiles[index]);
    secureStorage.setStringList(
        'ff_jobprofiles', _jobprofiles.map((x) => jsonEncode(x)).toList());
  }

  void insertAtIndexInJobprofiles(int index, dynamic value) {
    jobprofiles.insert(index, value);
    secureStorage.setStringList(
        'ff_jobprofiles', _jobprofiles.map((x) => jsonEncode(x)).toList());
  }

  List<String> _listofjobphones = [];
  List<String> get listofjobphones => _listofjobphones;
  set listofjobphones(List<String> value) {
    _listofjobphones = value;
    secureStorage.setStringList('ff_listofjobphones', value);
  }

  void deleteListofjobphones() {
    secureStorage.delete(key: 'ff_listofjobphones');
  }

  void addToListofjobphones(String value) {
    listofjobphones.add(value);
    secureStorage.setStringList('ff_listofjobphones', _listofjobphones);
  }

  void removeFromListofjobphones(String value) {
    listofjobphones.remove(value);
    secureStorage.setStringList('ff_listofjobphones', _listofjobphones);
  }

  void removeAtIndexFromListofjobphones(int index) {
    listofjobphones.removeAt(index);
    secureStorage.setStringList('ff_listofjobphones', _listofjobphones);
  }

  void updateListofjobphonesAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    listofjobphones[index] = updateFn(_listofjobphones[index]);
    secureStorage.setStringList('ff_listofjobphones', _listofjobphones);
  }

  void insertAtIndexInListofjobphones(int index, String value) {
    listofjobphones.insert(index, value);
    secureStorage.setStringList('ff_listofjobphones', _listofjobphones);
  }

  List<dynamic> _securehistory = [];
  List<dynamic> get securehistory => _securehistory;
  set securehistory(List<dynamic> value) {
    _securehistory = value;
    secureStorage.setStringList(
        'ff_securehistory', value.map((x) => jsonEncode(x)).toList());
  }

  void deleteSecurehistory() {
    secureStorage.delete(key: 'ff_securehistory');
  }

  void addToSecurehistory(dynamic value) {
    securehistory.add(value);
    secureStorage.setStringList(
        'ff_securehistory', _securehistory.map((x) => jsonEncode(x)).toList());
  }

  void removeFromSecurehistory(dynamic value) {
    securehistory.remove(value);
    secureStorage.setStringList(
        'ff_securehistory', _securehistory.map((x) => jsonEncode(x)).toList());
  }

  void removeAtIndexFromSecurehistory(int index) {
    securehistory.removeAt(index);
    secureStorage.setStringList(
        'ff_securehistory', _securehistory.map((x) => jsonEncode(x)).toList());
  }

  void updateSecurehistoryAtIndex(
    int index,
    dynamic Function(dynamic) updateFn,
  ) {
    securehistory[index] = updateFn(_securehistory[index]);
    secureStorage.setStringList(
        'ff_securehistory', _securehistory.map((x) => jsonEncode(x)).toList());
  }

  void insertAtIndexInSecurehistory(int index, dynamic value) {
    securehistory.insert(index, value);
    secureStorage.setStringList(
        'ff_securehistory', _securehistory.map((x) => jsonEncode(x)).toList());
  }

  String _sessionid = '';
  String get sessionid => _sessionid;
  set sessionid(String value) {
    _sessionid = value;
    secureStorage.setString('ff_sessionid', value);
  }

  void deleteSessionid() {
    secureStorage.delete(key: 'ff_sessionid');
  }

  List<String> _pinphones = [];
  List<String> get pinphones => _pinphones;
  set pinphones(List<String> value) {
    _pinphones = value;
    secureStorage.setStringList('ff_pinphones', value);
  }

  void deletePinphones() {
    secureStorage.delete(key: 'ff_pinphones');
  }

  void addToPinphones(String value) {
    pinphones.add(value);
    secureStorage.setStringList('ff_pinphones', _pinphones);
  }

  void removeFromPinphones(String value) {
    pinphones.remove(value);
    secureStorage.setStringList('ff_pinphones', _pinphones);
  }

  void removeAtIndexFromPinphones(int index) {
    pinphones.removeAt(index);
    secureStorage.setStringList('ff_pinphones', _pinphones);
  }

  void updatePinphonesAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    pinphones[index] = updateFn(_pinphones[index]);
    secureStorage.setStringList('ff_pinphones', _pinphones);
  }

  void insertAtIndexInPinphones(int index, String value) {
    pinphones.insert(index, value);
    secureStorage.setStringList('ff_pinphones', _pinphones);
  }

  List<dynamic> _receivedbilled = [];
  List<dynamic> get receivedbilled => _receivedbilled;
  set receivedbilled(List<dynamic> value) {
    _receivedbilled = value;
    secureStorage.setStringList(
        'ff_receivedbilled', value.map((x) => jsonEncode(x)).toList());
  }

  void deleteReceivedbilled() {
    secureStorage.delete(key: 'ff_receivedbilled');
  }

  void addToReceivedbilled(dynamic value) {
    receivedbilled.add(value);
    secureStorage.setStringList('ff_receivedbilled',
        _receivedbilled.map((x) => jsonEncode(x)).toList());
  }

  void removeFromReceivedbilled(dynamic value) {
    receivedbilled.remove(value);
    secureStorage.setStringList('ff_receivedbilled',
        _receivedbilled.map((x) => jsonEncode(x)).toList());
  }

  void removeAtIndexFromReceivedbilled(int index) {
    receivedbilled.removeAt(index);
    secureStorage.setStringList('ff_receivedbilled',
        _receivedbilled.map((x) => jsonEncode(x)).toList());
  }

  void updateReceivedbilledAtIndex(
    int index,
    dynamic Function(dynamic) updateFn,
  ) {
    receivedbilled[index] = updateFn(_receivedbilled[index]);
    secureStorage.setStringList('ff_receivedbilled',
        _receivedbilled.map((x) => jsonEncode(x)).toList());
  }

  void insertAtIndexInReceivedbilled(int index, dynamic value) {
    receivedbilled.insert(index, value);
    secureStorage.setStringList('ff_receivedbilled',
        _receivedbilled.map((x) => jsonEncode(x)).toList());
  }

  List<dynamic> _sentbills = [];
  List<dynamic> get sentbills => _sentbills;
  set sentbills(List<dynamic> value) {
    _sentbills = value;
    secureStorage.setStringList(
        'ff_sentbills', value.map((x) => jsonEncode(x)).toList());
  }

  void deleteSentbills() {
    secureStorage.delete(key: 'ff_sentbills');
  }

  void addToSentbills(dynamic value) {
    sentbills.add(value);
    secureStorage.setStringList(
        'ff_sentbills', _sentbills.map((x) => jsonEncode(x)).toList());
  }

  void removeFromSentbills(dynamic value) {
    sentbills.remove(value);
    secureStorage.setStringList(
        'ff_sentbills', _sentbills.map((x) => jsonEncode(x)).toList());
  }

  void removeAtIndexFromSentbills(int index) {
    sentbills.removeAt(index);
    secureStorage.setStringList(
        'ff_sentbills', _sentbills.map((x) => jsonEncode(x)).toList());
  }

  void updateSentbillsAtIndex(
    int index,
    dynamic Function(dynamic) updateFn,
  ) {
    sentbills[index] = updateFn(_sentbills[index]);
    secureStorage.setStringList(
        'ff_sentbills', _sentbills.map((x) => jsonEncode(x)).toList());
  }

  void insertAtIndexInSentbills(int index, dynamic value) {
    sentbills.insert(index, value);
    secureStorage.setStringList(
        'ff_sentbills', _sentbills.map((x) => jsonEncode(x)).toList());
  }

  List<String> _guestprofile = [];
  List<String> get guestprofile => _guestprofile;
  set guestprofile(List<String> value) {
    _guestprofile = value;
    secureStorage.setStringList('ff_guestprofile', value);
  }

  void deleteGuestprofile() {
    secureStorage.delete(key: 'ff_guestprofile');
  }

  void addToGuestprofile(String value) {
    guestprofile.add(value);
    secureStorage.setStringList('ff_guestprofile', _guestprofile);
  }

  void removeFromGuestprofile(String value) {
    guestprofile.remove(value);
    secureStorage.setStringList('ff_guestprofile', _guestprofile);
  }

  void removeAtIndexFromGuestprofile(int index) {
    guestprofile.removeAt(index);
    secureStorage.setStringList('ff_guestprofile', _guestprofile);
  }

  void updateGuestprofileAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    guestprofile[index] = updateFn(_guestprofile[index]);
    secureStorage.setStringList('ff_guestprofile', _guestprofile);
  }

  void insertAtIndexInGuestprofile(int index, String value) {
    guestprofile.insert(index, value);
    secureStorage.setStringList('ff_guestprofile', _guestprofile);
  }

  List<String> _hostprofile = [];
  List<String> get hostprofile => _hostprofile;
  set hostprofile(List<String> value) {
    _hostprofile = value;
    secureStorage.setStringList('ff_hostprofile', value);
  }

  void deleteHostprofile() {
    secureStorage.delete(key: 'ff_hostprofile');
  }

  void addToHostprofile(String value) {
    hostprofile.add(value);
    secureStorage.setStringList('ff_hostprofile', _hostprofile);
  }

  void removeFromHostprofile(String value) {
    hostprofile.remove(value);
    secureStorage.setStringList('ff_hostprofile', _hostprofile);
  }

  void removeAtIndexFromHostprofile(int index) {
    hostprofile.removeAt(index);
    secureStorage.setStringList('ff_hostprofile', _hostprofile);
  }

  void updateHostprofileAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    hostprofile[index] = updateFn(_hostprofile[index]);
    secureStorage.setStringList('ff_hostprofile', _hostprofile);
  }

  void insertAtIndexInHostprofile(int index, String value) {
    hostprofile.insert(index, value);
    secureStorage.setStringList('ff_hostprofile', _hostprofile);
  }

  dynamic _allbankjson;
  dynamic get allbankjson => _allbankjson;
  set allbankjson(dynamic value) {
    _allbankjson = value;
    secureStorage.setString('ff_allbankjson', jsonEncode(value));
  }

  void deleteAllbankjson() {
    secureStorage.delete(key: 'ff_allbankjson');
  }

  bool _hidebal = false;
  bool get hidebal => _hidebal;
  set hidebal(bool value) {
    _hidebal = value;
    secureStorage.setBool('ff_hidebal', value);
  }

  void deleteHidebal() {
    secureStorage.delete(key: 'ff_hidebal');
  }

  bool _voiceAnnouncementsActivated = false;
  bool get voiceAnnouncementsActivated => _voiceAnnouncementsActivated;
  set voiceAnnouncementsActivated(bool value) {
    _voiceAnnouncementsActivated = value;
    _disableVoiceBalance = !value;
    secureStorage.setBool('ff_voiceAnnouncementsActivated', value);
    secureStorage.setBool('ff_disableVoiceBalance', !value);
  }

  bool _disableVoiceBalance = true;
  bool get disableVoiceBalance => _disableVoiceBalance;
  set disableVoiceBalance(bool value) {
    _disableVoiceBalance = value;
    _voiceAnnouncementsActivated = !value;
    secureStorage.setBool('ff_voiceAnnouncementsActivated', !value);
    secureStorage.setBool('ff_disableVoiceBalance', value);
  }

  void deleteDisableVoiceBalance() {
    _disableVoiceBalance = true;
    _voiceAnnouncementsActivated = false;
    secureStorage.delete(key: 'ff_disableVoiceBalance');
    secureStorage.delete(key: 'ff_voiceAnnouncementsActivated');
  }


  String _tempid = '';
  String get tempid => _tempid;
  set tempid(String value) {
    _tempid = value;
    secureStorage.setString('ff_tempid', value);
  }

  void deleteTempid() {
    secureStorage.delete(key: 'ff_tempid');
  }

  String _deviceid = 'testing';
  String get deviceid => _deviceid;
  set deviceid(String value) {
    _deviceid = value;
    secureStorage.setString('ff_deviceid', value);
  }

  void deleteDeviceid() {
    secureStorage.delete(key: 'ff_deviceid');
  }

  String _sendaccount = '';
  String get sendaccount => _sendaccount;
  set sendaccount(String value) {
    _sendaccount = value;
  }

  String _news = '';
  String get news => _news;
  set news(String value) {
    _news = value;
    secureStorage.setString('ff_news', value);
  }

  void deleteNews() {
    secureStorage.delete(key: 'ff_news');
  }

  String _cachedFcmToken = '';
  String get cachedFcmToken => _cachedFcmToken;
  set cachedFcmToken(String value) {
    _cachedFcmToken = value;
    secureStorage.setString('ff_cachedFcmToken', value);
  }

  void deleteCachedFcmToken() {
    secureStorage.delete(key: 'ff_cachedFcmToken');
  }

  String _pendingRoute = '';
  String get pendingRoute => _pendingRoute;
  set pendingRoute(String value) {
    _pendingRoute = value;
    secureStorage.setString('ff_pendingRoute', value);
  }

  void deletePendingRoute() {
    secureStorage.delete(key: 'ff_pendingRoute');
  }

  String _pendingId = '';
  String get pendingId => _pendingId;
  set pendingId(String value) {
    _pendingId = value;
    secureStorage.setString('ff_pendingId', value);
  }

  void deletePendingId() {
    secureStorage.delete(key: 'ff_pendingId');
  }

  String _pendingNextPage = 'transactionHistory';
  String get pendingNextPage => _pendingNextPage;
  set pendingNextPage(String value) {
    _pendingNextPage = value;
    secureStorage.setString('ff_pendingNextPage', value);
  }

  void deletePendingNextPage() {
    secureStorage.delete(key: 'ff_pendingNextPage');
  }

  String _whatsapp = '';
  String get whatsapp => _whatsapp;
  set whatsapp(String value) {
    _whatsapp = value;
    secureStorage.setString('ff_whatsapp', value);
  }

  void deleteWhatsapp() {
    secureStorage.delete(key: 'ff_whatsapp');
  }

  String _password = '';
  String get password => _password;
  set password(String value) {
    _password = value;
    secureStorage.setString('ff_password', value);
  }

  void deletePassword() {
    secureStorage.delete(key: 'ff_password');
  }

  bool _updatereq = false;
  bool get updatereq => _updatereq;
  set updatereq(bool value) {
    _updatereq = value;
    secureStorage.setBool('ff_updatereq', value);
  }

  void deleteUpdatereq() {
    secureStorage.delete(key: 'ff_updatereq');
  }

  String _signature = '';
  String get signature => _signature;
  set signature(String value) {
    _signature = value;
    secureStorage.setString('ff_signature', value);
  }

  void deleteSignature() {
    secureStorage.delete(key: 'ff_signature');
  }

  String _userState = '';
  String get userState => _userState;
  set userState(String value) {
    _userState = value;
    secureStorage.setString('ff_userState', value);
  }

  String _userCity = '';
  String get userCity => _userCity;
  set userCity(String value) {
    _userCity = value;
    secureStorage.setString('ff_userCity', value);
  }

  String _userLGA = '';
  String get userLGA => _userLGA;
  set userLGA(String value) {
    _userLGA = value;
    secureStorage.setString('ff_userLGA', value);
  }

  String _userStreet = '';
  String get userStreet => _userStreet;
  set userStreet(String value) {
    _userStreet = value;
    secureStorage.setString('ff_userStreet', value);
  }

  String _userHouseNo = '';
  String get userHouseNo => _userHouseNo;
  set userHouseNo(String value) {
    _userHouseNo = value;
    secureStorage.setString('ff_userHouseNo', value);
  }

  String _userLandmark = '';
  String get userLandmark => _userLandmark;
  set userLandmark(String value) {
    _userLandmark = value;
    secureStorage.setString('ff_userLandmark', value);
  }

  String _userLandmarkDesc = '';
  String get userLandmarkDesc => _userLandmarkDesc;
  set userLandmarkDesc(String value) {
    _userLandmarkDesc = value;
    secureStorage.setString('ff_userLandmarkDesc', value);
  }

  String _userBusStop = '';
  String get userBusStop => _userBusStop;
  set userBusStop(String value) {
    _userBusStop = value;
    secureStorage.setString('ff_userBusStop', value);
  }

  String _userFillingStation = '';
  String get userFillingStation => _userFillingStation;
  set userFillingStation(String value) {
    _userFillingStation = value;
    secureStorage.setString('ff_userFillingStation', value);
  }

  String _userNearestBuilding = '';
  String get userNearestBuilding => _userNearestBuilding;
  set userNearestBuilding(String value) {
    _userNearestBuilding = value;
    secureStorage.setString('ff_userNearestBuilding', value);
  }

  String _userHouseColor = '';
  String get userHouseColor => _userHouseColor;
  set userHouseColor(String value) {
    _userHouseColor = value;
    secureStorage.setString('ff_userHouseColor', value);
  }

  String _userRouteDesc = '';
  String get userRouteDesc => _userRouteDesc;
  set userRouteDesc(String value) {
    _userRouteDesc = value;
    secureStorage.setString('ff_userRouteDesc', value);
  }

  String _userBVN = '';
  String get userBVN => _userBVN;
  set userBVN(String value) {
    _userBVN = value;
    secureStorage.setString('ff_userBVN', value);
  }

  String _userNIN = '';
  String get userNIN => _userNIN;
  set userNIN(String value) {
    _userNIN = value;
    secureStorage.setString('ff_userNIN', value);
  }

  void deleteUserNIN() {
    secureStorage.delete(key: 'ff_userNIN');
  }

  String _userPEP = '';
  String get userPEP => _userPEP;
  set userPEP(String value) {
    _userPEP = value;
    secureStorage.setString('ff_userPEP', value);
  }

  void deleteUserPEP() {
    secureStorage.delete(key: 'ff_userPEP');
  }

  String _userIdType = '';
  String get userIdType => _userIdType;
  set userIdType(String value) {
    _userIdType = value;
    secureStorage.setString('ff_userIdType', value);
  }

  void deleteUserIdType() {
    secureStorage.delete(key: 'ff_userIdType');
  }

  String _userIdIssueDate = '';
  String get userIdIssueDate => _userIdIssueDate;
  set userIdIssueDate(String value) {
    _userIdIssueDate = value;
    secureStorage.setString('ff_userIdIssueDate', value);
  }

  void deleteUserIdIssueDate() {
    secureStorage.delete(key: 'ff_userIdIssueDate');
  }

  String _userGender = '';
  String get userGender => _userGender;
  set userGender(String value) {
    _userGender = value;
    secureStorage.setString('ff_userGender', value);
  }

  void deleteUserGender() {
    secureStorage.delete(key: 'ff_userGender');
  }

  String _userDOB = '';
  String get userDOB => _userDOB;
  set userDOB(String value) {
    _userDOB = value;
    secureStorage.setString('ff_userDOB', value);
  }

  void deleteUserDOB() {
    secureStorage.delete(key: 'ff_userDOB');
  }

  bool _uploadtoggle = false;
  bool get uploadtoggle => _uploadtoggle;
  set uploadtoggle(bool value) {
    _uploadtoggle = value;
  }

  List<dynamic> _nearbylist = [];
  List<dynamic> get nearbylist => _nearbylist;
  set nearbylist(List<dynamic> value) {
    _nearbylist = value;
    secureStorage.setStringList(
        'ff_nearbylist', value.map((x) => jsonEncode(x)).toList());
  }

  void deleteNearbylist() {
    secureStorage.delete(key: 'ff_nearbylist');
  }

  void addToNearbylist(dynamic value) {
    nearbylist.add(value);
    secureStorage.setStringList(
        'ff_nearbylist', _nearbylist.map((x) => jsonEncode(x)).toList());
  }

  void removeFromNearbylist(dynamic value) {
    nearbylist.remove(value);
    secureStorage.setStringList(
        'ff_nearbylist', _nearbylist.map((x) => jsonEncode(x)).toList());
  }

  void removeAtIndexFromNearbylist(int index) {
    nearbylist.removeAt(index);
    secureStorage.setStringList(
        'ff_nearbylist', _nearbylist.map((x) => jsonEncode(x)).toList());
  }

  void updateNearbylistAtIndex(
    int index,
    dynamic Function(dynamic) updateFn,
  ) {
    nearbylist[index] = updateFn(_nearbylist[index]);
    secureStorage.setStringList(
        'ff_nearbylist', _nearbylist.map((x) => jsonEncode(x)).toList());
  }

  void insertAtIndexInNearbylist(int index, dynamic value) {
    nearbylist.insert(index, value);
    secureStorage.setStringList(
        'ff_nearbylist', _nearbylist.map((x) => jsonEncode(x)).toList());
  }

  bool _discoverme = false;
  bool get discoverme => _discoverme;
  set discoverme(bool value) {
    _discoverme = value;
    secureStorage.setBool('ff_discoverme', value);
  }

  void deleteDiscoverme() {
    secureStorage.delete(key: 'ff_discoverme');
  }
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}

Color? _colorFromIntValue(int? val) {
  if (val == null) {
    return null;
  }
  return Color(val);
}

extension FlutterSecureStorageExtensions on FlutterSecureStorage {
  static final _lock = Lock();

  Future<void> writeSync({required String key, String? value}) async =>
      await _lock.synchronized(() async {
        await write(key: key, value: value);
      });

  void remove(String key) => delete(key: key);

  Future<String?> getString(String key) async => await read(key: key);
  Future<void> setString(String key, String value) async =>
      await writeSync(key: key, value: value);

  Future<bool?> getBool(String key) async => (await read(key: key)) == 'true';
  Future<void> setBool(String key, bool value) async =>
      await writeSync(key: key, value: value.toString());

  Future<int?> getInt(String key) async =>
      int.tryParse(await read(key: key) ?? '');
  Future<void> setInt(String key, int value) async =>
      await writeSync(key: key, value: value.toString());

  Future<double?> getDouble(String key) async =>
      double.tryParse(await read(key: key) ?? '');
  Future<void> setDouble(String key, double value) async =>
      await writeSync(key: key, value: value.toString());

  Future<List<String>?> getStringList(String key) async =>
      await read(key: key).then((result) {
        if (result == null || result.isEmpty) {
          return null;
        }
        return CsvToListConverter()
            .convert(result)
            .first
            .map((e) => e.toString())
            .toList();
      });
  Future<void> setStringList(String key, List<String> value) async =>
      await writeSync(key: key, value: ListToCsvConverter().convert([value]));
}
