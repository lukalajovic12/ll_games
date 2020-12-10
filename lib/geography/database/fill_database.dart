import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';

import 'geo_database.dart';

Future<void> fillCountries(Database db) async {
  var geoString = await rootBundle.loadString('assets/countries/geo.csv');
  LineSplitter ls = new LineSplitter();
  List<String> geoLines = ls.convert(geoString);
  for (int i = 1; i < geoLines.length; i++) {
    if (geoLines[i].split(",").length < 4) {
      Map<String, dynamic> values = {
        DatabaseGameHelper.primaryQuestionData: geoLines[i].split(",")[0],
        DatabaseGameHelper.secondaryQuestionData: geoLines[i].split(",")[1],
        DatabaseGameHelper.questionType: 'Countries',
        DatabaseGameHelper.category: geoLines[i].split(",")[2]
      };
      final id = db.insert(DatabaseGameHelper.questionDataTable, values);
    }
  }
  Map<String, dynamic> atributes = {
    DatabaseGameHelper.questionType: 'Countries',
    DatabaseGameHelper.questionSecondaryType: 'Capitals',
    DatabaseGameHelper.primaryQuestionColumn: 'The capital of %s is?',
    DatabaseGameHelper.secondaryQuestionColumn: ' %s is the capital of?'
  };

  await db.insert(DatabaseGameHelper.gameAtriburesTable, atributes);
}

Future<void> fillStates(Database db) async {
  await fillStateData(db, 'assets/states/us_state_capitals.csv', 'USA');
  await fillStateData(
      db, 'assets/states/german_state_capitals.csv', 'Deutschland');
  await fillStateData(
      db, 'assets/states/austrian_state_capitals.csv', 'Ostereich');

  Map<String, dynamic> atributes = {
    DatabaseGameHelper.questionType: 'States',
    DatabaseGameHelper.questionSecondaryType: 'Capitals',
    DatabaseGameHelper.primaryQuestionColumn: 'The capital of %s is?',
    DatabaseGameHelper.secondaryQuestionColumn: ' %s is the capital of?'
  };

  await db.insert(DatabaseGameHelper.gameAtriburesTable, atributes);
}

Future<void> fillStateData(
    Database db, String filePath, String stateCategory) async {
  var geoString = await rootBundle.loadString(filePath);
  LineSplitter ls = new LineSplitter();
  List<String> geoLines = ls.convert(geoString);
  for (int i = 1; i < geoLines.length; i++) {
    if (geoLines[i].split(",").length < 4) {
      Map<String, dynamic> values = {
        DatabaseGameHelper.primaryQuestionData: geoLines[i].split(",")[0],
        DatabaseGameHelper.secondaryQuestionData: geoLines[i].split(",")[1],
        DatabaseGameHelper.questionType: 'States',
        DatabaseGameHelper.category: stateCategory
      };
      final id = db.insert(DatabaseGameHelper.questionDataTable, values);
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
      DatabaseGameHelper.primaryQuestionData: geoLines[i].split(",")[1],
      DatabaseGameHelper.secondaryQuestionData: geoLines[i].split(",")[2],
      DatabaseGameHelper.questionType: 'Presidents',
      DatabaseGameHelper.category: categoryPresidents
    };
    final id = db.insert(DatabaseGameHelper.questionDataTable, values);
  }
  Map<String, dynamic> atributes = {
    DatabaseGameHelper.questionType: 'Presidents',
    DatabaseGameHelper.questionSecondaryType: 'Year',
    DatabaseGameHelper.primaryQuestionColumn: '%s became president in the year:',
    DatabaseGameHelper.secondaryQuestionColumn: 'Who became president in %s?'
  };

  await db.insert(DatabaseGameHelper.gameAtriburesTable, atributes);
}