import 'dart:convert';
import 'package:http/http.dart';

import 'package:unpaprd/models/audiobook_full.dart';

Future<AudiobookFull> fetchBook(int id) async {
  final response =
      await get("https://unpaprdapi.gargakshit.now.sh/api/book?id=$id");

  if (response.statusCode == 200) {
    return AudiobookFull.fromJson(jsonDecode(response.body));
  } else {
    throw Exception("HTTP Error");
  }
}
