import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

  List<charts.Series<TotalAnwsers, String>> _seriesPieData =
      List<charts.Series<TotalAnwsers, String>>();

  List<charts.Series<Score, int>> _seriesLineData =
      List<charts.Series<Score, int>>();

  List<charts.Series<Rezult, String>> _seriesColumnData =
      new List<charts.Series<Rezult, String>>();

  _ScoreListState() {
    this.scoreist = new List();
    _query();
  }

  void _query() async {
    scoreist = new List();
    final allRows = await dbHelper.queryAllRows();
    List<Score> scl = new List();
    if (allRows != null) {
      allRows.forEach((row) => scl.add(new Score(
          row[DatabaseHelper.columnId],
          row[DatabaseHelper.columnCorrectAnwser],
          row[DatabaseHelper.columnWrongAnwser],
          row[DatabaseHelper.columnSkipedAnwser],
        row[DatabaseHelper.columnTime],
        row[DatabaseHelper.columnPossibleAnwsers],)));
    }
    setState(() {
      this.scoreist = scl;
    });
  }

  final dbHelper = DatabaseHelper.instance;

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
                        Text('${s.correctAnwser-s.wrongAnwser}',
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
                  ),
                )
                .toList(),
          ),
        ));
  }

  void generatePieChart(bool totalScore) {
    int co = 0;
    int wr = 0;
    int sk = 0;
    if(totalScore) {
      for (Score s in getScoreList()) {
        co += s.correctAnwser;
        wr += s.wrongAnwser;
        sk += s.skipedAnwser;
      }
    }
    else{
      co=getScoreList()[ getScoreList().length-1].correctAnwser;
      wr=getScoreList()[ getScoreList().length-1].wrongAnwser;
      sk=getScoreList()[ getScoreList().length-1].skipedAnwser;

    }
    generatePieData(co, wr, sk);
  }

  void generatePieData(int correct, int wrong, int skipped) {
    _seriesPieData = List<charts.Series<TotalAnwsers, String>>();
    var piedata = [
      new TotalAnwsers('correct', correct, Color(0xfffdbe19)),
      new TotalAnwsers('wrong', wrong, Color(0xffff9900)),
      new TotalAnwsers('skipped', skipped, Color(0xffdc3912)),
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
  }

  Container pieContainer(bool totalPoints) {
    generatePieChart(totalPoints);
    String sco='previous score';
    if(totalPoints){
      sco='Total points';
    }

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

  void generateLineChart() {
    List<Score> scl = new List();
    Score s= new Score(0, 0, 0, 0,0,0);
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

  void generataColumnChart() {
    _seriesColumnData = new List<charts.Series<Rezult, String>>();

    _seriesColumnData.add(
      charts.Series(
        domainFn: (Rezult r, _) => '${r.categry}',
        measureFn: (Rezult r, _) => r.points,
        id: 'Score',
        data: getCorrect(),
        fillPatternFn: (_, __) => charts.FillPatternType.solid,
        fillColorFn: (Rezult r, _) =>
            charts.ColorUtil.fromDartColor(Colors.blue),
      ),
    );
    _seriesColumnData.add(
      charts.Series(
        domainFn: (Rezult r, _) => '${r.categry}',
        measureFn: (Rezult r, _) => r.points,
        id: 'Score',
        data: getWrong(),
        fillPatternFn: (_, __) => charts.FillPatternType.solid,
        fillColorFn: (Rezult r, _) =>
            charts.ColorUtil.fromDartColor(Colors.red),
      ),
    );
    _seriesColumnData.add(
      charts.Series(
        domainFn: (Rezult r, _) => '${r.categry}',
        measureFn: (Rezult r, _) => r.points,
        id: 'Score',
        data: getSkipped(),
        fillPatternFn: (_, __) => charts.FillPatternType.solid,
        fillColorFn: (Rezult r, _) =>
            charts.ColorUtil.fromDartColor(Colors.green),
      ),
    );
  }

  Container columnContainer() {
    generataColumnChart();
    return Container(
      child: Center(
        child: Column(
          children: <Widget>[
            Text(
              'Score in charts',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: charts.BarChart(
                _seriesColumnData,
                animate: true,
                barGroupingType: charts.BarGroupingType.grouped,
                animationDuration: Duration(seconds: 1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 4,
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
                    text: 'pie',
                  ),
                  Tab(
                    icon: Icon(FontAwesomeIcons.chartPie),
                    text: 'lastScore',
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
              pieContainer(true),
              pieContainer(false),
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
