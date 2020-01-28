import 'package:flutter/material.dart';
import 'package:unpaprd/components/exploreList.dart';
import 'package:google_fonts/google_fonts.dart';

class ExplorePage extends StatefulWidget {
  final Function navigate;

  ExplorePage({this.navigate});

  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  TabController controller;

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    super.dispose();

    controller.dispose();
  }

  @override
  void initState() {
    super.initState();

    controller = TabController(length: 7, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

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
                      ExploreList(
                        url: "https://unpaprdapi.gargakshit.now.sh/api/feed",
                        navigate: widget.navigate,
                      ),
                      ExploreList(
                        url:
                            "https://unpaprdapi.gargakshit.now.sh/api/genres/lifi",
                        navigate: widget.navigate,
                      ),
                      ExploreList(
                        url:
                            "https://unpaprdapi.gargakshit.now.sh/api/genres/romance",
                        navigate: widget.navigate,
                      ),
                      ExploreList(
                        url:
                            "https://unpaprdapi.gargakshit.now.sh/api/genres/plays",
                        navigate: widget.navigate,
                      ),
                      ExploreList(
                        url:
                            "https://unpaprdapi.gargakshit.now.sh/api/genres/scifi",
                        navigate: widget.navigate,
                      ),
                      ExploreList(
                        url:
                            "https://unpaprdapi.gargakshit.now.sh/api/genres/poetry",
                        navigate: widget.navigate,
                      ),
                      ExploreList(
                        url:
                            "https://unpaprdapi.gargakshit.now.sh/api/genres/satire",
                        navigate: widget.navigate,
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
