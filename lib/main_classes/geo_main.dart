import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../main.dart';
import '../geography/geo.dart';
import '../geography/geo_quiz_settings.dart';
import '../geography/left_menu.dart';
import 'package:flutter/material.dart';

class GeoMainWidget extends StatefulWidget {

  String type='';

  String getType(){
    if(type==null){
      type='';
    }
    return type;
  }

  GeoMainWidget(String type,String secondaryType){
    this.type=type;
    this.secondaryType=secondaryType;
  }


  String secondaryType='';

  String getSecondaryType(){
    if(secondaryType==null){
      secondaryType='';
    }
    return secondaryType;
  }

  @override
  State createState() => new _GeoMainWidget(getType(),getSecondaryType());
}

class _GeoMainWidget extends State<GeoMainWidget> {

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

  _GeoMainWidget(String type,String secondaryType) {
    this.type=type;
    this.secondaryType=secondaryType;
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
      body: GeoTabWidget(getType(),getSecondaryType()),
      drawer: leftMenu(context,getType(),getSecondaryType()),
    );
  }
}

class GeoTabWidget extends StatefulWidget {

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

  GeoTabWidget(String type,String secondaryType) {
    this.type=type;
    this.secondaryType=secondaryType;
  }

  @override
  State createState() => new _GeoTabWidget(getType(),getSecondaryType());
}

class _GeoTabWidget extends State<GeoTabWidget> {
  final ScrollController scrollController = ScrollController();

  List<CountryCategory> countryCategoryList = new List();

  List<String> categories = new List();

  Map<String, bool> selectedCategories = {};


  String type='Countries';

  String getType(){
    if(type==null){
      type='Countries';
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

  _GeoTabWidget(String type,String secondaryType) {
    this.type=type;
    this.secondaryType=secondaryType;
    if(type=='Countries'){
      loadGeo();
    }
    if(type=='States'){
      loadStates('assets/states/us_state_capitals.csv', 'USA');
      loadStates('assets/states/german_state_capitals.csv', 'Deutschland');
      loadStates('assets/states/austrian_state_capitals.csv', 'Austria');
    }
    if(type=='Presidents'){
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
          selectedCategories[category] = false;
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

  void loadStates(String file, String category) async {
    List<QuizObject> countryCapitalList = new List();
    var geoString = await rootBundle.loadString(file);
    LineSplitter ls = new LineSplitter();
    List<String> geoLines = ls.convert(geoString);
    for (int i = 1; i < geoLines.length; i++) {
      QuizObject countryCapital = new QuizObject(
          type: geoLines[i].split(",")[0],
          secondaryType: geoLines[i].split(",")[1]);
      countryCapitalList.add(countryCapital);
    }
    selectedCategories[category] = false;
    CountryCategory countryCategory = new CountryCategory(category, null);
    countryCategory.countryCapitalList = countryCapitalList;
    setState(() {
      if (countryCategoryList != null) {
        countryCategoryList.add(countryCategory);
      } else {
        countryCategoryList = new List();
        countryCategoryList.add(countryCategory);
      }
    });
  }


  void loadPresidents() async {
    List<QuizObject> countryCapitalList = new List();
    var geoString = await rootBundle.loadString('assets/presidents/american_presidents.csv');
    LineSplitter ls = new LineSplitter();
    List<String> geoLines = ls.convert(geoString);
    for (int i = 1; i < geoLines.length; i++) {
      QuizObject countryCapital = new QuizObject(
          type: geoLines[i].split(",")[1],
          secondaryType: geoLines[i].split(",")[2]);
      countryCapitalList.add(countryCapital);
    }
    selectedCategories['Presidents'] = false;
    CountryCategory countryCategory = new CountryCategory('Presidents', null);
    countryCategory.countryCapitalList = countryCapitalList;
    setState(() {
      if (countryCategoryList != null) {
        countryCategoryList.add(countryCategory);
      } else {
        countryCategoryList = new List();
        countryCategoryList.add(countryCategory);
      }
    });
  }






  @override
  Widget build(BuildContext context) {
    double c_height = MediaQuery.of(context).size.height;
    return Container(
      color: Color(hexColor('#B7D7DA')),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: c_height * 0.7,
            child: Scrollbar(
              controller: scrollController,
              child: ListView.builder(
                controller: scrollController,
                scrollDirection: Axis.vertical,
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
                      value:
                          selectedCategories[countryCategoryList[i].category],
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
                'PLAY',
                style: TextStyle(color: Color(hexColor('#B7D7DA'))),
              ),
              onPressed: () {
                if (!getSelectedCountryCapitals().isEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => GeoQuizSettingsWidget(
                            getSelectedCountryCapitals(),
                            getSelectedCategories(),getType(),getSecondaryType())),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  List<CountryCategory> getCountryCategoryList() {
    if (countryCategoryList == null) {
      countryCategoryList = new List();
    }
    return countryCategoryList;
  }

  List<String> getCategories() {
    if (categories == null) {
      categories = new List();
    }
    return categories;
  }

  List<QuizObject> getSelectedCountryCapitals() {
    List<QuizObject> countryCapitals = new List();
    for (CountryCategory cc in getCountryCategoryList()) {
      if (selectedCategories[cc.category]) {
        countryCapitals.addAll(cc.countryCapitalList);
      }
    }
    return countryCapitals;
  }

  List<String> getSelectedCategories() {
    List<String> sc = new List();
    for (String s in selectedCategories.keys) {
      if (selectedCategories[s]) {
        sc.add(s);
      }
    }
    return sc;
  }
}

class CountryCategory {
  String category = '';

  List<String> returnCategoryAsList() {
    List<String> cl = new List();
    cl.add(category);
    return cl;
  }

  List<QuizObject> countryCapitalList = new List();

  CountryCategory(String category, QuizObject countryCapital) {
    this.category = category;
    countryCapitalList = new List();
    if (countryCapital != null) {
      countryCapitalList.add(countryCapital);
    }
  }

  void addCountryCapital(QuizObject countryCapital) {
    countryCapitalList.add(countryCapital);
  }
}
