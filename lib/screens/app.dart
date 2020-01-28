import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:unpaprd/state/playerState.dart';

import 'home.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = Provider.of<PlayerStore>(context);

    state.loadColors();
    state.loadSeekTime();

    return Observer(
      builder: (_) => MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          brightness: Brightness.dark,
          backgroundColor: state.bgColor,
          canvasColor: state.bgColor,
          cursorColor: state.accentColor,
          textTheme: GoogleFonts.montserratTextTheme(
            Theme.of(context).textTheme,
          ),
          accentColor: state.accentColor,
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
                        Text(
                          "Restart the app to re-check",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                          ),
                        ),
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
