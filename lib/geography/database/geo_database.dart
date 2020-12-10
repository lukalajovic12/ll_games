
import 'dart:io';


import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import 'fill_database.dart';

class DatabaseGameHelper {
  static final _databaseName = "MyDatabase.db";
  static final _databaseVersion = 1;

  static final gameTable = 'quiz_game';

  static final columnId = '_id';

  static final gameColumnType = 'type';

  static final gameColumnDate = 'gameDate';

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
            $columnId INTEGER PRIMARY KEY,
            $gameColumnType TEXT,
            $gameColumnDate TEXT
          )
          ''';
    await db.execute(sql1);
    String sql2 = '''
          CREATE TABLE IF NOT EXISTS  $questionsTable (
            $columnId INTEGER PRIMARY KEY,
            $gameId INTEGER NOT NULL,
            $gameColumnQuestion TEXT NOT NULL,  
            $gameColumnCorrectAnwser TEXT NOT NULL,
            $gameColumnAnwser TEXT NOT NULL          
          )
          ''';
    await db.execute(sql2);
    String sql3 = '''
          CREATE TABLE IF NOT EXISTS  $propertiesTable (
            $columnId INTEGER PRIMARY KEY,
            $gameId INTEGER NOT NULL,      
            $propertyTypeColumn TEXT NOT NULL,
            $propertyValueColumn TEXT NOT NULL           
          )
          ''';
    await db.execute(sql3);

    String sql4 = '''
          CREATE TABLE IF NOT EXISTS  $questionDataTable (
          $columnId INTEGER PRIMARY KEY,
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
            $columnId INTEGER PRIMARY KEY,
            $gameColumnType TEXT,
            $gameColumnDate TEXT
          )
          ''';
    await db.execute(sql1);
    String sql2 = '''
          CREATE TABLE IF NOT EXISTS  $questionsTable (
            $columnId INTEGER PRIMARY KEY,
            $gameId INTEGER NOT NULL,
            $gameColumnQuestion TEXT NOT NULL,  
            $gameColumnCorrectAnwser TEXT NOT NULL,
            $gameColumnAnwser TEXT NOT NULL          
          )
          ''';
    await db.execute(sql2);
    String sql3 = '''
          CREATE TABLE IF NOT EXISTS  $propertiesTable (
            $columnId INTEGER PRIMARY KEY,
            $gameId INTEGER NOT NULL,      
            $propertyTypeColumn TEXT NOT NULL,
            $propertyValueColumn TEXT NOT NULL           
          )
          ''';
    await db.execute(sql3);

    String sql4 = '''
          CREATE TABLE IF NOT EXISTS  $questionDataTable (
            $columnId INTEGER PRIMARY KEY,
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

  Future<void> insertType(String type,String secondaryType,String primaryQuestion,String secondaryQuestion) async {
  Map<String, dynamic> atributes = {
    DatabaseGameHelper.questionType: type,
    DatabaseGameHelper.questionSecondaryType: secondaryType,
    DatabaseGameHelper.primaryQuestionColumn: primaryQuestion,
    DatabaseGameHelper.secondaryQuestionColumn: secondaryQuestion
  };
  Database db = await instance.database;
  await db.insert(DatabaseGameHelper.gameAtriburesTable, atributes);
}


  Future<void> updateType(String type,String secondaryType,String primaryQuestion,String secondaryQuestion) async {
    Map<String, dynamic> atributes = {
      DatabaseGameHelper.questionType: type,
      DatabaseGameHelper.questionSecondaryType: secondaryType,
      DatabaseGameHelper.primaryQuestionColumn: primaryQuestion,
      DatabaseGameHelper.secondaryQuestionColumn: secondaryQuestion
    };
    Database db = await instance.database;
    await db.update(DatabaseGameHelper.gameAtriburesTable, atributes,where: '${DatabaseGameHelper.questionType} = ?',whereArgs: [DatabaseGameHelper.questionType]);
  }


  Future<int> insertQuestionData(String primaryData, String secondaryData,
      String qType, String qCatagory) async {
    Map<String, dynamic> row = {
      primaryQuestionData: primaryData,
      secondaryQuestionData: secondaryData,
      questionType: qType,
      category: qCatagory
    };

    Database db = await instance.database;
    return await db.insert(questionDataTable, row);
  }

  Future<int> updateQuestionData(String primaryData, String secondaryData,
      String qType, String qCatagory, int id) async {
    Map<String, dynamic> row = {
      primaryQuestionData: primaryData,
      secondaryQuestionData: secondaryData,
      questionType: qType,
      category: qCatagory
    };

    Database db = await instance.database;
    return await db.update(questionDataTable, row , where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> deleteQuestionData(int id) async {
    Database db = await instance.database;
    return await db.delete(questionDataTable, where: '$columnId = ?', whereArgs: [id]);
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
      DatabaseGameHelper.gameAtriburesTable,
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
        'SELECT COUNT(*) FROM $questionsTable WHERE $gameId=(SELECT MAX($columnId) FROM $gameTable) AND $gameColumnCorrectAnwser=$gameColumnAnwser'));
  }

  Future<int> queryWrongAnwsersCount(int gId) async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery(
        'SELECT COUNT(*) FROM $questionsTable WHERE $gameId=$gId AND ($gameColumnCorrectAnwser != $gameColumnAnwser AND $gameColumnAnwser NOT LIKE "Skipped")'));
  }

  Future<int> queryWrongAnwsersLast() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery(
        'SELECT COUNT(*) FROM $questionsTable WHERE $gameId=(SELECT MAX($columnId) FROM $gameTable) AND ($gameColumnCorrectAnwser != $gameColumnAnwser AND $gameColumnAnwser NOT LIKE "Skipped")'));
  }

  Future<int> querySkippedAnwsersCount(int gId) async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery(
        'SELECT COUNT(*) FROM $questionsTable WHERE $gameId=$gId AND $gameColumnAnwser LIKE "Skipped"'));
  }

  Future<int> querySkippedAnwsersCountLast() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery(
        'SELECT COUNT(*) FROM $questionsTable WHERE $gameId=(SELECT MAX($columnId) FROM $gameTable)AND $gameColumnAnwser LIKE "Skipped"'));
  }

  Future<int> queryLastGameId() async {
    Database db = await instance.database;
    String sql = '''
          Select $columnId FROM  $questionsTable WHERE $gameId=(SELECT MAX($columnId) FROM $gameTable)
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
          Select * FROM  $questionsTable WHERE $gameId=(SELECT MAX($columnId) FROM $gameTable)
          ''';
    return await db.rawQuery(sql);
  }

  Future<List<Map<String, dynamic>>> queryLastGameProperties() async {
    Database db = await instance.database;
    String sql = '''
          Select * FROM  $propertiesTable WHERE $gameId=(SELECT MAX($columnId) FROM $gameTable)
          
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
    int id = row[columnId];
    return await db
        .update(gameTable, row, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(gameTable, where: '$columnId = ?', whereArgs: [id]);
  }
}
