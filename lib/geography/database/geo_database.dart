import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../geo.dart';

class DatabaseGameHelper {
  static final _databaseName = "MyDatabase.db";
  static final _databaseVersion = 1;

  static final gameTable = 'quiz_game';

  static final gameColumnId = '_id';

  static final gameColumnType = 'type';

  static final gameColumnDate = 'gameDate';

  static final questionColumnId = '_id';

  static final gameId = 'gameId';

  static final gameColumnQuestion = 'question';

  static final gameColumnCorrectAnwser = 'correctAnwser';

  static final gameColumnAnwser = 'anwsered';

  static final questionsTable = 'question_table';

  static final propertiesTable = 'properties_table';

  static final propertyTypeColumn = 'propertyType';

  static final propertyValueColumn = 'propertyValue';

  static final questionDataTable = "question_data_table";

  static final primaryQuestionData = "questionData";

  static final secondaryQuestionData = "secondaryQuestionData";

  static final questionType = "questionType";

  static final questionSecondaryType = "secondaryType";

  static final category = "category";

  static final gameAtriburesTable = "game_atributte_tables";

  static final secondaryTypeColumn = "secondaryType";

  static final primaryQuestionColumn = "primaryQuestion";

  static final secondaryQuestionColumn = "secondaryQuestion";

  DatabaseGameHelper._privateConstructor();

  static final DatabaseGameHelper instance =
      DatabaseGameHelper._privateConstructor();

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
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    String sql1 = '''
          CREATE TABLE IF NOT EXISTS  $gameTable (
            $gameColumnId INTEGER PRIMARY KEY,
            $gameColumnType TEXT,
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

    String sql4 = '''
          CREATE TABLE IF NOT EXISTS  $questionDataTable (
          $questionColumnId INTEGER PRIMARY KEY,
            $primaryQuestionData TEXT NOT NULL,     
            $secondaryQuestionData TEXT NOT NULL,
            $questionType TEXT NOT NULL,
            $category TEXT NOT NULL           
          )
          ''';
    await db.execute(sql4);

    String sql5 = '''
          CREATE TABLE IF NOT EXISTS  $gameAtriburesTable (
            $questionType TEXT PRIMARY KEY,
            $questionSecondaryType TEXT NOT NULL,
            $primaryQuestionColumn TEXT,
            $secondaryQuestionColumn TEXT
          )
          ''';
    await db.execute(sql5);

    await fillDataOnCreate(db);
  }

  Future create() async {
    Database db = await instance.database;

    String sql1 = '''
          CREATE TABLE IF NOT EXISTS  $gameTable (
            $gameColumnId INTEGER PRIMARY KEY,
            $gameColumnType TEXT,
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

    String sql4 = '''
          CREATE TABLE IF NOT EXISTS  $questionDataTable (
          $questionColumnId INTEGER PRIMARY KEY,
            $primaryQuestionData TEXT NOT NULL,     
            $secondaryQuestionData TEXT NOT NULL,
            $questionType TEXT NOT NULL,
            $category TEXT NOT NULL           
          )
          ''';
    await db.execute(sql4);

    String sql5 = '''
          CREATE TABLE IF NOT EXISTS  $gameAtriburesTable (
            $questionType TEXT PRIMARY KEY,
            $questionSecondaryType TEXT NOT NULL,
            $primaryQuestionColumn TEXT,
            $secondaryQuestionColumn TEXT
          )
          ''';
    await db.execute(sql5);

    await fillDataOnCreate(db);
  }

  Future<void> fillCountries(Database db) async {
    var geoString = await rootBundle.loadString('assets/countries/geo.csv');
    LineSplitter ls = new LineSplitter();
    List<String> geoLines = ls.convert(geoString);
    for (int i = 1; i < geoLines.length; i++) {
      if (geoLines[i].split(",").length < 4) {
        Map<String, dynamic> values = {
          primaryQuestionData: geoLines[i].split(",")[0],
          secondaryQuestionData: geoLines[i].split(",")[1],
          questionType: 'Countries',
          category: geoLines[i].split(",")[2]
        };

        final id = db.insert(questionDataTable, values);
        print('id: $id');
      }
    }
    Map<String, dynamic> atributes = {
      questionType: 'Countries',
      questionSecondaryType: 'Capitals',
      primaryQuestionColumn: 'The capital of %s is?',
      secondaryQuestionColumn: ' %s is the capital of?'
    };

    await db.insert(gameAtriburesTable, atributes);
  }

  Future<void> fillStates(Database db) async {
    await fillStateData(db, 'assets/states/us_state_capitals.csv', 'USA');
    await fillStateData(
        db, 'assets/states/german_state_capitals.csv', 'Deutschland');
    await fillStateData(
        db, 'assets/states/austrian_state_capitals.csv', 'Ostereich');

    Map<String, dynamic> atributes = {
      questionType: 'States',
      questionSecondaryType: 'Capitals',
      primaryQuestionColumn: 'The capital of %s is?',
      secondaryQuestionColumn: ' %s is the capital of?'
    };

    await db.insert(gameAtriburesTable, atributes);
  }

  Future<void> fillStateData(
      Database db, String filePath, String stateCategory) async {
    var geoString = await rootBundle.loadString(filePath);
    LineSplitter ls = new LineSplitter();
    List<String> geoLines = ls.convert(geoString);
    for (int i = 1; i < geoLines.length; i++) {
      if (geoLines[i].split(",").length < 4) {
        Map<String, dynamic> values = {
          primaryQuestionData: geoLines[i].split(",")[0],
          secondaryQuestionData: geoLines[i].split(",")[1],
          questionType: 'States',
          category: stateCategory
        };
        final id = db.insert(questionDataTable, values);
      }
    }
  }

