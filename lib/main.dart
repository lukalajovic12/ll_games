import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'geography/geo_main.dart';
import 'memory/memory_main.dart';
import 'memory/memory_score_chart.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State createState() => new MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
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
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MenuButtonWidget('memory'),
            MenuButtonWidget('geo'),
          ],
        ),
      ),
    );
  }
}

class MenuButtonWidget extends StatefulWidget {
  String name = "";

  MenuButtonWidget(String name) {
    this.name = name;
  }

  @override
  State createState() => new _MenuButtonWidget(name);
}

class _MenuButtonWidget extends State<MenuButtonWidget> {
  String name = "";

  _MenuButtonWidget(String name) {
    this.name = name;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150.0,
      padding: new EdgeInsets.only(left: 10,right:10,top: 30,bottom: 30 ),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(90),
            side: BorderSide(color: Colors.black)),
        color: Colors.blue,
        child: Text('$name'),
        onPressed: () {
          changeScreen();
        },
      ),
    );
  }

  void changeScreen() {
    if (name == 'memory') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MemoryMainWidget()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => GeoMainWidget()),
      );
    }
  }
}
