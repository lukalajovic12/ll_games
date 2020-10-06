import 'package:flutter/material.dart';
import 'dart:math';

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
  int correctAnwser=0;
  int wrongAnwser=0;
  int skipedAnwser=0;
  int time=0;
  int possibleAnwsers=0;

  Score(int id,int correctAnwser,int wrongAnwser, int skipedAnwser,int time,possibleAnwsers){
    this.id=id;
    this.correctAnwser=correctAnwser;
    this.wrongAnwser=wrongAnwser;
    this.skipedAnwser=skipedAnwser;
    this.time=time;
    this.possibleAnwsers=possibleAnwsers;
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
  int type=1;




  Anwser(String question,String correctAnwser,String anwser,int type){
    this.question=question;
    this.correctAnwser=correctAnwser;
    this.anwser=anwser;
    this.type=type;
  }



}