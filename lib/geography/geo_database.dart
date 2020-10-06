import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
class DatabaseGameHelper {

  static final _databaseName = "MyDatabase.db";
  static final _databaseVersion = 1;

  static final gameTable = 'geo_game';

  static final gameColumnId = '_id';

  static final gameColumnTime = 'time';

  static final gameColumnPossibleAnwsers='possibleAnwsers';


  static final questionColumnId = '_id';

  static final gameId = 'gameId';

  static final gameColumnQuestion = 'question';

  static final gameColumnCorrectAnwser = 'correctAnwsers';

  static final gameColumnAnwser = 'anwsered';

  static final gameColumnType = 'type';

  static final questionsTable = 'question_table';


  // make this a singleton class
  DatabaseGameHelper._privateConstructor();
  static final DatabaseGameHelper instance = DatabaseGameHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    print(documentsDirectory.path);
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  // SQL code to create the database table


  Future _onCreate(Database db, int version) async {
    String sql1='''
          CREATE TABLE IF NOT EXISTS  $gameTable (
            $gameColumnId INTEGER PRIMARY KEY,
            $gameColumnTime INTEGER NOT NULL,
            $gameColumnPossibleAnwsers INTEGER NOT NULL
          )
          ''';
    await db.execute(sql1);
    String sql2='''
          CREATE TABLE IF NOT EXISTS  $questionsTable (
            $questionColumnId INTEGER PRIMARY KEY,
            $gameId INTEGER NOT NULL,
            $gameColumnQuestion TEXT NOT NULL,  
            $gameColumnCorrectAnwser TEXT NOT NULL,          
            $gameColumnAnwser TEXT NOT NULL,
            $gameColumnType INTEGER NOT NULL
          )
          ''';
    await db.execute(sql2);
  }

  Future<int> insertQuestion(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(questionsTable, row);
  }

  Future<int> queryCorrectAnwsersCount(int gId) async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $questionsTable WHERE $gameId=$gId AND $gameColumnCorrectAnwser=$gameColumnAnwser'));
  }

  Future<int> queryWrongAnwsersCount(int gId) async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $questionsTable WHERE $gameId=$gId AND ($gameColumnCorrectAnwser != $gameColumnAnwser AND $gameColumnAnwser NOT LIKE "Skipped")'));
  }


  //Skipped

  Future<int> querySkippedAnwsersCount(int gId) async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $questionsTable WHERE $gameId=$gId AND $gameColumnAnwser LIKE "Skipped"'));
  }


  // Helper methods

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(gameTable, row);
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryGameRows() async {
    Database db = await instance.database;
    if(!db.isOpen){
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      print(documentsDirectory.path);
      String path = join(documentsDirectory.path, _databaseName);
      await openDatabase(path,version: _databaseVersion, onCreate: _onCreate);
    }
    return await db.query(gameTable);
  }


  Future<List<Map<String, dynamic>>> queryAnwserRows(int idG) async {
    Database db = await instance.database;
    return await db.query(questionsTable,where: '$gameId=$idG');
  }


  Future<List<Map<String, dynamic>>> queryLastGameRows() async {
    Database db = await instance.database;
    String sql='''
          Select * FROM  $questionsTable WHERE $gameId=(SELECT MAX($gameColumnId) FROM $gameTable)
          
          ''';
    return await db.rawQuery(sql);
  }


  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $gameTable'));
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[gameColumnId];
    return await db.update(gameTable, row, where: '$gameColumnId = ?', whereArgs: [id]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(gameColumnId, where: '$gameColumnId = ?', whereArgs: [id]);
  }
}