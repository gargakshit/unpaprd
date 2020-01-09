import 'package:unpaprd/models/audiobook_short.dart';

class AudiobookShortList {
  final List<AudiobookShort> books;

  AudiobookShortList({
    this.books,
  });

  factory AudiobookShortList.fromJson(List<dynamic> json) {
    List<AudiobookShort> books = List<AudiobookShort>();

    books = json.map((d) => AudiobookShort.fromJson(d)).toList();

    return AudiobookShortList(
      books: books,
    );
  }
}
