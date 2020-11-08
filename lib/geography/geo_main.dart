import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../main.dart';
import 'geo.dart';
import 'geo_quiz_settings.dart';
import 'left_menu.dart';
import 'package:flutter/material.dart';



class GeoMainWidget extends StatefulWidget {
  @override
  State createState() => new _GeoMainWidget();
}

class _GeoMainWidget extends State<GeoMainWidget> {
  _GeoMainWidget() {}

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
      drawer: leftMenu(context),
    );
  }
}

class GeoTabWidget extends StatefulWidget {
  GeoTabWidget() {}

  @override
  State createState() => new _GeoTabWidget();
}

class _GeoTabWidget extends State<GeoTabWidget> {

  final ScrollController scrollController = ScrollController();

  List<CountryCategory> countryCategoryList = new List();

  List<String> categories = new List();

  Map<String, bool> selectedCategories = {};


  _GeoTabWidget() {
    loadGeo();
    loadStates('assets/us_state_capitals.csv','USA');
    loadStates('assets/german_state_capitals.csv','Deutschland');
    loadStates('assets/austrian_state_capitals.csv','Austria');

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



  void loadStates(String file,String category) async {
    List<CountryCapital> countryCapitalList=new List();
    var geoString = await rootBundle.loadString(file);
    LineSplitter ls = new LineSplitter();
    List<String> geoLines = ls.convert(geoString);
    for (int i = 1; i < geoLines.length; i++) {
        CountryCapital countryCapital = new CountryCapital(
            country: geoLines[i].split(",")[0],
            capital: geoLines[i].split(",")[1]);
        countryCapitalList.add(countryCapital);

    }
    selectedCategories[category] = false;
    CountryCategory countryCategory=new CountryCategory(category, null);
    countryCategory.countryCapitalList=countryCapitalList;
    setState(() {
      if(countryCategoryList!=null) {
        countryCategoryList.add(countryCategory);
      }
      else{
        countryCategoryList= new List();
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
        height: c_height*0.7,
        child:Scrollbar(
          controller: scrollController,
          child:ListView.builder(
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
        ),




      ),

          Container(
            padding: new EdgeInsets.only(top:20, left: 160),
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
                            getSelectedCountryCapitals(), getSelectedCategories())),
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

  List<CountryCapital> getSelectedCountryCapitals() {
    List<CountryCapital> countryCapitals = new List();
    for (CountryCategory cc in getCountryCategoryList()) {
      if (selectedCategories[cc.category]) {
        countryCapitals.addAll(cc.countryCapitalList);
      }
    }
    return countryCapitals;
  }

  List<String> getSelectedCategories() {
    List<String> sc=new List();
    for(String s in selectedCategories.keys){
      if(selectedCategories[s]){
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

  List<CountryCapital> countryCapitalList = new List();

  CountryCategory(String category, CountryCapital countryCapital) {
    this.category = category;
    countryCapitalList = new List();
    if (countryCapital != null){
      countryCapitalList.add(countryCapital);
  }
  }



  void addCountryCapital(CountryCapital countryCapital) {
    countryCapitalList.add(countryCapital);
  }
}
