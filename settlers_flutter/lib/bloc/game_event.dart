import 'package:equatable/equatable.dart';

abstract class GameEvent extends Equatable {
  const GameEvent();
}

class FetchGame extends GameEvent {
  const FetchGame();

  @override
  List<Object> get props => [];
}

class PutGame extends GameEvent {
  const PutGame();

  @override
  List<Object> get props => [];
}
