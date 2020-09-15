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

  List<String> categories = new List();

  GeoQuizSettingsWidget(List<CountryCapital> geoList, List<String> categories) {
    this.geoList = geoList;
    this.categories = categories;
  }

  @override
  State createState() =>
      new _GeoQuizSettingsWidget(getGeoList(), getCategories());

  List<String> getCategories() {
    if (categories == null) {
      categories = new List();
    }
    return categories;
  }

  List<CountryCapital> getGeoList() {
    if (geoList == null) {
      geoList = new List();
    }
    return geoList;
  }
}

class _GeoQuizSettingsWidget extends State<GeoQuizSettingsWidget> {
  List<CountryCapital> geoList;

  List<String> categories = new List();

  double time = 30.0;

  double numberOfAnwsers = 3.0;

  Map<String, bool> selectedTypes = {};

  _GeoQuizSettingsWidget(
      List<CountryCapital> geoList, List<String> categories) {
    this.geoList = geoList;
    this.categories = categories;
    selectedTypes = {};
    selectedTypes['Countries'] = true;
    selectedTypes['Capitals'] = false;
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
                child: Text('number of anwsers ${getNumberOfAnwsers()}',
                    style: TextStyle(
                      color: Color(hexColor('#0E629B')),
                      fontSize: 20.0,
                    )),
              ),
            ),
            Slider(
              value: numberOfAnwsers,
              min: 2,
              max: 5,
              divisions: 3,
              label: numberOfAnwsers.round().toString(),
              onChanged: (double value) {
                setState(() {
                  numberOfAnwsers = value;
                });
              },
            ),
            Container(
              padding: new EdgeInsets.only(left: 40, right: 40),
              child: CheckboxListTile(
                title: new Text(
                  'Countries',
                  style: TextStyle(color: Color(hexColor('#0E629B'))),
                ),
                value: selectedTypes['Countries'],
                onChanged: (bool value) {
                  setState(() {
                    selectedTypes['Countries'] = value;
                  });
                },
                activeColor: Color(hexColor('#0E629B')),
                checkColor: Color(hexColor('#0E629B')),
              ),
            ),
            Container(
              padding: new EdgeInsets.only(left: 40, right: 40),
              child: CheckboxListTile(
                title: new Text(
                  'Capitals',
                  style: TextStyle(color: Color(hexColor('#0E629B'))),
                ),
                value: selectedTypes['Capitals'],
                onChanged: (bool value) {
                  setState(() {
                    selectedTypes['Capitals'] = value;
                  });
                },
                activeColor: Color(hexColor('#0E629B')),
                checkColor: Color(hexColor('#0E629B')),
              ),
            ),
            Container(
              padding:
                  new EdgeInsets.only(top:20,left: 160),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                color: Color(hexColor('#0E629B')),
                child: Text(
                  'Play',
                  style: TextStyle(
                      color: Color(hexColor('#B7D7DA'))),
                ),
                onPressed: () {
                  if (selectedTypes['Countries'] || selectedTypes['Capitals']) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Quiz(
                              getGeoList(),
                              selectedTypes,
                              getCategories(),
                              getTime(),
                              getNumberOfAnwsers())),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  int getTime() {
    if (time == null) {
      time = 30.0;
    }
    return time.round();
  }

  int getNumberOfAnwsers() {
    if (numberOfAnwsers == null) {
      numberOfAnwsers = 3.0;
    }
    return numberOfAnwsers.round();
  }

  List<String> getCategories() {
    if (categories == null) {
      categories = new List();
    }
    return categories;
  }

  List<CountryCapital> getGeoList() {
    if (geoList == null) {
      geoList = new List();
    }
    return geoList;
  }
}
