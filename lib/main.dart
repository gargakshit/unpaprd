import 'package:flutter/material.dart';
import 'package:unpaprd/screens/home.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(MyApp());

var blueColor = Color(0xFF090e42);
var pinkColor = Color(0xFFff6b80);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        backgroundColor: blueColor,
        canvasColor: blueColor,
        textTheme: GoogleFonts.montserratTextTheme(
          Theme.of(context).textTheme,
        ),
        accentColor: pinkColor,
      ),
      home: HomePage(),
    );
  }
}