  Future<void> fillUsPresidents(Database db) async {
    var geoString = await rootBundle
        .loadString('assets/presidents/american_presidents.csv');
    LineSplitter ls = new LineSplitter();
    List<String> geoLines = ls.convert(geoString);
    for (int i = 1; i < geoLines.length; i++) {
      String categoryPresidents = 'first 15';
      if (i > 15) {
        categoryPresidents = 'second 15';
      }
      if (i > 30) {
        categoryPresidents = 'last 15';
      }
      Map<String, dynamic> values = {
        primaryQuestionData: geoLines[i].split(",")[1],
        secondaryQuestionData: geoLines[i].split(",")[2],
        questionType: 'Presidents',
        category: categoryPresidents
      };
      final id = db.insert(questionDataTable, values);
    }

    Map<String, dynamic> atributes = {
      questionType: 'Presidents',
      questionSecondaryType: 'Year',
      primaryQuestionColumn: '%s became president in the year:',
      secondaryQuestionColumn: 'Who became president in %s?'
    };

    await db.insert(gameAtriburesTable, atributes);
  }

  Future<void> createQuestionData() async {
    Database db = await instance.database;
    fillDataOnCreate(db);
  }

  Future<void> fillDataOnCreate(Database db) async {
    int count = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $questionDataTable'));
    if (count == 0) {
      await fillCountries(db);
      await fillUsPresidents(db);
      await fillStates(db);
    }
  }

  Future<List<Map<String, dynamic>>> selectAllTypes() async {
    Database db = await instance.database;
    return await db.query(
      questionDataTable,
      columns: [questionType],
      distinct: true,
    );
  }

  Future<List<Map<String, dynamic>>> selectCategoriesByType(String type) async {
    Database db = await instance.database;

    return await db.query(questionDataTable,
        columns: [category],
        distinct: true,
        where: '$questionType = ?',
        whereArgs: [type]);
  }

  Future<List<Map<String, dynamic>>> queryQuestionsDataByType(
      String type) async {
    Database db = await instance.database;
    return await db.query(questionDataTable, where: "$questionType='$type'");
  }

  Future<String> queryAtributesDataByType(String type, String atr) async {
    Database db = await instance.database;
    String s = "";
    final r = await db.query(gameAtriburesTable,
        columns: [atr], where: "$questionType='$type'");
    if (r != null) {
      r.forEach((rr) => s = rr[atr]);
    }

    return s;
  }

  Future<List<Map<String, dynamic>>> queryQuestionsDataByTypeCategory(
      String type, List<String> categories) async {
    Database db = await instance.database;
    return await db.query(questionDataTable,
        where:
            "$questionType='$type' AND $category IN (${('?' * (categories.length)).split('').join(', ')})",
        whereArgs: categories);
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

  Future<int> queryCorrectAnwsersCountLast() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery(
        'SELECT COUNT(*) FROM $questionsTable WHERE $gameId=(SELECT MAX($gameColumnId) FROM $gameTable) AND $gameColumnCorrectAnwser=$gameColumnAnwser'));
  }

  Future<int> queryWrongAnwsersCount(int gId) async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery(
        'SELECT COUNT(*) FROM $questionsTable WHERE $gameId=$gId AND ($gameColumnCorrectAnwser != $gameColumnAnwser AND $gameColumnAnwser NOT LIKE "Skipped")'));
  }

  Future<int> queryWrongAnwsersLast() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery(
        'SELECT COUNT(*) FROM $questionsTable WHERE $gameId=(SELECT MAX($gameColumnId) FROM $gameTable) AND ($gameColumnCorrectAnwser != $gameColumnAnwser AND $gameColumnAnwser NOT LIKE "Skipped")'));
  }

  Future<int> querySkippedAnwsersCount(int gId) async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery(
        'SELECT COUNT(*) FROM $questionsTable WHERE $gameId=$gId AND $gameColumnAnwser LIKE "Skipped"'));
  }

  Future<int> querySkippedAnwsersCountLast() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery(
        'SELECT COUNT(*) FROM $questionsTable WHERE $gameId=(SELECT MAX($gameColumnId) FROM $gameTable)AND $gameColumnAnwser LIKE "Skipped"'));
  }

  Future<int> queryLastGameId() async {
    Database db = await instance.database;
    String sql = '''
          Select $questionColumnId FROM  $questionsTable WHERE $gameId=(SELECT MAX($gameColumnId) FROM $gameTable)
          ''';
    return Sqflite.firstIntValue(await db.rawQuery(sql));
  }

  Future<int> insertNewGame(String type) async {
    Map<String, dynamic> row = {};
    Database db = await instance.database;
    DateTime dateTime = DateTime.now();
    Map<String, dynamic> values = {
      gameColumnDate: dateTime.toIso8601String(),
      gameColumnType: type
    };
    return await db.insert(gameTable, values);
  }

  Future<List<Map<String, dynamic>>> queryGameRows(String type) async {
    Database db = await instance.database;
    if (!db.isOpen) {
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      print(documentsDirectory.path);
      String path = join(documentsDirectory.path, _databaseName);
      await openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
    }
    return await db.query(gameTable, where: '$gameColumnType=$type');
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
    return await db
        .update(gameTable, row, where: '$gameColumnId = ?', whereArgs: [id]);
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db
        .delete(gameColumnId, where: '$gameColumnId = ?', whereArgs: [id]);
  }
}
