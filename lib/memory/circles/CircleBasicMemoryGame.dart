import 'package:flutter/material.dart';
import '../logic.dart';


class BasicCircleMemory extends MemoryGame{

  List<Circle> circles=new List();

  bool advanceLevel=false;

  BasicCircleMemory(canvasWidth,canvasHeight): super(canvasWidth,canvasHeight,3,2);

  @override
  void createGeoObjects() {
    this.circles=new List();
    double lineLength=canvasWidth/objectsNumber;
    lineLength=(lineLength);
    double yy=lineLength/2;
    List<int> pobarvani=new List();
    for(int i=0;i<mustBeClicked;i++){
      pobarvani.add(1);
    }
    for(int o=0;o<objectsNumber*objectsNumber-mustBeClicked;o++){
      pobarvani.add(0);
    }
    pobarvani.shuffle();
    int ii=0;
    for(int i=0;i<objectsNumber;i++){
      double xx=lineLength/2;
      for(int j=0;j<objectsNumber;j++){
        Circle c=new Circle(xx,yy,lineLength/2,pobarvani[ii]);
        circles.add(c);
        xx+=lineLength;
        ii+=1;
      }
      yy+=lineLength;
    }
  }

  @override
  void drawObjects(Canvas canvas) {
    Paint paint=new Paint();
    paint.color=Colors.lightBlue;
    Rect rect=Rect.fromLTRB(0, 0, canvasWidth, canvasWidth);
    canvas.drawRect(rect, paint);
    for(Circle circle in circles){
      circle.draw(canvas);
    }
  }

  @override
  int touch(Offset point) {
    //0 pomeni ni dotika
    //1 pomeni dotik prave
    //-1 pomeni dotik napacne
    int t = 0;
    if (work) {
      for (int i = 0; i < circles.length; i++) {
        if (circles[i].touch(point.dx, point.dy)) {
          if (circles[i].state==2) {
            circles[i].state+=1;
            t += 1;
          }
          else if(circles[i].state==0){
            t -= 1;
          }
          break;
        }
      }
    }
    return t;
  }

  @override
  void hideGeoObjects() {
    for(Circle circle in circles){
      circle.hide();
    }

  }

  @override
  bool prepareForNextLevel() {
    bool nextLevel=false;
    if (objectsClicked == mustBeClicked) {
      nextLevel=true;
      points += 200;
      objectsClicked=0;
      countDownOriginal+=100;
      countDown=countDownOriginal;
      if(advanceLevel){
        objectsNumber += 1;
      }
      advanceLevel=!advanceLevel;
      mustBeClicked += 1;
      createGeoObjects();
    }
    return nextLevel;
  }

  @override
  void looseLife() {
    countDownOriginal+=100;
    countDown=countDownOriginal;
    lives -= 1;
    if(objectsNumber>3) {
      objectsNumber -= 1;
      if(mustBeClicked>3) {
        mustBeClicked -= 2;
      }
    }
    if(objectsNumber==3){
      mustBeClicked=2;
    }
    objectsClicked=0;
    advanceLevel=false;
  }
}

class Circle extends GeoObject{

  double x;
  double y;
  double radius;
  //0 je ne pobarvan
  //1 je pobarvan
  //2 je pobarvan ampak skrit
  //3 je pobarvan najden
  int state;

  Circle(this.x,this.y,this.radius ,this.state);

  @override
  void draw(Canvas canvas) {
    Paint paint=new Paint();
    if(state==1){
      paint.color=Colors.red;
    }
    else if(state==3){
      paint.color=Colors.yellow;
    }
    else{
      paint.color=Colors.black26;
    }
    canvas.drawCircle(new Offset(x, y), radius, paint);
  }
  @override
  bool touch(double dx, double dy) {
    if((x-dx)*(x-dx)+(y-dy)*(y-dy)<radius*radius){
      return true;
    }
    else{
      return false;
    }
  }
  @override
  void hide() {
    if(state==1){
      state=2;
    }
  }
}



