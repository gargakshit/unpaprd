import 'dart:math';

import 'package:flutter/material.dart';
import 'package:unpaprd/api/search.dart';
import 'package:unpaprd/components/bookItem.dart';
import 'package:unpaprd/constants/colors.dart';
import 'package:unpaprd/constants/searchPlaceholders.dart';
import 'package:unpaprd/models/feed.dart';

class SearchPage extends StatefulWidget {
  final Function navigate;

  SearchPage({this.navigate});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _controller;
  String searchText = "";
  Future<AudiobookShortList> search;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController();

    _controller.addListener(() {
      setState(() {
        searchText = _controller.text;
        if (_controller.text.isNotEmpty) {
          search = querySearchAPI(searchText, limit: 10);
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();

    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 16.0,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.grey.withOpacity(0.16),
                ),
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
                        autofocus: false,
                        controller: _controller,
                        cursorColor: accentColor,
                        decoration: InputDecoration(
                          hintText:
                              "Try \"${searchPlaceHolders[Random().nextInt(searchPlaceHolders.length)]}\"",
                          hintStyle: TextStyle(
                            color: Colors.white60,
                          ),
                          border: InputBorder.none,
                        ),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                    searchText.isEmpty
                        ? GestureDetector(
                            onTap: () => null,
                            child: Icon(
                              Icons.mic,
                              color: Colors.white,
                            ),
                          )
                        : GestureDetector(
                            child: Icon(Icons.close),
                            onTap: () => setState(() => _controller.clear()),
                          ),
                    SizedBox(
                      width: 8.0,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 16.0,
              ),
              Expanded(
                child: searchText.isNotEmpty
                    ? FutureBuilder<AudiobookShortList>(
                        future: search,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data.books.length == 0) {
                              return Text(
                                "No results found",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                ),
                                textAlign: TextAlign.center,
                              );
                            } else {
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
                            }
                          } else if (snapshot.hasError) {
                            return Text(
                              "No results found",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                              ),
                              textAlign: TextAlign.center,
                            );
                          }
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      )
                    : Text(
                        "Please search for something...",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
