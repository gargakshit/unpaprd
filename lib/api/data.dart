import 'dart:convert';

import 'package:http/http.dart';

class AudioData {
  final String name;
  final String provider;
  final List<String> audio;

  AudioData({this.name, this.provider, this.audio});

  factory AudioData.fromJSON(Map<String, dynamic> json) {
    return AudioData(
      name: json['name'],
      provider: json['provider'],
      audio: List<String>.from(json['audio']),
    );
  }
}

Future<List<AudioData>> getData() async {
  final res = await get(
    "https://gist.githubusercontent.com/gargakshit/70b94bd9bde88f81272d1f7bf6da410f/raw",
  );

  if (res.statusCode == 200) {
    return jsonDecode(res.body)
        .map<AudioData>((d) => AudioData.fromJSON(d))
        .toList();
  } else {
    throw Exception("Unable to fetch data!");
  }
}
