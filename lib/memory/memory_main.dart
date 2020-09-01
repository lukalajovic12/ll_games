import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'memory_game.dart';
import 'memory_score_chart.dart';

class MemoryMainWidget extends StatefulWidget {
  @override
  State createState() => new _MemoryMainWidget();
}

class _MemoryMainWidget extends State<MemoryMainWidget> {
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
            title: Text('Memory'),
            centerTitle: true,
            backgroundColor: Colors.blue,
            bottom: TabBar(
              indicatorColor: Color(0xff9962D0),
              tabs: [
                Tab(
                  icon: Icon(FontAwesomeIcons.square),
                  text: 'squares',
                ),
                Tab(
                  icon: Icon(FontAwesomeIcons.circle),
                  text: 'circles',
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              MemoryTabWidget(1),
              MemoryTabWidget(2),

            ],
          ),
        ),
      ),
    );
  }
}

class MemoryTabWidget extends StatefulWidget {
  int type = 1;

  MemoryTabWidget(int type){
    this.type=type;
  }

  @override
  State createState() => new _MemoryTabWidget(type);
}

class _MemoryTabWidget extends State<MemoryTabWidget> {
  int type = 1;

  _MemoryTabWidget(int type) {
    this.type = type;
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
            child: Text('PLAY'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GameWidget(type)),
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
                MaterialPageRoute(builder: (context) => ScorePage(type)),
              );
            },
          ),
        ],
      ),
    );
  }
}
