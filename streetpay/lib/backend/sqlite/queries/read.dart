import '/backend/sqlite/queries/sqlite_row.dart';
import 'package:sqflite/sqflite.dart';

Future<List<T>> _readQuery<T>(
  Database database,
  String query,
  T Function(Map<String, dynamic>) create, [
  List<Object?>? arguments,
]) =>
    database
        .rawQuery(query, arguments)
        .then((r) => r.map((e) => create(e)).toList());

/// BEGIN READALL
Future<List<ReadallRow>> performReadall(
  Database database,
) {
  final query = '''
SELECT phoneNumber, password FROM "user" WHERE id = 1;

''';
  return _readQuery(database, query, (d) => ReadallRow(d));
}

class ReadallRow extends SqliteRow {
  ReadallRow(Map<String, dynamic> data) : super(data);

  String get phoneNumber => data['phoneNumber'] as String;
  String get password => data['password'] as String;
}

/// END READALL

/// BEGIN ISPRESENT
Future<List<IspresentRow>> performIspresent(
  Database database, {
  String? phoneNumber,
}) {
  final query = '''
SELECT EXISTS(SELECT 1 FROM "user" WHERE phoneNumber = ?) AS is_present;

''';
  return _readQuery(database, query, (d) => IspresentRow(d), [phoneNumber]);
}

class IspresentRow extends SqliteRow {
  IspresentRow(Map<String, dynamic> data) : super(data);

  String get phoneNumber => data['phoneNumber'] as String;
}

/// END ISPRESENT
