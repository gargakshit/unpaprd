import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:objectdb/objectdb.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:unpaprd/models/audiobook_short.dart';
import 'package:unpaprd/screens/reader.dart';
import 'package:unpaprd/state/playerState.dart';

class BookItem extends StatelessWidget {
  final AudiobookShort audioData;
  final Function navigate;

  BookItem({this.audioData, this.navigate});

  @override
  Widget build(BuildContext context) {
    final PlayerStore playerState = Provider.of<PlayerStore>(context);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        showModalBottomSheet(
          context: context,
          builder: (ctx) => Container(
            child: Wrap(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 12.0,
                  ),
                  child: Row(
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: CachedNetworkImage(
                          imageUrl:
                              "https://unpaprdapi.gargakshit.now.sh/api/cover?name=${audioData.title.replaceAll(" ", "%20")}",
                          height: 70.0,
                          width: 70.0,
                          placeholder: (context, url) => Container(
                            width: 70.0,
                            height: 70.0,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            width: 70.0,
                            height: 70.0,
                            child: Center(
                              child: Icon(Icons.error),
                            ),
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 16.0),
                      Container(
                        width: MediaQuery.of(context).size.width - 128,
                        child: Text(
                          audioData.title,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 17.0,
                            ),
                          ),
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                ),
                ListTile(
                  leading: Icon(Feather.download),
                  title: Text(
                    "Download",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onTap: () async {
                    Directory docDirector =
                        await getApplicationDocumentsDirectory();
                    final db = ObjectDB(docDirector.path + "/download_00.db");
                    await db.open();

                    if ((await db.find({"book.id": audioData.id})).length > 0) {
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text("Download already Queued!"),
                      ));
                    } else {
                      await db.insert({
                        "book": {
                          "id": audioData.id,
                          "cover":
                              "https://unpaprdapi.gargakshit.now.sh/api/cover?name=${audioData.title.replaceAll(" ", "%20")}",
                          "title": audioData.title,
                          "numSections": audioData.numSections,
                        },
                        "progress": {
                          "status": "Pending",
                          "section": "1",
                          "progress": 0,
                        }
                      });

                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text("Download Queued!"),
                      ));
                    }

                    await db.tidy();

                    Navigator.of(ctx).pop();
                    await db.close();
                  },
                ),
                ListTile(
                  leading: Icon(Feather.play),
                  title: Text(
                    "Stream",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(ctx).pop();

                    if (playerState.id != int.parse(audioData.id)) {
                      playerState.play(int.parse(audioData.id));
                    }
                    navigate();
                  },
                ),
                ListTile(
                  leading: Icon(Feather.book),
                  title: Text(
                    "Read (Experimental)",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(ctx).pop();

                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ReaderPage(
                          name: audioData.title,
                          night: false,
                        ),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Feather.save),
                  title: Text(
                    "Save for later",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(ctx).pop();

                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ReaderPage(
                          name: audioData.title,
                          night: false,
                        ),
                      ),
                    );
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
      child: Padding(
        padding: const EdgeInsets.only(bottom: 26.0),
        child: Row(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: CachedNetworkImage(
                imageUrl:
                    "https://unpaprdapi.gargakshit.now.sh/api/cover?name=${audioData.title.replaceAll(" ", "%20")}",
                height: 70.0,
                width: 70.0,
                placeholder: (context, url) => Container(
                  width: 70.0,
                  height: 70.0,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  width: 70.0,
                  height: 70.0,
                  child: Center(
                    child: Icon(Icons.error),
                  ),
                ),
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 16.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width - 128,
                      child: Text(
                        audioData.title,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 17.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  "${audioData.numSections} sections - ${audioData.language}",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 14.0,
                  ),
                ),
                Text(
                  "Length - ${audioData.totalTime}",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 14.0,
                  ),
                ),
              ],
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
