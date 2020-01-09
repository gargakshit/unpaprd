import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unpaprd/models/audio.dart';
import 'package:unpaprd/models/audiobook_full.dart';
import 'package:http/http.dart';

class PlayerCompomemt extends StatefulWidget {
  final AudiobookFull book;

  PlayerCompomemt({this.book});

  @override
  _PlayerCompomemtState createState() => _PlayerCompomemtState();
}

class _PlayerCompomemtState extends State<PlayerCompomemt> {
  AudioPlayer audioPlayer = AudioPlayer();

  bool isPlaying = false;
  bool complete = false;
  int currentSection = 0;
  Duration duration;
  Duration position;

  StreamSubscription durationSubscription;
  StreamSubscription positionSubscription;
  StreamSubscription completionSubscription;
  StreamSubscription stateSubscription;
  StreamSubscription errorSubscription;

  @override
  void initState() {
    super.initState();

    errorSubscription = audioPlayer.onPlayerError.listen(print);

    stateSubscription =
        audioPlayer.onPlayerStateChanged.listen((AudioPlayerState state) {
      setState(() {
        isPlaying = state == AudioPlayerState.PLAYING;
      });

      print(state);
    });

    durationSubscription = audioPlayer.onDurationChanged.listen((Duration d) {
      setState(() {
        duration = d;
      });
    });

    completionSubscription = audioPlayer.onPlayerCompletion.listen((e) {
      if (currentSection + 1 == widget.book.audio.length) {
        audioPlayer.stop();
        setState(() {
          complete = true;
        });
      } else {
        audioPlayer.stop();
        setState(() {
          currentSection++;
        });

        play();
      }
    });

    positionSubscription =
        audioPlayer.onAudioPositionChanged.listen((Duration p) {
      setState(() {
        position = p;
      });
    });

    play();
  }

  play() async {
    Audio audio = widget.book.audio[currentSection];
    final buildUrl =
        "https://unpaprdapi.gargakshit.now.sh/api/getRedirected?url=${audio.url}";
    final urlReq = await get(
      buildUrl,
    );

    await audioPlayer.play(urlReq.body.replaceFirst("http", "https"));
  }

  @override
  Widget build(BuildContext context) {
    return !complete
        ? SafeArea(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: TransitionToImage(
                          height: 200.0,
                          width: 130.0,
                          image: AdvancedNetworkImage(
                            "https://unpaprdapi.gargakshit.now.sh/api/cover?name=${widget.book.title}",
                            useDiskCache: true,
                            loadFailedCallback: () {
                              print("loading failed...");
                            },
                            cacheRule: CacheRule(
                              maxAge: Duration(days: 30),
                            ),
                          ),
                          placeholder: Container(
                            width: 70.0,
                            height: 70.0,
                            child: Center(
                              child: Icon(Icons.close),
                            ),
                          ),
                          loadingWidgetBuilder: (_, double progress, __) =>
                              Container(
                            width: 70.0,
                            height: 70.0,
                            child: Center(
                              child: progress == 0
                                  ? CircularProgressIndicator()
                                  : CircularProgressIndicator(
                                      value: progress,
                                    ),
                            ),
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(
                        width: 16.0,
                      ),
                      SizedBox(
                        height: 200,
                        width: MediaQuery.of(context).size.width - 178,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              height: 16.0,
                            ),
                            Text(
                              "by",
                              style: TextStyle(
                                color: Colors.white70,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "${widget.book.authors[0].fName} ${widget.book.authors[0].lName}",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.playfairDisplay(
                                textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28.0,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    width: 1,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(),
                            ),
                            Text(
                              "${widget.book.numSections} chapters",
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14.0,
                              ),
                            ),
                            Text(
                              "${widget.book.language}",
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.right,
                              style: GoogleFonts.playfairDisplay(
                                textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  Text(
                    widget.book.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.playfairDisplay(
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 36.0,
                      ),
                    ),
                  ),
                  Text(
                    "${widget.book.audio[currentSection].title}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Expanded(
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      padding: EdgeInsets.only(
                        left: 16,
                        right: 16,
                      ),
                      child: ListView(
                        children: <Widget>[
                          Text(
                            widget.book.description,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            maxLines: 1000,
                            textAlign: TextAlign.left,
                          )
                        ],
                      ),
                    ),
                  ),
                  (duration != null && position != null)
                      ? Container(
                          child: Column(
                            children: <Widget>[
                              Slider(
                                onChanged: (val) => audioPlayer.seek(
                                  Duration(
                                      milliseconds:
                                          (val * duration.inMilliseconds)
                                              .round()),
                                ),
                                value: position.inMilliseconds /
                                    duration.inMilliseconds,
                                activeColor: Colors.white,
                                inactiveColor: Colors.white24,
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 24,
                                  right: 24,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      position.toString().substring(
                                          0, position.toString().length - 7),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14.0,
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(),
                                    ),
                                    Text(
                                      duration.toString().substring(
                                          0, duration.toString().length - 7),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 24,
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 24,
                                  right: 24,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    IconButton(
                                      icon: Icon(Icons.keyboard_arrow_left),
                                      onPressed: currentSection == 0
                                          ? null
                                          : () {
                                              setState(() {
                                                currentSection--;
                                              });

                                              play();
                                            },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.rotate_left),
                                      onPressed: () => audioPlayer.seek(
                                        Duration(
                                          milliseconds:
                                              (position.inMilliseconds < 5000
                                                  ? 0
                                                  : position.inMilliseconds -
                                                      5000),
                                        ),
                                      ),
                                    ),
                                    AnimatedCrossFade(
                                      crossFadeState: isPlaying
                                          ? CrossFadeState.showSecond
                                          : CrossFadeState.showFirst,
                                      duration: Duration(milliseconds: 150),
                                      firstChild: IconButton(
                                        icon: Icon(Icons.play_arrow),
                                        onPressed: () => audioPlayer.resume(),
                                      ),
                                      secondChild: IconButton(
                                        icon: Icon(Icons.pause),
                                        onPressed: () => audioPlayer.pause(),
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.rotate_right),
                                      onPressed: () => audioPlayer.seek(
                                        Duration(
                                          milliseconds: (duration
                                                          .inMilliseconds -
                                                      position.inMilliseconds <
                                                  5000
                                              ? duration.inMilliseconds
                                              : position.inMilliseconds + 5000),
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.keyboard_arrow_right),
                                      onPressed: currentSection + 1 ==
                                              widget.book.audio.length
                                          ? null
                                          : () {
                                              setState(() {
                                                currentSection++;
                                              });

                                              play();
                                            },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      : Center(
                          child: CircularProgressIndicator(),
                        ),
                  SizedBox(
                    height: 16,
                  ),
                ],
              ),
            ),
          )
        : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "You completed ${widget.book.title} 🥳",
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
                  "Please select another audiobook to play",
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
          );
  }

  @override
  void dispose() {
    super.dispose();

    stopPlayer();
    durationSubscription?.cancel();
    positionSubscription?.cancel();
    completionSubscription?.cancel();
    stateSubscription?.cancel();
    errorSubscription?.cancel();
  }

  stopPlayer() async {
    await audioPlayer.release();
  }
}
