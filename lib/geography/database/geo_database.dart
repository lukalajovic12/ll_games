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

  static final gameColumnDate = 'gameDate';

  static final questionColumnId = '_id';

  static final gameId = 'gameId';

  static final gameColumnQuestion = 'question';

  static final gameColumnCorrectAnwser = 'correctAnwsers';

  static final gameColumnAnwser = 'anwsered';

  static final questionsTable = 'question_table';


  static final propertiesTable = 'properties_table';

  static final propertyTypeColumn = 'propertyType';

  static final propertyValueColumn = 'propertyValue';


  DatabaseGameHelper._privateConstructor();

  static final DatabaseGameHelper instance = DatabaseGameHelper
      ._privateConstructor();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    print(documentsDirectory.path);
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    String sql1 = '''
          CREATE TABLE IF NOT EXISTS  $gameTable (
            $gameColumnId INTEGER PRIMARY KEY,
            $gameColumnDate TEXT
          )
          ''';
    await db.execute(sql1);
    String sql2 = '''
          CREATE TABLE IF NOT EXISTS  $questionsTable (
            $questionColumnId INTEGER PRIMARY KEY,
            $gameId INTEGER NOT NULL,
            $gameColumnQuestion TEXT NOT NULL,  
            $gameColumnCorrectAnwser TEXT NOT NULL,
            $gameColumnAnwser TEXT NOT NULL          
          )
          ''';
    await db.execute(sql2);
    String sql3 = '''
          CREATE TABLE IF NOT EXISTS  $propertiesTable (
            $questionColumnId INTEGER PRIMARY KEY,
            $gameId INTEGER NOT NULL,      
            $propertyTypeColumn TEXT NOT NULL,
            $propertyValueColumn TEXT NOT NULL           
          )
          ''';

    await db.execute(sql3);
  }

  Future<int> insertQuestion(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(questionsTable, row);
  }

  Future<int> insertProperty(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(propertiesTable, row);
  }

  Future<int> queryCorrectAnwsersCount(int gId) async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery(
        'SELECT COUNT(*) FROM $questionsTable WHERE $gameId=$gId AND $gameColumnCorrectAnwser=$gameColumnAnwser'));
  }

  Future<int> queryWrongAnwsersCount(int gId) async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery(
        'SELECT COUNT(*) FROM $questionsTable WHERE $gameId=$gId AND ($gameColumnCorrectAnwser != $gameColumnAnwser AND $gameColumnAnwser NOT LIKE "Skipped")'));
  }

  Future<int> querySkippedAnwsersCount(int gId) async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery(
        'SELECT COUNT(*) FROM $questionsTable WHERE $gameId=$gId AND $gameColumnAnwser LIKE "Skipped"'));
  }


  Future<int> queryLastGameId() async {
    Database db = await instance.database;
    String sql = '''
          Select $questionColumnId FROM  $questionsTable WHERE $gameId=(SELECT MAX($gameColumnId) FROM $gameTable)
          ''';
    return Sqflite.firstIntValue(await db.rawQuery(sql));
  }

  Future<int> insertNewGame() async {
    Map<String, dynamic> row = {};
    Database db = await instance.database;

    DateTime dateTime = DateTime.now();
    Map<String, dynamic> values = {
      gameColumnDate: dateTime.toIso8601String()
    };
    return await db.insert(gameTable, values);
  }

  Future<List<Map<String, dynamic>>> queryGameRows() async {
    Database db = await instance.database;
    if (!db.isOpen) {
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      print(documentsDirectory.path);
      String path = join(documentsDirectory.path, _databaseName);
      await openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
    }
    return await db.query(gameTable);
  }


  Future<List<Map<String, dynamic>>> queryAnwserRows(int idG) async {
    Database db = await instance.database;
    return await db.query(questionsTable, where: '$gameId=$idG');
  }


  Future<List<Map<String, dynamic>>> queryConstantRows(int idG) async {
    Database db = await instance.database;
    return await db.query(propertiesTable, where: '$gameId=$idG');
  }

  Future<List<Map<String, dynamic>>> queryLastGameRows() async {
    Database db = await instance.database;
    String sql = '''
          Select * FROM  $questionsTable WHERE $gameId=(SELECT MAX($gameColumnId) FROM $gameTable)
          
          ''';
    return await db.rawQuery(sql);
  }

  Future<List<Map<String, dynamic>>> queryLastGameProperties() async {
    Database db = await instance.database;
    String sql = '''
          Select * FROM  $propertiesTable WHERE $gameId=(SELECT MAX($gameColumnId) FROM $gameTable)
          
          ''';
    return await db.rawQuery(sql);
  }



  Future<int> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $gameTable'));
  }

  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[gameColumnId];
    return await db.update(
        gameTable, row, where: '$gameColumnId = ?', whereArgs: [id]);
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(
        gameColumnId, where: '$gameColumnId = ?', whereArgs: [id]);
  }
}