import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:html' as html;
import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:settlers_flutter/models/game.dart';

import 'package:settlers_flutter/repositories/repositories.dart';
import 'package:settlers_flutter/bloc/bloc.dart';
import 'globals.dart' as globals;

final appContainer = html.window.document.getElementById('app-container');
const colors = {
  'beige': Color(0xffbeb3aa),
  'brown': Color(0xff352d26),
  's': Color(0xff09af11),
  'o': Color(0xff555555),
  'b': Color(0xff693117),
  'w': Color(0xffb39a2d),
  'f': Color(0xff063300),
  'r': Color(0xffc4bf98),
  'water': Color(0xff253d4b),
  'offwhite': Color(0xffe9dfb5)
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
      '/order': (context) => OrderScreen(),
      '/local/game': (context) => StartLocalGame()
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
    if (globals.gametype == 'online')
      UpdateGame(repository: repository).update('num_players', num);
    else
      globals.numPlayers = num;
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
            if (globals.gametype == 'online')
              UpdateGame(repository: repository).update("%new_player%", name);
            else {
              globals.players[name] = globals.playerBlank;
            }
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

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreen createState() {
    return _OrderScreen();
  }
}

class _OrderScreen extends State<OrderScreen> {
  void _showGameScreen() {
    Navigator.of(context).pushNamed('/local/game');
  }

  @override
  Widget build(BuildContext context) {
    if (globals.gametype == 'online') {
      return Scaffold(
          backgroundColor: colors['beige'],
          body: Stack(children: <Widget>[
            GestureDetector(
                onTap: _showGameScreen,
                child: Container(
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
                            style: TextStyle(fontSize: 40.0)))))),
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
                    globals.playerOrder =
                        state.gamedata.game_data['player_order'];
                    var str = '';
                    for (var i in globals.playerOrder) {
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
    List players = [];
    globals.players.forEach((key, value) => players.add(key));
    players.shuffle();

    globals.playerOrder = players;
    String str = '';
    for (String i in globals.playerOrder) {
      str += i + '\n';
    }
    return Scaffold(
        backgroundColor: colors['beige'],
        body: Stack(children: <Widget>[
          GestureDetector(
              onTap: _showGameScreen,
              child: Container(
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
                          style: TextStyle(fontSize: 40.0)))))),
          Center(
              child: Text(str,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 40.0)))
        ]));
  }
}

class StartLocalGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: GameBoard(),
      child: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: 7.0,
                color: colors['brown'],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GameBoard extends CustomPainter {
  var bgCanvas, resNums, robberLoc;

  @override
  void paint(Canvas canvas, Size size) {
    //initialize the drawing variables
    globals.w = size.width;
    globals.h = size.height;
    bgCanvas = canvas;
    globals.refscale = (globals.w < globals.h) ? globals.w : globals.h;
    globals.r = globals.refscale * .08;

    //draw background
    var rect = Offset.zero & size;
    canvas.drawRect(
      rect,
      Paint()..color = colors['water'],
    );
    //initialize the tiles

    if (globals.tiles == null) {
      initTiles();
      print('Initializing Tiles...');
    }
    drawTiles();
    removeDuplicates();
    if (globals.gametype == 'online') {
      //pass to api
      UpdateGame(repository: repository)
          .update('tiles', globals.tiles.toString());
    }
  }

  @override
  bool shouldRepaint(GameBoard oldDelegate) => false;

  //initializes the tiles
  void initTiles() {
    globals.tiles = {};
    var resArr = [
      "s",
      "s",
      "s",
      "s",
      "o",
      "o",
      "o",
      "b",
      "b",
      "b",
      "w",
      "w",
      "w",
      "w",
      "f",
      "f",
      "f",
      "f",
      "r",
    ]; //stored possible resources s=sheep, o=ore, b=brick,w=wheat,f=forest,r=robber
    resNums = {0: "s", 1: "o", 2: "b", 3: "w", 4: "f"};

    var startlen = resArr.length;
    var rand = Random();
    for (int i = 0; i < startlen; i++) {
      int ind = (rand.nextDouble() * resArr.length).floor();
      var newRes = resArr[ind];
      resArr.removeRange(ind, ind + 1);
      int diceNum = (rand.nextDouble() * 10 + 3).floor();
      if (diceNum == 7) diceNum = 2;
      globals.tiles[i] = [newRes, diceNum];
      if (newRes == "r") robberLoc = i;
    }
  }

  //draws all of the game tiles in the standard 3-4-5-4-3 config with the resource color and number chips
  void drawTiles() {
    double xi = globals.w / 2 - globals.right * 4; // hexagon x
    double yi = globals.h / 2 - globals.down * 2; // hexagon y
    double x = xi;
    double y = yi;
    for (int i = 0; i < globals.tiles.length; i++) {
      if (i == 3 || i == 7) {
        xi -= globals.right;
        x = xi;
        y += globals.down;
      } else if (i == 12 || i == 16) {
        xi += globals.right;
        x = xi;
        y += globals.down;
      }
      x += globals.right * 2;

      drawHexagon(x, y, i);
      // tile_centers[i] = [x, y];
      if (globals.tiles[i][0] != "r") {
        Rect cirRect =
            Rect.fromCircle(center: Offset(x, y), radius: globals.r * 0.3);
        var paint = Paint()..color = colors['offwhite'];
        bgCanvas.drawArc(cirRect, 0, 2 * pi, true, paint);
        TextSpan span = new TextSpan(
            style:
                new TextStyle(color: Colors.black, fontSize: globals.r * 0.2),
            text: globals.tiles[i][1].toString());
        TextPainter tp = new TextPainter(
            text: span,
            textScaleFactor: 2,
            textAlign: TextAlign.center,
            textDirection: TextDirection.ltr);
        tp.layout();
        tp.paint(bgCanvas, new Offset(x - (tp.width / 2), y - (tp.height / 2)));
      }
    }
  }

// draws a hexagon at the given position with a given tile
  void drawHexagon(x, y, tile) {
    var paint = Paint()..color = colors[globals.tiles[tile][0]];

    final hex = Path();
    globals.vertices.add([globals.hexagon[0] + x, globals.hexagon[1] + y]);
    hex.moveTo(globals.hexagon[0] + x, globals.hexagon[1] + y);
    for (int i = 2; i < globals.hexagon.length - 1; i += 2) {
      globals.vertices
          .add([globals.hexagon[i] + x, globals.hexagon[i + 1] + y]);
      hex.lineTo(globals.hexagon[i] + x, globals.hexagon[i + 1] + y);
    }
    bgCanvas.drawPath(hex, paint);
  }

  //removes overlapping vertices
  void removeDuplicates() {
    for (int i = 0; i < globals.vertices.length; i++) {
      var count = 0;
      for (int j = i + 1; j < globals.vertices.length; j++) {
        if ((globals.vertices[j][0]).round() ==
                (globals.vertices[i][0]).round() &&
            (globals.vertices[j][1]).round() ==
                (globals.vertices[i][1]).round()) {
          // for (k = 0; k < 12; k++) {
          //   for (l = 0; l < 5; l++) {
          //     dist[i][k][l] += dist[j][k][l];
          //   }
          // }

          // dist.splice(j, 1);
          globals.vertices.removeRange(j, j + 1);
          count++;
          j -= 1;
        }
      }
      // if (count < 2) coast_verts.push(i);
    }
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
