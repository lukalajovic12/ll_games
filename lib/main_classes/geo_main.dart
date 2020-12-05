import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:llgames/geography/database/geo_database.dart';
import '../main.dart';
import '../geography/geo.dart';
import '../geography/geo_quiz_settings.dart';
import '../geography/left_menu.dart';

class GeoMainWidget extends StatefulWidget {
  String type = '';

  String getType() {
    if (type == null) {
      type = '';
    }
    return type;
  }

  GeoMainWidget(String type) {
    this.type = type;
  }

  @override
  State createState() => new _GeoMainWidget(
        getType(),
      );
}

class _GeoMainWidget extends State<GeoMainWidget> {
  String type = '';

  String getType() {
    if (type == null) {
      type = '';
    }
    return type;
  }

  _GeoMainWidget(String type) {
    this.type = type;
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
      body: GeoTabWidget(getType()),
      drawer: leftMenu(context, getType()),
    );
  }
}

class GeoTabWidget extends StatefulWidget {
  String type = '';

  String getType() {
    if (type == null) {
      type = '';
    }
    return type;
  }

  GeoTabWidget(String type) {
    this.type = type;
  }

  @override
  State createState() => new _GeoTabWidget(getType());
}

class _GeoTabWidget extends State<GeoTabWidget> {
  final ScrollController scrollController = ScrollController();

  List<String> categories = new List();

  Map<String, bool> selectedCategories = {};

  final dbGameHelper = DatabaseGameHelper.instance;

  String type = '';

  String getType() {
    if (type == null) {
      type = '';
    }
    return type;
  }

  bool isLoading = true;

  _GeoTabWidget(String type) {
    this.type = type;
    loadData();
  }

  void loadData() async {
    isLoading = true;
    await dbGameHelper.createQuestionData();
    final categoryRows = await dbGameHelper.selectCategoriesByType(getType());
    List<String> categs = new List();
    if (categoryRows != null) {
      categoryRows
          .forEach((row) => categs.add(row[DatabaseGameHelper.category]));
    }
    setState(() {
      categories = new List();
      for (String cat in categs) {
        selectedCategories[cat] = false;
        categories.add(cat);
      }
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Container(
      color: Color(hexColor('#B7D7DA')),
      child: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: <Widget>[
                SizedBox(
                  height: height * 0.7,
                  child: Scrollbar(
                    controller: scrollController,
                    child: ListView.builder(
                      controller: scrollController,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: selectedCategories.length,
                      itemBuilder: (context, i) {
                        return Container(
                          padding: new EdgeInsets.only(left: 40, right: 40),
                          child: CheckboxListTile(
                            title: new Text(
                              selectedCategories.keys.toList()[i],
                              style:
                                  TextStyle(color: Color(hexColor('#0E629B'))),
                            ),
                            value: selectedCategories[
                                selectedCategories.keys.toList()[i]],
                            onChanged: (bool value) {
                              setState(() {
                                selectedCategories[selectedCategories.keys
                                    .toList()[i]] = value;
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
                      if (selectedCategories.containsValue(true)) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GeoQuizSettingsWidget(
                                  getSelectedCategories(), getType()),
                            ));
                      }
                    },
                  ),
                ),
              ],
            ),
    );
  }

  List<String> getCategories() {
    if (categories == null) {
      categories = new List();
    }
    return categories;
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
