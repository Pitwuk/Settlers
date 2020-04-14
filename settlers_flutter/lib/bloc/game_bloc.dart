import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'package:settlers_flutter/models/models.dart';
import 'package:settlers_flutter/repositories/repositories.dart';
import './bloc.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  final GameRepository repository;

  GameBloc({@required this.repository}) : assert(repository != null);

  @override
  GameState get initialState => GameEmpty();

  @override
  Stream<GameState> mapEventToState(GameEvent event) async* {
    if (event is FetchGame) {
      yield GameLoading();
      try {
        print('Trying to fetch');
        final Game gamedata = await repository.fetchGame();

        yield GameLoaded(gamedata: gamedata);
      } catch (_) {
        yield GameError();
      }
    }
  }
}
