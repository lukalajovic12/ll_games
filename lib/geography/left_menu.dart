import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:llgames/geography/single_game_statistics.dart';
import '../main.dart';
import 'country_capital_table.dart';
import 'general_statistics.dart';
import 'geo.dart';
import 'geo_database.dart';

Container leftMenu(BuildContext context){
  return Container(
    color: Color(hexColor('#B7D7DA')),
    child: ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          child: Text('Settings'),
          decoration: BoxDecoration(
            color: Color(hexColor('#B7D7DA')),
          ),
        ),
        ListTile(
          title: Center(child: Text('statistics')),
          onTap: () {
            // Update the state of the app
            // ...
            // Then close the drawer
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ScoreList()),
            );
          },
        ),
        ListTile(
          title: Center(child: Text('data')),
          onTap: () {
            // Update the state of the app
            // ...
            // Then close the drawer
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => GeoDataWidget()),
            );
          },
        ),

        ListTile(
          title: Center(child: Text('last game')),
          onTap: () {
            pushLastGame(context);
          },
        ),

        ListTile(
          title: Center(child: Text('back')),
          onTap: () {
            // Update the state of the app
            // ...
            // Then close the drawer
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}

Future<void> pushLastGame(BuildContext context) async {
  List<Anwser> anl = new List();
  final dbGameHelper = DatabaseGameHelper.instance;
  final anwserRows = await dbGameHelper.queryLastGameRows();
  anwserRows.forEach((row) => anl.add(new Anwser(
      row[DatabaseGameHelper.gameColumnQuestion],
      row[DatabaseGameHelper.gameColumnCorrectAnwser],
      row[DatabaseGameHelper.gameColumnAnwser],
      row[DatabaseGameHelper.gameColumnType])));
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => SingleGameStatistics(lastGameAnwsers: anl),
    ),
  );

}