import 'dart:math';

import 'package:flutter/material.dart';
import 'package:llgames/geography/statistics/single_game_statistics.dart';
import 'package:sprintf/sprintf.dart';
import '../main.dart';
import 'constants.dart';
import 'geo.dart';
import 'dart:async';
import 'database/geo_database.dart';

class Quiz extends StatefulWidget {
  String type = '';

  List<QuizObject> geoList;

  int quizType = 1;

  int time = 30;

  List<String> categories = new List();

  int numberOfQuestions = 3;

  String questionString;

  String reverseQuestionString;

  Quiz(
      List<QuizObject> geoList,
      int quizType,
      List<String> categories,
      int time,
      int numberOfQuestions,
      String type,
      String questionString,
      String reverseQuestionString) {
    this.geoList = geoList;
    this.categories = categories;
    this.time = time;
    this.numberOfQuestions = numberOfQuestions;
    this.quizType = quizType;
    this.type = type;
    this.questionString = questionString;
    this.reverseQuestionString = reverseQuestionString;
  }

  @override
  _QuizState createState() => _QuizState(getGeoList(), quizType, categories,
      time, numberOfQuestions, type, questionString, reverseQuestionString);

  List<QuizObject> getGeoList() {
    if (geoList == null) {
      geoList = new List();
    }
    return geoList;
  }
}

class _QuizState extends State<Quiz> {
  final dbGameHelper = DatabaseGameHelper.instance;

  int quizType = 1;

  int time = 30;

  List<String> categories = new List();

  List<QuizObject> geoList;

  List<String> correctlyAnwsered = new List();

  int numberOfAnwsers = 3;

  KvizQuestion kvizQuestion;

  String _question;

  List<String> anwsers = new List();

  int countDown;

  int wait;

  bool timeCounting = true;

  String clickedAnwser = "";

  bool askCountry = true;

  List<Anwser> listAnwsers = new List();

  String type = '';

  String questionString;

  String reverseQuestionString;

  Timer _timer;

  _QuizState(
      List<QuizObject> geoList,
      int quizType,
      List<String> categories,
      int time,
      int numberOfAnwsers,
      String type,
      questionString,
      String reverseQuestionString) {
    this.geoList = geoList;
    this.quizType = quizType;
    this.time = time;
    this.numberOfAnwsers = numberOfAnwsers;
    this.categories = categories;
    this.correctlyAnwsered = new List();
    createQuestion();
    runTimer();
    listAnwsers = new List();
    this.type = type;
    this.questionString = questionString;
    this.reverseQuestionString = reverseQuestionString;
  }

  void createQuestion() {
    clickedAnwser = "";
    getGeoList().shuffle();
    QuizObject rightAnwser = null;
    while (true) {
      if (correctlyAnwsered.contains(getGeoList()[0].secondaryType) ||
          correctlyAnwsered.contains(getGeoList()[0].type)) {
        getGeoList().shuffle();
      } else {
        rightAnwser = getGeoList()[0];
        break;
      }
    }

    if (quizType == 1) {
      _question = rightAnwser.type;
    } else if (quizType == 2) {
      _question = rightAnwser.secondaryType;
    } else {
      Random random = new Random();
      askCountry = random.nextBool();
      if (askCountry) {
        _question = rightAnwser.type;
      } else {
        _question = rightAnwser.secondaryType;
      }
    }
    List<QuizObject> wrongAnwsers = new List();
    anwsers = new List();

    for (int i = 1; i < numberOfAnwsers; i++) {
      wrongAnwsers.add(getGeoList()[i]);
    }

    kvizQuestion =
        new KvizQuestion(corectAnwser: rightAnwser, wrongAnwsers: wrongAnwsers);
    for (QuizObject cc in kvizQuestion.getPossibleAnwsers()) {
      if (quizType == 1) {
        anwsers.add(cc.secondaryType);
      } else if (quizType == 2) {
        anwsers.add(cc.type);
      } else {
        if (askCountry) {
          anwsers.add(cc.secondaryType);
        } else {
          anwsers.add(cc.type);
        }
      }
    }
  }

