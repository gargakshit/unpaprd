import 'package:flutter/material.dart';
import 'package:unpaprd/api/feed.dart';
import 'package:unpaprd/components/bookItem.dart';
import 'package:unpaprd/models/feed.dart';
// import 'package:unpaprd/screens/player.dart';
import 'package:google_fonts/google_fonts.dart';

class ExplorePage extends StatefulWidget {
  final Function navigate;

  ExplorePage({this.navigate});

  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  Future<AudiobookShortList> feed;

  @override
  void initState() {
    super.initState();

    feed = fetchFeed(limit: 10);
  }

  Future<void> refresh() async {
    setState(() {
      feed = fetchFeed(limit: 10);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Center(
            child: RefreshIndicator(
              onRefresh: refresh,
              child: ListView(
                children: <Widget>[
                  SizedBox(height: 16.0),
                  Text(
                    "Explore",
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
                  FutureBuilder<AudiobookShortList>(
                    future: feed,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Column(
                          children: List.generate(
                            snapshot.data.books.length,
                            (i) {
                              return BookItem(
                                audioData: snapshot.data.books[i],
                                navigate: widget.navigate,
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
        ),
      ),
    );
  }
}
