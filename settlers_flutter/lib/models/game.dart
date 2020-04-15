import 'package:equatable/equatable.dart';

class Game extends Equatable {
  final game_data;

  const Game({this.game_data});

  @override
  List<Object> get props => [game_data];

  static Game fromJson(dynamic json) {
    return Game(game_data: json);
  }

  @override
  String toString() => 'Game { game_data: $game_data }';
}
