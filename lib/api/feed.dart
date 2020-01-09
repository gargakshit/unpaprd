import 'dart:convert';
import 'package:http/http.dart';

import 'package:unpaprd/models/feed.dart';

Future<AudiobookShortList> fetchFeed({int limit: 10}) async {
  final response =
      await get("https://unpaprdapi.gargakshit.now.sh/api/feed?limit=$limit");

  if (response.statusCode == 200) {
    return AudiobookShortList.fromJson(jsonDecode(response.body));
  } else {
    throw Exception("HTTP Error!");
  }
}
