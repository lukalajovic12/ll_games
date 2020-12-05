import 'package:flutter/material.dart';
import 'dart:math';

import 'constants.dart';


class QuizObjectData{
  String type;
  String secondaryType;
  String category;
  QuizObjectData({this.type,this.secondaryType,this.category}){

  }
}


class QuizObject{
  String type;
  String secondaryType;
  QuizObject({this.type,this.secondaryType}){

  }
}



class KvizQuestion{

  QuizObject corectAnwser;
  List<QuizObject> wrongAnwsers;


  KvizQuestion({this.corectAnwser,this.wrongAnwsers}){
  }

  List<QuizObject> getPossibleAnwsers() {
    List<QuizObject> allAnwsers = new List();
    for (QuizObject cc in wrongAnwsers) {
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

  Score({this.id,this.score,this.datePlayed}){
  }

}

class Rezult{
  int id=-1;
  String categry="";
  int points=0;
  Rezult({this.id,this.categry,this.points}){
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