import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:html' as html;
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:settlers_flutter/models/game.dart';

import 'package:settlers_flutter/repositories/repositories.dart';
import 'package:settlers_flutter/bloc/bloc.dart';

final appContainer = html.window.document.getElementById('app-container');
const colors = {
  'beige': Color(0xffbeb3aa),
  'brown': Color(0xff352d26),
  's': Color(0xff09af11),
  'o': Color(0xff555555),
  'b': Color(0xff693117),
  'w': Color(0xffb39a2d),
  'f': Color(0xff063300),
  'r': Color(0xffc4bf98)
};

final GameRepository repository = GameRepository(
  apiClient: ApiClient(),
);

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();

  runApp(Menu());
}

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }
}

class Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(routes: {
      '/': (context) => StartMenu(),
      '/singleplayer': (context) => SingleplayerMenu(),
      '/multiplayer': (context) => MultiplayerMenu(),
      '/local': (context) => NumPlayersMenu(),
      '/online': (context) => OnlineMenu(),
      '/names/1': (context) => InputNames(1),
      '/names/2': (context) => InputNames(2),
      '/names/3': (context) => InputNames(3),
      '/names/4': (context) => InputNames(4),
      '/order': (context) => OrderScreen()
    });
  }
}

class StartMenu extends StatelessWidget {
  final buttons = [
    'Singleplayer',
    '/singleplayer',
    'Multiplayer',
    '/multiplayer'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors['beige'],
      body: Stack(
        children: <Widget>[
          Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 7.0,
                  color: colors['brown'],
                ),
              ),
              child: Align(
                  alignment: Alignment(0, -0.7),
                  child: (Text('Welcome to The Settlers of Catan',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 40.0))))),
          MenuButtons(buttons)
        ],
      ),
    );
  }
}

class RefreshGame extends StatelessWidget {
  final GameRepository repository;

  RefreshGame({Key key, @required this.repository})
      : assert(repository != null),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(
      builder: (context, state) {
        if (state is GameEmpty) {
          BlocProvider.of<GameBloc>(context).add(FetchGame());
        }
        if (state is GameError) {
          return Center(
            child: Text('failed to fetch game'),
          );
        }
        if (state is GameLoaded) {
          return Center(
              child: Text(
            '${state.gamedata.game_data}',
            style: TextStyle(fontSize: 40.0),
          ));
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class UpdateGame extends StatelessWidget {
  final GameRepository repository;

  UpdateGame({Key key, @required this.repository})
      : assert(repository != null),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(
      builder: (context, state) {
        if (state is GameEmpty) {
          BlocProvider.of<GameBloc>(context).add(PutGame());
        }
        if (state is GameError) {
          return Center(
            child: Text('failed to put value'),
          );
        }
        if (state is GameLoaded) {
          return Center(
              child: Text(
            '${state.gamedata.game_data['num_players']}',
            style: TextStyle(fontSize: 40.0),
          ));
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Future<Game> update(ke, value) async {
    return await repository.putGame(ke, value);
  }
}

class MultiplayerMenu extends StatelessWidget {
  final buttons = ['Local', '/local', 'Online', '/online'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors['beige'],
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: 7.0,
                color: colors['brown'],
              ),
            ),
          ),
          MenuButtons(buttons)
        ],
      ),
    );
  }
}

class SingleplayerMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Singleplayer Not Yet Supported',
            style: Theme.of(context).textTheme.headline2),
      ),
    );
  }
}

class OnlineMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Online Not Yet Supported',
            style: Theme.of(context).textTheme.headline2),
      ),
    );
  }
}

class NumPlayersMenu extends StatelessWidget {
  final buttons = [
    '1',
    '/names/1',
    '2',
    '/names/2',
    '3',
    '/names/3',
    '4',
    '/names/4'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors['beige'],
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: 7.0,
                color: colors['brown'],
              ),
            ),
          ),
          MenuButtons(buttons)
        ],
      ),
    );
  }
}

class InputNames extends StatelessWidget {
  final num;
  InputNames(this.num);

