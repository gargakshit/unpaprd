import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:unpaprd/state/playerState.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TextEditingController textEditingController = TextEditingController();

  @override
  void dispose() {
    textEditingController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<PlayerStore>(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 16.0),
              Text(
                "Settings",
                style: GoogleFonts.playfairDisplay(
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 32.0,
                  ),
                ),
              ),
              SizedBox(height: 24.0),
              Expanded(
                child: ListView(
                  children: <Widget>[
                    InkWell(
                      child: GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (ctx) => Container(
                              child: ListView(
                                children: <Widget>[
                                  ListTile(
                                    title: Text(
                                      "Default",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.of(ctx).pop();
                                      state.accentColor = Color(0xFFff6b80);
                                      state.bgColor = Color(0xFF000120);
                                      state.persistColors();
                                    },
                                  ),
                                  ListTile(
                                    title: Text(
                                      "Kinda Blue",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.of(ctx).pop();
                                      state.bgColor = Color(0xFF0e153a);
                                      state.accentColor = Color(0xFF22d1ee);
                                      state.persistColors();
                                    },
                                  ),
                                  ListTile(
                                    title: Text(
                                      "Pitch Black - Blue Accent",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.of(ctx).pop();
                                      state.accentColor = Color(0xFF22d1ee);
                                      state.bgColor = Color(0xFF000000);
                                      state.persistColors();
                                    },
                                  ),
                                  ListTile(
                                    title: Text(
                                      "Pitch Black - Default Accent",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.of(ctx).pop();
                                      state.accentColor = Color(0xFFff6b80);
                                      state.bgColor = Color(0xFF000000);
                                      state.persistColors();
                                    },
                                  ),
                                  ListTile(
                                    title: Text(
                                      "Palenight - yellow",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.of(ctx).pop();
                                      state.accentColor = Color(0xFFffd460);
                                      state.bgColor = Color(0xFF2d4059);
                                      state.persistColors();
                                    },
                                  ),
                                  ListTile(
                                    title: Text(
                                      "Purple nights",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.of(ctx).pop();
                                      state.accentColor = Color(0xFFffb997);
                                      state.bgColor = Color(0xFF0b032d);
                                      state.persistColors();
                                    },
                                  ),
                                  ListTile(
                                    title: Text(
                                      "Velvet",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.of(ctx).pop();
                                      state.accentColor = Color(0xFFfd0054);
                                      state.bgColor = Color(0xFF2b2024);
                                      state.persistColors();
                                    },
                                  ),
                                  ListTile(
                                    title: Text(
                                      "Pinkish Purple",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.of(ctx).pop();
                                      state.accentColor = Color(0xFFff94c7);
                                      state.bgColor = Color(0xFF343a69);
                                      state.persistColors();
                                    },
                                  ),
                                  ListTile(
                                    title: Text(
                                      "Greenish nights",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.of(ctx).pop();
                                      state.accentColor = Color(0xFF4ae3b5);
                                      state.bgColor = Color(0xFF171332);
                                      state.persistColors();
                                    },
                                  ),
                                  ListTile(
                                    leading: Icon(Feather.x),
                                    title: Text(
                                      "Cancel",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    onTap: () => Navigator.of(ctx).pop(),
                                  ),
                                  SizedBox(
                                    height: Platform.isIOS ? 72 : 0,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        child: Container(
                          height: 48.0,
                          child: Row(
                            children: <Widget>[
                              Icon(Feather.edit_3),
                              SizedBox(
                                width: 24.0,
                              ),
                              Text(
                                "Set Theme",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    InkWell(
                      child: GestureDetector(
                        onTap: () {
                          textEditingController.text =
                              state.seekTime.toString();

                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(
                                "Seek Time",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              content: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: TextField(
                                      controller: textEditingController,
                                      keyboardType: TextInputType.number,
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    "s",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              ),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text("OK"),
                                  onPressed: () {
                                    state.seekTime =
                                        int.parse(textEditingController.text);
                                    state.persistSeekTime();
                                    Navigator.of(context).pop();
                                  },
                                ),
                                FlatButton(
                                  child: Text("Cancel"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                        child: Container(
                          height: 48.0,
                          child: Row(
                            children: <Widget>[
                              Icon(Feather.fast_forward),
                              SizedBox(
                                width: 24.0,
                              ),
                              Text(
                                "Set seek time",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Center(
                child: FutureBuilder<PackageInfo>(
                  future: PackageInfo.fromPlatform(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        children: <Widget>[
                          Text(
                            "${snapshot.data.packageName}",
                            style: TextStyle(
                              color: Colors.white54,
                            ),
                          ),
                          Text(
                            "${snapshot.data.version}+${snapshot.data.buildNumber}",
                            style: TextStyle(
                              color: Colors.white38,
                              fontSize: 12.0,
                            ),
                          )
                        ],
                      );
                    }
                    return Container();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
