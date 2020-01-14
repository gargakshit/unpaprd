import 'package:flutter/material.dart';
import 'package:unpaprd/api/feed.dart';
import 'package:unpaprd/components/bookItem.dart';
import 'package:unpaprd/models/feed.dart';
import 'package:google_fonts/google_fonts.dart';

class ExplorePage extends StatefulWidget {
  final Function navigate;

  ExplorePage({this.navigate});

  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage>
    with SingleTickerProviderStateMixin {
  Future<AudiobookShortList> feed;
  Future<AudiobookShortList> lifi;
  Future<AudiobookShortList> romance;
  Future<AudiobookShortList> plays;
  Future<AudiobookShortList> scifi;
  Future<AudiobookShortList> poetry;
  Future<AudiobookShortList> satire;

  TabController controller;

  @override
  void dispose() {
    super.dispose();

    controller.dispose();
  }

  @override
  void initState() {
    super.initState();

    controller = TabController(length: 7, vsync: this);

    feed =
        fetchFeed("https://unpaprdapi.gargakshit.now.sh/api/feed", limit: 10);
    lifi = fetchFeed("https://unpaprdapi.gargakshit.now.sh/api/genres/lifi",
        limit: 10);
    romance = fetchFeed(
        "https://unpaprdapi.gargakshit.now.sh/api/genres/romance",
        limit: 10);
    plays = fetchFeed("https://unpaprdapi.gargakshit.now.sh/api/genres/plays",
        limit: 10);
    scifi = fetchFeed("https://unpaprdapi.gargakshit.now.sh/api/genres/scifi",
        limit: 10);
    poetry = fetchFeed("https://unpaprdapi.gargakshit.now.sh/api/genres/poetry",
        limit: 10);
    satire = fetchFeed("https://unpaprdapi.gargakshit.now.sh/api/genres/satire",
        limit: 10);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                TabBar(
                  controller: controller,
                  isScrollable: true,
                  tabs: [
                    Tab(
                      text: "Random",
                    ),
                    Tab(
                      text: "Literary Fiction",
                    ),
                    Tab(
                      text: "Romance",
                    ),
                    Tab(
                      text: "Plays",
                    ),
                    Tab(
                      text: "Science Fiction",
                    ),
                    Tab(
                      text: "Poetry",
                    ),
                    Tab(
                      text: "Satire",
                    ),
                  ],
                ),
                SizedBox(
                  height: 16.0,
                ),
                Expanded(
                  child: TabBarView(
                    controller: controller,
                    children: <Widget>[
                      FutureBuilder<AudiobookShortList>(
                        future: feed,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return ListView(
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
                            return Center(
                              child: Text(
                                "Error fetching data, please refresh",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                ),
                              ),
                            );
                          }
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      ),
                      FutureBuilder<AudiobookShortList>(
                        future: lifi,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return ListView(
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
                            return Center(
                              child: Text(
                                "Error fetching data, please refresh",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                ),
                              ),
                            );
                          }
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      ),
                      FutureBuilder<AudiobookShortList>(
                        future: romance,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return ListView(
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
                            return Center(
                              child: Text(
                                "Error fetching data, please refresh",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                ),
                              ),
                            );
                          }
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      ),
                      FutureBuilder<AudiobookShortList>(
                        future: plays,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return ListView(
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
                            return Center(
                              child: Text(
                                "Error fetching data, please refresh",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                ),
                              ),
                            );
                          }
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      ),
                      FutureBuilder<AudiobookShortList>(
                        future: scifi,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return ListView(
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
                            return Center(
                              child: Text(
                                "Error fetching data, please refresh",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                ),
                              ),
                            );
                          }
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      ),
                      FutureBuilder<AudiobookShortList>(
                        future: poetry,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return ListView(
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
                            return Center(
                              child: Text(
                                "Error fetching data, please refresh",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                ),
                              ),
                            );
                          }
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      ),
                      FutureBuilder<AudiobookShortList>(
                        future: satire,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return ListView(
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
                            return Center(
                              child: Text(
                                "Error fetching data, please refresh",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                ),
                              ),
                            );
                          }
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 8.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
