import 'package:equatable/equatable.dart';

class Game extends Equatable {
  final gameData;

  const Game({this.gameData});

  @override
  List<Object> get props => [gameData];

  static Game fromJson(dynamic json) {
    return Game(gameData: json);
  }

  @override
  String toString() => 'Game { game_data: $gameData }';
}
