import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../main.dart';
import 'geo.dart';
import 'kviz.dart';
import 'statistics.dart';

class GeoQuizSettingsWidget extends StatefulWidget {
  List<CountryCapital> geoList;

  List<CountryCapital> getGeoList() {
    if (geoList == null) {
      geoList = new List();
    }
    return geoList;
  }

  List<String> categories = new List();

  List<String> getCategories() {
    if (categories == null) {
      categories = new List();
    }
    return categories;
  }

  GeoQuizSettingsWidget(List<CountryCapital> geoList, List<String> categories) {
    this.geoList = geoList;
    this.categories = categories;
  }

  @override
  State createState() =>
      new _GeoQuizSettingsWidget(getGeoList(), getCategories());
}

enum SingingCharacter { Countries, Capitals }

class _GeoQuizSettingsWidget extends State<GeoQuizSettingsWidget> {
  List<CountryCapital> geoList;

  List<CountryCapital> getGeoList() {
    if (geoList == null) {
      geoList = new List();
    }
    return geoList;
  }

  List<String> categories = new List();

  List<String> getCategories() {
    if (categories == null) {
      categories = new List();
    }
    return categories;
  }

  _GeoQuizSettingsWidget(
      List<CountryCapital> geoList, List<String> categories) {
    this.geoList = geoList;
    this.categories = categories;
  }

  SingingCharacter _character = SingingCharacter.Countries;

  double time = 30.0;

  int getTime() {
    if (time == null) {
      time = 30.0;
    }
    return time.round();
  }

  double questions = 3.0;

  int getQuestions() {
    if (questions == null) {
      questions = 3.0;
    }
    return questions.round();
  }

  bool quizType = true;

  int getType() {
    if (quizType) {
      return 1;
    } else {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          'Gemory',
          style: TextStyle(fontStyle: FontStyle.italic),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Color(hexColor('#B7D7DA')),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Center(
                child: Text('time ${getTime()}',
                    style: TextStyle(
                      color: Color(hexColor('#0E629B')),
                      fontSize: 20.0,
                    )),
              ),
            ),
            Slider(
              value: time,
              min: 10,
              max: 100,
              divisions: 90,
              label: time.round().toString(),
              onChanged: (double value) {
                setState(() {
                  time = value;
                });
              },
            ),
            Container(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Center(
                child: Text('number of questions ${getQuestions()}',
                    style: TextStyle(
                      color: Color(hexColor('#0E629B')),
                      fontSize: 20.0,
                    )),
              ),
            ),
            Slider(
              value: questions,
              min: 2,
              max: 5,
              divisions: 3,
              label: questions.round().toString(),
              onChanged: (double value) {
                setState(() {
                  questions = value;
                });
              },
            ),
            ListTile(
              title: const Text('Countries'),
              leading: Radio(
                value: SingingCharacter.Countries,
                groupValue: _character,
                onChanged: (SingingCharacter value) {
                  setState(() {
                    _character = value;
                    quizType = true;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('Capitals'),
              leading: Radio(
                value: SingingCharacter.Capitals,
                groupValue: _character,
                onChanged: (SingingCharacter value) {
                  setState(() {
                    _character = value;
                    quizType = false;
                  });
                },
              ),
            ),
            Container(
              height: 150.0,
              width: 550.0,
              padding: new EdgeInsets.only(left: 40,right:40,top: 40,bottom: 40),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(90),
                ),
                color: Color(hexColor('#0E629B')),
                child: Text(
                  'Continue',
                  style: TextStyle(          fontSize: 20.0,
                      letterSpacing: 2.0,color: Color(hexColor('#B7D7DA'))),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Quiz(getGeoList(), getType(),
                            getCategories(), getTime(),getQuestions())),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
