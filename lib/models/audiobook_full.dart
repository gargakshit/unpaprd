import 'package:unpaprd/models/reader.dart';
import 'package:unpaprd/models/author.dart';
import 'package:unpaprd/models/audio.dart';

class AudiobookFull {
  final String id;
  final String title;
  final String description;
  final String language;
  final String totalTime;
  final String numSections;

  final List<Author> authors;
  final List<Reader> readers;
  final List<Audio> audio;

  AudiobookFull({
    this.id,
    this.title,
    this.description,
    this.language,
    this.totalTime,
    this.numSections,
    this.authors,
    this.readers,
    this.audio,
  });

  factory AudiobookFull.fromJson(Map<String, dynamic> json) {
    var aList = json['authors'] as List;
    List<Author> authorList = aList
        .cast<Map<String, dynamic>>()
        .map((d) => Author.fromJson(d))
        .toList();

    var rList = json['readers'] as List;
    List<Reader> readerList = rList
        .cast<Map<String, dynamic>>()
        .map((d) => Reader.fromJson(d))
        .toList();

    var auList = json['audio'] as List;
    List<Audio> audioList = auList
        .cast<Map<String, dynamic>>()
        .map((d) => Audio.fromJson(d))
        .toList();

    return AudiobookFull(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      language: json['language'],
      totalTime: json['total_time'],
      numSections: json['num_sections'],
      authors: authorList,
      readers: readerList,
      audio: audioList,
    );
  }
}
