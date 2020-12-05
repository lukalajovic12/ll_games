import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:llgames/geography/statistics/single_game_statistics.dart';
import '../main.dart';
import 'constants.dart';
import 'country_capital_table.dart';
import 'statistics/general_statistics.dart';
import 'geo.dart';
import 'database/geo_database.dart';

Container leftMenu(BuildContext context,String type){
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
          title: Center(child: Text('Statistics')),
          onTap: () {
            // Update the state of the app
            // ...
            // Then close the drawer
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ScoreList(type)),
            );
          },
        ),
        ListTile(
          title: Center(child: Text('Data')),
          onTap: () {
            // Update the state of the app
            // ...
            // Then close the drawer
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => GeoDataWidget(type)),
            );
          },
        ),

        ListTile(
          title: Center(child: Text('Last game')),
          onTap: () {
            pushLastGame(context);
          },
        ),

        ListTile(
          title: Center(child: Text('Back')),
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
      row[DatabaseGameHelper.gameColumnAnwser])));

  List<GameConstantInstance> gamePropertiesList=new List();
  final propertyRows = await dbGameHelper.queryLastGameProperties();
  propertyRows.forEach((row) =>gamePropertiesList.add(
    new GameConstantInstance(row[DatabaseGameHelper.propertyTypeColumn],row[DatabaseGameHelper.propertyValueColumn])
  ));
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => SingleGameStatistics(lastGameAnwsers: anl,gameProperties:gamePropertiesList),
    ),
  );

}