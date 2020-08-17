import 'package:flutter/material.dart';
import '../logic.dart';


class BasicSquareMemory extends MemoryGame{

  List<Square> squares=new List();

  bool advanceLevel=false;

  BasicSquareMemory(canvasWidth,canvasHeight): super(canvasWidth,canvasHeight,3,2);

  @override
  void createGeoObjects() {



    this.squares=new List();
    double lineLength=canvasWidth/objectsNumber;
    double xx=0;
    double yy=0;
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
      xx=0;
      for(int j=0;j<objectsNumber;j++){
        Square k=new Square(xx,yy,lineLength,pobarvani[ii]);
        squares.add(k);
        xx+=lineLength;
        ii+=1;
      }
      yy+=lineLength;
    }
  }

  @override
  void drawObjects(Canvas canvas) {
    for(Square square in squares){
      square.draw(canvas);
    }
  }

  @override
  int touch(Offset point) {
    //0 pomeni ni dotika
    //1 pomeni dotik prave
    //-1 pomeni dotik napacne
    int t = 0;
    if (work) {
      for (int i = 0; i < squares.length; i++) {
        if (squares[i].touch(point.dx, point.dy)) {
          if (squares[i].state==2) {
            squares[i].state+=1;
            t += 1;
          }
          else if(squares[i].state==0){
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
    for(Square square in squares){
      square.hide();
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
      if(mustBeClicked==3 && advanceLevel){
        mustBeClicked-=1;
      }
    }
    if(objectsNumber==3){
      mustBeClicked=2;
    }
    objectsClicked=0;
    advanceLevel=false;
  }
  }


class Square extends GeoObject{

  double x;
  double y;
  double width;
  //0 je ne pobarvan
  //1 je pobarvan
  //2 je pobarvan ampak skrit
  //3 je pobarvan najden
  int state;

  Square(this.x,this.y,this.width ,this.state);

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
    //Rect rect=Rect.fromLTRB(x, y, x+width, y+width);
    Offset p1=new Offset(x,y);
    Offset p2=new Offset(x+width,y);
    Offset p3=new Offset(x+width,y+width);
    Offset p4=new Offset(x,y+width);
    Path path=new Path();
    path.moveTo(x, y);
    path.lineTo(x+width,y);
    path.lineTo(x+width,y+width);
    path.lineTo(x,y+width);
    path.lineTo(x, y);
    path.close();
    paint.style=PaintingStyle.fill;
    canvas.drawPath(path, paint);
    //canvas.drawRect(rect, paint);
    paint.color=Colors.black;
    canvas.drawLine(p1, p2, paint);
    canvas.drawLine(p2, p3, paint);
    canvas.drawLine(p3, p4, paint);
    canvas.drawLine(p4, p1, paint);
  }
  @override
  bool touch(double dx, double dy) {
    if((x<dx)&&(dx<(x+width))&&(y<dy)&&(dy<(y+width))){
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



