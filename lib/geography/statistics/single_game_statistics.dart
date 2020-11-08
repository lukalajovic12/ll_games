import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:llgames/geography/statistics/properties_container.dart';
import '../../main.dart';
import '../constants.dart';
import '../country_capital_table.dart';
import 'anwser_list_container.dart';
import 'general_statistics.dart';
import '../geo.dart';





class SingleGameStatistics extends StatelessWidget {
  List<Anwser> lastGameAnwsers = new List();









  List<Anwser> getLastGameAnwsers() {
    if (lastGameAnwsers == null) {
      lastGameAnwsers = new List();
    }
    return lastGameAnwsers;
  }

  List<GameConstantInstance> gameProperties=new List();

  List<GameConstantInstance> getGameProperties(){
  if(gameProperties==null){
    gameProperties=new List();
  }
  return gameProperties;
  }


  SingleGameStatistics(
      {Key key,
      @required this.lastGameAnwsers,
      @required this.gameProperties})
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
                    icon: Icon(FontAwesomeIcons.globe),
                    text: 'Data',
                  ),

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
              gamePropertiesContainer(getGameProperties(),context),
              anwserListContainer(getLastGameAnwsers(),context),
              lastPie(),

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




