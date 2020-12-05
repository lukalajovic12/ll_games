import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import 'database/geo_database.dart';
import 'geo.dart';
import 'kviz.dart';
import 'left_menu.dart';

class GeoQuizSettingsWidget extends StatefulWidget {
  String type = '';

  String getType() {
    if (type == null) {
      type = '';
    }
    return type;
  }

  List<String> categories = new List();

  GeoQuizSettingsWidget(List<String> categories, String type) {
    this.categories = categories;
    this.type = type;
  }

  @override
  State createState() => new _GeoQuizSettingsWidget(getCategories(), getType());

  List<String> getCategories() {
    if (categories == null) {
      categories = new List();
    }
    return categories;
  }
}

class _GeoQuizSettingsWidget extends State<GeoQuizSettingsWidget> {
  final ScrollController scrollController = ScrollController();

  List<String> categories = new List();

  double time = 30.0;

  double numberOfAnwsers = 3.0;

  Map<String, bool> selectedTypes = {};


  bool isLoading=false;

  Map<String, bool> getSelectedTypes(){
    if(selectedTypes==null){
      selectedTypes={};
    }
    return selectedTypes;
  }

  List<String> types = new List();

  List<String> getTypes(){
    if(types==null){
      types=new List();
    }
    return types;
  }

  final dbGameHelper = DatabaseGameHelper.instance;

  _GeoQuizSettingsWidget(List<String> categories, String type) {
    this.categories = categories;
    selectedTypes = {};
    types = [type];
    selectedTypes[type]=false;
    loadData();
  }

  Future<void> loadData() async {
    isLoading=true;
    String secondaryType = await dbGameHelper.queryAtributesDataByType(
        getTypes()[0], DatabaseGameHelper.questionSecondaryType);

    setState(() {
      isLoading=false;
      getSelectedTypes()[secondaryType] = false;
      getTypes().add(secondaryType);
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
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
        color: Color(hexColor('#B7D7DA')),




        child: isLoading
            ? Center(
          child: CircularProgressIndicator(),
        )

        :Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Center(
                child: Text('time ${getTime()}',
                    style: TextStyle(
                      color: Color(hexColor('#0E629B')),
                      fontSize: 20.0,
                    )),
              ),
            ),
            Slider(
              value: time,
              min: 10,
              max: 100,
              divisions: 90,
              label: time.round().toString(),
              onChanged: (double value) {
                setState(() {
                  time = value;
                });
              },
            ),
            Container(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Center(
                child: Text('number of anwsers ${getNumberOfAnwsers()}',
                    style: TextStyle(
                      color: Color(hexColor('#0E629B')),
                      fontSize: 20.0,
                    )),
              ),
            ),
            Slider(
              value: numberOfAnwsers,
              min: 2,
              max: 5,
              divisions: 3,
              label: numberOfAnwsers.round().toString(),
              onChanged: (double value) {
                setState(() {
                  numberOfAnwsers = value;
                });
              },
            ),
            SizedBox(
              height: screenHeight * 0.2,
              child: ListView.builder(
                controller: scrollController,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: getTypes().length,
                itemBuilder: (context, i) {
                  return Container(
                    padding: new EdgeInsets.only(left: 40, right: 40),
                    child: CheckboxListTile(
                      title: new Text(
                        getTypes()[i],
                        style: TextStyle(color: Color(hexColor('#0E629B'))),
                      ),
                      value: getSelectedTypes()[getTypes()[i]],
                      onChanged: (bool value) {
                        setState(() {
                          getSelectedTypes()[getTypes()[i]] = value;
                        });
                      },
                      activeColor: Color(hexColor('#0E629B')),
                      checkColor: Color(hexColor('#0E629B')),
                    ),
                  );
                },
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
                  'Play',
                  style: TextStyle(color: Color(hexColor('#B7D7DA'))),
                ),
                onPressed: () {
                  if (types.length == 2 &&
                      (getSelectedTypes()[types[0]] || getSelectedTypes()[types[1]])) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Quiz(
                              isReverse(),
                              getCategories(),
                              getTime(),
                              getNumberOfAnwsers(),
                              types[0])),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      drawer: leftMenu(context, types[0]),
    );
  }

  int isReverse() {
    if (types.length == 2 &&
        (selectedTypes[types[0]] == selectedTypes[types[1]])) {
      return 3;
    } else {
      if (selectedTypes[types[0]]) {
        return 1;
      } else {
        return 2;
      }
    }
  }

  int getTime() {
    if (time == null) {
      time = 30.0;
    }
    return time.round();
  }

  int getNumberOfAnwsers() {
    if (numberOfAnwsers == null) {
      numberOfAnwsers = 3.0;
    }
    return numberOfAnwsers.round();
  }

  List<String> getCategories() {
    if (categories == null) {
      categories = new List();
    }
    return categories;
  }
}
