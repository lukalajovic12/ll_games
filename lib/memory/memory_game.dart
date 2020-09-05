import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import '../main.dart';
import 'memory_database.dart';
import 'squares/squareBasicMemoryGame.dart';
import 'circles/CircleBasicMemoryGame.dart';
import 'memory_main.dart';
import 'logic.dart';

class GameWidget extends StatefulWidget {
  GameWidget(int type) {
    this.type = type;
  }

  int type = 1;

  @override
  _GameWidget createState() => _GameWidget(type);
}

class _GameWidget extends State<GameWidget> {
  final dbHelper = DatabaseHelper.instance;

  GlobalKey _paintKey = new GlobalKey();
  double canvasWidth = 300;
  double canvasHeight = 300;
  MemoryGame memoryGame;
  Timer _timer;

  int type = 1;

  _GameWidget(int type) {
    this.type = type;
    if (type == 1) {
      memoryGame = new BasicSquareMemory(this.canvasWidth, this.canvasHeight);
    } else {
      memoryGame = new BasicCircleMemory(canvasWidth, canvasHeight);
    }
    memoryGame.createGeoObjects();
    runTimer();
  }

  void runTimer() {
    memoryGame.work = false;
    const oneSec = const Duration(milliseconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (memoryGame.countDown < 1) {
            timer.cancel();
            memoryGame.work = true;
            memoryGame.hideGeoObjects();
          } else {
            memoryGame.countDown -= 1;
          }
        },
      ),
    );
  }

  void _insert() async {
    Map<String, dynamic> row = {
      DatabaseHelper.columnPoints: memoryGame.points,
      DatabaseHelper.columnType: type,
    };
    await dbHelper.insert(row);
  }

  void waitGameOver() {
    memoryGame.work = false;
    int timeOut = 1000;
    const oneSec = const Duration(milliseconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (timeOut < 1) {
            timer.cancel();
            _insert();
            Navigator.pop(context);
          } else {
            timeOut -= 1;
          }
        },
      ),
    );
  }

  void touch(Offset point) {
    //0 pomeni ni dotika
    //1 pomeni dotik prave
    //-1 pomeni dotik napacne
    int t = memoryGame.touch(point);
    if (t == 1) {
      setState(() {
        memoryGame.objectsClicked += 1;
        memoryGame.points += 100;
        if (memoryGame.prepareForNextLevel()) {
          setState(() {
            GameCanvas(this.memoryGame);
          });
          runTimer();
        }
      });
    }
    if (t == -1) {
      memoryGame.looseLife();
      if (memoryGame.lives > 0) {
        memoryGame.createGeoObjects();
        setState(() {
          GameCanvas(this.memoryGame);
        });
        runTimer();
      } else {
        waitGameOver();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('memory'),
      ),
      body: new Listener(
        onPointerDown: (PointerDownEvent event) {
          RenderBox referenceBox = _paintKey.currentContext.findRenderObject();
          Offset offset = referenceBox.globalToLocal(event.position);
          setState(() {
            touch(offset);
          });
        },
        child: Container(
          color: Color(hexColor('#B7D7DA')),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Center(
                child: CustomPaint(
                  key: _paintKey,
                  size: Size(canvasWidth, canvasHeight),
                  painter: GameCanvas(memoryGame),
                ),
              ),
              Text(
                'points: ${memoryGame.points}',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                  letterSpacing: 2.0,
                ),
              ),
              Text(
                'lives ${memoryGame.lives}',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                  letterSpacing: 2.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}