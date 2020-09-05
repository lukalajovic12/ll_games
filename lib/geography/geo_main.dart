import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../main.dart';
import 'geo.dart';
import 'kviz.dart';
import 'score_table.dart';

class GeoMainWidget extends StatefulWidget {
  @override
  State createState() => new _GeoMainWidget();
}

class _GeoMainWidget extends State<GeoMainWidget> {
  _GeoMainWidget() {}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: DefaultTabController(
            length: 2,
            child: Scaffold(
                appBar: AppBar(
                  iconTheme: IconThemeData(
                    color: Colors.black, //change your color here
                  ),
                  title: Text('GEO'),
                  centerTitle: true,
                  backgroundColor: Colors.blue,
                  bottom: TabBar(
                    indicatorColor: Color(0xff9962D0),
                    tabs: [
                      Tab(
                        icon: Icon(FontAwesomeIcons.landmark),
                        text: 'countries',
                      ),
                      Tab(
                        icon: Icon(FontAwesomeIcons.city),
                        text: 'capitals',
                      ),
                    ],
                  ),
                ),
                body: TabBarView(children: [
                  GeoTabWidget(1),
                  GeoTabWidget(2),
                ]))));
  }
}

class GeoTabWidget extends StatefulWidget {
  int type = 1;

  GeoTabWidget(int type) {
    this.type = type;
  }

  @override
  State createState() => new _GeoTabWidget(type);
}

class _GeoTabWidget extends State<GeoTabWidget> {
  List<CountryCategory> countryCategoryList = new List();

  int type = 1;

  void loadGeo() async {
    List<CountryCategory> ccl = new List();
    var geoString = await rootBundle.loadString('assets/geo.txt');
    LineSplitter ls = new LineSplitter();
    List<String> geoLines = ls.convert(geoString);
    for (int i = 0; i < geoLines.length; i++) {
      CountryCapital countryCapital = new CountryCapital(
          country: geoLines[i].split(",")[0],
          capital: geoLines[i].split(",")[1]);
      String category = geoLines[i].split(",")[2];
      bool newContinent = true;
      for (int i = 0; i < ccl.length; i++) {
        if (category == ccl[i].category) {
          ccl[i].addCountryCapital(countryCapital);
          newContinent = false;
          break;
        }
      }
      if (newContinent) {
        CountryCategory countryCategory =
            new CountryCategory(category, countryCapital);
        ccl.add(countryCategory);
      }
    }
    setState(() {
      countryCategoryList = ccl;
    });
  }

  _GeoTabWidget(int type) {
    this.type = type;
    loadGeo();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Color(hexColor('#B7D7DA')),
        child: Column(
          children: <Widget>[
            ListView.builder(
                shrinkWrap: true,
                itemCount: countryCategoryList.length,
                itemBuilder: (context, i) {
                  return Container(
                    padding: new EdgeInsets.only(
                        left: 40, right: 40),
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      color: Color(hexColor('#0E629B')),
                      child: Text(
                        countryCategoryList[i].category,
                        style: TextStyle(color: Color(hexColor('#B7D7DA'))),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Quiz(
                                  countryCategoryList[i].countryCapitalList,
                                  type,
                                  countryCategoryList[i].category)),
                        );
                      },
                    ),
                  );
                }),



      Container(
        padding: new EdgeInsets.only(
            left: 40, right: 40),
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          color: Color(hexColor('#0E629B')),
          child: Text(
            'STATISTICS',
            style: TextStyle(color: Color(hexColor('#B7D7DA'))),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ScoreList(type)),
            );
          },
        ),
      ),








          ],
        ));
  }
}

class CountryCategory {
  String category = '';

  List<CountryCapital> countryCapitalList = new List();

  CountryCategory(String category, CountryCapital countryCapital) {
    this.category = category;

    countryCapitalList = new List();
    countryCapitalList.add(countryCapital);
  }

  void addCountryCapital(CountryCapital countryCapital) {
    countryCapitalList.add(countryCapital);
  }
}