  @override
  Widget build(BuildContext context) {
    UpdateGame(repository: repository).update('num_players', num);
    return Scaffold(
      backgroundColor: colors['beige'],
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: 7.0,
                color: colors['brown'],
              ),
            ),
          ),
          NameForm(num)
        ],
      ),
    );
  }
}

class MenuButtons extends StatefulWidget {
  final buttons;
  MenuButtons(this.buttons);
  @override
  _MenuState createState() => _MenuState(buttons);
}

class _MenuState extends State<MenuButtons> {
  var buttons;
  _MenuState(this.buttons);

  void _showNextScreen(route) {
    Navigator.of(context).pushNamed(route);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> buttonWidgets = new List(buttons.length / 2);
    for (int i = 0; i < buttons.length - 1; i += 2) {
      // print(i);
      // print((i / 2).round());
      buttonWidgets[(i / 2).round()] =
          menuButton(context, buttons[i], 200, 100, buttons[i + 1]);
    }
    return Center(
        child: Wrap(spacing: 10, runSpacing: 10, children: buttonWidgets));
  }

  Widget menuButton(BuildContext context, txt, width, height, route) {
    return SizedBox(
        width: width,
        height: height,
        child: Container(
            child: MouseRegion(
                onHover: (event) {
                  appContainer.style.cursor = 'pointer';
                },
                onExit: (event) {
                  appContainer.style.cursor = 'default';
                },
                child: FlatButton(
                  color: colors['brown'],
                  splashColor: colors['beige'],
                  hoverColor: colors['s'],
                  onPressed: () => _showNextScreen(route),
                  child: AutoSizeText(txt,
                      style: TextStyle(fontSize: 40.0, color: Colors.white),
                      maxLines: 1),
                ))));
  }
}

class NameForm extends StatefulWidget {
  final num;
  NameForm(this.num);
  @override
  _NameFormState createState() {
    return _NameFormState(num);
  }
}

class _NameFormState extends State<NameForm> {
  final num;
  _NameFormState(this.num);

  void _showOrderScreen() {
    Navigator.of(context).pushNamed('/order');
  }

  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int count = 0;
    return Column(children: <Widget>[
      Padding(
        padding: const EdgeInsets.all(30.0),
        child: TextFormField(
          controller: myController,
          decoration: const InputDecoration(labelText: 'Name'),
          validator: (value) {
            if (value.isEmpty) {
              return 'Please enter name';
            }
            return null;
          },
        ),
      ),
      RaisedButton(
        onPressed: () {
          if (myController.text != '') {
            var name = myController.text;
            Scaffold.of(context).showSnackBar(SnackBar(content: Text(name)));
            UpdateGame(repository: repository).update("%new_player%", name);
            count++;
            if (count == num) {
              _showOrderScreen();
            }
          }
        },
        child: Text('Submit'),
      )
    ]);
  }
}

class OrderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: colors['beige'],
        body: Stack(children: <Widget>[
          Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 7.0,
                  color: colors['brown'],
                ),
              ),
              child: Align(
                  alignment: Alignment(0, -0.7),
                  child: (Text('Player Order:',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 40.0))))),
          BlocProvider(
            create: (BuildContext context) => GameBloc(
                repository: repository, ke: '%player_order%', value: null),
            child: BlocBuilder<GameBloc, GameState>(
              builder: (context, state) {
                if (state is GameEmpty) {
                  BlocProvider.of<GameBloc>(context).add(PutGame());
                }
                if (state is GameError) {
                  return Center(
                    child: Text('failed to put value'),
                  );
                }
                if (state is GameLoaded) {
                  var players = state.gamedata.game_data['player_order'];
                  var str = '';
                  for (var i in players) {
                    str += i + '\n';
                  }
                  return Center(
                      child: Text(
                    str,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 40.0,
                    ),
                  ));
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ]));
  }
}

//put to api basic example
// @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: BlocProvider(
//         create: (BuildContext context) =>
//             GameBloc(repository: repository, ke: 'num_players', value: 2),
//         child: UpdateGame(
//           repository: repository,
//         ),
//       ),
//     );
//   }
