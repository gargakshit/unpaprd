import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';

import '../api/data.dart';

var blueColor = Color(0xFF090e42);
var pinkColor = Color(0xFFff6b80);

class PlayerPage extends StatefulWidget {
  final AudioData audioData;

  PlayerPage({@required this.audioData});

  @override
  _PlayerPageState createState() => _PlayerPageState(audioData);
}

class _PlayerPageState extends State<PlayerPage> {
  _PlayerPageState(AudioData audioData);
  bool isPlaying = true;
  int chap = 1;
  double pos = 0;
  Duration p;
  double duration = 0;
  Duration d;

  StreamSubscription durSub;
  StreamSubscription posSub;
  StreamSubscription comSub;

  AudioPlayer audioPlayer = AudioPlayer();

  play(String url, int c) async {
    setState(() {
      isPlaying = true;
      chap = c;
    });
    await audioPlayer.play(url);
  }

  @override
  void dispose() {
    super.dispose();

    stopPlayer();
    durSub?.cancel();
    posSub?.cancel();
    comSub?.cancel();
  }

  stopPlayer() async {
    await audioPlayer.stop();
  }

  @override
  void initState() {
    super.initState();

    initPlayer();
  }

  initPlayer() {
    play(widget.audioData.audio[chap - 1].toString(), 1);

    durSub = audioPlayer.onDurationChanged.listen((Duration d) {
      setState(() {
        duration = d.inMilliseconds.toDouble();
        this.d = d;
      });
    });

    posSub = audioPlayer.onAudioPositionChanged.listen((Duration d) {
      setState(() {
        pos = d.inMilliseconds.toDouble();
        p = d;
      });
    });

    comSub = audioPlayer.onPlayerCompletion.listen((e) {
      setState(() {
        chap = (chap) == widget.audioData.audio.length ? 1 : chap + 1;
      });

      play(widget.audioData.audio[chap - 1], chap);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 500.0,
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(widget.audioData.img),
                        fit: BoxFit.cover),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [blueColor.withOpacity(0.4), blueColor],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 52.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(50.0)),
                              child: Icon(
                                Icons.arrow_drop_down,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Column(
                            children: <Widget>[
                              Text(
                                'PLAYER',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.6),
                                  fontSize: 12.0,
                                ),
                              ),
                              Text(
                                'The Unpaprd.',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.0,
                                ),
                              ),
                            ],
                          ),
                          Icon(
                            Icons.playlist_add,
                            color: Colors.white,
                          )
                        ],
                      ),
                      Spacer(),
                      Text(
                        widget.audioData.name,
                        style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 24.0,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 6.0,
                      ),
                      Text(
                        "Chapter $chap",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 16.0,
                        ),
                      ),
                      SizedBox(height: 16.0),
                    ],
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 42.0),
          Slider(
            value:
                (pos != null && duration != null && pos > 0 && pos < duration)
                    ? pos / duration
                    : 0,
            onChanged: (v) {
              double position = v * duration;
              audioPlayer.seek(Duration(milliseconds: position.round()));
            },
            activeColor: pinkColor,
          ),
          (d != null && p != null)
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "${p.inHours}:${p.inMinutes.remainder(60)}:${(p.inSeconds.remainder(60))}",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                      Text(
                        "${d.inHours}:${d.inMinutes.remainder(60)}:${(d.inSeconds.remainder(60))}",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                        ),
                      )
                    ],
                  ),
                )
              : Center(
                  child: CircularProgressIndicator(),
                ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.fast_rewind,
                  size: 32.0,
                ),
                onPressed: () {
                  audioPlayer.seek(
                    Duration(
                      milliseconds: (pos >= 5000 ? pos - 5000 : pos).toInt(),
                    ),
                  );
                },
              ),
              SizedBox(width: 32.0),
              GestureDetector(
                onTap: () {
                  if (isPlaying) {
                    audioPlayer.pause();
                  } else {
                    audioPlayer.resume();
                  }
                  setState(() {
                    isPlaying = !isPlaying;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: pinkColor,
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow,
                      size: 38.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 32.0),
              IconButton(
                icon: Icon(
                  Icons.fast_forward,
                  size: 32.0,
                ),
                onPressed: () {
                  audioPlayer.seek(
                    Duration(
                      milliseconds: (pos + 5000).toInt(),
                    ),
                  );
                },
              ),
            ],
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.keyboard_arrow_left,
                  size: 32.0,
                ),
                onPressed: chap == 1
                    ? null
                    : () {
                        setState(() {
                          chap--;
                        });

                        audioPlayer.stop();

                        play(widget.audioData.audio[chap - 1], chap);
                      },
              ),
              IconButton(
                icon: Icon(
                  Icons.keyboard_arrow_right,
                  size: 32.0,
                ),
                onPressed: chap == widget.audioData.audio.length
                    ? null
                    : () {
                        setState(() {
                          chap++;
                        });

                        audioPlayer.stop();

                        play(widget.audioData.audio[chap - 1], chap);
                      },
              ),
            ],
          ),
          SizedBox(height: 58.0),
        ],
      ),
    );
  }
}
