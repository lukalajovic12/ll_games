import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:llgames/main_classes/geo_main.dart';

import '../main.dart';
import 'database/geo_database.dart';
import 'geo.dart';

class AttributesEditWidget extends StatefulWidget {
  String type;

  AttributesEditWidget(String type) {
    this.type = type;
  }

  @override
  State createState() => new _AttributesEditWidget(type);
}

class _AttributesEditWidget extends State<AttributesEditWidget> {
  final type = TextEditingController();

  final secondaryType = TextEditingController();

  final primaryQuestion = TextEditingController();

  final secondaryQuestion = TextEditingController();

  final dbGameHelper = DatabaseGameHelper.instance;

  final ScrollController scrollController = ScrollController();

  bool addType = true;

  bool isLoading = false;

  void save() {
    dbGameHelper.insertType(type.text, secondaryType.text, primaryQuestion.text,
        secondaryQuestion.text);
    if(addType) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => MyApp()));
    }
    else{
      Navigator.pop(context);
    }
  }

  void delete() {
    dbGameHelper.deleteQuestionData(-1);
  }

  _AttributesEditWidget(String type) {
    this.type.text = type;

    if (type.length == 0) {
      addType = true;
      this.secondaryType.text = "";
      this.primaryQuestion.text = "";
      this.secondaryQuestion.text = "";
    } else {
      addType = false;
      loadData();
    }
  }

  Future<void> loadData() async {
    isLoading = true;
    String st = await dbGameHelper.queryAtributesDataByType(
        type.text, DatabaseGameHelper.questionSecondaryType);

    String q = await dbGameHelper.queryAtributesDataByType(
        type.text, DatabaseGameHelper.primaryQuestionColumn);

    String sq = await dbGameHelper.queryAtributesDataByType(
        type.text, DatabaseGameHelper.secondaryQuestionColumn);

    setState(() {
      isLoading = false;
      this.secondaryType.text = st;
      this.primaryQuestion.text = q;
      this.secondaryQuestion.text = sq;
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(hexColor('#B7D7DA')),
      appBar: AppBar(
        title: Text('Edit'),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: new EdgeInsets.only(bottom: 10, top: 10),
                      child: Text(
                        'type:',
                        style: TextStyle(
                            color: Color(hexColor('#0E629B')), fontSize: 25),
                      ),
                    ),
                    Container(
                      child: TextField(
                        style: TextStyle(
                            color: Color(hexColor('#0E629B')), fontSize: 25),
                        controller: type,
                      ),
                    ),
                    Container(
                      padding: new EdgeInsets.only(bottom: 10, top: 10),
                      child: Text(
                        'secondary type:',
                        style: TextStyle(
                            color: Color(hexColor('#0E629B')), fontSize: 25),
                      ),
                    ),
                    Container(
                      child: TextField(
                        style: TextStyle(
                            color: Color(hexColor('#0E629B')), fontSize: 25),
                        controller: secondaryType,
                      ),
                    ),
                    Container(
                      padding: new EdgeInsets.only(bottom: 10, top: 10),
                      child: Text(
                        'primary question :',
                        style: TextStyle(
                            color: Color(hexColor('#0E629B')), fontSize: 25),
                      ),
                    ),
                    Container(
                      child: TextField(
                        style: TextStyle(
                            color: Color(hexColor('#0E629B')), fontSize: 25),
                        controller: primaryQuestion,
                      ),
                    ),
                    Container(
                      padding: new EdgeInsets.only(bottom: 10, top: 10),
                      child: Text(
                        'secondary question :',
                        style: TextStyle(
                            color: Color(hexColor('#0E629B')), fontSize: 25),
                      ),
                    ),
                    Container(
                      child: TextField(
                        style: TextStyle(
                            color: Color(hexColor('#0E629B')), fontSize: 25),
                        controller: secondaryQuestion,
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
                              style:
                                  TextStyle(color: Color(hexColor('#B7D7DA'))),
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
