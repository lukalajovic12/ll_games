import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'main_classes/geo_main.dart';


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
            MenuButtonWidget('Countries','Capitals'),
            MenuButtonWidget('States','Capitals'),
            MenuButtonWidget('Presidents','Year'),
            //MenuButtonWidget('usPresidents'),
          ],
        ),
      ),
    );
  }
}

class MenuButtonWidget extends StatefulWidget {
  String name = "";
  String secondaryName;

  MenuButtonWidget(String name,secondaryName) {
    this.name = name;
    this.secondaryName=secondaryName;
  }

  @override
  State createState() => new _MenuButtonWidget(name,secondaryName);
}

class _MenuButtonWidget extends State<MenuButtonWidget> {

  String secondaryName;

  String name = "";

  _MenuButtonWidget(String name,String secondaryName) {
    this.name = name;
    this.secondaryName=secondaryName;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150.0,
      padding: new EdgeInsets.only(left: 40,right:40,top: 40,bottom: 40 ),
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
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => GeoMainWidget(name,secondaryName)));
        },
      ),
    );
  }






}
