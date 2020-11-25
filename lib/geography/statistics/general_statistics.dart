import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:llgames/geography/statistics/single_game_statistics.dart';
import '../../main.dart';
import '../constants.dart';
import '../geo.dart';
import '../database/geo_database.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class ScoreList extends StatefulWidget {

  String type='';

  String getType(){
    if(type==null){
      type='Countries';
    }
    return type;
  }


  ScoreList(String type) {
    this.type=type;
  }

  @override
  _ScoreListState createState() => _ScoreListState(getType());
}

class _ScoreListState extends State<ScoreList> {
  List<Score> scoreist = new List();

  final bool animate = true;


  String type='Countries';

  String getType(){
    if(type==null){
      type='Countries';
    }
    return type;
  }

  _ScoreListState(String type) {
    this.type=type;
    this.scoreist = new List();
    _query();
  }

  List<charts.Series<Score, int>> _seriesLineData =
      List<charts.Series<Score, int>>();

  final dbGameHelper = DatabaseGameHelper.instance;

  List<Anwser> lastGameAnwsers = new List();

  List<Anwser> getLastGameAnwsers() {
    if (lastGameAnwsers == null) {
      lastGameAnwsers = new List();
    }
    return lastGameAnwsers;
  }



  void _query() async {
    scoreist = new List();
    final gameRows = await dbGameHelper.queryGameRows(getType());
    List<Score> scl = new List();
    List<Anwser> anl = new List();
    int idGame = -1;
    if (gameRows != null) {
      gameRows.forEach((row) => scl.add(new Score(id: row[DatabaseGameHelper.gameColumnId],
          datePlayed:row[DatabaseGameHelper.gameColumnDate],
            score:0
          )));
      for (int i = 0; i < scl.length; i++) {
        Score s = scl[i];
        idGame = s.id;
        int correctAnwser = await dbGameHelper.queryCorrectAnwsersCount(s.id);
        int wrongAnwser = await dbGameHelper.queryWrongAnwsersCount(s.id);
        s.score=correctAnwser-wrongAnwser;
      }
    }
    setState(() {
      this.scoreist = scl;
      this.lastGameAnwsers = anl;
    });
  }


  Future<List<GameConstantInstance>> queryGameConstants(int idGame) async {
    List<GameConstantInstance> properties=new List();
    final constantRows = await dbGameHelper.queryConstantRows(idGame);
    constantRows.forEach((row) =>properties.add(new GameConstantInstance(row[DatabaseGameHelper.propertyTypeColumn],row[DatabaseGameHelper.propertyTypeColumn])));
    return properties;
  }

  Future<List<Anwser>> queryGameAnwsers(int idGame) async {
    List<Anwser> anl = new List();
    final anwserRows = await dbGameHelper.queryAnwserRows(idGame);
    anwserRows.forEach((row) => anl.add(new Anwser(
        row[DatabaseGameHelper.gameColumnQuestion],
        row[DatabaseGameHelper.gameColumnCorrectAnwser],
        row[DatabaseGameHelper.gameColumnAnwser])));
    return anl;
  }

  Container scoreTableContainer() {
    return Container(
        color: Color(hexColor('#B7D7DA')),
        child: SingleChildScrollView(
          child: DataTable(
            sortAscending: true,
            columns: <DataColumn>[
              DataColumn(
                label: Text('date',
                    style: TextStyle(
                        color: Color(hexColor('#0E629B')),
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold)),
              ),
              DataColumn(
                label: Text('score',
                    style: TextStyle(
                        color: Color(hexColor('#0E629B')),
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold)),
              ),
            ],
            rows: getScoreList()
                .map(
                  (s) => DataRow(
                      cells: [
                        DataCell(
                          Text('${s.displayDate()}',
                              style:
                                  TextStyle(color: Color(hexColor('#0E629B')))),
                          showEditIcon: false,
                          placeholder: false,
                        ),
                        DataCell(
                          Text('${s.score}',
                              style:
                              TextStyle(color: Color(hexColor('#0E629B')))),
                          showEditIcon: false,
                          placeholder: false,
                        ),
                      ],
                      onSelectChanged: (bool selected) {
                        if (selected) {
                          goToSingleGameStatisticslScreen(s.id);
                        };
                      }),
                )
                .toList(),
          ),
        ));
  }

