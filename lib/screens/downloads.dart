import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:objectdb/objectdb.dart';
import 'package:path_provider/path_provider.dart';

class DownloadsPage extends StatefulWidget {
  @override
  _DownloadsPageState createState() => _DownloadsPageState();
}

class _DownloadsPageState extends State<DownloadsPage> {
  Timer updateTimer;
  List dlList;
  Directory docDirector;

  @override
  void initState() {
    super.initState();

    init();
  }

  init() async {
    docDirector = await getApplicationDocumentsDirectory();

    updateDownloadDBCache();

    updateTimer = Timer.periodic(Duration(seconds: 1), (t) {
      updateDownloadDBCache();
    });
  }

  updateDownloadDBCache() async {
    final db = ObjectDB(docDirector.path + "/download_00.db");
    await db.open();

    List list = await db.find({});
    print(list.toString());

    setState(() {
      dlList = list;
    });

    // await db.remove({"progress.section": "1"});

    await db.close();
  }

  @override
  void dispose() async {
    destroy();

    super.dispose();
  }

  destroy() async {
    updateTimer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 16.0),
              Text(
                "Downloads",
                style: GoogleFonts.playfairDisplay(
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 32.0,
                  ),
                ),
              ),
              SizedBox(
                height: 16.0,
              ),
              Expanded(
                child: Container(
                  child: ListView(
                    shrinkWrap: true,
                    children: List.generate(
                      dlList.length,
                      (i) => Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: CachedNetworkImage(
                                imageUrl: dlList[i]['book']['cover'],
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
                                      width: MediaQuery.of(context).size.width -
                                          128,
                                      child: Text(
                                        dlList[i]['book']['title'],
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
                                  dlList[i]['progress']['status'],
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.5),
                                    fontSize: 14.0,
                                  ),
                                ),
                                // Text(
                                //   "Length - ${audioData.totalTime}",
                                //   style: TextStyle(
                                //     color: Colors.white.withOpacity(0.5),
                                //     fontSize: 14.0,
                                //   ),
                                // ),
                              ],
                            ),
                            Spacer(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
