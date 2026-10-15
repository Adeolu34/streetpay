// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class LatlangStruct extends BaseStruct {
  LatlangStruct({
    double? lat,
    double? lang,
  })  : _lat = lat,
        _lang = lang;

  // "lat" field.
  double? _lat;
  double get lat => _lat ?? 0.0;
  set lat(double? val) => _lat = val;

  void incrementLat(double amount) => lat = lat + amount;

  bool hasLat() => _lat != null;

  // "lang" field.
  double? _lang;
  double get lang => _lang ?? 0.0;
  set lang(double? val) => _lang = val;

  void incrementLang(double amount) => lang = lang + amount;

  bool hasLang() => _lang != null;

  static LatlangStruct fromMap(Map<String, dynamic> data) => LatlangStruct(
        lat: castToType<double>(data['lat']),
        lang: castToType<double>(data['lang']),
      );

  static LatlangStruct? maybeFromMap(dynamic data) =>
      data is Map ? LatlangStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'lat': _lat,
        'lang': _lang,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'lat': serializeParam(
          _lat,
          ParamType.double,
        ),
        'lang': serializeParam(
          _lang,
          ParamType.double,
        ),
      }.withoutNulls;

  static LatlangStruct fromSerializableMap(Map<String, dynamic> data) =>
      LatlangStruct(
        lat: deserializeParam(
          data['lat'],
          ParamType.double,
          false,
        ),
        lang: deserializeParam(
          data['lang'],
          ParamType.double,
          false,
        ),
      );

  @override
  String toString() => 'LatlangStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is LatlangStruct && lat == other.lat && lang == other.lang;
  }

  @override
  int get hashCode => const ListEquality().hash([lat, lang]);
}

LatlangStruct createLatlangStruct({
  double? lat,
  double? lang,
}) =>
    LatlangStruct(
      lat: lat,
      lang: lang,
    );
