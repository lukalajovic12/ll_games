import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../main.dart';
import 'country_capital_table.dart';
import 'general_statistics.dart';
import 'geo.dart';

class SingleGameStatistics extends StatelessWidget {
  List<Anwser> lastGameAnwsers = new List();

  int time = 0;

  int getTime() {
    if (time == null) {
      time = 0;
    }
    return time;
  }

  int anwsers = 0;

  int getAnwsers() {
    if (anwsers == null) {
      anwsers = 0;
    }
    return anwsers;
  }

  List<Anwser> getLastGameAnwsers() {
    if (lastGameAnwsers == null) {
      lastGameAnwsers = new List();
    }
    return lastGameAnwsers;
  }





  SingleGameStatistics(
      {Key key,
      @required this.lastGameAnwsers,
      @required this.time,
      @required this.anwsers})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
            appBar: AppBar(
              leading: BackButton(color: Colors.white),
              iconTheme: IconThemeData(
                color: Colors.black, //change your color here
              ),
              title: Text('Gemory'),
              centerTitle: true,
              backgroundColor: Colors.blue,
              bottom: TabBar(
                indicatorColor: Colors.white,
                tabs: [
                  Tab(
                    icon: Icon(FontAwesomeIcons.table),
                    text: 'table',
                  ),
                  Tab(
                    icon: Icon(FontAwesomeIcons.chartPie),
                    text: 'Pie',
                  ),
                  Tab(
                    icon: Icon(FontAwesomeIcons.globe),
                    text: 'Data',
                  ),
                ],
              ),
            ),
            body: TabBarView(children: [
              anwserListContainer(getLastGameAnwsers(),context),
              lastPie(),
              gameDataContainer(getLastGameAnwsers(), getTime(), getAnwsers(),context)
            ])));
  }

  Container lastPie() {
    int co = 0;
    int wr = 0;
    int sk = 0;
    for (Anwser a in getLastGameAnwsers()) {
      if (a.anwser == a.correctAnwser) {
        co += 1;
      } else if (a.anwser == "Skipped") {
        sk += 1;
      } else {
        wr += 1;
      }
    }
    return pieContainer(co, wr, sk, 'Your anwsers');
  }
}

Container gameDataContainer(
    List<Anwser> lastGameAnwsers, int time, int anwsers,BuildContext context) {
  int co = 0;
  int wr = 0;
  int sk = 0;
  for (Anwser a in lastGameAnwsers) {
    if (a.anwser == a.correctAnwser) {
      co += 1;
    } else if (a.anwser == "Skipped") {
      sk += 1;
    } else {
      wr += 1;
    }
  }
  double c_width = MediaQuery.of(context).size.width;
  return Container(
      color: Color(hexColor('#B7D7DA')),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            Container(
                child: Text('Anwsered questions:',
                    style: TextStyle(
                        color: Color(hexColor('#0E629B')),
                        fontSize: 35.0,
                        fontWeight: FontWeight.bold))),
          ]),
          Row(
            children: <Widget>[
              Container(
                width: c_width/2,
                  padding: new EdgeInsets.only(left: 40),
                  child: Text('Correct:',
                      style: TextStyle(
                          color: Color(hexColor('#0E629B')),
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold))),
              Container(
                  padding: new EdgeInsets.only(left: 35),
                  width: c_width/2,
                  child: Text('$co',
                      style: TextStyle(
                          color: Color(hexColor('#0E629B')),
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold)))
            ],
          ),
          Row(
            children: <Widget>[
              Container(
                  padding: new EdgeInsets.only(left: 40),
                  width: c_width/2,
                  child: Text('Wrong:',
                      style: TextStyle(
                          color: Color(hexColor('#0E629B')),
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold))),
              Container(
                  padding: new EdgeInsets.only(left: 40),
                  width: c_width/2,
                  child: Text('$wr',
                      style: TextStyle(
                          color: Color(hexColor('#0E629B')),
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold)))
            ],
          ),
          Row(
            children: <Widget>[
              Container(
                  padding: new EdgeInsets.only(left: 40),
                  width: c_width/2,
                  child: Text('Skipped:',
                      style: TextStyle(
                          color: Color(hexColor('#0E629B')),
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold))),
              Container(
                  padding: new EdgeInsets.only(left: 40),
                  width: c_width/2,
                  child: Text('$sk',
                      style: TextStyle(
                          color: Color(hexColor('#0E629B')),
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold)))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                  padding: new EdgeInsets.only(left: 40),
                  width: c_width/2,
                  child: Text('Time:',
                      style: TextStyle(
                          color: Color(hexColor('#0E629B')),
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold))),
              Container(
                  padding: new EdgeInsets.only(left: 40),
                  width: c_width/2,
                  child: Text('${time}',
                      style: TextStyle(
                          color: Color(hexColor('#0E629B')),
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold)))
            ],
          ),
          Row(
            children: <Widget>[
              Container(
                  padding: new EdgeInsets.only(left: 40),
                  width: c_width/2,
                  child: Text('Possible anwsers:',
                      style: TextStyle(
                          color: Color(hexColor('#0E629B')),
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold))),
              Container(
                  padding: new EdgeInsets.only(left: 40),
                  width: c_width/2,
                  child: Text('${anwsers}',
                      style: TextStyle(
                          color: Color(hexColor('#0E629B')),
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold)))
            ],
          )
        ],
      ));
}

