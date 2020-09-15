import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../main.dart';
import 'geo.dart';
import 'geo_database.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class ScoreList extends StatefulWidget {
  int type = 1;

  ScoreList(int type) {
    this.type = type;
  }

  @override
  _ScoreListState createState() => _ScoreListState(type);
}

class _ScoreListState extends State<ScoreList> {
  int type = 1;

  List<Score> scoreist = new List();

  _ScoreListState(int type) {
    this.type = type;
    this.scoreist = new List();
    _query();
  }

  void _query() async {
    scoreist = new List();
    final allRows = await dbHelper.queryAllTypeRows(type);
    List<Score> scl = new List();
    if (allRows != null) {
      allRows.forEach((row) => scl.add(new Score(
          row[DatabaseHelper.columnCorrectAnwser],
          row[DatabaseHelper.columnWrongAnwser],
          row[DatabaseHelper.columnSkipedAnwser],
          row[DatabaseHelper.columnType])));
    }
    setState(() {
      scoreist = scl;
    });
  }

  final dbHelper = DatabaseHelper.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: DefaultTabController(
            length: 3,
            child: Scaffold(
                appBar: AppBar(
                  iconTheme: IconThemeData(
                    color: Colors.black, //change your color here
                  ),
                  title: Text('Memory'),
                  centerTitle: true,
                  backgroundColor: Colors.blue,
                  bottom: TabBar(
                    indicatorColor: Colors.white,
                    tabs: [
                      Tab(
                        icon: Icon(FontAwesomeIcons.landmark),
                        text: 'Last score',
                      ),
                      Tab(
                        icon: Icon(FontAwesomeIcons.table),
                        text: 'table',
                      ),
                      Tab(
                        icon: Icon(FontAwesomeIcons.chartPie),
                        text: 'pie',
                      ),
                    ],
                  ),
                ),
                body: TabBarView(children: [
                  LastMaxWidget(scoreist),
                  ScoreTableWidget(scoreist),
                  PieTableWidget(scoreist),
                ]))));
  }
}

class ScoreTableWidget extends StatefulWidget {
  List<Score> scoreist = new List();

  ScoreTableWidget(List<Score> scoreist) {
    this.scoreist = scoreist;
  }

  @override
  State createState() => new _ScoreTableWidget(scoreist);
}

class _ScoreTableWidget extends State<ScoreTableWidget> {
  List<Score> scoreist = new List();

  _ScoreTableWidget(List<Score> scoreist) {
    this.scoreist = scoreist;
  }

  @override
  Widget build(BuildContext context) {
    return Container(


        color: Color(hexColor('#B7D7DA')),
        child: SingleChildScrollView(
      child: DataTable(
        sortAscending: true,
        columns: <DataColumn>[
          DataColumn(
            label: Text('correct'),
          ),
          DataColumn(
            label: Text('wrong'),
          ),
          DataColumn(
            label: Text('skiped'),
          ),
          DataColumn(
            label: Text('type'),
          ),
        ],
        rows: scoreist
            .map(
              (s) => DataRow(
                cells: [
                  DataCell(
                    Text('${s.correctAnwser}'),
                    showEditIcon: false,
                    placeholder: false,
                  ),
                  DataCell(
                    Text('${s.wrongAnwser}'),
                    showEditIcon: false,
                    placeholder: false,
                  ),
                  DataCell(
                    Text('${s.skipedAnwser}'),
                    showEditIcon: false,
                    placeholder: false,
                  ),
                  DataCell(
                    Text('${s.type}'),
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
}

class LastMaxWidget extends StatefulWidget {
  List<Score> lastScoreList = new List();

  LastMaxWidget(List<Score> lastScoreList) {
    this.lastScoreList = lastScoreList;
  }

  @override
  State createState() => new _LastMaxWidget(lastScoreList);
}

class _LastMaxWidget extends State<LastMaxWidget> {
  List<Score> lastScoreList = new List();

  Score lastScore = new Score(0, 0, 0, 0);

  _LastMaxWidget(List<Score> ll) {
    if (ll != null && !ll.isEmpty) {
      lastScore = ll.last;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Color(hexColor('#B7D7DA')),
        child: SingleChildScrollView(
      child: DataTable(
        sortAscending: true,
        columns: <DataColumn>[
          DataColumn(
            label: Text('correct'),
          ),
          DataColumn(
            label: Text('wrong'),
          ),
          DataColumn(
            label: Text('skiped'),
          ),
          DataColumn(
            label: Text('type'),
          ),
        ],
        rows: lastScoreList
            .map(
              (s) => DataRow(
                cells: [
                  DataCell(
                    Text('${s.correctAnwser}'),
                    showEditIcon: false,
                    placeholder: false,
                  ),
                  DataCell(
                    Text('${s.wrongAnwser}'),
                    showEditIcon: false,
                    placeholder: false,
                  ),
                  DataCell(
                    Text('${s.skipedAnwser}'),
                    showEditIcon: false,
                    placeholder: false,
                  ),
                  DataCell(
                    Text('${s.type}'),
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
}

class PieTableWidget extends StatefulWidget {
  List<Score> scoreist = new List();

  PieTableWidget(List<Score> scoreist) {
    this.scoreist = scoreist;
  }

  @override
  State createState() => new _PieTableWidget(scoreist);
}

class _PieTableWidget extends State<PieTableWidget> {
  _PieTableWidget(List<Score> scoreist) {
    int co = 0;
    int wr = 0;
    int sk = 0;
    for (Score s in scoreist) {
      co += s.correctAnwser;
      wr += s.wrongAnwser;
      sk += s.skipedAnwser;
    }
    _generateData(co, wr, sk);
  }

  final bool animate = true;

  List<charts.Series<TotalAnwsers, String>> _seriesPieData =
      List<charts.Series<TotalAnwsers, String>>();

  _generateData(int correct, int wrong, int skipped) {
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Container(
        color: Color(hexColor('#B7D7DA')),
        child: Center(
          child: Column(
            children: <Widget>[
              Text(
                'total points',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10.0,
              ),
              Expanded(
                child: charts.PieChart(_seriesPieData,
                    animate: true,
                    animationDuration: Duration(seconds: 5),
                    behaviors: [
                      new charts.DatumLegend(
                        outsideJustification:
                            charts.OutsideJustification.endDrawArea,
                        horizontalFirst: false,
                        desiredMaxRows: 2,
                        cellPadding:
                            new EdgeInsets.only(right: 4.0, bottom: 4.0),
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
      ),
    );
  }
}

class TotalAnwsers {
  String type;
  int count;
  Color colorval;

  TotalAnwsers(this.type, this.count, this.colorval);
}
