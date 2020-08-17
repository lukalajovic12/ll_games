import 'package:flutter/material.dart';

abstract class MemoryGame{

  int points;
  int lives;
  int countDownOriginal;
  int countDown;
  bool work=true;
  int objectsClicked;
  double canvasWidth;
  double canvasHeight;
  int objectsNumber;
  int mustBeClicked;

  MemoryGame(this.canvasWidth,this.canvasHeight,this.objectsNumber,this.mustBeClicked){
    this.points=lives=3;
    this.points=0;
    this.countDownOriginal=500;
    this.countDown=countDownOriginal;
    this.work=true;
    this.objectsClicked=0;
  }

  void createGeoObjects();

  void hideGeoObjects();

  void drawObjects(Canvas canvas);

  int touch(Offset point);

  bool prepareForNextLevel();

  void looseLife();

}

abstract class GeoObject{

  bool touch(double dx, double dy);

  void draw(Canvas canvas);

  void hide();

}

class GameCanvas extends CustomPainter {

  MemoryGame memoryGame;
  GameCanvas(this.memoryGame);

  @override
  void paint(Canvas canvas, Size size) {
    memoryGame.drawObjects(canvas);
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return true;
  }

  @override
  void addListener(VoidCallback listener) {
  }
}