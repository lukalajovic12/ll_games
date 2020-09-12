import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../main.dart';
import 'geo.dart';
import 'kviz.dart';
import 'statistics.dart';

bool quizType = true;

TextEditingController txt = TextEditingController();

TextEditingController getTxt(){
  if(txt==null){
    txt = TextEditingController();
}
  return txt;
}

int returnTime(){
  int time=30;
   time =int.tryParse(getTxt().text);
  return time;
}



class GeoMainWidget extends StatefulWidget {
  @override
  State createState() => new _GeoMainWidget();
}

enum SingingCharacter { Countries, Capitals }

class _GeoMainWidget extends State<GeoMainWidget> {
  _GeoMainWidget() {}

  SingingCharacter _character = SingingCharacter.Countries;

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
      body: GeoTabWidget(),
      drawer: Drawer(
        child: Container(
          color: Color(hexColor('#B7D7DA')),
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Text('Settings'),
                decoration: BoxDecoration(
                  color: Color(hexColor('#B7D7DA')),
                ),
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
              /*
              ListTile(
                title: const Text('time'),
                leading: TextField(
                  controller: getTxt(),
                  decoration: new InputDecoration(labelText: "30"),
                  keyboardType: TextInputType.number,
                ),
              ),
              */

              ListTile(
                title: Center(child: Text('back')),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GeoTabWidget extends StatefulWidget {
  GeoTabWidget() {}

  @override
  State createState() => new _GeoTabWidget();
}

class _GeoTabWidget extends State<GeoTabWidget> {
  List<CountryCategory> countryCategoryList = new List();

  List<CountryCategory> getCountryCategoryList() {
    if (countryCategoryList == null) {
      countryCategoryList = new List();
    }
    return countryCategoryList;
  }

  int returnType() {
    if (quizType) {
      return 1;
    } else {
      return 0;
    }
  }

  List<String> categories = new List();

  List<String> getCategories() {
    if (categories == null) {
      categories = new List();
    }

    return categories;
  }

  Map<String, bool> selectedCategories = {};

  List<CountryCapital> getSelectedCountryCapitals() {
    List<CountryCapital> countryCapitals = new List();
    for (CountryCategory cc in getCountryCategoryList()) {
      if (selectedCategories[cc.category]) {
        countryCapitals.addAll(cc.countryCapitalList);
      }
    }
    return countryCapitals;
  }

  void loadGeo() async {
    categories = new List();
    List<CountryCategory> ccl = new List();
    var geoString = await rootBundle.loadString('assets/geo.csv');
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
        getCategories().add(category);
        selectedCategories[category] = false;
        CountryCategory countryCategory =
            new CountryCategory(category, countryCapital);
        ccl.add(countryCategory);
      }
    }
    setState(() {
      countryCategoryList = ccl;
    });
  }

  _GeoTabWidget() {
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
                padding: new EdgeInsets.only(left: 40, right: 40),
                child: CheckboxListTile(
                  title: new Text(
                    countryCategoryList[i].category,
                    style: TextStyle(color: Color(hexColor('#0E629B'))),
                  ),
                  value: selectedCategories[countryCategoryList[i].category],
                  onChanged: (bool value) {
                    setState(() {
                      selectedCategories[countryCategoryList[i].category] =
                          value;
                    });
                  },
                  activeColor: Color(hexColor('#0E629B')),
                  checkColor: Color(hexColor('#0E629B')),
                ),
              );
            },
          ),
          Container(
            padding: new EdgeInsets.only(top: 90),
            child: Row(
              children: <Widget>[
                Container(
                  padding: new EdgeInsets.only(left: 20, right: 20),
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
                            builder: (context) => ScoreList(returnType())),
                      );
                    },
                  ),
                ),
                Container(
                  padding: new EdgeInsets.only(left: 110),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    color: Color(hexColor('#0E629B')),
                    child: Text(
                      'PLAY',
                      style: TextStyle(color: Color(hexColor('#B7D7DA'))),
                    ),
                    onPressed: () {
                      if (!getSelectedCountryCapitals().isEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Quiz(
                                  getSelectedCountryCapitals(),
                                  returnType(),
                                  getCategories(),
                                  returnTime())),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CountryCategory {
  String category = '';

  List<String> returnCategoryAsList() {
    List<String> cl = new List();
    cl.add(category);
    return cl;
  }

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
