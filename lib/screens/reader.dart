import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:photo_view/photo_view.dart';
import 'package:unpaprd/constants/colors.dart';

class ReaderPage extends StatefulWidget {
  final String name;

  ReaderPage({@required this.name});

  @override
  _ReaderPageState createState() => _ReaderPageState();
}

class _ReaderPageState extends State<ReaderPage> {
  Future<PDFDocument> _getPdf() async {
    final url = await get(
        "https://unpaprdapi.gargakshit.now.sh/api/getEbook?q=${widget.name}");

    if (url.statusCode == 200) {
      PDFDocument doc = await PDFDocument.fromURL(url.body);
      return doc;
    } else {
      throw Exception("HTTP Error!");
    }
  }

  int page = 1;

  double opacity = 1;

  Color bgColor = Colors.black;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: FutureBuilder<PDFDocument>(
          future: _getPdf(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height - 130,
                    child: FutureBuilder<PDFPage>(
                      future: snapshot.data.get(page: page),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Center(
                            child: ColorFiltered(
                              colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(opacity),
                                BlendMode.dstATop,
                              ),
                              child: ClipRRect(
                                child: PhotoView(
                                  imageProvider: FileImage(
                                    File(snapshot.data.imgPath),
                                  ),
                                  maxScale: 3.00,
                                ),
                              ),
                            ),
                          );
                        }

                        if (snapshot.hasError) {
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: 16,
                                right: 16,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "Error Rendering Page",
                                    style: GoogleFonts.montserrat(
                                      textStyle: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    "${snapshot.error}",
                                    style: GoogleFonts.montserrat(
                                      textStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14.0,
                                      ),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: IconButton(
                              onPressed: page == 1
                                  ? null
                                  : () => setState(
                                        () => page--,
                                      ),
                              icon: Icon(Icons.keyboard_arrow_left),
                            ),
                          ),
                          Container(
                            width: 120,
                            child: Center(
                              child: Text(
                                "$page / ${snapshot.data.count}",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: IconButton(
                              onPressed: page == (snapshot.data.count - 1)
                                  ? null
                                  : () => setState(
                                        () => page++,
                                      ),
                              icon: Icon(Icons.keyboard_arrow_right),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Error Loading Book",
                        style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "${snapshot.error}",
                        style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 14.0,
                          ),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }

            return Center(
              child: Padding(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Please wait while we load the book for you",
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
