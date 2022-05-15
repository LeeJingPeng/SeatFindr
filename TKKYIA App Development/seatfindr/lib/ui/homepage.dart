// ignore_for_file: prefer_const_constructors

import "package:flutter/material.dart";
import "package:seatfindr/ui/menu.dart";

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GestureDetector(
      onVerticalDragUpdate: (details) {
        if (details.delta.dy < -8) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => menu()),
          );
        }
      },
      child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
            Container(
              width: 400,
              height: 150,
              margin: const EdgeInsets.symmetric(horizontal: 10.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.white, width: 4.0),
                borderRadius: BorderRadius.all(Radius.circular(60.0)),
              ),
              child: _buildTitle(),
            ),
            _spacing(),
            _swipeUp(),
          ])),
    ));
  }
}

Widget _buildTitle() => Text(
      "SeatFindr",
      style: TextStyle(fontSize: 45, letterSpacing: 12),
      textAlign: TextAlign.center,
    );

Widget _spacing() => Text('''












''');
Widget _swipeUp() => Text(
      '''
  ^   
  ^
Swipe Up''',
      style: TextStyle(
        fontSize: 20,
        color: Colors.black87,
      ),
      textAlign: TextAlign.center,
    );
