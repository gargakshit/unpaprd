import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:unpaprd/components/player.dart';
import 'package:unpaprd/state/playerState.dart';

class PlayerPage extends StatefulWidget {
  @override
  _PlayerPageState createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  @override
  Widget build(BuildContext context) {
    final PlayerStore playerState = Provider.of<PlayerStore>(context);

    return Scaffold(
      body: Observer(
        builder: (_) {
          print(playerState.id);

          if (playerState.id == 0) {
            return Center(
              child: Padding(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Nothing seems to be playing 🤔",
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "Please select an audiobook to play from the other two tabs",
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                          color: Colors.white70,
                          fontSize: 14.0,
                        ),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          } else {
            if (playerState.loading) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Please wait while we load the book for you",
                        style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      CircularProgressIndicator(),
                    ],
                  ),
                ),
              );
            }
          }

          return PlayerCompomemt(
            book: playerState.book,
          );
        },
      ),
    );
  }
}
