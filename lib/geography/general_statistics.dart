import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:llgames/geography/single_game_statistics.dart';
import '../main.dart';
import 'geo.dart';
import 'geo_database.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class ScoreList extends StatefulWidget {
  ScoreList() {}

  @override
  _ScoreListState createState() => _ScoreListState();
}

class _ScoreListState extends State<ScoreList> {
  List<Score> scoreist = new List();

  final bool animate = true;

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

  _ScoreListState() {
    this.scoreist = new List();
    _query();
  }

  void _query() async {
    scoreist = new List();
    final gameRows = await dbGameHelper.queryGameRows();
    List<Score> scl = new List();
    List<Anwser> anl = new List();
    int idGame = -1;
    if (gameRows != null) {
      gameRows.forEach((row) => scl.add(new Score(
            row[DatabaseGameHelper.gameColumnId],
            0,
            0,
            0,
            row[DatabaseGameHelper.gameColumnTime],
            row[DatabaseGameHelper.gameColumnPossibleAnwsers],
          )));
      for (int i = 0; i < scl.length; i++) {
        Score s = scl[i];
        idGame = s.id;
        s.correctAnwser = await dbGameHelper.queryCorrectAnwsersCount(s.id);
        s.wrongAnwser = await dbGameHelper.queryWrongAnwsersCount(s.id);
        s.skipedAnwser = await dbGameHelper.querySkippedAnwsersCount(s.id);
      }
      anl = await queryGameAnwsers(idGame);
    }
    setState(() {
      this.scoreist = scl;
      this.lastGameAnwsers = anl;
    });
  }

  Future<List<Anwser>> queryGameAnwsers(int idGame) async {
    List<Anwser> anl = new List();
    final anwserRows = await dbGameHelper.queryAnwserRows(idGame);
    anwserRows.forEach((row) => anl.add(new Anwser(
        row[DatabaseGameHelper.gameColumnQuestion],
        row[DatabaseGameHelper.gameColumnCorrectAnwser],
        row[DatabaseGameHelper.gameColumnAnwser],
        row[DatabaseGameHelper.gameColumnType])));
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
                label: Text('score',
                    style: TextStyle(
                        color: Color(hexColor('#0E629B')),
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold)),
              ),
              DataColumn(
                label: Text('time',
                    style: TextStyle(
                        color: Color(hexColor('#0E629B')),
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold)),
              ),
              DataColumn(
                label: Text('anwsers',
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
                          Text('${s.correctAnwser - s.wrongAnwser}',
                              style:
                                  TextStyle(color: Color(hexColor('#0E629B')))),
                          showEditIcon: false,
                          placeholder: false,
                        ),
                        DataCell(
                          Text('${s.time}',
                              style:
                                  TextStyle(color: Color(hexColor('#0E629B')))),
                          showEditIcon: false,
                          placeholder: false,
                        ),
                        DataCell(
                          Text('${s.possibleAnwsers}',
                              style:
                                  TextStyle(color: Color(hexColor('#0E629B')))),
                          showEditIcon: false,
                          placeholder: false,
                        ),
                      ],
                      onSelectChanged: (bool selected) {
                        if (selected) {
                          goToDetailScreen(s.id);
                        }
                        ;
                      }),
                )
                .toList(),
          ),
        ));
  }

  Future<void> goToDetailScreen(int idGame) async {
    List<Anwser> anl = await queryGameAnwsers(idGame);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SingleGameStatistics(lastGameAnwsers: anl),
      ),
    );
  }

  Container totalPie() {
    int co = 0;
    int wr = 0;
    int sk = 0;
    for (Score s in getScoreList()) {
      co += s.correctAnwser;
      wr += s.wrongAnwser;
      sk += s.skipedAnwser;
    }
    return pieContainer(co, wr, sk, 'Total points');
  }

  Container lastPie() {
    int co = 0;
    int wr = 0;
    int sk = 0;
    co = getScoreList()[getScoreList().length - 1].correctAnwser;
    wr = getScoreList()[getScoreList().length - 1].wrongAnwser;
    sk = getScoreList()[getScoreList().length - 1].skipedAnwser;
    return pieContainer(co, wr, sk, 'Last points');
  }

  void generateLineChart() {
    List<Score> scl = new List();
    Score s = new Score(0, 0, 0, 0, 0, 0);
    scl.add(s);
    scl.addAll(getScoreList());
    _seriesLineData = List<charts.Series<Score, int>>();
    _seriesLineData.add(
      charts.Series(
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xff990099)),
        id: 'Game Line Scores',
        data: scl,
        domainFn: (Score s, _) => s.id,
        measureFn: (Score s, _) => (s.correctAnwser - s.wrongAnwser),
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

  List<Rezult> getCorrect() {
    List<Rezult> correct = new List();
    for (Score score in getScoreList()) {
      Rezult r = new Rezult(score.id, 'c', score.correctAnwser);
      correct.add(r);
    }
    return correct;
  }

  List<Rezult> getWrong() {
    List<Rezult> wrong = new List();
    for (Score score in getScoreList()) {
      Rezult r = new Rezult(score.id, 'w', score.wrongAnwser);
      wrong.add(r);
    }
    return wrong;
  }

  List<Rezult> getSkipped() {
    List<Rezult> skipped = new List();
    for (Score score in getScoreList()) {
      Rezult r = new Rezult(score.id, 's', score.skipedAnwser);
      skipped.add(r);
    }
    return skipped;
  }

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
                    icon: Icon(FontAwesomeIcons.table),
                    text: 'table',
                  ),
                  Tab(
                    icon: Icon(FontAwesomeIcons.chartLine),
                    text: 'line',
                  ),
                  Tab(
                    icon: Icon(FontAwesomeIcons.chartPie),
                    text: 'pie',
                  ),
                ],
              ),
            ),
            body: TabBarView(children: [
              scoreTableContainer(),
              lineContainer(),
              totalPie(),
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




