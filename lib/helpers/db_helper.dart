import 'dart:developer';

import 'package:path_provider/path_provider.dart';
import 'package:realtime_job_task/models/employee.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

import 'logger.dart';

class DatabaseHelper {
  final loger = getLogger('DatabaseHelper');
  final String _tableName = 'employee';
  static const bool _isTableCreated = false;

  Database? _database;

  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
        '${'create table employee'}(id INTEGER PRIMARY KEY, name varchar, role varchar, startdate varchar, enddate varchar);');
  }

  Future<Database> get database async {
    if (_database != null) return _database!;

    // final dir = await sql.getDatabasesPath();
    final directory = await getApplicationDocumentsDirectory();
    final tablePath = path.join(directory.path, 'real.db');
    // sql.deleteDatabase(tablePath);
    // print('DATABASE DELETED');
    _database =
        await sql.openDatabase(tablePath, version: 1, onCreate: _onCreate);

    return _database!;
  }

  Future<Employee> insertValues(
      String name, String role, String startDate, String? endDate) async {
    final db = await instance.database;
    final empId = await db.insert('employee', {
      'name': name,
      'role': role,
      'startdate': startDate,
      'enddate': endDate,
    });
    return Employee(
      id: empId,
      name: name,
      role: role,
      startDate: DateTime.parse(startDate),
      endDate: endDate != null ? DateTime.parse(endDate) : null,
    );
  }

  Future<List<Map<String, Object?>>> getTableData() async {
    final db = await instance.database;
    final res = await db.rawQuery('Select * from employee');
    if (res.isEmpty) {
      loger.i('EMPTY');
    }
    for (var i = 0; i < res.length; i++) {
      loger.i(res[i]['id']);
      loger.i(res[i]['name']);
      loger.i(res[i]['startdate']);
      loger.i(res[i]['enddate']);
    }
    return res;
  }

  void updateName({required String name, required int id}) async {
    final db = await instance.database;
    db.update('employee', {'name': name}, where: "id = ? ", whereArgs: [id]);
  }

  void updateStartDate({required String startDate, required int id}) async {
    final db = await instance.database;
    db.update('employee', {'startdate': startDate}, where: "id = ? ", whereArgs: [id]);
  }

  void updateRole({required String role, required int id}) async {
    final db = await instance.database;
    db.update('employee', {'role': role}, where: "id = ? ", whereArgs: [id]);
  }

  

  void updateEndDate({required String endDate, required int id}) async {
    final db = await instance.database;
    db.update('employee', {'enddate': endDate},
        where: "id = ? ", whereArgs: [id]);
  }

  Future<void> delete(int id) async {
    final db = await instance.database;
    log('ID: $id');
    await db.rawQuery('DELETE FROM employee WHERE id = $id;');
    // final res = await db.delete('employee', where: "id = ? ", whereArgs: [id]);
    await getTableData();
    // return res;
  }
}
