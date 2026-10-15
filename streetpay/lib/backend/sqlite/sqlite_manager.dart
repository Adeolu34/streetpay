import 'package:flutter/foundation.dart';

import '/backend/sqlite/init.dart';
import 'queries/read.dart';

import 'package:sqflite/sqflite.dart';
export 'queries/read.dart';
export 'queries/update.dart';

class SQLiteManager {
  SQLiteManager._();

  static SQLiteManager? _instance;
  static SQLiteManager get instance => _instance ??= SQLiteManager._();

  static late Database _database;
  Database get database => _database;

  static Future initialize() async {
    if (kIsWeb) {
      return;
    }
    _database = await initializeDatabaseFromDbFile(
      'user',
      'user.db',
    );
  }

  /// START READ QUERY CALLS

  Future<List<ReadallRow>> readall() => performReadall(
        _database,
      );

  Future<List<IspresentRow>> ispresent({
    String? phoneNumber,
  }) =>
      performIspresent(
        _database,
        phoneNumber: phoneNumber,
      );

  /// END READ QUERY CALLS

  /// START UPDATE QUERY CALLS

  /// END UPDATE QUERY CALLS
}
