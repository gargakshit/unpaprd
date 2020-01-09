import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:unpaprd/models/audiobook_short.dart';
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
        if (playerState.id != int.parse(audioData.id)) {
          playerState.play(int.parse(audioData.id));
        }
        navigate();
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 26.0),
        child: Row(
          children: <Widget>[
            Stack(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: TransitionToImage(
                    height: 70.0,
                    width: 70.0,
                    image: AdvancedNetworkImage(
                      "https://unpaprdapi.gargakshit.now.sh/api/cover?name=${audioData.title}",
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
                    loadingWidgetBuilder: (_, double progress, __) => Container(
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
                Container(
                  height: 70.0,
                  width: 70.0,
                  child: Icon(
                    Icons.play_circle_filled,
                    color: Colors.white.withOpacity(0.7),
                    size: 28.0,
                  ),
                )
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
                SizedBox(height: 8.0),
                Text(
                  "${audioData.numSections} chapters - ${audioData.language}",
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
