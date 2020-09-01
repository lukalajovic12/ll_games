import 'package:flutter/material.dart';
import 'dart:math';

class CountryCapital{
  String country;
  String capital;
  String continent;
  CountryCapital({ this.country,this.capital,this.continent}){
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
  int correctAnwser=0;
  int wrongAnwser=0;
  int skipedAnwser=0;
  int type=1;

  Score(int correctAnwser,int wrongAnwser, int skipedAnwser,int type){
    this.correctAnwser=correctAnwser;
    this.wrongAnwser=wrongAnwser;
    this.skipedAnwser=skipedAnwser;
    this.type=type;
  }
}