import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:settlers_flutter/models/models.dart';

class ApiClient {
  final _baseUrl = 'http://christiandahnke.ddns.net';

  Future<Game> fetchGame() async {
    final url = _baseUrl + '/gamedata/';
    final response = await http.Client().get(url);

    if (response.statusCode != 200) {
      print('error getting gamedata');
      throw new Exception('error getting gamedata');
    }

    final json = jsonDecode(response.body);
    return Game.fromJson(json);
  }

  Future<Game> putGame(ke, value) async {
    final url = _baseUrl + '/gamedata/';
    print(ke);
    print(value);
    Map<String, String> headers = new Map();
    headers['Accept'] = 'application/json';
    headers['Content-type'] = 'application/json';

    final response = await http.Client()
        .put(url, body: jsonEncode({ke: value}), headers: headers);

    if (response.statusCode != 200) {
      print('error getting gamedata');
      throw new Exception('error getting gamedata');
    }

    final json = jsonDecode(response.body);
    return Game.fromJson(json);
  }
}
