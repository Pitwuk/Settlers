import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:html' as html;
import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:settlers_flutter/repositories/repositories.dart';
import 'package:settlers_flutter/bloc/bloc.dart';
import 'globals.dart' as globals;
import 'host.dart';
import 'client.dart';
import 'local.dart';

final appContainer = html.window.document.getElementById('app-container');
const colors = <String, Color>{
  'beige': Color(0xffbeb3aa),
  'brown': Color(0xff352d26),
  's': Color(0xff09af11),
  'o': Color(0xff555555),
  'b': Color(0xff693117),
  'w': Color(0xffb39a2d),
  'f': Color(0xff063300),
  'r': Color(0xffc4bf98),
  'water': Color(0xff253d4b),
  'offwhite': Color(0xffe9dfb5),
  'sand': Color(0xfffff3bd),
  'selection': Color(0x9fcfcfcf),
  'boardwalk': Color(0xff5a4832),
  'white': Color(0xffe9e9e9),
  'black': Color(0xff1d1d1d),
  'darkgrey': Color(0xff202020),
  'screenBG': Color(0xe1242424),
  'TB': Color(0xe1919191)
};
List<Color> playerColors = [
  Color(0xff720000),
  Color(0xffffffff),
  Color(0xff3d2707),
  Color(0xff915700),
  Color(0xffb3b00f),
  Color(0xff160b57),
  Color(0xff3b0b57),
  Color(0xffa32e99),
  Color(0xff2ea399),
  Color(0xff39642e),
];

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
  }
}

class Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(routes: {
      '/': (context) => StartMenu(),
      '/singleplayer': (context) => SingleplayerMenu(),
      '/multiplayer': (context) => MultiplayerMenu(),
      '/numplayers': (context) => NumPlayersMenu(),
      '/online': (context) => OnlineMenu(),
      '/names': (context) => InputNames(),
      '/order': (context) => OrderScreen(),
      '/host/order': (context) => HostOrder(),
      '/client/order': (context) => ClientOrder(),
      '/local/colors': (context) => ColorChoice(),
      '/local/game': (context) => InitLocalGame(),
      '/hostgame': (context) => HostGame(),
      '/clientgame': (context) => ClientGame(),
      '/host': (context) => HostMenuScreen(),
      '/host/lobby': (context) => HostLobby(),
      '/client': (context) => ClientMenuScreen(),
      '/client/lobby': (context) => ClientLobby(),
      // '/host/color': (context) => HostColorChoice(),
      // '/client/color': (context) => ClientColorChoice()
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
            '${state.gamedata.gameData}',
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

class MultiplayerMenu extends StatelessWidget {
  final buttons = ['Local', '/numplayers', 'Online', '/online'];
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
  final buttons = ['Host', '/numplayers', 'Client', '/client'];
  @override
  Widget build(BuildContext context) {
    globals.gametype = 'online';
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

class NumPlayersMenu extends StatelessWidget {
  final buttons = ['2', '/names', '3', '/names', '4', '/names'];
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
          NameForm()
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
  String _getGameCode() {
    String str = '';
    for (int i = 0; i < 4; i++) {
      int charCode = Random().nextInt(35);

      if (charCode < 10)
        charCode += 48;
      else
        charCode += 87;

      str += String.fromCharCode(charCode);
    }
    return str;
  }

  void _showNextScreen(route, txt) {
    if (route == '/names') {
      if (globals.gametype == 'online') {
        String gamecode = _getGameCode();
        globals.gameCode = gamecode;
        globals.numPlayers = int.parse(txt);
        Navigator.of(context).pushNamed('/host');
      } else {
        globals.numPlayers = int.parse(txt);
        Navigator.of(context).pushNamed(route);
      }
    } else
      Navigator.of(context).pushNamed(route);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> buttonWidgets = new List(buttons.length / 2);
    for (int i = 0; i < buttons.length - 1; i += 2) {
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
                  onPressed: () => _showNextScreen(route, txt),
                  child: AutoSizeText(txt,
                      style: TextStyle(fontSize: 40.0, color: Colors.white),
                      maxLines: 1),
                ))));
  }
}
