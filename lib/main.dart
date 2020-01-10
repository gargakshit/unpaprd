import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unpaprd/screens/home.dart';
import 'package:unpaprd/state/playerState.dart';

void main() => runApp(MyApp());

var blueColor = Color(0xFF090e42);
var pinkColor = Color(0xFFff6b80);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<PlayerStore>(
      create: (ctx) => PlayerStore(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          brightness: Brightness.dark,
          backgroundColor: blueColor,
          canvasColor: blueColor,
          cursorColor: pinkColor,
          textTheme: GoogleFonts.montserratTextTheme(
            Theme.of(context).textTheme,
          ),
          accentColor: pinkColor,
        ),
        debugShowCheckedModeBanner: false,
        home: FutureBuilder<ConnectivityResult>(
          future: Connectivity().checkConnectivity(),
          builder: (ctx, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data != ConnectivityResult.mobile &&
                  snapshot.data != ConnectivityResult.wifi) {
                return Scaffold(
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "No Internet Connection",
                          style: GoogleFonts.playfairDisplay(
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 32.0,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        Text("Restart the app to re-check",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                            )),
                      ],
                    ),
                  ),
                );
              }
            }

            return HomePage();
          },
        ),
      ),
    );
  }
}
