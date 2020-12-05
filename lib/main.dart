import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'geography/database/geo_database.dart';
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
  State createState() => new _MyHomePage();
}


  hexColor(String chc){
  String cn='0xff'+chc;
  cn=cn.replaceAll('#', '');
  int ci=int.parse(cn);
  return ci;
  }


class _MyHomePage extends State<MyHomePage> {

  final dbGameHelper = DatabaseGameHelper.instance;

  List<String> types=new List();

  final ScrollController scrollController = ScrollController();

  bool isLoading=false;

  Future<void> loadData() async {
    isLoading=true;
    await dbGameHelper.create();
    final categoryRows=await dbGameHelper.selectAllTypes();
    List<String> ty=new List();
    if (categoryRows != null) {
      categoryRows.forEach((row) => ty.add(row[DatabaseGameHelper.questionType]));
    }
    setState(() {
      isLoading=false;
      types=ty;

    });


  }

  _MyHomePage(){
    loadData();
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
      body:
    SizedBox(
    height: screenHeight,

    child:  Container(
        color: Color(hexColor('#B7D7DA')),
        child: Scrollbar(
          controller: scrollController,
          child: ListView.builder(
            controller: scrollController,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: types.length,
            itemBuilder: (context, i) {
              return Container(
                height: 150.0,
                padding: new EdgeInsets.only(left: 40,right:40,top: 40,bottom: 40 ),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(90),
                  ),
                  color: Color(hexColor('#0E629B')),
                  child: Text('${types[i]}',style:TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(hexColor('#B7D7DA')),
                    fontSize: 40.0,
                    letterSpacing: 2.0,
                  ),),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => GeoMainWidget(types[i])));
                  },
                ),
              );
            },
          ),
        ),
      ),
    ),
    );
  }
}