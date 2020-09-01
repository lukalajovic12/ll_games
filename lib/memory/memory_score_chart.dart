import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'memory_database.dart';

class Score{
  int id=-1;
  int points=0;
  int type=-1;
  Score(int id, int points,int type){
    this.id=id;
    this.points=points;
    this.type=type;
  }
}

class ScorePage extends StatefulWidget {

  int type=1;
  ScorePage(int type){
    this.type=type;
  }

  _ScorePageState createState() => _ScorePageState(type);
}

class _ScorePageState extends State<ScorePage> {

  int type=1;

  _ScorePageState(int type) {
    this.type=type;
    _seriesLineData = List<charts.Series<Score, int>>();
    _seriesData= List<charts.Series<Score, String>>();
    _query();
  }

  List<charts.Series<Score, int>> _seriesLineData;

  List<charts.Series<Score, String>> _seriesData;

  List<Score> scoreist;



  void _query() async {
    scoreist=new List();
    final allRows = await dbHelper.queryAllTypeRows(type);
    List<Score> scl=new List();
    if(allRows!=null) {
      allRows.forEach((row) => scl.add(new Score(row[DatabaseHelper.columnId],row[DatabaseHelper.columnPoints],row[DatabaseHelper.columnType])));
    }
    setState(() {
      scoreist=scl;
      _generateData();
    });
  }
  final dbHelper = DatabaseHelper.instance;

  List<Score> getScoreList(){
    if(scoreist==null){
      scoreist=new List();
    }
    return scoreist;
  }



  _generateData() {
    _seriesLineData.add(
      charts.Series(
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xff990099)),
        id: 'Game Line Scores',
        data: getScoreList(),
        domainFn: (Score s, _) => s.id,
        measureFn: (Score s, _) => s.points,
      ),
    );
      _seriesData.add(
        charts.Series(
          domainFn: (Score score, _) => '${score.id}',
          measureFn: (Score score, _) => score.points,
          id: 'Game Column Scores',
          data: getScoreList(),
          fillPatternFn: (_, __) => charts.FillPatternType.solid,
          fillColorFn: (Score score, _) =>
              charts.ColorUtil.fromDartColor(Color(0xff990099)),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Chart'),
            centerTitle: true,
            backgroundColor: Colors.red,
            bottom: TabBar(
              indicatorColor: Color(0xff9962D0),
              tabs: [
                Tab(icon: Icon(FontAwesomeIcons.table)),
                Tab(icon: Icon(FontAwesomeIcons.chartLine)),
                Tab(icon: Icon(FontAwesomeIcons.solidChartBar)),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: DataTable(
                  sortAscending: true,
                  columns: <DataColumn>[
                    DataColumn(
                      label: Text('id'),
                    ),
                    DataColumn(
                      label: Text('points'),
                    ),
                  ],
                  rows: scoreist
                      .map(
                        (s) => DataRow(
                      cells: [
                        DataCell(
                          Text('${s.id}'),
                          showEditIcon: false,
                          placeholder: false,
                        ),
                        DataCell(
                          Text('${s.points}'),
                          showEditIcon: false,
                          placeholder: false,
                        ),
                      ],
                    ),
                  ).toList(),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Your game progress in line',style: TextStyle(fontSize: 24.0,fontWeight: FontWeight.bold),),
                        Expanded(
                          child: charts.LineChart(
                              _seriesLineData,
                              defaultRenderer: new charts.LineRendererConfig(
                                  includeArea: true, stacked: true),
                              animate: true,
                              animationDuration: Duration(seconds: 5),
                              behaviors: [
                                new charts.ChartTitle('Id',
                                    behaviorPosition: charts.BehaviorPosition.bottom,
                                    titleOutsideJustification:charts.OutsideJustification.middleDrawArea),
                                new charts.ChartTitle('Score',
                                    behaviorPosition: charts.BehaviorPosition.start,
                                    titleOutsideJustification: charts.OutsideJustification.middleDrawArea),
                              ]
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Your game progress in columns',style: TextStyle(fontSize: 24.0,fontWeight: FontWeight.bold),),
                        Expanded(
                          child: charts.BarChart(
                            _seriesData,
                            animate: true,
                            barGroupingType: charts.BarGroupingType.grouped,
                            //behaviors: [new charts.SeriesLegend()],
                            animationDuration: Duration(seconds: 5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),




            ],
          ),
        ),
      ),
    );
  }
}