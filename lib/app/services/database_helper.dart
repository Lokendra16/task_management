import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:task_management/app/services/database_constant.dart';

class DatabaseHelper {

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), DatabaseConstant.databaseName);
    return await openDatabase(path, version: DatabaseConstant.databaseVersion,
        onCreate: (db, version) {
      db.execute('''
          CREATE TABLE ${DatabaseConstant.table} (
            ${DatabaseConstant.columnId} INTEGER PRIMARY KEY,
            ${DatabaseConstant.columnName} TEXT NOT NULL,
            ${DatabaseConstant.columnAge} INTEGER NOT NULL
          )
          ''');
    });
  }
}
