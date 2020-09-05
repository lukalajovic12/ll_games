import 'package:flutter/material.dart';
import '../main.dart';
import 'geo.dart';
import 'dart:async';
import 'geo_database.dart';
import 'geo_main.dart';

class Quiz extends StatefulWidget {
  List<CountryCapital> geoList;
  int quizType = 1;

  String continent = '';

  List<CountryCapital> getGeoList() {
    if (geoList == null) {
      geoList = new List();
    }
    return geoList;
  }

  Quiz(List<CountryCapital> geoList, int quizType, String continent) {
    this.geoList = geoList;
    this.quizType = quizType;
    this.continent = continent;
  }

  @override
  _QuizState createState() => _QuizState(getGeoList(), quizType, continent);
}

class _QuizState extends State<Quiz> {
  final dbHelper = DatabaseHelper.instance;

  final GlobalKey<AnimatedListState> _listKey = GlobalKey();

  // type true is you guess country type false is you guess capital
  int quizType = 1;

  String continent = '';

  List<CountryCapital> geoList;

  List<CountryCapital> getGeoList() {
    if (geoList == null) {
      geoList = new List();
    }
    return geoList;
  }

  _QuizState(List<CountryCapital> geoList, int quizType, String continent) {
    this.geoList = geoList;
    this.quizType = quizType;
    createGeo();
    runTimer();
    correctAnwsers = 0;
    wrongAnwsers = 0;
    skipedAnwserrs = 0;
    this.continent = continent;
  }

  KvizQuestion kvizQuestion;

  String _question;

  List<String> anwsers = new List();

  int correctAnwsers = 0;

  int wrongAnwsers = 0;

  int skipedAnwserrs = 0;

  Timer _timer;

  int countDown;

  void createGeo() {
    getGeoList().shuffle();
    CountryCapital rightAnwser = getGeoList()[0];
    if (quizType == 1) {
      _question = rightAnwser.country;
    } else {
      _question = rightAnwser.capital;
    }
    List<CountryCapital> wrongAnwsers = new List();
    anwsers = new List();
    wrongAnwsers.add(getGeoList()[1]);
    wrongAnwsers.add(getGeoList()[2]);
    kvizQuestion = new KvizQuestion(rightAnwser, wrongAnwsers);
    for (CountryCapital cc in kvizQuestion.getPossibleAnwsers()) {
      if (quizType == 1) {
        anwsers.add(cc.capital);
      } else {
        anwsers.add(cc.country);
      }
    }
  }

  void runTimer() {
    countDown = 50;
    const oneSec = const Duration(milliseconds: 1000);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (countDown < 1) {
            timer.cancel();
            _insert();
            Navigator.pop(context);
          } else {
            countDown -= 1;
          }
        },
      ),
    );
  }

  void _insert() async {
    Map<String, dynamic> row = {
      DatabaseHelper.columnCorrectAnwser: correctAnwsers,
      DatabaseHelper.columnWrongAnwser: wrongAnwsers,
      DatabaseHelper.columnSkipedAnwser: skipedAnwserrs,
      DatabaseHelper.columnType: quizType
    };
    final id = await dbHelper.insert(row);
  }

  void checkAnwser(String anwser) {
    setState(() {
      if (quizType == 1) {
        if (anwser == kvizQuestion.corectAnwser.capital) {
          correctAnwsers += 1;
        } else {
          wrongAnwsers += 1;
        }
      } else {
        if (anwser == kvizQuestion.corectAnwser.country) {
          correctAnwsers += 1;
        } else {
          wrongAnwsers += 1;
        }
      }
      createGeo();
    });
  }

  void skipAnwser() {
    setState(() {
      skipedAnwserrs += 1;
      createGeo();
    });
  }

  String getQuestion() {
    if (quizType == 1) {
      return 'The Capital of $_question is?';
    } else {
      return '$_question is the capital of?';
    }
  }

  List<String> getAnwsers() {
    if (anwsers == null) {
      anwsers = new List();
    }
    return anwsers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('$continent rime ')),
        body: Container(
          color: Color(hexColor('#B7D7DA')),
          child: Column(
            children: <Widget>[
              Container(
                color: Color(hexColor('#0E629B')),
                child: Text(getQuestion(),
                    style: TextStyle(
                      color: Color(hexColor('#B7D7DA')),
                      fontSize: 20.0,
                    )),
              ),
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: getAnwsers().length,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: new EdgeInsets.only(left: 40, right: 40),
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        color: Color(hexColor('#0E629B')),
                        child: Text(
                          getAnwsers()[index],
                          style: TextStyle(color: Color(hexColor('#B7D7DA'))),
                        ),
                        onPressed: () {
                          checkAnwser(getAnwsers()[index]);
                        },
                      ),
                    );
                  }),
              Container(
                padding: new EdgeInsets.only(
                    left: 40, right: 40, top: 40, bottom: 40),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  color: Color(hexColor('#0E629B')),
                  child: Text(
                    'Skip',
                    style: TextStyle(color: Color(hexColor('#B7D7DA'))),
                  ),
                  onPressed: () {
                    skipAnwser();
                  },
                ),
              ),
              Container(
                color: Color(hexColor('#0E629B')),
                child: Text(
                    ' correct: $correctAnwsers wrong: $wrongAnwsers skiped $skipedAnwserrs',
                    style: TextStyle(
                      color: Color(hexColor('#B7D7DA')),
                      fontSize: 20.0,
                    )),
              ),
              Container(
                color: Color(hexColor('#0E629B')),
                child: Text('You have $countDown time',
                    style: TextStyle(
                      color: Color(hexColor('#B7D7DA')),
                      fontSize: 20.0,
                    )),
              ),
            ],
          ),
        ));
  }
}
