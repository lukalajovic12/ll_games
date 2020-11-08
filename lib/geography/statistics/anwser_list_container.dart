import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../main.dart';
import '../country_capital_table.dart';
import '../geo.dart';

Container anwserListContainer(List<Anwser> lastGameAnwsers,BuildContext context) {
  double c_width = MediaQuery.of(context).size.width;
  return Container(
      color: Color(hexColor('#B7D7DA')),
      child: ListView.builder(
        itemCount: lastGameAnwsers.length,
        itemBuilder: (context, index) {
          Anwser anwser = lastGameAnwsers[index];
          return Column(
            children: <Widget>[
              Row(children: <Widget>[
                Container(
                  width: c_width,
                  padding: new EdgeInsets.only(top: 10, bottom: 10),
                  child: Text('${index+1}. ${anwser.question}',
                      style: TextStyle(
                          color: Color(hexColor('#0E629B')),
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold)),
                ),
              ]),
              Row(
                //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      width: c_width/2,
                      child: Text('Correct anwser:',
                          style: TextStyle(
                              color: Color(hexColor('#0E629B')),
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold)),
                    ),
                    Container(
                      width: c_width/2,
                      child: Text(anwser.correctAnwser,
                          style: TextStyle(
                              color: Color(hexColor('#0E629B')),
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold)),
                    ),
                  ]),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      width: c_width/2,
                      child: Text('Anwsered:',
                          style: TextStyle(
                              color: Color(hexColor('#0E629B')),
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold)),
                    ),
                    Container(
                      width: c_width/2,
                      child: Text(anwser.anwser,
                          style: TextStyle(
                              color: anwserCollor(anwser),
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold)),
                    ),
                  ]),
              Row(
                  children: <Widget>[
                    Container(
                      width: c_width/3,
                      child: Text('Wikipedia:',
                          style: TextStyle(
                              color: Color(hexColor('#0E629B')),
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold)),
                    ),
                    Container(
                      width: c_width/2,
                      child: IconButton(
                        color: Color(hexColor('#0E629B')),
                        icon: Icon(FontAwesomeIcons.wikipediaW),
                        onPressed: () {
                          goToWikipedia(anwser.correctAnwser);
                        },
                      ),
                    ),
                  ]),
              Row(
                  children: <Widget>[
                    Container(
                      width: c_width/3,
                      child: Text('Google Maps:',
                          style: TextStyle(
                              color: Color(hexColor('#0E629B')),
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold)),
                    ),
                    Container(
                      width: c_width/2,
                      child: IconButton(
                        color: Color(hexColor('#0E629B')),
                        icon: Icon(FontAwesomeIcons.mapMarker),
                        onPressed: () {
                          goToGoogleMaps(anwser.correctAnwser);
                        },
                      ),
                    ),
                  ]),
              Row(
                  children: <Widget>[
                    Container(
                      width: c_width/3,
                      child: Text('Britanica:',
                          style: TextStyle(
                              color: Color(hexColor('#0E629B')),
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold)),
                    ),
                    Container(
                      width: c_width/2,
                      child: IconButton(
                        color: Color(hexColor('#0E629B')),
                        icon: Icon(FontAwesomeIcons.book),
                        onPressed: () {
                          goToBritanica(anwser.correctAnwser);
                        },
                      ),
                    ),
                  ]),
            ],
          );
        },
      ));
}


Color anwserCollor(Anwser a) {
  if (a.anwser == 'Skipped') {
    return Colors.purple;
  } else if (a.correctAnwser == a.anwser) {
    return Colors.green;
  } else {
    return Colors.red;
  }
}