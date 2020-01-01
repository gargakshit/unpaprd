import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';

import '../api/data.dart';

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
            width: MediaQuery.of(context).size.width,
            height: 150,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xff5151d5),
                  Color(0xff0a3d7c),
                ],
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    "Player",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36.0,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    widget.audioData.name,
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 10.0,
                    ),
                  ),
                  Text(
                    "Chapter $chap",
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.rotate_left),
                        onPressed: () {
                          audioPlayer.seek(
                            Duration(
                              milliseconds:
                                  (pos >= 5000 ? pos - 5000 : pos).toInt(),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_left),
                        onPressed: () {
                          setState(() {
                            chap = (chap) == widget.audioData.audio.length
                                ? 1
                                : chap - 1;
                          });

                          audioPlayer.stop();

                          play(widget.audioData.audio[chap - 1], chap);
                        },
                      ),
                      IconButton(
                        icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                        onPressed: () {
                          if (isPlaying) {
                            audioPlayer.pause();
                          } else {
                            audioPlayer.resume();
                          }
                          setState(() {
                            isPlaying = !isPlaying;
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_right),
                        onPressed: () {
                          setState(() {
                            chap = (chap) == widget.audioData.audio.length
                                ? 1
                                : chap + 1;
                          });

                          audioPlayer.stop();

                          play(widget.audioData.audio[chap - 1], chap);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.rotate_right),
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
                  Slider(
                    value: (pos != null &&
                            duration != null &&
                            pos > 0 &&
                            pos < duration)
                        ? pos / duration
                        : 0,
                    onChanged: (v) {
                      double position = v * duration;
                      audioPlayer
                          .seek(Duration(milliseconds: position.round()));
                    },
                    activeColor: Color(0xff5151d5),
                    inactiveColor: Color(0x2f0a3d7c),
                  ),
                  Text(
                    pos != 0
                        ? "${p.inHours}:${p.inMinutes.remainder(60)}:${(p.inSeconds.remainder(60))} / ${d.inHours}:${d.inMinutes.remainder(60)}:${(d.inSeconds.remainder(60))}"
                        : "0:0:0 / 0:0:0",
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
