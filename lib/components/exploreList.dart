import 'package:flutter/material.dart';
import 'package:unpaprd/api/feed.dart';
import 'package:unpaprd/components/bookItem.dart';
import 'package:unpaprd/models/audiobook_short.dart';
import 'package:unpaprd/models/feed.dart';
import 'package:unpaprd/services/errorHandler.dart';

class ExploreList extends StatefulWidget {
  final Function navigate;
  final String url;

  ExploreList({this.url, this.navigate});

  @override
  _ExploreListState createState() => _ExploreListState();
}

class _ExploreListState extends State<ExploreList>
    with AutomaticKeepAliveClientMixin {
  List<AudiobookShort> feed = List();
  ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    fetch();

    controller.addListener(() {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        fetch();
      }
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return feed.length != 0
        ? ListView.builder(
            itemCount: feed.length + 1,
            controller: controller,
            itemBuilder: (BuildContext ctx, int index) {
              if (index != feed.length) {
                return BookItem(
                  audioData: feed[index],
                  navigate: widget.navigate,
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            })
        : Center(
            child: CircularProgressIndicator(),
          );
  }

  fetch() async {
    try {
      AudiobookShortList list = await fetchFeed(widget.url);
      list.books.forEach((AudiobookShort book) => feed.add(book));
      setState(() {});
    } catch (error, stackTrace) {
      handleError(error, stackTrace);
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
