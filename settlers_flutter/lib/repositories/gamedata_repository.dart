import 'dart:async';

import 'package:meta/meta.dart';

import './api_client.dart';
import 'package:settlers_flutter/models/models.dart';

class GameRepository {
  final ApiClient apiClient;

  GameRepository({@required this.apiClient}) : assert(apiClient != null);

  Future<Game> fetchGame() async {
    print('fetching');
    return await apiClient.fetchGame();
  }
}
