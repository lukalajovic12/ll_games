import 'package:flutter/material.dart';
import 'dart:math';

import 'constants.dart';

class CountryCapital{
  String country;
  String capital;
  CountryCapital({ this.country,this.capital}){
  }
}

class KvizQuestion{

  CountryCapital corectAnwser;
  List<CountryCapital> wrongAnwsers;


  KvizQuestion(CountryCapital corectAnwser,List<CountryCapital> wrongAnwsers){
    this.corectAnwser=corectAnwser;
    this.wrongAnwsers=wrongAnwsers;
  }

  List<CountryCapital> getPossibleAnwsers() {
    List<CountryCapital> allAnwsers = new List();
    for (CountryCapital cc in wrongAnwsers) {
      allAnwsers.add(cc);
    }
    allAnwsers.add(corectAnwser);
    allAnwsers.shuffle();
    return allAnwsers;
  }

}


class Score{
  int id=-1;
  String datePlayed="";
  int score=0;


  String displayDate(){
    if(datePlayed==null || datePlayed==""){
      return "";
    }
    else{
      DateTime dateTime = DateTime.parse(datePlayed);

      return "${dateTime.year}:${dateTime.month}:${dateTime.day}:${dateTime.hour}:${dateTime.minute}";


    }
  }

  Score(int id,String datePlayed,int score){
    this.id=id;
    this.datePlayed=datePlayed;
    this.score=score;
  }

}

class Rezult{
  int id=-1;
  String categry="";
  int points=0;
  Rezult(int id,String category,int points){
    this.id=id;
    this.categry=categry;
    this.points=points;

  }
}

class Anwser{

  String question="";
  String correctAnwser="";
  String anwser="";





  Anwser(String question,String correctAnwser,String anwser){
    this.question=question;
    this.correctAnwser=correctAnwser;
    this.anwser=anwser;
  }



}