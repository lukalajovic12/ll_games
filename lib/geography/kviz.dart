import 'package:flutter/material.dart';
import '../main.dart';
import 'geo.dart';
import 'dart:async';
import 'geo_database.dart';
import 'geo_main.dart';

class Quiz extends StatefulWidget {
  List<CountryCapital> geoList;
  int quizType = 1;

  int time = 30;

  List<String> categories = new List();

  List<CountryCapital> getGeoList() {
    if (geoList == null) {
      geoList = new List();
    }
    return geoList;
  }

  Quiz(List<CountryCapital> geoList, int quizType, List<String> categories,
      int time) {
    this.geoList = geoList;
    this.quizType = quizType;
    this.categories = categories;
    this.time = time;
  }

  @override
  _QuizState createState() =>
      _QuizState(getGeoList(), quizType, categories, time);
}

class _QuizState extends State<Quiz> {
  final dbHelper = DatabaseHelper.instance;

  final GlobalKey<AnimatedListState> _listKey = GlobalKey();

  int quizType = 1;

  int time = 30;

  List<String> categories = new List();

  List<CountryCapital> geoList;

  List<CountryCapital> getGeoList() {
    if (geoList == null) {
      geoList = new List();
    }
    return geoList;
  }

  List<String> correctlyAnwsered = new List();

  _QuizState(List<CountryCapital> geoList, int quizType,
      List<String> categories, int time) {
    this.geoList = geoList;
    this.quizType = quizType;
    createGeo();
    runTimer();
    correctAnwsers = 0;
    wrongAnwsers = 0;
    skipedAnwserrs = 0;
    this.categories = categories;
    this.correctlyAnwsered = new List();
    this.time = time;
  }

  KvizQuestion kvizQuestion;

  String _question;

  List<String> anwsers = new List();

  int correctAnwsers = 0;

  int wrongAnwsers = 0;

  int skipedAnwserrs = 0;

  Timer _timer;

  int countDown;

  int wait;

  bool timeCounting = true;

  String clickedAnwser = "";

  void createGeo() {
    clickedAnwser = "";
    getGeoList().shuffle();

    CountryCapital rightAnwser = null;
    while (true) {
      if (correctlyAnwsered.contains(getGeoList()[0].capital) ||
          correctlyAnwsered.contains(getGeoList()[0].country)) {
        getGeoList().shuffle();
      } else {
        rightAnwser = getGeoList()[0];
        break;
      }
    }

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
    countDown = time;
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
            if (timeCounting) {
              countDown -= 1;
            } else {
              wait -= 1;
              if (wait < 1) {
                timeCounting = true;
                createGeo();
              }
            }
          }
        },
      ),
    );
  }

  void startWait() {
    timeCounting = false;
    wait = 2;
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

  bool checkingAnwser(String anwser) {
    bool cor = true;
    if (quizType == 1) {
      if (anwser == kvizQuestion.corectAnwser.capital) {
        cor = true;
      } else {
        cor = false;
      }
    } else {
      if (anwser == kvizQuestion.corectAnwser.country) {
        cor = true;
      } else {
        cor = false;
      }
    }
    return cor;
  }

  void checkAnwser(String anwser) {
    clickedAnwser = anwser;
    setState(() {
      if (checkingAnwser(anwser)) {
        correctAnwsers += 1;
        correctlyAnwsered.add(anwser);
        if (getGeoList().length == correctlyAnwsered.length) {
          Navigator.pop(context);
        }
      } else {
        wrongAnwsers += 1;
      }
      startWait();
    });
  }

  Color buttonCollor(String anwser) {
    if (timeCounting) {
      return Color(hexColor('#0E629B'));
    } else {
      if (checkingAnwser(anwser)) {
        return Colors.green;
      } else if (anwser == clickedAnwser) {
        return Colors.red;
      } else {
        return Color(hexColor('#0E629B'));
      }
    }
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
        appBar: AppBar(title: Text('GEO')),
        body: Container(
          color: Color(hexColor('#B7D7DA')),
          child: Column(
            children: <Widget>[
              Container(
                padding: new EdgeInsets.only(top: 40,bottom: 40),
                width: double.infinity,
                color: Color(hexColor('#0E629B')),
                child: Center(
                  child: Text(getQuestion(),
                      style: TextStyle(
                        color: Color(hexColor('#B7D7DA')),
                        fontSize: 20.0,
                      )),
                ),
              ),
          Container(
            padding: new EdgeInsets.only(top: 20),
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: getAnwsers().length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: new EdgeInsets.only(left: 40, right: 40, top:20,bottom: 20),
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      color: buttonCollor(getAnwsers()[index]),
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

          ),

              Container(
                padding: new EdgeInsets.only(
                    left: 40, right: 40,),
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
                color: Color(hexColor('#B7D7DA')),
                child: Text('${countDown}s',
                    style: TextStyle(
                      color: Color(hexColor('#0E629B')),
                      fontSize: 20.0,
                    )),
              ),
            ],
          ),
        ));
  }
}
