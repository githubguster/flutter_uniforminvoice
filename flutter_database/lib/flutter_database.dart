import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:version/version.dart';

export 'package:version/version.dart';

part 'database_management_db.dart';

class FllutterDataBase {
  FllutterDataBase(this._databaseName);

  Future<bool> open({bool readOnly = false}) async {
    if (_db == null) {
      String path = join(await getDatabasesPath(), _databaseName);
      _db = await openDatabase(path, readOnly: readOnly);
    }
    return isOpen();
  }

  Future<bool> close() async {
    if (isOpen()) {
      await _db?.close();
      _db = null;
    }
    return !isOpen();
  }

  bool isOpen() => _db?.isOpen ?? false;

  Future<List<Map<String, Object?>>?> select(String table, List<String> columns,
      {String? where,
      String? order,
      String? group,
      String? having,
      int? limit,
      List<Object?>? arguments}) async {
    Future<List<Map<String, Object?>>?> ret = Future.value(null);
    if (isOpen()) {
      try {
        ret = Future.value(await _db!.query(table,
            columns: columns,
            where: where,
            orderBy: order,
            groupBy: group,
            having: having,
            limit: limit,
            whereArgs: arguments));
      } catch (_) {}
    }
    return ret;
  }

  Future<int> insert(String table, Map<String, Object?> values,
      {List<Object?>? arguments}) async {
    Future<int> ret = Future.value(0);
    if (isOpen()) {
      try {
        ret = Future.value(await _db!.insert(table, values));
      } catch (_) {}
    }
    return ret;
  }

  Future<int> update(String table, Map<String, Object?> values,
      {String? where, List<Object?>? arguments}) async {
    Future<int> ret = Future.value(0);
    if (isOpen()) {
      try {
        ret = Future.value(await _db!
            .update(table, values, where: where, whereArgs: arguments));
      } catch (_) {}
    }
    return ret;
  }

  Future<int> delete(String table,
      {String? where, List<Object?>? arguments}) async {
    Future<int> ret = Future.value(0);
    if (isOpen()) {
      try {
        ret = Future.value(
            await _db!.delete(table, where: where, whereArgs: arguments));
      } catch (_) {}
    }
    return ret;
  }

  Future<void> createTable(String table, String columns,
      {List<Object?>? arguments}) async {
    Future<void> ret = Future.value();
    if (isOpen()) {
      try {
        await _db!
            .execute('CREATE TABLE IF NOT EXISTS $table ($columns)', arguments);
      } catch (_) {}
    }
    return ret;
  }

  Future<void> dropTable(String table, {List<Object?>? arguments}) async {
    Future<void> ret = Future.value();
    if (isOpen()) {
      try {
        await _db!.execute('DROP TABLE IF EXISTS $table', arguments);
      } catch (_) {}
    }
    return ret;
  }

  Future<void> addTableColumn(String table, String column, String type,
      {List<Object?>? arguments}) async {
    Future<void> ret = Future.value();
    if (isOpen()) {
      try {
        await _db!.execute(
            'ALERT TABLE $table ADD COLUMN IF NOT EXISTS $column $type',
            arguments);
      } catch (_) {}
    }
    return ret;
  }

  Future<void> updateTableColumn(String table, String column, String type,
      {List<Object?>? arguments}) async {
    Future<void> ret = Future.value();
    if (isOpen()) {
      try {
        await _db!.execute(
            'ALERT TABLE $table MODIFY IF EXISTS $column $type', arguments);
      } catch (_) {}
    }
    return ret;
  }

  Future<void> dropTableColumn(String table, String column,
      {List<Object?>? arguments}) async {
    Future<void> ret = Future.value();
    if (isOpen()) {
      try {
        await _db!.execute(
            'ALERT TABLE $table DROP COLUMN IF EXISTS $column', arguments);
      } catch (_) {}
    }
    return ret;
  }

  final String _databaseName;
  Database? _db;
}
