import 'package:sems/features/batches/model/batch_model.dart' show BatchModel;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class BatchDBHelper {
  static final db = BatchDBHelper._internal();
  Database? _database;

  BatchDBHelper._internal();

  Future<Database> get database async {
    _database ??= await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'batches.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE batches(
            id TEXT PRIMARY KEY,
            name TEXT,
            incharge TEXT,
            teacherId TEXT,
            location TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertBatch(BatchModel batch) async {
    final db = await database;
    await db.insert(
      'batches',
      batch.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<BatchModel>> getAllBatches() async {
    final db = await database;
    final result = await db.query('batches');
    return result.map((e) => BatchModel.fromMap(e)).toList();
  }
}
