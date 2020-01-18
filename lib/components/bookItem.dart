import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            contentPadding: EdgeInsets.all(0),
            content: Container(
              height: 150,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 8),
                borderRadius: BorderRadius.circular(2),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: CachedNetworkImageProvider(
                    "https://unpaprdapi.gargakshit.now.sh/api/cover?name=${audioData.title}",
                  ),
                ),
              ),
              child: Stack(
                children: <Widget>[
                  Container(
                    color: Colors.black45,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: InkWell(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(ctx).pop();
                              if (playerState.id != int.parse(audioData.id)) {
                                playerState.play(int.parse(audioData.id));
                              }
                              navigate();
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.play_circle_outline,
                                  size: 56.0,
                                ),
                                SizedBox(
                                  height: 12.0,
                                ),
                                Text(
                                  "Play",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 72,
                        decoration: BoxDecoration(
                          border: Border(
                            left: BorderSide(
                              width: 2,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(ctx).pop();

                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (c) => ReaderPage(
                                    name: audioData.title,
                                  ),
                                ),
                              );
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.book,
                                  size: 56.0,
                                ),
                                SizedBox(
                                  height: 12.0,
                                ),
                                Text(
                                  "Read",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 26.0),
        child: Row(
          children: <Widget>[
            Stack(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: CachedNetworkImage(
                    imageUrl:
                        "https://unpaprdapi.gargakshit.now.sh/api/cover?name=${audioData.title}",
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
                Container(
                  width: 70.0,
                  height: 70.0,
                  child: Center(
                    child: Icon(Icons.play_circle_outline),
                  ),
                ),
              ],
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
