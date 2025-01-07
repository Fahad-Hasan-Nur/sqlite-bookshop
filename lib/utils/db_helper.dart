import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const _dbName = 'bookshop4.db';
  static const _dbVersion = 1;
  static const _tableName = 'contacts';
  static const columnId = 'id';
  static const columnName = 'name';
  static const columnImage = 'image';
  static const columnDes = 'des';
  static const columnDop = 'dop';
  static const columnCountryId = 'countryId';
  static const columnCreatedAt = 'created_at';
  static const columnUpdatedAt = 'updated_at';
  static const countryName = 'countryName';

  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database == null) {
      _database = await _initiateDatabase();
      return _database!;
    } else {
      return _database!;
    }

    // return await _initiateDatabase();
  }

  _initiateDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, _dbName);
    // return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
    return await openDatabase(path, version: _dbVersion,
        onCreate: (Database db, int version) async {
      await db.execute('''
      CREATE TABLE $_tableName(
      $columnId INTEGER PRIMARY KEY,
      $columnName TEXT NOT NULL,
      $columnImage TEXT NOT NULL,
      $columnDes TEXT NULL,
      $columnDop TEXT  NULL,
      $columnCountryId INTEGER NULL,
      $columnCreatedAt TEXT NULL,
      $columnUpdatedAt TEXT NULL
      )
    
      ''');

      await db.execute('''
   CREATE TABLE country(
    id integer primary key autoincrement,
    $countryName text not null
   )''');
    });
  }

  // Future _onCreate(Database db, int version) async {
  //   print('_onCreate function calling');
  //   db.execute('''
  //     CREATE TABLE $_tableName(
  //     $columnId INTEGER PRIMARY KEY,
  //     $columnName TEXT NOT NULL,
  //     $columnimage TEXT NOT NULL,
  //     $columndes TEXT NULL,
  //     $columnGender TEXT NULL,
  //     $columnknownUnkown TEXT NULL,
  //     $columnDob TEXT NULL,
  //     $columnCreatedAt TEXT NULL,
  //     $columnUpdatedAt TEXT NULL,
  //     )

  //     ''');
  // }

  Future<int> insert(Map<String, dynamic> row, String table) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  Future<List<Map<String, dynamic>>> queryAll(String table) async {
    Database db = await instance.database;
    return await db.query(table);
  }

  Future<int> update(Map<String, dynamic> row, String table) async {
    Database db = await instance.database;
    int id = row[columnId];
    return await db.update(table, row, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> delete(int id, String table) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }
}
