import "package:flutter/material.dart";
import "package:seatfindr/ui/homepage.dart";

class SeatFindr extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "SeatFindr",
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.blue[200],
      ),
      home: HomePage(title: "SeatFindr"),
    );
  }
}