  void endGame() {
    _insert();
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SingleGameStatistics(
            lastGameAnwsers: listAnwsers,
            gameProperties: generateGameProperties()),
      ),
    );
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
            endGame();
          } else {
            if (timeCounting) {
              countDown -= 1;
            } else {
              wait -= 1;
              if (wait < 1) {
                timeCounting = true;
                createQuestion();
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

  List<GameConstantInstance> generateGameProperties() {
    List<GameConstantInstance> gameProperties = new List();
    gameProperties
        .add(new GameConstantInstance(GameConstants.game_time, '$time'));
    gameProperties.add(new GameConstantInstance(
        GameConstants.game_possible_anwsers, '$numberOfAnwsers'));
    for (String cat in categories) {
      gameProperties
          .add(new GameConstantInstance(GameConstants.game_category, '$cat'));
    }
    return gameProperties;
  }

  void _insert() async {
    final id = await dbGameHelper.insertNewGame(type);
    for (Anwser a in listAnwsers) {
      Map<String, dynamic> rr = {
        DatabaseGameHelper.gameColumnQuestion: a.question,
        DatabaseGameHelper.gameColumnCorrectAnwser: a.correctAnwser,
        DatabaseGameHelper.gameColumnAnwser: a.anwser,
        DatabaseGameHelper.gameId: id
      };
      await dbGameHelper.insertQuestion(rr);

      for (GameConstantInstance gci in generateGameProperties()) {
        Map<String, dynamic> cc = {
          DatabaseGameHelper.propertyTypeColumn: gci.type,
          DatabaseGameHelper.propertyValueColumn: gci.value,
          DatabaseGameHelper.gameId: id
        };
        await dbGameHelper.insertProperty(cc);
      }

      for (String cat in categories) {
        Map<String, dynamic> cc = {
          DatabaseGameHelper.propertyTypeColumn: GameConstants.game_category,
          DatabaseGameHelper.propertyValueColumn: '$cat',
          DatabaseGameHelper.gameId: id
        };
        await dbGameHelper.insertProperty(cc);
      }
    }
  }

  bool checkingAnwser(String anwser) {
    bool cor = true;
    if (quizType == 1) {
      if (anwser == kvizQuestion.corectAnwser.secondaryType) {
        cor = true;
      } else {
        cor = false;
      }
    } else if (quizType == 2) {
      if (anwser == kvizQuestion.corectAnwser.type) {
        cor = true;
      } else {
        cor = false;
      }
    } else {
      if (askCountry) {
        if (anwser == kvizQuestion.corectAnwser.secondaryType) {
          cor = true;
        } else {
          cor = false;
        }
      } else {
        if (anwser == kvizQuestion.corectAnwser.type) {
          cor = true;
        } else {
          cor = false;
        }
      }
    }
    return cor;
  }

  void checkAnwser(String anwser) {
    if (timeCounting) {
      clickedAnwser = anwser;
      setState(() {
        if (checkingAnwser(anwser)) {
          correctlyAnwsered.add(anwser);
          if (getGeoList().length == correctlyAnwsered.length) {
            endGame();
          }
        }
        String corAnw = "";
        if (quizType == 1) {
          corAnw = kvizQuestion.corectAnwser.secondaryType;
        } else if (quizType == 2) {
          corAnw = kvizQuestion.corectAnwser.type;
        } else {
          if (askCountry) {
            corAnw = kvizQuestion.corectAnwser.secondaryType;
          } else {
            corAnw = kvizQuestion.corectAnwser.type;
          }
        }
        Anwser a = new Anwser(getQuestion(), corAnw, anwser);
        listAnwsers.add(a);
        startWait();
      });
    }
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
    if (timeCounting) {
      String corAnw = "";
      if (quizType == 1) {
        corAnw = kvizQuestion.corectAnwser.secondaryType;
      } else if (quizType == 2) {
        corAnw = kvizQuestion.corectAnwser.type;
      } else {
        if (askCountry) {
          corAnw = kvizQuestion.corectAnwser.secondaryType;
        } else {
          corAnw = kvizQuestion.corectAnwser.type;
        }
      }
      corAnw = kvizQuestion.corectAnwser.type;
      Anwser a = new Anwser(getQuestion(), corAnw, 'Skipped');
      listAnwsers.add(a);
      setState(() {
        createQuestion();
      });
    }
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
                padding: new EdgeInsets.only(top: 10, bottom: 10),
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
                        padding: new EdgeInsets.only(
                            left: 40,
                            right: 40,
                            bottom: 60 / numberOfAnwsers.toDouble(),
                            top: 60 / numberOfAnwsers.toDouble()),
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
                  left: 40,
                  right: 40,
                ),
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

  List<QuizObject> getGeoList() {
    if (geoList == null) {
      geoList = new List();
    }
    return geoList;
  }

  List<String> getAnwsers() {
    if (anwsers == null) {
      anwsers = new List();
    }
    return anwsers;
  }

  String getQuestion() {
    if (quizType == 1) {
      return sprintf(questionString, [_question]);
    } else if (quizType == 2) {
      return sprintf(reverseQuestionString, [_question]);
    } else {
      if (askCountry) {
        return sprintf(reverseQuestionString, [_question]);
      } else {
        return sprintf(questionString, [_question]);
      }
    }
  }
}
