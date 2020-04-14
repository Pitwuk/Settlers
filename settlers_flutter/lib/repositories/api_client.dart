import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

import 'package:settlers_flutter/models/models.dart';

class ApiClient {
  final _baseUrl = 'https://christiandahnke.ddns.net';
  final http.Client httpClient;

  ApiClient({
    @required this.httpClient,
  }) : assert(httpClient != null);

  Future<Game> fetchGame() async {
    final url = '$_baseUrl/gamedata';
    print(url);
    final response =
        await http.Client().get('http://christiandahnke.ddns.net/gamedata/');
    print(response.body);

    if (response.statusCode != 200) {
      print('error getting gamedata');
      throw new Exception('error getting gamedata');
    } else {
      print('success');
    }

    final json = jsonDecode(response.body);
    return Game.fromJson(json);
  }
}
