import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class GameState extends Equatable {
  const GameState();

  @override
  List<Object> get props => [];
}

class GameEmpty extends GameState {}

class GameLoading extends GameState {}

class GameLoaded extends GameState {
  final String gamedata;

  const GameLoaded({@required this.gamedata}) : assert(gamedata != null);

  @override
  List<Object> get props => [gamedata];
}

class GameError extends GameState {}
