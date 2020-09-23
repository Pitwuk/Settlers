import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:settlers_flutter/models/models.dart';
import 'package:settlers_flutter/globals.dart' as globals;

class ApiClient {
  final _baseUrl = 'http://christiandahnke.ddns.net';

  Future<Game> fetchGame() async {
    final url = _baseUrl + '/gamedata/';
    Map<String, String> headers = new Map();
    headers['Accept'] = 'application/json';
    headers['Content-type'] = 'application/json';
    final response = await http.Client().put(url,
        body: jsonEncode({'game': globals.gameCode}), headers: headers);

    if (response.statusCode != 200) {
      print('error getting gamedata');
      throw new Exception('error getting gamedata');
    }

    final json = jsonDecode(response.body);
    return Game.fromJson(json);
  }

  Future<Game> putGame(ke, value) async {
    final url = _baseUrl + '/gamedata/';
    Map<String, String> headers = new Map();
    headers['Accept'] = 'application/json';
    headers['Content-type'] = 'application/json';

    final response = await http.Client().put(url,
        body: jsonEncode({ke: value, 'game': globals.gameCode}),
        headers: headers);

    if (response.statusCode != 200) {
      print('error getting gamedata');
      throw new Exception('error getting gamedata');
    }

    final json = jsonDecode(response.body);
    return Game.fromJson(json);
  }
}
