import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../main.dart';
import 'geo.dart';
import '../main_classes/geo_main.dart';
import 'package:url_launcher/url_launcher.dart';

class GeoDataWidget extends StatefulWidget {


  String type='';

  String getType(){
    if(type==null){
      type='';
    }
    return type;
  }


  String secondaryType='';

  String getSecondaryType(){
    if(secondaryType==null){
      secondaryType='';
    }
    return secondaryType;
  }

  GeoDataWidget(String type,String secondaryType){
    this.type=type;
    this.secondaryType=secondaryType;
  }


  @override
  State createState() => new _GeoDataWidget(getType(),getSecondaryType());
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

  List<QuizObject> getGeoList() {
    List<QuizObject> ccl = new List();
    if (countryCategoryList != null && !countryCategoryList.isEmpty) {
      ccl = countryCategoryList[getSelectedIndex()].countryCapitalList;
    }
    return ccl;
  }

  String type='';

  String getType(){
    if(type==null){
      type='';
    }
    return type;
  }

  String secondaryType='';

  String getSecondaryType(){
    if(secondaryType==null){
      secondaryType='';
    }
    return secondaryType;
  }

  _GeoDataWidget(String type,String secondaryType) {
    this.type=type;
    this.secondaryType=secondaryType;
    if(getType()=='Countries'){
      loadGeo();
    }
    if(getType()=='States'){
      loadStates('assets/states/us_state_capitals.csv','USA');
      loadStates('assets/states/german_state_capitals.csv','Deutschland');
      loadStates('assets/states/austrian_state_capitals.csv','Austria');
    }
    if(getType()=='Presidents'){
      loadPresidents();
    }
  }

  void loadGeo() async {
    categories = new List();
    List<CountryCategory> ccl = new List();
    var geoString = await rootBundle.loadString('assets/countries/geo.csv');
    LineSplitter ls = new LineSplitter();
    List<String> geoLines = ls.convert(geoString);
    for (int i = 1; i < geoLines.length; i++) {
      if (geoLines[i].split(",").length < 4) {
        QuizObject countryCapital = new QuizObject(
            type: geoLines[i].split(",")[0],
            secondaryType: geoLines[i].split(",")[1]);
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

  void loadStates(String file,String category) async {
    List<QuizObject> countryCapitalList=new List();
    var geoString = await rootBundle.loadString(file);
    LineSplitter ls = new LineSplitter();
    List<String> geoLines = ls.convert(geoString);
    for (int i = 1; i < geoLines.length; i++) {
      QuizObject countryCapital = new QuizObject(
          type: geoLines[i].split(",")[0],
          secondaryType: geoLines[i].split(",")[1]);
      countryCapitalList.add(countryCapital);

    }
    CountryCategory countryCategory=new CountryCategory(category, null);
    countryCategory.countryCapitalList=countryCapitalList;
    setState(() {
      getCategories().add(category);
      if(countryCategoryList!=null) {
        countryCategoryList.add(countryCategory);
      }
      else{
        countryCategoryList= new List();
        countryCategoryList.add(countryCategory);
      }
    });
  }


  void loadPresidents() async {
    List<QuizObject> first15=new List();
    List<QuizObject> second15=new List();
    List<QuizObject> other=new List();
    List<CountryCategory> ccl = new List();
    var geoString = await rootBundle.loadString('assets/presidents/american_presidents.csv');
    LineSplitter ls = new LineSplitter();
    List<String> geoLines = ls.convert(geoString);
    for (int i = 1; i < geoLines.length; i++) {
      QuizObject countryCapital = new QuizObject(
          type: geoLines[i].split(",")[1],
          secondaryType: geoLines[i].split(",")[2]);
      if(i<15){
        first15.add(countryCapital);
      } else if(i<30){
        second15.add(countryCapital);
      }
      else{
        first15.add(countryCapital);
      }
      other.add(countryCapital);

    }



    getCategories().add('First 15');
    getCategories().add('Second 15');
    getCategories().add('Other');
    CountryCategory countryCategory1=new CountryCategory(getCategories()[0], null);
    countryCategory1.countryCapitalList=first15;
    ccl.add(countryCategory1);

    CountryCategory countryCategory2=new CountryCategory(getCategories()[1], null);
    countryCategory2.countryCapitalList=second15;
    ccl.add(countryCategory2);



    CountryCategory countryCategory3=new CountryCategory(getCategories()[2], null);
    countryCategory3.countryCapitalList=other;
    ccl.add(countryCategory3);





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
            QuizObject cc = getGeoList()[index];
            return Container(
              padding: new EdgeInsets.only(top: 10, bottom: 10),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: new EdgeInsets.only(left: 40),
                        width: c_width / 2,
                        child: Text('${getType()}:',
                            style: TextStyle(
                                color: Color(hexColor('#0E629B')),
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold)),
                      ),
                      Container(
                          width: c_width / 2,
                          padding: new EdgeInsets.only(left: 65),
                          child: Text(cc.type,
                              style: TextStyle(
                                  color: Color(hexColor('#0E629B')),
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold))),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        padding: new EdgeInsets.only(left: 40),
                        width: c_width / 2,
                        child: Text('${getSecondaryType()}:',
                            style: TextStyle(
                                color: Color(hexColor('#0E629B')),
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold)),
                      ),
                      Container(
                          width: c_width / 2,
                          padding: new EdgeInsets.only(left: 65),
                          child: Text(cc.secondaryType,
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
                          goToGoogleMaps(cc.type);
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
