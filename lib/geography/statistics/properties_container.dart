import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../main.dart';
import '../constants.dart';

Container gamePropertiesContainer(
    List<GameConstantInstance> gameProperties, BuildContext context) {
  double c_width = MediaQuery.of(context).size.width;
  double c_height = MediaQuery.of(context).size.height;

  return Container(
      color: Color(hexColor('#B7D7DA')),
      child: Container(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: c_height*0.6,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: gameProperties.length,
                itemBuilder: (context, index) {
                  GameConstantInstance gci = gameProperties[index];
                  return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          padding: new EdgeInsets.only(left: c_width / 6,top: 10,bottom: 10),
                          width: c_width / 2,
                          child: Text('${gci.type}:',
                              style: TextStyle(
                                  color: Color(hexColor('#0E629B')),
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold)),
                        ),
                        Container(
                          padding: new EdgeInsets.only(left: c_width / 6,top: 10,bottom: 10),
                          width: c_width / 2,
                          child: Text('${gci.value}',
                              style: TextStyle(
                                  color: Color(hexColor('#0E629B')),
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ]);
                },
              ),
            ),
            Container(
              padding: new EdgeInsets.only(top:20, left: 160),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                color: Color(hexColor('#0E629B')),
                child: Text(
                  'PLAY AGAIN',
                  style: TextStyle(color: Color(hexColor('#B7D7DA'))),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),














          ],
        ),
      ));
}
