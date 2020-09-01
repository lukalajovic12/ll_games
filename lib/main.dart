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


  hexColor(String chc){
  String cn='0xff'+chc;
  cn=cn.replaceAll('#', '');
  int ci=int.parse(cn);
  return ci;
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
        color: Color(hexColor('#B7D7DA')),
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
      padding: new EdgeInsets.only(left: 10,right:10,top: 40,bottom: 40 ),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(90),
            ),
        color: Color(hexColor('#0E629B')),
        child: Text('$name',style:TextStyle(
          fontWeight: FontWeight.bold,
          color: Color(hexColor('#B7D7DA')),
          fontSize: 40.0,
          letterSpacing: 2.0,
        ),),
        onPressed: () {
          changeScreen();
        },
      ),
    );
  }

  void changeScreen() {
    if (name == 'memory') {
      Navigator.of(context).push(_createRoute());
    } else {
      Navigator.of(context).push(_createRoute2());
    }
  }



  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => MemoryMainWidget(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }


  Route _createRoute2() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => GeoMainWidget(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }




}
