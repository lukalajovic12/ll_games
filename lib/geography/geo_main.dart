import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../main.dart';
import 'geo.dart';
import 'kviz.dart';
import 'statistics.dart';

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
                ]),




              drawer: Drawer(
                // Add a ListView to the drawer. This ensures the user can scroll
                // through the options in the drawer if there isn't enough vertical
                // space to fit everything.
                child: ListView(
                  // Important: Remove any padding from the ListView.
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    DrawerHeader(
                      child: Text('Drawer Header'),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                      ),
                    ),
                    ListTile(
                      title: Text('Item 1'),
                      onTap: () {
                        // Update the state of the app
                        // ...
                        // Then close the drawer
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      title: Text('Item 2'),
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




            )),






    );
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

  List<CountryCategory> getCountryCategoryList() {
    if (countryCategoryList == null) {
      countryCategoryList = new List();
    }
    return countryCategoryList;
  }

  int type = 1;

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
                            builder: (context) => ScoreList(type)),
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Quiz(
                                getSelectedCountryCapitals(),
                                type,
                                getCategories())),
                      );
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
