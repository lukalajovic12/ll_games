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

  Score(int id,int correctAnwser,int wrongAnwser, int skipedAnwser){
    this.id=id;
    this.correctAnwser=correctAnwser;
    this.wrongAnwser=wrongAnwser;
    this.skipedAnwser=skipedAnwser;
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