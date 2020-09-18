import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'geo.dart';
import 'geo_main.dart';

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
          'Gemory',
          style: TextStyle(fontStyle: FontStyle.italic),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
      ),
      body: Container(
          child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: DataTable(
          sortAscending: true,
          columns: <DataColumn>[
            DataColumn(
              label: Text('country'),
            ),
            DataColumn(
              label: Text('capital'),
            ),
          ],
          rows: getGeoList()
              .map(
                (cc) => DataRow(
                  cells: [
                    DataCell(
                      Text(cc.country),
                      showEditIcon: false,
                      placeholder: false,
                    ),
                    DataCell(
                      Text(cc.capital),
                      showEditIcon: false,
                      placeholder: false,
                    ),
                  ],
                ),
              )
              .toList(),
        ),
      )),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: getSelectedIndex(),
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
        items: barItems(),
      ),
    );
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
