import 'package:flutter/material.dart';
import 'geo.dart';
import 'dart:async';
import 'geo_database.dart';
import 'geo_main.dart';
class Quiz extends StatefulWidget {

  List<CountryCapital> geoList;
  int quizType=1;

  String continent='';

  List<CountryCapital> getGeoList(){
    if(geoList==null){
      geoList=new List();
    }
    return geoList;
  }


  Quiz(List<CountryCapital> geoList,int quizType,String continent){
      this.geoList=geoList;
      this.quizType=quizType;
      this.continent=continent;
}

  @override
  _QuizState createState() => _QuizState(getGeoList(),quizType,continent);
}

class _QuizState extends State<Quiz> {

  final dbHelper = DatabaseHelper.instance;

  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  // type true is you guess country type false is you guess capital
  int quizType=1;

  String continent='';

  List<CountryCapital> geoList;

  List<CountryCapital> getGeoList(){
    if(geoList==null){
      geoList=new List();
    }
    return geoList;
  }

  _QuizState(List<CountryCapital> geoList,int quizType,String continent){
    this.geoList=geoList;
    this.quizType=quizType;
    createGeo();
    runTimer();
    correctAnwsers=0;
    wrongAnwsers=0;
    skipedAnwserrs=0;
    this.continent=continent;
  }

  KvizQuestion kvizQuestion;

  String _question;

  List<String> anwsers=new List();

  int correctAnwsers=0;

  int  wrongAnwsers=0;

  int skipedAnwserrs=0;

  Timer _timer;

  int countDown;

void createGeo(){
  getGeoList().shuffle();
  CountryCapital rightAnwser=getGeoList()[0];
  if(quizType==1) {
    _question = rightAnwser.country;
  }
  else{
    _question = rightAnwser.capital;
  }
  List<CountryCapital> wrongAnwsers=new List();
  anwsers=new List();
  wrongAnwsers.add(getGeoList()[1]);
  wrongAnwsers.add(getGeoList()[2]);
  kvizQuestion=new KvizQuestion(rightAnwser,wrongAnwsers);
  for(CountryCapital cc in kvizQuestion.getPossibleAnwsers()){
    if(quizType==1) {
      anwsers.add(cc.capital);
    }
    else{
      anwsers.add(cc.country);
    }
  }
}



  void runTimer() {
    countDown=50;
    const oneSec = const Duration(milliseconds: 1000);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) => setState(
            () {
          if (countDown <1) {
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
      DatabaseHelper.columnCorrectAnwser : correctAnwsers,
      DatabaseHelper.columnWrongAnwser  : wrongAnwsers,
      DatabaseHelper.columnSkipedAnwser:skipedAnwserrs,
      DatabaseHelper.columnType:quizType
    };
    final id = await dbHelper.insert(row);
  }


void checkAnwser(String anwser){
    setState(() {
      if(quizType==1) {
        if (anwser == kvizQuestion.corectAnwser.capital) {
          correctAnwsers += 1;
        }
        else {
          wrongAnwsers += 1;
        }
      }
      else{
        if (anwser == kvizQuestion.corectAnwser.country) {
          correctAnwsers += 1;
        }
        else {
          wrongAnwsers += 1;
        }
      }
      createGeo();
    });
}

void skipAnwser(){
  setState(() {
    skipedAnwserrs+=1;
    createGeo();
  });
}

  String getQuestion(){
    if(quizType==1){
      return 'The Capital of $_question is?';
    }
    else{
      return '$_question is the capital of?';
    }
  }

  List<String> getAnwsers(){
  if(anwsers==null){
    anwsers=new List();
  }
    return anwsers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title:Text('$continent')),

        body:

        Column(
          children: <Widget>[
            Center(
              heightFactor: 8,
              child: Text(getQuestion()),
            ),
            SizedBox(
              height: 300,
              child: AnimatedList(
                // Give the Animated list the global key
                key: _listKey,
                initialItemCount: getAnwsers().length,
                // Similar to ListView itemBuilder, but AnimatedList has
                // an additional animation parameter.
                itemBuilder: (context, index, animation) {
                  // Breaking the row widget out as a method so that we can
                  // share it with the _removeSingleItem() method.
                  return RadioListTile<String>(
                    value:  getAnwsers()[index],
                    onChanged: (String value) {
                      checkAnwser(value);
                    },
                    title: new Text( getAnwsers()[index]),
                  );
                },
              ),
            ),
            Center(

              child: RaisedButton(
                child: Text('Skip'),
                onPressed: () {
                      skipAnwser();
                },
              ),
            ),
            Center(
              heightFactor: 2,
              widthFactor: 9,
              child: Text(' correct: $correctAnwsers wrong: $wrongAnwsers skiped $skipedAnwserrs'),
            ),
            Center(
              heightFactor: 2,
              widthFactor: 9,
              child: Text('You have $countDown time'),
            ),
          ],
            ),
        );
  }
}



