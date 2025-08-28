import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../../../shared/utils/logger.dart';
import '../model/student_model.dart';

class StudentDb {
  StudentDb._();

  static final StudentDb dbInstance = StudentDb._();
  static const tableName = 'students';

  static const acadmyIdCol = 'acadmyId';
  static const isActiveCol = 'isActive';
  static const studentIdCol = 'studentId';
  static const profileImageCol = 'profileImage';
  static const rollNumberCol = 'rollNumber';
  static const studentNameCol = 'studentName';
  static const guardianNameCol = 'guardianName';
  static const dateOfBirthCol = 'dateOfBirth';
  static const mobileNumber1Col = 'mobileNumber1';
  static const mobileNumber2Col = 'mobileNumber2';
  static const genderCol = 'gender';
  static const addressCol = 'address';
  static const batchNameCol = 'batchName';
  static const feeTypeCol = 'feeType';
  static const feeAmountCol = 'feeAmount';
  static const startDateCol = 'startDate';
  static const classOrSubjectCol = 'classOrSubject';
  static const schoolNameCol = 'schoolName';
  static const optionalField1Col = 'optionalField1';
  static const optionalField2Col = 'optionalField2';
  static const optionalField3Col = 'optionalField3';

  Database? _database;

  Future<Database> getStudentDatabase() async {
    _database ??= await _openDb();
    return _database!;
  }

  Future<Database> _openDb() async {
    try {
      final Directory appPath = await getApplicationDocumentsDirectory();
      final String dbPath = join(appPath.path, 'sems.db');

      return await openDatabase(
        dbPath,
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
          CREATE TABLE IF NOT EXISTS $tableName (
            $acadmyIdCol TEXT,
            $isActiveCol INTEGER,
            $studentIdCol TEXT PRIMARY KEY,
            $profileImageCol BLOB,
            $rollNumberCol TEXT,
            $studentNameCol TEXT,
            $guardianNameCol TEXT,
            $dateOfBirthCol TEXT,
            $mobileNumber1Col TEXT,
            $mobileNumber2Col TEXT,
            $genderCol TEXT,
            $addressCol TEXT,
            $batchNameCol TEXT,
            $feeTypeCol TEXT,
            $feeAmountCol TEXT,
            $startDateCol TEXT,
            $classOrSubjectCol TEXT,
            $schoolNameCol TEXT,
            $optionalField1Col TEXT,
            $optionalField2Col TEXT,
            $optionalField3Col TEXT
          )
        ''');
        },
      );
    } catch (e) {
      logger.e(e.toString());
      rethrow;
    }
  }

  Future<int> addStudent(Student student) async {
    final db = await getStudentDatabase();
    return await db.insert(tableName, student.toMap());
  }

  Future<List<Student>> getStudents() async {
    final db = await getStudentDatabase();
    final List<Map<String, dynamic>> rawStudents = await db.query(tableName);
    return rawStudents.map((e) => Student.fromMap(e)).toList();
  }

  Future<int> deleteStudent(String studentId) async {
    final db = await getStudentDatabase();
    return await db.delete(
      tableName,
      where: '$studentIdCol = ?',
      whereArgs: [studentId],
    );
  }

  Future<Student?> verifyStudentLogin({
    required String academyId,
    required String studentId,
    required String dateOfBirth,
  }) async {
    final db = await getStudentDatabase();
    final localStudent = await _verifyStudentLocally(
      db,
      academyId,
      studentId,
      dateOfBirth,
    );

    if (localStudent != null) {
      return localStudent;
    }

    try {
      final doc = await FirebaseFirestore.instance
          .collection('students')
          .doc(studentId)
          .get();

      if (doc.exists) {
        final data = doc.data()!;
        if (data['academyId'] == academyId &&
            data['dateOfBirth'] == dateOfBirth) {
          final newStudent = Student.fromMap(data);
          await addStudent(newStudent);
          return newStudent;
        }
      }
    } catch (e) {
      logger.e('Firestore login error: $e');
    }

    return null;
  }

  Future<Student?> _verifyStudentLocally(
    Database db,
    String academyId,
    String studentId,
    String dateOfBirth,
  ) async {
    try {
      final List<Map<String, dynamic>> result = await db.query(
        tableName,
        where:
            '$acadmyIdCol = ? AND $studentIdCol = ? AND $dateOfBirthCol = ? AND $isActiveCol = ?',
        whereArgs: [academyId, studentId, dateOfBirth, 1],
        limit: 1,
      );

      if (result.isNotEmpty) {
        return Student.fromMap(result.first);
      }
      return null;
    } catch (e) {
      logger.e('Local login error: $e');
      return null;
    }
  }
}
