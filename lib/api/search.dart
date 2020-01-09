import 'dart:convert';
import 'package:http/http.dart';

import 'package:unpaprd/models/feed.dart';

Future<AudiobookShortList> querySearchAPI(String query, {int limit: 10}) async {
  final response = await get(
      "https://unpaprdapi.gargakshit.now.sh/api/search?limit=$limit&q=$query");

  if (response.statusCode == 200) {
    return AudiobookShortList.fromJson(jsonDecode(response.body));
  } else {
    throw Exception("HTTP Error");
  }
}
