import 'dart:async';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:objectdb/objectdb.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unpaprd/models/audio.dart';
import 'package:unpaprd/models/audiobook_full.dart';
import 'package:http/http.dart';
import 'package:unpaprd/state/playerState.dart';

class PlayerCompomemt extends StatefulWidget {
  final AudiobookFull book;
  final BuildContext globalContext;

  PlayerCompomemt({this.book, this.globalContext});

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
  bool firstLoad = true;
  bool requiresSeek = false;
  Duration seekTo;

  StreamSubscription durationSubscription;
  StreamSubscription positionSubscription;
  StreamSubscription completionSubscription;
  StreamSubscription stateSubscription;
  StreamSubscription errorSubscription;

  SharedPreferences preferences;

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

      seekToSaved();
      seekIfRequired();
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

      updateSharedPrefs();

      if (firstLoad) {
        setState(() {
          firstLoad = false;
        });
      }
    });

    initPrefs();
  }

  seekIfRequired() {
    if (requiresSeek) {
      print(seekTo.toString());
      audioPlayer.seek(seekTo);

      setState(() {
        requiresSeek = false;
      });
    }
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

  seekToSaved() {
    if (firstLoad) {
      List<String> data = preferences.getStringList(widget.book.id);

      if (data != null) {
        audioPlayer.seek(
          Duration(
            seconds: int.parse(data[1]),
            minutes: int.parse(data[2]),
            hours: int.parse(data[3]),
          ),
        );
      }
    }
  }

  initPrefs() async {
    preferences = await SharedPreferences.getInstance();

    List<String> data = preferences.getStringList(widget.book.id);

    if (data != null) {
      setState(() {
        currentSection = int.parse(data[0]);
      });
    }

    play();
  }

  updateSharedPrefs() async {
    if (duration != null && position != null) {
      await preferences.setStringList(widget.book.id, [
        currentSection.toString(),
        position.inSeconds.toString(),
        position.inMinutes.toString(),
        position.inHours.toString(),
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<PlayerStore>(context);

    return Observer(
      builder: (_) => !complete
          ? OrientationBuilder(
              builder: (ctx, orientation) => SafeArea(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: CachedNetworkImage(
                              imageUrl:
                                  "https://unpaprdapi.gargakshit.now.sh/api/cover?name=${widget.book.title}",
                              height: orientation == Orientation.landscape
                                  ? 140
                                  : 200,
                              width: orientation == Orientation.landscape
                                  ? 105
                                  : 130,
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(
                            width: 16.0,
                          ),
                          SizedBox(
                            height: orientation == Orientation.landscape
                                ? 140
                                : 200,
                            width: MediaQuery.of(context).size.width -
                                (orientation == Orientation.landscape
                                    ? 503
                                    : 178),
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
                                  "${widget.book.numSections} sections",
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
                          SizedBox(
                            width:
                                orientation == Orientation.landscape ? 25 : 0,
                          ),
                          SizedBox(
                            height: orientation == Orientation.landscape
                                ? 140
                                : 200,
                            width:
                                orientation == Orientation.landscape ? 325 : 0,
                            child: orientation == Orientation.landscape
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        widget.book.title,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.playfairDisplay(
                                          textStyle: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w900,
                                            fontSize: 36.0,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 14,
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
                                    ],
                                  )
                                : Container(),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: orientation == Orientation.landscape ? 8 : 24,
                      ),
                      orientation == Orientation.landscape
                          ? Container(
                              width: 0,
                              height: 0,
                            )
                          : Expanded(
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 200),
                                padding: EdgeInsets.only(
                                  left: 16,
                                  right: 16,
                                ),
                                child: ListView(
                                  children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        Text(
                                          widget.book.title,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.playfairDisplay(
                                            textStyle: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w900,
                                              fontSize: 36.0,
                                            ),
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(
                                          height: 14,
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
                                      ],
                                    ),
                                    SizedBox(
                                      height: 16,
                                    ),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          position.toString().substring(0,
                                              position.toString().length - 7),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14.0,
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(),
                                        ),
                                        Text(
                                          duration.toString().substring(0,
                                              duration.toString().length - 7),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: orientation == Orientation.landscape
                                        ? 8
                                        : 24,
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
                                              milliseconds: (position
                                                          .inMilliseconds <
                                                      (state.seekTime * 1000)
                                                  ? 0
                                                  : position.inMilliseconds -
                                                      (state.seekTime * 1000)),
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
                                            onPressed: () =>
                                                audioPlayer.resume(),
                                          ),
                                          secondChild: IconButton(
                                            icon: Icon(Icons.pause),
                                            onPressed: () =>
                                                audioPlayer.pause(),
                                          ),
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.rotate_right),
                                          onPressed: () => audioPlayer.seek(
                                            Duration(
                                              milliseconds: (duration
                                                              .inMilliseconds -
                                                          position
                                                              .inMilliseconds <
                                                      (state.seekTime * 1000)
                                                  ? duration.inMilliseconds
                                                  : position.inMilliseconds +
                                                      (state.seekTime * 1000)),
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          icon:
                                              Icon(Icons.keyboard_arrow_right),
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
                                        IconButton(
                                          icon: Icon(Icons.bookmark_border),
                                          onPressed: () async {
                                            Directory dbPath =
                                                await getApplicationDocumentsDirectory();
                                            final db = ObjectDB(dbPath.path +
                                                "/bookmarks__03.db");
                                            await db.open();

                                            var results = await db
                                                .find({"id": widget.book.id});

                                            showBottomSheet(
                                              context: context,
                                              builder: (context) => Container(
                                                child: Wrap(
                                                  children: List.generate(
                                                      results.length + 2,
                                                      (index) {
                                                    if (index == 0) {
                                                      return ListTile(
                                                        leading: Icon(
                                                          Icons.add,
                                                        ),
                                                        title: Text(
                                                          "Save current position",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                        onTap: () async {
                                                          await db.insert(
                                                            {
                                                              "id": widget
                                                                  .book.id,
                                                              "position":
                                                                  position
                                                                      .toString()
                                                                      .substring(
                                                                        0,
                                                                        position.toString().length -
                                                                            7,
                                                                      ),
                                                              "section":
                                                                  currentSection
                                                                      .toString(),
                                                            },
                                                          );

                                                          db.tidy();
                                                          await db.close();
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      );
                                                    } else if (index !=
                                                        results.length + 1) {
                                                      var res =
                                                          results[index - 1];

                                                      return ListTile(
                                                        title: Text(
                                                          "${widget.book.audio[int.parse(res["section"])].title} - ${res["position"]}",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                        onTap: () async {
                                                          setState(() {
                                                            currentSection =
                                                                int.parse(
                                                              res["section"],
                                                            );
                                                          });

                                                          Navigator.of(context)
                                                              .pop();

                                                          audioPlayer.pause();

                                                          await play();

                                                          final stringSlice =
                                                              res["position"]
                                                                  .split(":");

                                                          setState(() {
                                                            requiresSeek = true;

                                                            seekTo = Duration(
                                                              hours: int.parse(
                                                                stringSlice[0],
                                                              ),
                                                              minutes:
                                                                  int.parse(
                                                                stringSlice[1],
                                                              ),
                                                              seconds:
                                                                  int.parse(
                                                                stringSlice[2],
                                                              ),
                                                            );
                                                          });

                                                          db.tidy();
                                                          await db.close();
                                                        },
                                                      );
                                                    } else {
                                                      return ListTile(
                                                        leading: Icon(
                                                          Feather.x,
                                                        ),
                                                        title: Text(
                                                          "Cancel",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                        onTap: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      );
                                                    }
                                                  }),
                                                ),
                                              ),
                                            );
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
                        height: orientation == Orientation.landscape ? 0 : 16,
                      ),
                    ],
                  ),
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
