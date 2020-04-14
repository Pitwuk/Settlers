import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

class ApiClient {
  final _baseUrl = 'https://christiandahnke.ddns.net';
  final http.Client httpClient;

  ApiClient({
    @required this.httpClient,
  }) : assert(httpClient != null);

  Future<String> fetchGame() async {
    final url = '$_baseUrl/gamedata';
    final response = await this.httpClient.get(url);

    if (response.statusCode != 200) {
      throw new Exception('error getting quotes');
    }

    final json = jsonDecode(response.body);
    return json;
  }
}