  Future<void> goToSingleGameStatisticslScreen(int idGame) async {
    List<Anwser> anl = await queryGameAnwsers(idGame);
    List<GameConstantInstance> gp=await queryGameConstants(idGame);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SingleGameStatistics(lastGameAnwsers: anl,gameProperties:gp),
      ),
    );
  }



  Future<Container> lastPie() async {

    int correctAnwser = await dbGameHelper.queryCorrectAnwsersCountLast();
    int wrongAnwser = await dbGameHelper.queryWrongAnwsersLast();
    int skipedAnwser= await dbGameHelper.querySkippedAnwsersCountLast();

    return pieContainer(correctAnwser, wrongAnwser, skipedAnwser, 'Last points');
  }

  void generateLineChart() {
    List<Score> scl = new List();
    Score s = new Score(id:0, datePlayed:"", score:0);
    scl.add(s);
    scl.addAll(getScoreList());
    _seriesLineData = List<charts.Series<Score, int>>();
    _seriesLineData.add(
      charts.Series(
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xff990099)),
        id: 'Game Line Scores',
        data: scl,
        domainFn: (Score s, _) => s.id,
        measureFn: (Score s, _) => (s.score),
      ),
    );
  }

  Container lineContainer() {
    generateLineChart();
    return Container(
      color: Color(hexColor('#B7D7DA')),
      child: Center(
        child: Column(
          children: <Widget>[
            Text('Your game progress in line',
                style: TextStyle(
                    color: Color(hexColor('#0E629B')),
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold)),
            Expanded(
              child: charts.LineChart(_seriesLineData,
                  defaultRenderer: new charts.LineRendererConfig(
                      includeArea: true, stacked: true),
                  animate: true,
                  animationDuration: Duration(seconds: 1),
                  behaviors: [
                    new charts.ChartTitle('Id',
                        behaviorPosition: charts.BehaviorPosition.bottom,
                        titleOutsideJustification:
                            charts.OutsideJustification.middleDrawArea),
                    new charts.ChartTitle('Score',
                        behaviorPosition: charts.BehaviorPosition.start,
                        titleOutsideJustification:
                            charts.OutsideJustification.middleDrawArea),
                  ]),
            ),
          ],
        ),
      ),
    );
  }



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
                    icon: Icon(FontAwesomeIcons.chartLine),
                    text: 'line',
                  ),
                ],
              ),
            ),
            body: TabBarView(children: [
              scoreTableContainer(),
              lineContainer(),
            ])));
  }

  List<Score> getScoreList() {
    if (scoreist == null) {
      scoreist = new List();
    }
    return scoreist;
  }
}

class TotalAnwsers {
  String type;
  int count;
  Color colorval;

  TotalAnwsers(this.type, this.count, this.colorval);
}



Container pieContainer(int co, int wr, int sk, String sco) {
  List<charts.Series<TotalAnwsers, String>> _seriesPieData =
      List<charts.Series<TotalAnwsers, String>>();

  _seriesPieData = List<charts.Series<TotalAnwsers, String>>();
  var piedata = [
    new TotalAnwsers('correct', co, Color(0xfffdbe19)),
    new TotalAnwsers('wrong', wr, Color(0xffff9900)),
    new TotalAnwsers('skipped', sk, Color(0xffdc3912)),
  ];
  _seriesPieData.add(
    charts.Series(
      domainFn: (TotalAnwsers a, _) => a.type,
      measureFn: (TotalAnwsers a, _) => a.count,
      colorFn: (TotalAnwsers a, _) =>
          charts.ColorUtil.fromDartColor(a.colorval),
      id: 'Score pie',
      data: piedata,
      labelAccessorFn: (TotalAnwsers row, _) => '${row.count}',
    ),
  );

  return Container(
    color: Color(hexColor('#B7D7DA')),
    child: Center(
      child: Column(
        children: <Widget>[
          Text(
            '$sco',
            style: TextStyle(
                color: Color(hexColor('#0E629B')),
                fontSize: 40.0,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10.0,
          ),
          Expanded(
            child: charts.PieChart(_seriesPieData,
                animate: true,
                animationDuration: Duration(seconds: 1),
                behaviors: [
                  new charts.DatumLegend(
                    outsideJustification:
                        charts.OutsideJustification.endDrawArea,
                    horizontalFirst: false,
                    desiredMaxRows: 2,
                    cellPadding: new EdgeInsets.only(right: 4.0, bottom: 4.0),
                    entryTextStyle: charts.TextStyleSpec(
                        color: charts.MaterialPalette.purple.shadeDefault,
                        fontFamily: 'Georgia',
                        fontSize: 11),
                  )
                ],
                defaultRenderer: new charts.ArcRendererConfig(
                    arcWidth: 100,
                    arcRendererDecorators: [
                      new charts.ArcLabelDecorator(
                          labelPosition: charts.ArcLabelPosition.inside)
                    ])),
          ),
        ],
      ),
    ),
  );
}




