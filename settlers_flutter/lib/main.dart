import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:html' as html;
import 'package:http/http.dart' as http;
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();

  final GameRepository repository = GameRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );
  runApp(Menu(
    repository: repository,
  ));
}

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }
}

class Menu extends StatelessWidget {
  final GameRepository repository;

  Menu({Key key, @required this.repository})
      : assert(repository != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        routes: {
          // '/': (context) => StartMenu(),
          '/singleplayer': (context) => SingleplayerMenu(),
          '/multiplayer': (context) => MultiplayerMenu(),
          '/local': (context) => NumPlayersMenu(),
          '/online': (context) => OnlineMenu(),
          '/names': (context) => InputNames()
        },
        home: Scaffold(
          body: BlocProvider(
            create: (context) => GameBloc(repository: repository),
            child: StartMenu(),
          ),
        ));
  }
}

class StartMenu extends StatelessWidget {
  var buttons = [
    'Singleplayer',
    '/singleplayer',
    'Multiplayer',
    '/multiplayer'
  ];
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
          return ListTile(
            leading: Text(
              '${state.gamedata}',
              style: TextStyle(fontSize: 10.0),
            ),
            title: Text('gay'),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    // return Scaffold(
    //   backgroundColor: colors['beige'],
    //   body: Stack(
    //     children: <Widget>[
    //       Container(
    //           decoration: BoxDecoration(
    //             border: Border.all(
    //               width: 7.0,
    //               color: colors['brown'],
    //             ),
    //           ),
    //           child: Align(
    //               alignment: Alignment(0, -0.7),
    //               child: (Text('Welcome to The Settlers of Catan',
    //                   textAlign: TextAlign.center,
    //                   style: TextStyle(fontSize: 40.0))))),
    //       MenuButtons(buttons)
    //     ],
    //   ),
    // );
  }
}

class MultiplayerMenu extends StatelessWidget {
  var buttons = ['Local', '/local', 'Online', '/online'];
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
  var buttons = ['1', '/names', '2', '/names', '3', '/names', '4', '/names'];
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
      body: Center(
        child: Text('Can\'t Enter Names Yet',
            style: Theme.of(context).textTheme.headline2),
      ),
    );
  }
}

class MenuButtons extends StatefulWidget {
  var buttons;
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
    List<Widget> button_widgets = new List(buttons.length / 2);
    for (int i = 0; i < buttons.length - 1; i += 2) {
      // print(i);
      // print((i / 2).round());
      button_widgets[(i / 2).round()] =
          menuButton(context, buttons[i], 200, 100, buttons[i + 1]);
    }
    return Center(
        child: Wrap(spacing: 10, runSpacing: 10, children: button_widgets));
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
