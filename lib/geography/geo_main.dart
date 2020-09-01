import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'geo.dart';
import 'kviz.dart';
import 'score_table.dart';

class GeoMainWidget extends StatefulWidget {
  @override
  State createState() => new _GeoMainWidget();
}

class _GeoMainWidget extends State<GeoMainWidget> {

  _GeoMainWidget() {
    loadGeo();
  }




  void loadGeo() async {
    List<CountryCapital> geoList = new List();
    WidgetsFlutterBinding.ensureInitialized();
    var geoString = await rootBundle.loadString('assets/geo.txt');
    LineSplitter ls = new LineSplitter();
    List<String> geoLines = ls.convert(geoString);
    for (int i = 0; i < geoLines.length; i++) {
      CountryCapital cc = new CountryCapital(
          country: geoLines[i].split(",")[0],
          capital: geoLines[i].split(",")[1],
          continent: geoLines[i].split(",")[2]);
      geoList.add(cc);
    }

  }

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

                ]))));
  }
}



class GeoTabWidget extends StatefulWidget {

  int type = 1;



  GeoTabWidget(int type){
    this.type=type;
  }



  @override
  State createState() => new _GeoTabWidget(type);
}


class _GeoTabWidget extends State<GeoTabWidget> {




  List<CountryCapital> euroList=new List();



  List<CountryCapital> namericaList=new List();

  List<CountryCapital> samericaList=new List();

  List<CountryCapital> afroList=new List();

  List<CountryCapital> asiaList=new List();

  List<CountryCapital> oceaniaList=new List();

  int type = 1;



  void loadGeo() async {
    List<CountryCapital> geoList=new List();
    var geoString = await rootBundle.loadString('assets/geo.txt');
    LineSplitter ls = new LineSplitter();
    List<String> geoLines = ls.convert(geoString);
    for (int i = 0; i < geoLines.length; i++) {
      CountryCapital cc = new CountryCapital(
          country: geoLines[i].split(",")[0],
          capital: geoLines[i].split(",")[1],
          continent: geoLines[i].split(",")[2]);
      geoList.add(cc);
    }

    for(CountryCapital cc in geoList) {
      if (cc.continent == 'europe') {
        euroList.add(cc);
      }
      if (cc.continent == 'afrika') {
        afroList.add(cc);
      }
      if (cc.continent == 'north america') {
        namericaList.add(cc);
      }
      if (cc.continent == 'south america') {
        samericaList.add(cc);
      }
      if (cc.continent == 'asia') {
        asiaList.add(cc);
      }
      if (cc.continent == 'oceania') {
        oceaniaList.add(cc);
      }
    }

  }

  _GeoTabWidget(int type) {


    this.type = type;
    loadGeo();

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          Colors.indigo,
          Colors.blueAccent,
          Colors.indigo,
          Colors.blueAccent,
          Colors.indigo,
        ], stops: [
          0.2,
          0.4,
          0.6,
          0.8,
          1,
        ]),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
                side: BorderSide(color: Colors.black)),
            color: Colors.blue,
            child: Text('Europe'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  Quiz(euroList, type,'europe')),
              );
            },
          ),
          RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
                side: BorderSide(color: Colors.black)),
            color: Colors.blue,
            child: Text('asia'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  Quiz(asiaList, type,'asia')),
              );
            },
          ),
          RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
                side: BorderSide(color: Colors.black)),
            color: Colors.blue,
            child: Text('North America'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  Quiz(namericaList, type,',orth america')),
              );
            },
          ),
          RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
                side: BorderSide(color: Colors.black)),
            color: Colors.blue,
            child: Text('south america'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  Quiz(samericaList, type,'south america')),
              );
            },
          ),
          RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
                side: BorderSide(color: Colors.black)),
            color: Colors.blue,
            child: Text('afrika'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  Quiz(afroList, type,'afrika')),
              );
            },
          ),
          RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
                side: BorderSide(color: Colors.black)),
            color: Colors.blue,
            child: Text('oceania'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  Quiz(oceaniaList, type,'oceania')),
              );
            },
          ),







          RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(60),
                side: BorderSide(color: Colors.blue)),
            color: Colors.blue,
            child: Text('STATISTICS'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ScoreList(type)),
              );
            },
          ),
        ],
      ),
    );
  }
}