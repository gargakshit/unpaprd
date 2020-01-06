import 'package:flutter/material.dart';
import 'package:unpaprd/screens/player.dart';
import 'package:google_fonts/google_fonts.dart';

import '../api/data.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<AudioData>> audioData;

  @override
  void initState() {
    super.initState();

    audioData = getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: ListView(
            children: <Widget>[
              SizedBox(height: 32.0),
              CustomTextField(),
              SizedBox(height: 32.0),
              Text(
                'Audiobooks',
                style: GoogleFonts.montserrat(
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 32.0,
                  ),
                ),
              ),
              SizedBox(
                height: 16.0,
              ),
              FutureBuilder<List<AudioData>>(
                future: audioData,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView(
                      shrinkWrap: true,
                      children: List.generate(
                        snapshot.data.length,
                        (i) {
                          return SongItem(
                            audioData: snapshot.data[i],
                          );
                        },
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text("Error fetching data");
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.withOpacity(0.16),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 8.0,
          ),
          Icon(
            Icons.search,
            color: Colors.white,
          ),
          SizedBox(
            width: 8.0,
          ),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                  hintText: 'Search for audiobooks...',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none),
            ),
          ),
          SizedBox(
            width: 8.0,
          ),
          Icon(
            Icons.mic,
            color: Colors.white,
          ),
          SizedBox(
            width: 8.0,
          ),
        ],
      ),
    );
  }
}

class SongItem extends StatelessWidget {
  final AudioData audioData;

  SongItem({this.audioData});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlayerPage(
              audioData: audioData,
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
                Container(
                  height: 80.0,
                  width: 80.0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      audioData.img,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  height: 80.0,
                  width: 80.0,
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
                Text(
                  audioData.name,
                  style: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  "${audioData.audio.length + 1} chapters",
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
