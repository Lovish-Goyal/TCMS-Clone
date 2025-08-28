import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import '../models/attendance_model.dart';

class AttendanceDb {
  static const _tableName = 'attendance';

  static final AttendanceDb instance = AttendanceDb._internal();

  factory AttendanceDb() => instance;

  AttendanceDb._internal();

  Database? _database;

  Future<Database> get db async {
    _database ??= await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = join(dir.path, 'attendance.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableName (
            id TEXT PRIMARY KEY,
            studentId TEXT,
            status TEXT,
            remarks TEXT,
            timestamp TEXT
          )
        ''');
      },
    );
  }

  Future<void> addAttendance(AttendanceModel attendance) async {
    final database = await db;
    await database.insert(
      _tableName,
      attendance.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<AttendanceModel>> getAttendanceByStudent(String studentId) async {
    final database = await db;
    final result = await database.query(
      _tableName,
      where: 'studentId = ?',
      whereArgs: [studentId],
      orderBy: 'timestamp DESC',
    );

    return result.map((e) => AttendanceModel.fromMap(e)).toList();
  }

  Future<List<AttendanceModel>> getAttendanceByDate(DateTime date) async {
    final database = await db;
    // Filter on just the date part of timestamp
    final dateString = date.toIso8601String().substring(0, 10);

    final result = await database.query(
      _tableName,
      where: "substr(timestamp,1,10) = ?",
      whereArgs: [dateString],
    );

    return result.map((e) => AttendanceModel.fromMap(e)).toList();
  }
}
