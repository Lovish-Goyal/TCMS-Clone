import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../../../shared/utils/logger.dart';
import '../model/attachment_model.dart';

class AttachmentDb {
  AttachmentDb._();

  static final AttachmentDb dbInstance = AttachmentDb._();
  static const tableName = 'attachments';

  static const documentIdCol = 'documentId';
  static const studentIdCol = 'studentId';
  static const nameCol = 'name';
  static const imageCol = 'image';

  Database? database;

  Future<bool> checkIfTableExists(Database db, String tableName) async {
    final result = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name=?",
      [tableName],
    );
    return result.isNotEmpty;
  }

  Future<Database> getAttachmentsDatabase() async {
    database ??= await openDb();
    final isTableExists = await checkIfTableExists(database!, tableName);
    if (!isTableExists) {
      print("Table does not exist. Creating new table.");
      await createTableIfNotExists(database!, '''
        CREATE TABLE IF NOT EXISTS $tableName (
          $documentIdCol TEXT PRIMARY KEY,
          $studentIdCol TEXT,
          $nameCol TEXT,
          $imageCol BLOB
        )
      ''');
    }
    return database!;
  }

  Future<void> createTableIfNotExists(
    Database db,
    String createTableQuery,
  ) async {
    try {
      await db.execute(createTableQuery);
    } catch (e) {
      logger.e('Table creation failed: $e');
    }
  }

  Future<Database> openDb() async {
    try {
      final Directory appPath = await getApplicationDocumentsDirectory();
      final String dbPath = join(appPath.path, 'sems.db');
      final Database db = await openDatabase(dbPath, version: 1);
      await createTableIfNotExists(db, '''
        CREATE TABLE IF NOT EXISTS $tableName (
          $documentIdCol TEXT PRIMARY KEY,
          $studentIdCol TEXT,
          $nameCol TEXT,
          $imageCol BLOB
        )
      ''');
      return db;
    } catch (e) {
      logger.e(e.toString());
      rethrow;
    }
  }

  Future<int> addAttachments(AttachmentsModel attachment) async {
    final db = await getAttachmentsDatabase();
    return await db.insert(tableName, attachment.toMap());
  }

  Future<List<AttachmentsModel>> getAttachmentsById(String studentId) async {
    final db = await getAttachmentsDatabase();
    final List<Map<String, dynamic>> rawAttachments = await db.query(
      tableName,
      where: '$studentIdCol = ?',
      whereArgs: [studentId],
    );
    return rawAttachments.map((e) => AttachmentsModel.fromMap(e)).toList();
  }

  Future<int> deleteAttachments(String documentId) async {
    final db = await getAttachmentsDatabase();
    return await db.delete(
      tableName,
      where: '$documentIdCol = ?',
      whereArgs: [documentId],
    );
  }
}
