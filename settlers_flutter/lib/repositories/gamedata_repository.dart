import 'dart:async';

import 'package:meta/meta.dart';

import './api_client.dart';

class GameRepository {
  final ApiClient apiClient;

  GameRepository({@required this.apiClient}) : assert(apiClient != null);

  Future<String> fetchGame() async {
    return await apiClient.fetchGame();
  }
}
