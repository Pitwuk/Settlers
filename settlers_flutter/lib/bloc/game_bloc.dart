import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'package:settlers_flutter/models/models.dart';
import 'package:settlers_flutter/repositories/repositories.dart';
import './bloc.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  final GameRepository repository;
  final ke, value;

  GameBloc(this.ke, this.value, {@required this.repository})
      : assert(repository != null);

  @override
  GameState get initialState => GameEmpty();

  @override
  Stream<GameState> mapEventToState(GameEvent event) async* {
    if (event is FetchGame) {
      yield GameLoading();
      try {
        print('Attempting to fetch');
        final Game gamedata = await repository.fetchGame();
        yield GameLoaded(gamedata: gamedata);
      } catch (_) {
        yield GameError();
      }
    } else if (event is PutGame) {
      yield GameLoading();
      try {
        print('Attempting to put');
        print(ke);
        final Game gamedata = await repository.putGame(ke, value);
        yield GameLoaded(gamedata: gamedata);
      } catch (_) {
        yield GameError();
      }
    }
  }
}