Container anwserListContainer(List<Anwser> lastGameAnwsers,BuildContext context) {
  double c_width = MediaQuery.of(context).size.width;
  return Container(
      color: Color(hexColor('#B7D7DA')),
      child: ListView.builder(
        itemCount: lastGameAnwsers.length,
        itemBuilder: (context, index) {
          Anwser anwser = lastGameAnwsers[index];
          return Column(
            children: <Widget>[
              Row(children: <Widget>[
                Container(
                  width: c_width,
                  padding: new EdgeInsets.only(top: 10, bottom: 10),
                  child: Text('${index+1}. ${anwser.question}',
                      style: TextStyle(
                          color: Color(hexColor('#0E629B')),
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold)),
                ),
              ]),
              Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                Container(
                  width: c_width/2,
                  child: Text('Correct anwser:',
                      style: TextStyle(
                          color: Color(hexColor('#0E629B')),
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold)),
                ),
                Container(
                  width: c_width/2,
                  child: Text(anwser.correctAnwser,
                      style: TextStyle(
                          color: Color(hexColor('#0E629B')),
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold)),
                ),
              ]),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                Container(
                  width: c_width/2,
                  child: Text('Anwsered:',
                      style: TextStyle(
                          color: Color(hexColor('#0E629B')),
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold)),
                ),
                Container(
                  width: c_width/2,
                  child: Text(anwser.anwser,
                      style: TextStyle(
                          color: anwserCollor(anwser),
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold)),
                ),
              ]),

              Row(
                  children: <Widget>[
                    Container(
                      width: c_width/3,
                      child: Text('Wikipedia:',
                          style: TextStyle(
                              color: Color(hexColor('#0E629B')),
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold)),
                    ),
                    Container(
                      width: c_width/2,
                      child: IconButton(
                        color: Color(hexColor('#0E629B')),
                        icon: Icon(FontAwesomeIcons.wikipediaW),
                        onPressed: () {
                          goToWikipedia(anwser.correctAnwser);
                        },
                      ),
                    ),
                  ]),

              Row(
                  children: <Widget>[
                    Container(
                      width: c_width/3,
                      child: Text('Google Maps:',
                          style: TextStyle(
                              color: Color(hexColor('#0E629B')),
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold)),
                    ),
                    Container(
                      width: c_width/2,
                      child: IconButton(
                        color: Color(hexColor('#0E629B')),
                        icon: Icon(FontAwesomeIcons.mapMarker),
                        onPressed: () {
                          goToGoogleMaps(anwser.correctAnwser);
                        },
                      ),
                    ),
                  ]),
















            ],
          );
        },
      ));
}


Color anwserCollor(Anwser a) {
  if (a.anwser == 'Skipped') {
    return Colors.purple;
  } else if (a.correctAnwser == a.anwser) {
    return Colors.green;
  } else {
    return Colors.red;
  }
}
