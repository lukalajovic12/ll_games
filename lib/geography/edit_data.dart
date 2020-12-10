import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import 'country_capital_table.dart';
import 'database/geo_database.dart';
import 'geo.dart';

class GeoDataEditWidget extends StatefulWidget {
  int id;

  String data;

  String secondaryData;

  String category;

  String type;

  GeoDataEditWidget(
      int id, String data, String secondaryData, String category, String type) {
    this.id = id;
    this.data = data;
    this.secondaryData = secondaryData;
    this.category = category;
    this.type = type;
  }

  @override
  State createState() =>
      new _GeoDataEditWidget(id, data, secondaryData, category, type);
}

class _GeoDataEditWidget extends State<GeoDataEditWidget> {
  int id;

  final data = TextEditingController();

  final secondaryData = TextEditingController();

  final category = TextEditingController();

  String type;

  final dbGameHelper = DatabaseGameHelper.instance;

  final ScrollController scrollController = ScrollController();

  void save() {
    if (id == -1) {
      dbGameHelper.insertQuestionData(
          data.text, secondaryData.text, type, category.text);
    } else {
      dbGameHelper.updateQuestionData(
          data.text, secondaryData.text, type, category.text, id);
    }
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GeoDataWidget(type)),
    );
  }

  void delete() {
    if (id != -1) {
      dbGameHelper.deleteQuestionData(id);
    }
  }

  _GeoDataEditWidget(
      int id, String data, String secondaryData, String category, String type) {
    this.id = id;
    this.data.text = data;
    this.secondaryData.text = secondaryData;
    this.category.text = category;
    this.type = type;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(hexColor('#B7D7DA')),
      appBar: AppBar(
        title: Text('Edit'),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                padding: new EdgeInsets.only(bottom: 10, top: 10),
                child: Text(
                  'data:',
                  style: TextStyle(
                      color: Color(hexColor('#0E629B')), fontSize: 25),
                ),
              ),
              Container(
                child: TextField(
                  style: TextStyle(
                      color: Color(hexColor('#0E629B')), fontSize: 25),
                  controller: data,
                ),
              ),
              Container(
                padding: new EdgeInsets.only(bottom: 10, top: 10),
                child: Text(
                  'secondary data:',
                  style: TextStyle(
                      color: Color(hexColor('#0E629B')), fontSize: 25),
                ),
              ),
              Container(
                child: TextField(
                  style: TextStyle(
                      color: Color(hexColor('#0E629B')), fontSize: 25),
                  controller: secondaryData,
                ),
              ),
              Container(
                padding: new EdgeInsets.only(bottom: 10, top: 10),
                child: Text(
                  'category:',
                  style: TextStyle(
                      color: Color(hexColor('#0E629B')), fontSize: 25),
                ),
              ),
              Container(
                child: TextField(
                  style: TextStyle(
                      color: Color(hexColor('#0E629B')), fontSize: 25),
                  controller: category,
                ),
              ),
              Row(
                children: <Widget>[
                  Container(
                    padding: new EdgeInsets.only(top: 20, left: 20),
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      color: Color(hexColor('#0E629B')),
                      child: Text(
                        'Delete',
                        style: TextStyle(
                          color: Color(hexColor('#B7D7DA')),
                        ),
                      ),
                      onPressed: () {
                        delete();
                      },
                    ),
                  ),
                  Container(
                    padding: new EdgeInsets.only(top: 20, left: 120),
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      color: Color(hexColor('#0E629B')),
                      child: Text(
                        'Save',
                        style: TextStyle(color: Color(hexColor('#B7D7DA'))),
                      ),
                      onPressed: () {
                        save();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
