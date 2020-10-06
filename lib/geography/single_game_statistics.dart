import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../main.dart';
import 'general_statistics.dart';
import 'geo.dart';

class SingleGameStatistics extends StatelessWidget {
  List<Anwser> lastGameAnwsers = new List();

  List<Anwser> getLastGameAnwsers() {
    if (lastGameAnwsers == null) {
      lastGameAnwsers = new List();
    }
    return lastGameAnwsers;
  }

  // In the constructor, require a Todo.
  SingleGameStatistics({Key key, @required this.lastGameAnwsers}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
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
                ],
              ),
            ),
            body: TabBarView(children: [
              anwserTableContainer(getLastGameAnwsers()),
              lastPie(),
            ])));
  }


  Container lastPie() {
    int co = 0;
    int wr = 0;
    int sk = 0;
    for(Anwser a in getLastGameAnwsers()){
      if(a.anwser==a.correctAnwser){
        co+=1;
      }
      else if(a.anwser=="Skipped"){
        sk+=1;
      }
      else{
        wr+=1;
      }
    }
    return pieContainer(co, wr, sk, 'Your anwsers');
  }




}
Container anwserTableContainer(List<Anwser> lastGameAnwsers) {
  return Container(
      color: Color(hexColor('#B7D7DA')),
      child: SingleChildScrollView(
        child: DataTable(
          sortAscending: true,
          columns: <DataColumn>[
            DataColumn(
              label: Text('Question',
                  style: TextStyle(
                      color: Color(hexColor('#0E629B')),
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold)),
            ),
            DataColumn(
              label: Text('Anwser',
                  style: TextStyle(
                      color: Color(hexColor('#0E629B')),
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold)),
            ),
            DataColumn(
              label: Text('Anwsered',
                  style: TextStyle(
                      color: Color(hexColor('#0E629B')),
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold)),
            ),
          ],
          rows: lastGameAnwsers
              .map(
                (a) => DataRow(
              cells: [
                DataCell(
                  Text('${a.question}',
                      style: TextStyle(color: Color(hexColor('#0E629B')))),
                  showEditIcon: false,
                  placeholder: false,
                ),
                DataCell(
                  Text('${a.correctAnwser}',
                      style: TextStyle(color: Color(hexColor('#0E629B')))),
                  showEditIcon: false,
                  placeholder: false,
                ),
                DataCell(
                  Text('${a.anwser}',
                      style: TextStyle(color: anwserCollor(a))),
                  showEditIcon: false,
                  placeholder: false,
                ),
              ],
            ),
          )
              .toList(),
        ),
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