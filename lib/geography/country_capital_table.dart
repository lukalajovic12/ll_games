import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../main.dart';
import 'geo.dart';
import 'geo_main.dart';
import 'package:url_launcher/url_launcher.dart';

class GeoDataWidget extends StatefulWidget {
  @override
  State createState() => new _GeoDataWidget();
}

class _GeoDataWidget extends State<GeoDataWidget> {
  List<String> categories = new List();

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

  List<CountryCapital> getGeoList() {
    List<CountryCapital> ccl = new List();
    if (countryCategoryList != null && !countryCategoryList.isEmpty) {
      ccl = countryCategoryList[getSelectedIndex()].countryCapitalList;
    }
    return ccl;
  }

  _GeoDataWidget() {
    loadGeo();
  }

  void loadGeo() async {
    categories = new List();
    List<CountryCategory> ccl = new List();
    var geoString = await rootBundle.loadString('assets/geo.csv');
    LineSplitter ls = new LineSplitter();
    List<String> geoLines = ls.convert(geoString);
    for (int i = 1; i < geoLines.length; i++) {
      if (geoLines[i].split(",").length < 4) {
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
          CountryCategory countryCategory =
              new CountryCategory(category, countryCapital);
          ccl.add(countryCategory);
        }
      }
    }
    setState(() {
      countryCategoryList = ccl;
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
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(hexColor('#B7D7DA')),
        type: BottomNavigationBarType.fixed,
        currentIndex: getSelectedIndex(),
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
        items: barItems(),
      ),
    );
  }

  Container countryList(BuildContext context) {
    double c_width = MediaQuery.of(context).size.width;
    return Container(
        color: Color(hexColor('#B7D7DA')),
        child: ListView.builder(
          itemCount: getGeoList().length,
          itemBuilder: (context, index) {
            CountryCapital cc = getGeoList()[index];
            return Container(
              padding: new EdgeInsets.only(top: 10, bottom: 10),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: Text(cc.country,
                            style: TextStyle(
                                color: Color(hexColor('#0E629B')),
                                fontSize: 25.0,
                                fontWeight: FontWeight.bold)),
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        padding: new EdgeInsets.only(left: 40),
                        width: c_width / 2,
                        child: Text('Capital:',
                            style: TextStyle(
                                color: Color(hexColor('#0E629B')),
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold)),
                      ),
                      Container(
                          width: c_width / 2,
                          padding: new EdgeInsets.only(left: 65),
                          child: Text(cc.capital,
                              style: TextStyle(
                                  color: Color(hexColor('#0E629B')),
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold))),
                    ],
                  ),
                  Row(children: <Widget>[
                    Container(
                      padding: new EdgeInsets.only(left: 40),
                      width: c_width / 2,
                      child: Text('Wikipedia:',
                          style: TextStyle(
                              color: Color(hexColor('#0E629B')),
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold)),
                    ),
                    Container(
                      width: c_width / 2,
                      child: IconButton(
                        color: Color(hexColor('#0E629B')),
                        icon: Icon(FontAwesomeIcons.wikipediaW),
                        onPressed: () {
                          goToWikipedia(cc.country);
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
                              color: Color(hexColor('#0E629B')),
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold)),
                    ),
                    Container(
                      width: c_width / 2,
                      child: IconButton(
                        color: Color(hexColor('#0E629B')),
                        icon: Icon(FontAwesomeIcons.mapMarker),
                        onPressed: () {
                          goToGoogleMaps(cc.country);
                        },
                      ),
                    ),
                  ]),
                ],
              ),
            );
          },
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
