import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import 'geo.dart';
import 'kviz.dart';
import 'left_menu.dart';
class GeoQuizSettingsWidget extends StatefulWidget {


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

  List<QuizObject> geoList;

  List<String> categories = new List();

  GeoQuizSettingsWidget(List<QuizObject> geoList, List<String> categories,String type,String secondaryType) {
    this.geoList = geoList;
    this.categories = categories;
    this.type=type;
    this.secondaryType=secondaryType;
  }

  @override
  State createState() =>
      new _GeoQuizSettingsWidget(getGeoList(), getCategories(),getType(),getSecondaryType());

  List<String> getCategories() {
    if (categories == null) {
      categories = new List();
    }
    return categories;
  }

  List<QuizObject> getGeoList() {
    if (geoList == null) {
      geoList = new List();
    }
    return geoList;
  }
}

class _GeoQuizSettingsWidget extends State<GeoQuizSettingsWidget> {

  String secondaryType='';

  String getSecondaryType(){
    if(secondaryType==null){
      secondaryType='';
    }
    return secondaryType;
  }

  List<QuizObject> geoList;

  List<String> categories = new List();

  double time = 30.0;

  double numberOfAnwsers = 3.0;

  Map<String, bool> selectedTypes = {};

  String type='';

  String getType(){
    if(type==null){
      type='';
    }
    return type;
  }

  _GeoQuizSettingsWidget(
      List<QuizObject> geoList, List<String> categories,String type,String secondaryType) {
    this.geoList = geoList;
    this.categories = categories;
    selectedTypes = {};
    this.type=type;
    this.secondaryType=secondaryType;
    selectedTypes[getType()] = true;
    selectedTypes[getSecondaryType()] = false;
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
        color: Color(hexColor('#B7D7DA')),
        child: Column(
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
            Container(
              padding: new EdgeInsets.only(left: 40, right: 40),
              child: CheckboxListTile(
                title: new Text(
                  getType(),
                  style: TextStyle(color: Color(hexColor('#0E629B'))),
                ),
                value: selectedTypes[getType()],
                onChanged: (bool value) {
                  setState(() {
                    selectedTypes[getType()] = value;
                  });
                },
                activeColor: Color(hexColor('#0E629B')),
                checkColor: Color(hexColor('#0E629B')),
              ),
            ),
            Container(
              padding: new EdgeInsets.only(left: 40, right: 40),
              child: CheckboxListTile(
                title: new Text(
                  getSecondaryType(),
                  style: TextStyle(color: Color(hexColor('#0E629B'))),
                ),
                value: selectedTypes[getSecondaryType()],
                onChanged: (bool value) {
                  setState(() {
                    selectedTypes[getSecondaryType()] = value;
                  });
                },
                activeColor: Color(hexColor('#0E629B')),
                checkColor: Color(hexColor('#0E629B')),
              ),
            ),
            Container(
              padding:
                  new EdgeInsets.only(top:20,left: 160),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                color: Color(hexColor('#0E629B')),
                child: Text(
                  'Play',
                  style: TextStyle(
                      color: Color(hexColor('#B7D7DA'))),
                ),
                onPressed: () {
                  if (selectedTypes[getType()] || selectedTypes[getSecondaryType()]) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Quiz(
                              getGeoList(),
                              isReverse(),
                              getCategories(),
                              getTime(),
                              getNumberOfAnwsers(),
                              getType(),generatequestionStrings()[0],generatequestionStrings()[1])),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      drawer: leftMenu(context,getType(),getSecondaryType()),
    );
  }


  List<String> generatequestionStrings(){
    List<String> questionStrings=new List();
    if(type=='Presidents'){
      if(selectedTypes[getType()]) {
        questionStrings.add('%s became president in the year:');
        questionStrings.add('Who became president in the year %s?');
      }
      else{
        questionStrings.add('Who became president in the year %s?');
        questionStrings.add('%s became president in the year:');
      }
    }
    else {
      if (selectedTypes[getType()]) {
        questionStrings.add('The capital of %s is?');
        questionStrings.add(' %s is the capital of?');
      }
      else {
        questionStrings.add(' %s is the capital of?');
        questionStrings.add('The capital of %s is?');
      }
    }

    return questionStrings;





  }


  int isReverse(){
    if(selectedTypes[getType()] == selectedTypes[getSecondaryType()]){
      return 3;
    }
    else{
      if(selectedTypes[getType()]){
        return 1;
      }
      else{
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

  List<QuizObject> getGeoList() {
    if (geoList == null) {
      geoList = new List();
    }
    return geoList;
  }
}
