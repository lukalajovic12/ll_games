import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../main.dart';
import 'database/geo_database.dart';
import 'edit_data.dart';
import 'geo.dart';
import '../main_classes/geo_main.dart';
import 'package:url_launcher/url_launcher.dart';

class GeoDataWidget extends StatefulWidget {
  String type = '';

  String getType() {
    if (type == null) {
      type = '';
    }
    return type;
  }

  GeoDataWidget(String type) {
    this.type = type;
  }

  @override
  State createState() => new _GeoDataWidget(getType());
}

class _GeoDataWidget extends State<GeoDataWidget> {
  final dbGameHelper = DatabaseGameHelper.instance;

  List<String> categories = new List();
  bool isLoading = true;

  List<String> getCategories() {
    if (categories == null) {
      categories = new List();
    }
    return categories;
  }

  List<BottomNavigationBarItem> barItems() {
    List<BottomNavigationBarItem> bl = new List();

    for (String s in getCategories()) {
      BottomNavigationBarItem b = new BottomNavigationBarItem(
        title: Text(s),
        icon: Icon(FontAwesomeIcons.globeAsia),
      );
      bl.add(b);
    }
    return bl;
  }

  List<CountryCategory> countryCategoryList = new List();

  int selectedIndex = 0;

  int getSelectedIndex() {
    if (selectedIndex == null) {
      selectedIndex = 0;
    }
    return selectedIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  String getTitle() {
    String title = "";
    if (countryCategoryList != null && !countryCategoryList.isEmpty) {
      title = countryCategoryList[getSelectedIndex()].category;
    }
    return title;
  }

  List<QuizObjectData> getGeoList() {
    List<QuizObjectData> ccl = new List();
    if (countryCategoryList != null && !countryCategoryList.isEmpty) {
      ccl = countryCategoryList[getSelectedIndex()].countryCapitalList;
    }
    return ccl;
  }

  String type = '';

  String getType() {
    if (type == null) {
      type = '';
    }
    return type;
  }

  String secondaryType = '';

  String getSecondaryType() {
    if (secondaryType == null) {
      secondaryType = '';
    }
    return secondaryType;
  }

  _GeoDataWidget(String type) {
    this.type = type;
    loadData();
  }

  void loadData() async {
    isLoading = true;
    countryCategoryList = new List();
    List<CountryCategory> ccl = new List();
    final questionRows = await dbGameHelper.queryQuestionsDataByType(getType());
    List<QuizObjectData> countryCapitalList = new List();

    if (questionRows != null) {
      questionRows.forEach((row) => countryCapitalList.add(new QuizObjectData(
            id: row[DatabaseGameHelper.columnId],
            type: row[DatabaseGameHelper.primaryQuestionData],
            secondaryType: row[DatabaseGameHelper.secondaryQuestionData],
            category: row[DatabaseGameHelper.category],
          )));
    }

    for (QuizObjectData qod in countryCapitalList) {
      String category = qod.category;
      bool newContinent = true;
      for (int i = 0; i < ccl.length; i++) {
        if (category == ccl[i].category) {
          ccl[i].addCountryCapital(qod);
          newContinent = false;
          break;
        }
      }
      if (newContinent) {
        getCategories().add(category);
        CountryCategory countryCategory = new CountryCategory(category, qod);
        ccl.add(countryCategory);
      }
    }
    secondaryType = await dbGameHelper.queryAtributesDataByType(
        type, DatabaseGameHelper.questionSecondaryType);
    setState(() {
      countryCategoryList = ccl;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          getTitle(),
          style: TextStyle(fontStyle: FontStyle.italic),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
      ),
      body: countryList(context),

      bottomNavigationBar: getCategories().length<2 || isLoading
          ? null
          : BottomNavigationBar(
              backgroundColor: Color(hexColor('#B7D7DA')),
              type: BottomNavigationBarType.fixed,
              currentIndex: getSelectedIndex(),
              selectedItemColor: Colors.amber[800],
              onTap: _onItemTapped,
              items: barItems(),
            ),
    );
  }

  final ScrollController scrollController = ScrollController();

  Container countryList(BuildContext context) {
    double c_width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
        color: Color(hexColor('#B7D7DA')),
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: height * 0.65,
                      child: Scrollbar(
                        controller: scrollController,
                        child: ListView.builder(
                          itemCount: getGeoList().length,
                          itemBuilder: (context, index) {
                            QuizObjectData cc = getGeoList()[index];
                            return Container(
                              padding: new EdgeInsets.only(top: 10, bottom: 10),
                              child: Container(
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          padding:
                                              new EdgeInsets.only(left: 40),
                                          width: c_width / 2,
                                          child: Text('${getType()}:',
                                              style: TextStyle(
                                                  color: Color(
                                                      hexColor('#0E629B')),
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                        Container(
                                            width: c_width / 2,
                                            padding:
                                                new EdgeInsets.only(left: 65),
                                            child: Text(cc.type,
                                                style: TextStyle(
                                                    color: Color(
                                                        hexColor('#0E629B')),
                                                    fontSize: 20.0,
                                                    fontWeight:
                                                        FontWeight.bold))),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Container(
                                          padding:
                                              new EdgeInsets.only(left: 40),
                                          width: c_width / 2,
                                          child: Text('${getSecondaryType()}:',
                                              style: TextStyle(
                                                  color: Color(
                                                      hexColor('#0E629B')),
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                        Container(
                                            width: c_width / 2,
                                            padding:
                                                new EdgeInsets.only(left: 65),
                                            child: Text(cc.secondaryType,
                                                style: TextStyle(
                                                    color: Color(
                                                        hexColor('#0E629B')),
                                                    fontSize: 20.0,
                                                    fontWeight:
                                                        FontWeight.bold))),
                                      ],
                                    ),
                                    Row(children: <Widget>[
                                      Container(
                                        padding: new EdgeInsets.only(left: 40),
                                        width: c_width / 2,
                                        child: Text('EDIT',
                                            style: TextStyle(
                                                color:
                                                    Color(hexColor('#0E629B')),
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      Container(
                                        width: c_width / 2,
                                        child: IconButton(
                                          color: Color(hexColor('#0E629B')),
                                          icon: Icon(FontAwesomeIcons.pen),
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        GeoDataEditWidget(
                                                            cc.id,
                                                            cc.type,
                                                            cc.secondaryType,
                                                            cc.category,
                                                            getType())));
                                          },
                                        ),
                                      ),
                                    ]),
                                    Row(children: <Widget>[
                                      Container(
                                        padding: new EdgeInsets.only(left: 40),
                                        width: c_width / 2,
                                        child: Text('Wikipedia:',
                                            style: TextStyle(
                                                color:
                                                    Color(hexColor('#0E629B')),
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      Container(
                                        width: c_width / 2,
                                        child: IconButton(
                                          color: Color(hexColor('#0E629B')),
                                          icon:
                                              Icon(FontAwesomeIcons.wikipediaW),
                                          onPressed: () {
                                            goToWikipedia(cc.type);
                                          },
                                        ),
                                      ),
                                    ]),
                                    Row(children: <Widget>[
                                      Container(
                                        padding: new EdgeInsets.only(left: 40),
                                        width: c_width / 2,
                                        child: Text('Google maps:',
                                            style: TextStyle(
                                                color:
                                                    Color(hexColor('#0E629B')),
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      Container(
                                        width: c_width / 2,
                                        child: IconButton(
                                          color: Color(hexColor('#0E629B')),
                                          icon:
                                              Icon(FontAwesomeIcons.mapMarker),
                                          onPressed: () {
                                            goToGoogleMaps(cc.type);
                                          },
                                        ),
                                      ),
                                    ]),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Container(
                      padding: new EdgeInsets.only(top: 20, left: 160),
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        color: Color(hexColor('#0E629B')),
                        child: Text(
                          'Add',
                          style: TextStyle(color: Color(hexColor('#B7D7DA'))),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => GeoDataEditWidget(
                                      -1, "", "", "", getType())));
                        },
                      ),
                    ),
                  ],
                ),
              ));
  }
}

void goToWikipedia(String country) {
  String url = 'https://en.wikipedia.org/wiki/$country';
  launchUrl(url);
}

void goToGoogleMaps(String country) {
  String url = 'https://www.google.com/maps/place/$country';
  launchUrl(url);
}

void goToBritanica(String country) {
  String url = 'https://www.britannica.com/place/$country';
  launchUrl(url);
}

Future<bool> launchUrl(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

class GeographyObject {
  String country;
  String capital;
  String category;
  String subCategory;

  GeographyObject(
      {this.country, this.capital, this.category, this.subCategory}) {}
}
