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
  'offwhite': Color(0xffe9dfb5),
  'sand': Color(0xfffff3bd),
  'selection': Color(0x9fcfcfcf),
  'boardwalk': Color(0xff5a4832),
  'white': Color(0xffe9e9e9),
  'black': Color(0xff1d1d1d)
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
      '/local/game': (context) => InitLocalGame()
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

class InitLocalGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    globals.w = screenSize.width;
    globals.h = screenSize.height;
    globals.refscale = (globals.w < globals.h) ? globals.w : globals.h;
    globals.r = globals.refscale * .08;
    return Scaffold(
        body: Stack(
      children: <Widget>[
        CustomPaint(painter: GameBoard(), child: Container()),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              width: 7.0,
              color: colors['brown'],
            ),
          ),
        ),
        UIWidget()
      ],
    ));
  }
}

class GameBoard extends CustomPainter {
  Canvas bgCanvas;

  @override
  void paint(Canvas canvas, Size size) {
    bgCanvas = canvas;
    //initialize the drawing variables
    if (globals.tiles == null) {
      //draw background
      var rect = Offset.zero & size;
      canvas.drawRect(
        rect,
        Paint()..color = colors['water'],
      );
      //initialize the tiles
      initTiles();
      print('Initializing Tiles...');

      drawTiles();
      removeDuplicates();
      if (globals.gametype == 'online') {
        //pass to api
        UpdateGame(repository: repository)
            .update('tiles', globals.tiles.toString());
      }
      // drawVertices();
      constructGraph();
      // print(globals.coastVerts);
      drawCoast();
      vertexXs();
    } else {
      var rect = Offset.zero & size;
      canvas.drawRect(
        rect,
        Paint()..color = colors['water'],
      );
      drawTiles();
      drawCoast();
    }
  }

  @override
  bool shouldRepaint(GameBoard oldDelegate) => false;

//sets a list of all vertex xs for use by gamepeice placement
  void vertexXs() {
    for (int i = 0; i < globals.vertices.length; i++) {
      if (!globals.vertexXs.contains(globals.vertices[i][0].round()))
        globals.vertexXs.add(globals.vertices[i][0].round());
    }
    globals.vertexXs.sort();
    globals.vertexXd = globals.vertexXs[1] - globals.vertexXs[0];
  }

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

    var startlen = resArr.length;
    var rand = Random();
    for (int i = 0; i < startlen; i++) {
      int ind = (rand.nextDouble() * resArr.length).floor();
      var newRes = resArr[ind];
      resArr.removeRange(ind, ind + 1);
      int diceNum = (rand.nextDouble() * 10 + 3).floor();
      if (diceNum == 7) diceNum = 2;
      globals.tiles[i] = [newRes, diceNum];
      if (newRes == "r") globals.robberLoc = i;
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
  void drawHexagon(double x, double y, int tile) {
    for (int i = 0; i < 6; i++) {
      globals.dist.add([]);
      for (int j = 0; j < 12; j++)
        globals.dist[globals.dist.length - 1].add([0, 0, 0, 0, 0]);

      if (globals.tiles[tile][0] != "r")
        globals.dist[globals.dist.length - 1][globals.tiles[tile][1] - 1]
            [globals.resourceIndex[globals.tiles[tile][0]]]++;
    }
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

//draws the coast and calls the function to draw the harbors
  void drawCoast() {
    List covered = [];
    covered.add(globals.coastVerts[0]);
    for (var i = 1; i < globals.coastVerts.length; i++) {
      List adjList = globals.vertGraph.getAdj(covered[covered.length - 1]);
      for (var j = 0; j < adjList.length; j++) {
        if (globals.coastVerts.contains(adjList[j]) &&
            !covered.contains(adjList[j])) {
          covered.add(adjList[j]);
          break;
        }
      }
    }
    globals.coastVerts = covered;

    drawHarbors();
    var paint = Paint()
      ..color = colors['sand']
      ..style = PaintingStyle.stroke
      ..strokeWidth = globals.refscale * .006;
    final shore = Path();
    shore.moveTo(globals.vertices[globals.coastVerts[0]][0],
        globals.vertices[globals.coastVerts[0]][1]);
    for (int i = 1; i < globals.coastVerts.length; i++)
      shore.lineTo(globals.vertices[globals.coastVerts[i]][0],
          globals.vertices[globals.coastVerts[i]][1]);
    shore.lineTo(globals.vertices[globals.coastVerts[0]][0],
        globals.vertices[globals.coastVerts[0]][1]);
    bgCanvas.drawPath(shore, paint);
  }

  //Calls draw harbor for each harbor in the standard board
  void drawHarbors() {
    drawHarbor(globals.coastVerts[1], globals.coastVerts[2], "w");
    drawHarbor(globals.coastVerts[5], globals.coastVerts[6], "o");
    drawHarbor(globals.coastVerts[8], globals.coastVerts[9], null);
    drawHarbor(globals.coastVerts[11], globals.coastVerts[12], "s");
    drawHarbor(globals.coastVerts[15], globals.coastVerts[16], null);
    drawHarbor(globals.coastVerts[18], globals.coastVerts[19], null);
    drawHarbor(globals.coastVerts[21], globals.coastVerts[22], "b");
    drawHarbor(globals.coastVerts[25], globals.coastVerts[26], "f");
    drawHarbor(globals.coastVerts[28], globals.coastVerts[29], null);
  }

  // draws a harbor at the given globals.vertices with the given resource
  void drawHarbor(pv1, pv2, res) {
    List inds = [null, "s", "o", "b", "w", "f"];
    //make v1 south of v2
    int v1, v2;
    if (globals.vertices[pv1][1] < globals.vertices[pv2][1]) {
      v1 = pv2;
      v2 = pv1;
    } else {
      v1 = pv1;
      v2 = pv2;
    }
    globals.portMap[v1] = inds.indexOf(res);
    globals.portMap[v2] = inds.indexOf(res);

    double bwW = globals.r / 5; // boardwalk width
    double bwL = globals.r / 2; // boardwalk length
    Paint paint = Paint()..color = colors['boardwalk'];

    if (harborDirection(v1, v2) == "E" || harborDirection(v1, v2) == "W") {
      if (harborDirection(v1, v2) == "W") bwL = -bwL;
      bgCanvas.drawRect(
          Rect.fromLTWH(
              globals.vertices[v2][0], globals.vertices[v2][1], bwL, bwW),
          paint);
      bgCanvas.drawRect(
          Rect.fromLTWH(
              globals.vertices[v2][0], globals.vertices[v1][1] - bwW, bwL, bwW),
          paint);
      Rect cirRect = Rect.fromCircle(
          center: Offset(globals.vertices[v2][0] + bwL * 2,
              globals.vertices[v2][1] + globals.r / 2),
          radius: globals.r * 0.3);
      paint = Paint()..color = colors['offwhite'];
      bgCanvas.drawArc(cirRect, 0, 2 * pi, true, paint);

      if (res == null) {
        //question mark
        TextSpan span = TextSpan(
            style: TextStyle(color: colors['brown'], fontSize: globals.r * 0.2),
            text: '?');
        TextPainter tp = TextPainter(
            text: span, textScaleFactor: 1.3, textDirection: TextDirection.ltr);
        tp.layout();
        tp.paint(
            bgCanvas,
            Offset(globals.vertices[v2][0] + bwL * 2 - (tp.width / 2),
                globals.vertices[v2][1] + globals.r / 2 - (tp.height)));
        //price
        span = TextSpan(
            style: TextStyle(color: colors['brown'], fontSize: globals.r * 0.2),
            text: '3:1');
        tp = TextPainter(
            text: span, textScaleFactor: 1.3, textDirection: TextDirection.ltr);
        tp.layout();
        tp.paint(
            bgCanvas,
            Offset(globals.vertices[v2][0] + bwL * 2 - (tp.width / 2),
                globals.vertices[v2][1] + globals.r / 2));
      } else {
        //circle
        paint = Paint()..color = colors[res];
        Rect cirRect = Rect.fromCircle(
            center: Offset(globals.vertices[v2][0] + bwL * 2,
                globals.vertices[v2][1] + globals.r / 2 - globals.r * 0.15),
            radius: globals.r * 0.15);
        bgCanvas.drawArc(cirRect, 0, 2 * pi, true, paint);
        //text
        TextSpan span = TextSpan(
            style: TextStyle(color: colors['brown'], fontSize: globals.r * 0.2),
            text: '2:1');
        TextPainter tp = TextPainter(
            text: span, textScaleFactor: 1.3, textDirection: TextDirection.ltr);
        tp.layout();
        tp.paint(
            bgCanvas,
            Offset(globals.vertices[v2][0] + bwL * 2 - (tp.width / 2),
                globals.vertices[v2][1] + globals.r / 2));
      }
    } else {
      //harbor at angle (default NE)
      //boardwalk 1
      int angle;
      if (harborDirection(v1, v2) == "SE")
        angle = 150;
      else if (harborDirection(v1, v2) == "SW") {
        angle = 210;
        v2 = v1;
      } else if (harborDirection(v1, v2) == "NW") {
        angle = -30;
        v2 = v1;
      } else
        angle = 30;
      final bw1 = Path();
      var paint = Paint()..color = colors['boardwalk'];
      bw1.moveTo(globals.vertices[v2][0], globals.vertices[v2][1]);
      bw1.lineTo(globals.vertices[v2][0] + sin((pi / 180) * angle) * bwL,
          globals.vertices[v2][1] - cos((pi / 180) * angle) * bwL);
      bw1.lineTo(
          globals.vertices[v2][0] +
              sin((pi / 180) * angle) * bwL +
              cos((pi / 180) * angle) * bwW,
          globals.vertices[v2][1] -
              cos((pi / 180) * angle) * bwL +
              sin((pi / 180) * angle) * bwW);
      bw1.lineTo(globals.vertices[v2][0] + cos((pi / 180) * angle) * bwW,
          globals.vertices[v2][1] + sin((pi / 180) * angle) * bwW);
      bw1.lineTo(globals.vertices[v2][0], globals.vertices[v2][1]);
      bgCanvas.drawPath(bw1, paint);
      // // boardwalk 2
      final bw2 = Path();
      bw2.moveTo(
          globals.vertices[v2][0] + cos((pi / 180) * angle) * (globals.r - bwW),
          globals.vertices[v2][1] +
              sin((pi / 180) * angle) * (globals.r - bwW));
      bw2.lineTo(
          globals.vertices[v2][0] +
              cos((pi / 180) * angle) * (globals.r - bwW) +
              sin((pi / 180) * angle) * bwL,
          globals.vertices[v2][1] +
              sin((pi / 180) * angle) * (globals.r - bwW) -
              cos((pi / 180) * angle) * bwL);
      bw2.lineTo(
          globals.vertices[v2][0] +
              cos((pi / 180) * angle) * (globals.r - bwW) +
              sin((pi / 180) * angle) * bwL +
              cos((pi / 180) * angle) * bwW,
          globals.vertices[v2][1] +
              sin((pi / 180) * angle) * (globals.r - bwW) -
              cos((pi / 180) * angle) * bwL +
              sin((pi / 180) * angle) * bwW);
      bw2.lineTo(
          globals.vertices[v2][0] +
              cos((pi / 180) * angle) * (globals.r - bwW) +
              cos((pi / 180) * angle) * bwW,
          globals.vertices[v2][1] +
              sin((pi / 180) * angle) * (globals.r - bwW) +
              sin((pi / 180) * angle) * bwW);
      bw2.lineTo(
          globals.vertices[v2][0] + cos((pi / 180) * angle) * (globals.r - bwW),
          globals.vertices[v2][1] +
              sin((pi / 180) * angle) * (globals.r - bwW));
      bgCanvas.drawPath(bw2, paint);
      // //port function circle
      Rect cirRect = Rect.fromCircle(
          center: Offset(
              globals.vertices[v2][0] +
                  sin((pi / 180) * (angle + 30)) *
                      sqrt(pow(globals.r / 2, 2) + pow(bwL * 2, 2)),
              globals.vertices[v2][1] -
                  cos((pi / 180) * (angle + 30)) *
                      sqrt(pow(globals.r / 2, 2) + pow(bwL * 2, 2))),
          radius: globals.r * 0.3);
      paint = Paint()..color = colors['offwhite'];
      bgCanvas.drawArc(cirRect, 0, 2 * pi, true, paint);
      // port function resource and text
      if (res == null) {
        //question mark
        TextSpan span = TextSpan(
            style: TextStyle(color: colors['brown'], fontSize: globals.r * 0.2),
            text: '?');
        TextPainter tp = TextPainter(
            text: span, textScaleFactor: 1.3, textDirection: TextDirection.ltr);
        tp.layout();
        tp.paint(
            bgCanvas,
            Offset(
                (globals.vertices[v2][0] +
                        sin((pi / 180) * (angle + 30)) *
                            sqrt(pow(globals.r / 2, 2) + pow(bwL * 2, 2))) -
                    (tp.width / 2),
                (globals.vertices[v2][1] -
                        cos((pi / 180) * (angle + 30)) *
                            sqrt(pow(globals.r / 2, 2) + pow(bwL * 2, 2))) -
                    (tp.height)));
        //price
        span = TextSpan(
            style: TextStyle(color: colors['brown'], fontSize: globals.r * 0.2),
            text: '3:1');
        tp = TextPainter(
            text: span, textScaleFactor: 1.3, textDirection: TextDirection.ltr);
        tp.layout();
        tp.paint(
            bgCanvas,
            Offset(
                (globals.vertices[v2][0] +
                        sin((pi / 180) * (angle + 30)) *
                            sqrt(pow(globals.r / 2, 2) + pow(bwL * 2, 2))) -
                    (tp.width / 2),
                (globals.vertices[v2][1] -
                    cos((pi / 180) * (angle + 30)) *
                        sqrt(pow(globals.r / 2, 2) + pow(bwL * 2, 2)))));
      } else {
        //circle
        paint = Paint()..color = colors[res];
        Rect cirRect = Rect.fromCircle(
            center: Offset(
                (globals.vertices[v2][0] +
                    sin((pi / 180) * (angle + 30)) *
                        sqrt(pow(globals.r / 2, 2) + pow(bwL * 2, 2))),
                (globals.vertices[v2][1] -
                        cos((pi / 180) * (angle + 30)) *
                            sqrt(pow(globals.r / 2, 2) + pow(bwL * 2, 2))) -
                    (globals.r * 0.15)),
            radius: globals.r * 0.15);
        bgCanvas.drawArc(cirRect, 0, 2 * pi, true, paint);
        //text
        TextSpan span = TextSpan(
            style: TextStyle(color: colors['brown'], fontSize: globals.r * 0.2),
            text: '2:1');
        TextPainter tp = TextPainter(
            text: span, textScaleFactor: 1.3, textDirection: TextDirection.ltr);
        tp.layout();
        tp.paint(
            bgCanvas,
            Offset(
                (globals.vertices[v2][0] +
                        sin((pi / 180) * (angle + 30)) *
                            sqrt(pow(globals.r / 2, 2) + pow(bwL * 2, 2))) -
                    (tp.width / 2),
                (globals.vertices[v2][1] -
                    cos((pi / 180) * (angle + 30)) *
                        sqrt(pow(globals.r / 2, 2) + pow(bwL * 2, 2)))));
      }
    }
  }

  //determines the direction of the coast
  String harborDirection(int v1, int v2) {
    var right = (sqrt(3) * globals.r) / 2;
    if ((globals.vertices[v1][0]).round() ==
        (globals.vertices[v2][0]).round()) {
      if ((globals.vertices[globals
                      .coastVerts[globals.coastVerts.indexOf(v2) + 1]][0])
                  .round() ==
              (globals.vertices[v2][0] + right).round() ||
          (globals.vertices[globals
                      .coastVerts[globals.coastVerts.indexOf(v1) - 1]][0])
                  .round() ==
              (globals.vertices[v2][0] + right).round())
        return "W";
      else
        return "E";
    } else {
      String dir = "";

      if ((globals.vertices[v1][1]).round() < globals.h / 2) dir = "N";

      if ((globals.vertices[v1][0] - right).round() ==
          (globals.vertices[v2][0]).round()) {
        if (dir == "N")
          dir = "NE";
        else
          dir = "SW";
      } else if (dir == "N") {
        dir = "NW";
      } else {
        dir = "SE";
      }
      return dir;
    }
  }

  //removes overlapping globals.vertices
  void removeDuplicates() {
    for (int i = 0; i < globals.vertices.length; i++) {
      int count = 0;
      for (int j = i + 1; j < globals.vertices.length; j++) {
        if ((globals.vertices[j][0]).round() ==
                (globals.vertices[i][0]).round() &&
            (globals.vertices[j][1]).round() ==
                (globals.vertices[i][1]).round()) {
          for (int k = 0; k < 12; k++) {
            for (int l = 0; l < 5; l++) {
              globals.dist[i][k][l] += globals.dist[j][k][l];
            }
          }

          globals.dist.removeRange(j, j + 1);
          globals.vertices.removeRange(j, j + 1);
          count++;
          j -= 1;
        }
      }
      if (count < 2) globals.coastVerts.add(i);
    }
  }

  //constructs an undirected graph of all globals.vertices and edges
  void constructGraph() {
    int numVerts = globals.vertices.length;
    globals.vertGraph = new Graph(numVerts);
    for (int i = 0; i < numVerts; i++) {
      globals.vertGraph.addVertex(i);
    }
    for (int i = 0; i < numVerts; i++) {
      List adj = getAdj(i);
      for (int j = 0; j < adj.length; j++) {
        if (adj[j] > i) {
          globals.vertGraph.addEdge(i, adj[j]);
        }
      }
    }
    // globals.vertGraph.printGraph();
  }

//checks the possible adjacent globals.vertices and returns their indeces
  List getAdj(i) {
    List adj = [];
    double xi = globals.vertices[i][0];
    double yi = globals.vertices[i][1];
    double x = xi;
    double y = yi - globals.r;
    double up = -globals.r / 2;
    double right = (sqrt(3) * globals.r) / 2;
    for (int k = 0; k < 6; k++) {
      if (k == 1) {
        y = yi + globals.r;
      } else if (k == 2) {
        x = xi + right;
        y = yi + up;
      } else if (k == 3) {
        y = yi - up;
      } else if (k == 4) {
        x = xi - right;
      } else if (k == 5) {
        y = yi + up;
      }
      for (int j = 0; j < globals.vertices.length; j++) {
        if ((globals.vertices[j][0]).round() == (x).round() &&
            (globals.vertices[j][1]).round() == (y).round()) {
          adj.add(j);
        }
      }
    }
    return adj;
  }

//draws circles at globals.vertices (used in debugging)
  void drawVertices() {
    for (int i = 0; i < globals.vertices.length; i++) {
      Rect cirRect = Rect.fromCircle(
          center: Offset(globals.vertices[i][0], globals.vertices[i][1]),
          radius: globals.r * 0.3);
      var paint = Paint()..color = Colors.black;
      bgCanvas.drawArc(cirRect, 0, 2 * pi, true, paint);
    }
    int target = 10;
    Rect cirRect = Rect.fromCircle(
        center:
            Offset(globals.vertices[target][0], globals.vertices[target][1]),
        radius: globals.r * 0.3);
    var paint = Paint()..color = Colors.red;
    bgCanvas.drawArc(cirRect, 0, 2 * pi, true, paint);
    List adj = getAdj(target);
    for (int i = 0; i < adj.length; i++) {
      Rect cirRect = Rect.fromCircle(
          center:
              Offset(globals.vertices[adj[i]][0], globals.vertices[adj[i]][1]),
          radius: globals.r * 0.3);
      var paint = Paint()..color = Colors.white;
      bgCanvas.drawArc(cirRect, 0, 2 * pi, true, paint);
    }
  }
}

class Graph {
  int noOfVertices;
  Map adjList;
  Graph(noOfVertices) {
    this.noOfVertices = noOfVertices;
    this.adjList = new Map();
  }

  addVertex(v) {
    // initialize the adjacency list
    this.adjList[v] = [];
  }

  addEdge(v, w) {
    this.adjList[v].add(w);
    this.adjList[w].add(v);
  }

  getAdj(key) {
    List temp = [];
    for (int j in this.adjList[key]) temp.add(j);
    return temp;
  }

  printGraph() {
    // get all the globals.vertices
    var getKeys = this.adjList.keys;

    // iterate over the globals.vertices
    for (int i in getKeys) {
      var getValues = this.adjList[i];
      String conc = "";

      for (int j in getValues) conc += j.toString() + " ";

      // print the vertex and its adjacency list
      print(i.toString() + " -> " + conc);
    }
  }

  dfs(startingNode) {
    List visited = [];
    List verts = [];
    for (var i = 0; i < this.noOfVertices; i++) visited[i] = false;

    this.dfsUtil(startingNode, visited);
    for (var n = 0; n < visited.length; n++) {
      if (visited[n]) verts.add(n);
    }
    return verts;
  }

  dfsUtil(vert, visited) {
    visited[vert] = true;

    var getNeighbors = this.adjList[vert];

    for (var i in getNeighbors) {
      var getElem = getNeighbors[i];
      if (!visited[getElem]) this.dfsUtil(getElem, visited);
    }
  }
}

class UIWidget extends StatefulWidget {
  @override
  _UIState createState() {
    return _UIState();
  }
}

class _UIState extends State<UIWidget> {
  @override
  Widget build(BuildContext context) {
    final double bcW = globals.refscale * 0.3;
    return Stack(children: <Widget>[
      //name
      uiButton(context, 'Name', 20, 20),
      //dice roll and number rolled
      Positioned(
          left: 20,
          top: 40 + globals.refscale * 0.07,
          child: MouseRegion(
              onHover: (event) {
                appContainer.style.cursor = 'pointer';
              },
              onExit: (event) {
                appContainer.style.cursor = 'default';
              },
              child: FlatButton(
                  padding: EdgeInsets.all(0),
                  color: Colors.transparent,
                  splashColor: colors['white'],
                  onPressed: () => print('Roll'),
                  child: SizedBox(
                      width: globals.refscale * .2,
                      height: globals.refscale * .1333334,
                      child: CustomPaint(
                        foregroundPainter: DicePainter(),
                        child: Container(),
                      ))))),
      //trade button
      uiButton(context, 'Trade', 20, 60 + (globals.refscale * 16) / 75),
      //end turn button
      uiButton(context, 'End Turn', 20, 80 + (globals.refscale * 22) / 75),
      //building cost card
      Positioned(
          left: globals.w - bcW - 20,
          top: 20,
          child: SizedBox(
              width: globals.refscale * .3,
              height: globals.refscale * .44,
              child: DecoratedBox(
                  decoration: BoxDecoration(
                      color: colors['beige'],
                      border: Border.all(
                          color: Colors.orange,
                          width: globals.refscale * 0.01)),
                  child: Stack(
                    children: <Widget>[
                      //title
                      Align(
                          alignment: Alignment(0, -0.93),
                          child: Text(
                            'Building Costs',
                            style: TextStyle(
                                fontSize: globals.refscale * 0.04,
                                color: colors['brown']),
                            textAlign: TextAlign.center,
                          )),
                      //Road label
                      Align(
                          alignment: Alignment(0, -0.617),
                          child: Container(
                              margin: EdgeInsets.all(0),
                              padding: EdgeInsets.all(0),
                              child: MouseRegion(
                                  onHover: (event) {
                                    appContainer.style.cursor = 'pointer';
                                  },
                                  onExit: (event) {
                                    appContainer.style.cursor = 'default';
                                  },
                                  child: FlatButton(
                                      padding: EdgeInsets.all(0),
                                      color: Colors.transparent,
                                      splashColor: colors['brown'],
                                      onPressed: () => print('Road'),
                                      child: SizedBox(
                                          width: globals.refscale * .28,
                                          height: globals.refscale * .085,
                                          child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: globals.refscale * .01,
                                                  top:
                                                      globals.refscale * 0.005),
                                              child: Text('Road',
                                                  style: TextStyle(
                                                      fontSize:
                                                          globals.refscale *
                                                              0.03,
                                                      color: colors['brown']),
                                                  textAlign:
                                                      TextAlign.left))))))),
                      //Settlement label
                      Align(
                          alignment: Alignment(0, -0.124),
                          child: Container(
                              margin: EdgeInsets.all(0),
                              padding: EdgeInsets.all(0),
                              child: MouseRegion(
                                  onHover: (event) {
                                    appContainer.style.cursor = 'pointer';
                                  },
                                  onExit: (event) {
                                    appContainer.style.cursor = 'default';
                                  },
                                  child: FlatButton(
                                      padding: EdgeInsets.all(0),
                                      color: Colors.transparent,
                                      splashColor: colors['brown'],
                                      onPressed: () => print('Settlement'),
                                      child: SizedBox(
                                          width: globals.refscale * .28,
                                          height: globals.refscale * .085,
                                          child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: globals.refscale * .01,
                                                  top:
                                                      globals.refscale * 0.005),
                                              child: Text('Settlement',
                                                  style: TextStyle(
                                                      fontSize:
                                                          globals.refscale *
                                                              0.03,
                                                      color: colors['brown']),
                                                  textAlign:
                                                      TextAlign.left))))))),
                      //City label
                      Align(
                          alignment: Alignment(0, 0.37),
                          child: Container(
                              margin: EdgeInsets.all(0),
                              padding: EdgeInsets.all(0),
                              child: MouseRegion(
                                  onHover: (event) {
                                    appContainer.style.cursor = 'pointer';
                                  },
                                  onExit: (event) {
                                    appContainer.style.cursor = 'default';
                                  },
                                  child: FlatButton(
                                      padding: EdgeInsets.all(0),
                                      color: Colors.transparent,
                                      splashColor: colors['brown'],
                                      onPressed: () => print('City'),
                                      child: SizedBox(
                                          width: globals.refscale * .28,
                                          height: globals.refscale * .085,
                                          child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: globals.refscale * .01,
                                                  top:
                                                      globals.refscale * 0.005),
                                              child: Text('City',
                                                  style: TextStyle(
                                                      fontSize:
                                                          globals.refscale *
                                                              0.03,
                                                      color: colors['brown']),
                                                  textAlign:
                                                      TextAlign.left))))))),
                      //Development Card label
                      Align(
                          alignment: Alignment(0, 0.868),
                          child: Container(
                              margin: EdgeInsets.all(0),
                              padding: EdgeInsets.all(0),
                              child: MouseRegion(
                                  onHover: (event) {
                                    appContainer.style.cursor = 'pointer';
                                  },
                                  onExit: (event) {
                                    appContainer.style.cursor = 'default';
                                  },
                                  child: FlatButton(
                                      padding: EdgeInsets.all(0),
                                      color: Colors.transparent,
                                      splashColor: colors['brown'],
                                      onPressed: () =>
                                          print('Development Card'),
                                      child: SizedBox(
                                          width: globals.refscale * .28,
                                          height: globals.refscale * .085,
                                          child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: globals.refscale * .01,
                                                  top:
                                                      globals.refscale * 0.005),
                                              child: Text('Development\nCard',
                                                  style: TextStyle(
                                                      fontSize:
                                                          globals.refscale *
                                                              0.03,
                                                      color: colors['brown']),
                                                  textAlign:
                                                      TextAlign.left))))))),
                      //building costs costs and lines
                      CustomPaint(
                          foregroundPainter: BuildingCostPainter(),
                          child: Container()),
                    ],
                  )))),
    ]);
  }

  Widget uiButton(BuildContext context, txt, x, y) {
    return Positioned(
        left: x,
        top: y,
        child: SizedBox(
            width: globals.refscale * .3,
            height: globals.refscale * .08,
            child: Container(
                child: MouseRegion(
                    onHover: (event) {
                      appContainer.style.cursor = 'pointer';
                    },
                    onExit: (event) {
                      appContainer.style.cursor = 'default';
                    },
                    child: FlatButton(
                      color: colors['beige'],
                      splashColor: colors['brown'],
                      onPressed: () => print(txt),
                      child: AutoSizeText(txt,
                          style:
                              TextStyle(fontSize: 30.0, color: colors['brown']),
                          maxLines: 1),
                    )))));
  }
}

class DicePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
        Rect.fromLTWH(0, 0, globals.refscale * 0.1, globals.refscale * 0.1),
        Paint()..color = colors['white']);
    canvas.drawRect(
        Rect.fromLTWH(globals.refscale * 0.1, globals.refscale * 0.1 / 3,
            globals.refscale * 0.1, globals.refscale * 0.1),
        Paint()..color = colors['white']);
    canvas.drawArc(
        Rect.fromCircle(
            center: Offset(globals.refscale * 0.05, globals.refscale * 0.05),
            radius: globals.refscale * 0.01),
        0,
        2 * pi,
        true,
        Paint()..color = colors['black']);
    canvas.drawArc(
        Rect.fromCircle(
            center: Offset(globals.refscale * 0.15, globals.refscale / 12),
            radius: globals.refscale * 0.01),
        0,
        2 * pi,
        true,
        Paint()..color = colors['black']);
    canvas.drawArc(
        Rect.fromCircle(
            center: Offset(globals.refscale * 0.15 - globals.refscale / 40,
                globals.refscale / 12 - globals.refscale / 40),
            radius: globals.refscale * 0.01),
        0,
        2 * pi,
        true,
        Paint()..color = colors['black']);
    canvas.drawArc(
        Rect.fromCircle(
            center: Offset(globals.refscale * 0.15 + globals.refscale / 40,
                globals.refscale / 12 + globals.refscale / 40),
            radius: globals.refscale * 0.01),
        0,
        2 * pi,
        true,
        Paint()..color = colors['black']);
  }

  bool shouldRepaint(BuildingCostPainter oldDelegate) => false;
}

class BuildingCostPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    //separation line 1
    canvas.drawLine(
      Offset(globals.refscale * 0.02, size.height * 0.15),
      Offset(size.width - globals.refscale * 0.02, size.height * 0.15),
      Paint()
        ..color = colors['brown']
        ..strokeWidth = globals.refscale * .003,
    );
    //Road Costs
    canvas.drawRect(
        Rect.fromLTWH(size.width - globals.refscale * 0.06, size.height * 0.24,
            globals.refscale * 0.04, globals.refscale * 0.04),
        Paint()..color = colors['f']);
    canvas.drawRect(
        Rect.fromLTWH(size.width - globals.refscale * 0.105, size.height * 0.24,
            globals.refscale * 0.04, globals.refscale * 0.04),
        Paint()..color = colors['b']);
    //separation line 2
    canvas.drawLine(
      Offset(globals.refscale * 0.02, size.height * 0.35),
      Offset(size.width - globals.refscale * 0.02, size.height * 0.35),
      Paint()
        ..color = colors['brown']
        ..strokeWidth = globals.refscale * .003,
    );
    //Settlement Costs
    canvas.drawRect(
        Rect.fromLTWH(size.width - globals.refscale * 0.06, size.height * 0.44,
            globals.refscale * 0.04, globals.refscale * 0.04),
        Paint()..color = colors['s']);
    canvas.drawRect(
        Rect.fromLTWH(size.width - globals.refscale * 0.105, size.height * 0.44,
            globals.refscale * 0.04, globals.refscale * 0.04),
        Paint()..color = colors['w']);
    canvas.drawRect(
        Rect.fromLTWH(size.width - globals.refscale * 0.15, size.height * 0.44,
            globals.refscale * 0.04, globals.refscale * 0.04),
        Paint()..color = colors['f']);
    canvas.drawRect(
        Rect.fromLTWH(size.width - globals.refscale * 0.195, size.height * 0.44,
            globals.refscale * 0.04, globals.refscale * 0.04),
        Paint()..color = colors['b']);
    //separation line 3
    canvas.drawLine(
      Offset(globals.refscale * 0.02, size.height * 0.55),
      Offset(size.width - globals.refscale * 0.02, size.height * 0.55),
      Paint()
        ..color = colors['brown']
        ..strokeWidth = globals.refscale * .003,
    );
    //City Costs
    canvas.drawRect(
        Rect.fromLTWH(size.width - globals.refscale * 0.06, size.height * 0.64,
            globals.refscale * 0.04, globals.refscale * 0.04),
        Paint()..color = colors['o']);
    canvas.drawRect(
        Rect.fromLTWH(size.width - globals.refscale * 0.105, size.height * 0.64,
            globals.refscale * 0.04, globals.refscale * 0.04),
        Paint()..color = colors['o']);
    canvas.drawRect(
        Rect.fromLTWH(size.width - globals.refscale * 0.15, size.height * 0.64,
            globals.refscale * 0.04, globals.refscale * 0.04),
        Paint()..color = colors['o']);
    canvas.drawRect(
        Rect.fromLTWH(size.width - globals.refscale * 0.195, size.height * 0.64,
            globals.refscale * 0.04, globals.refscale * 0.04),
        Paint()..color = colors['w']);
    canvas.drawRect(
        Rect.fromLTWH(size.width - globals.refscale * 0.24, size.height * 0.64,
            globals.refscale * 0.04, globals.refscale * 0.04),
        Paint()..color = colors['w']);
    //separation line 4
    canvas.drawLine(
      Offset(globals.refscale * 0.02, size.height * 0.75),
      Offset(size.width - globals.refscale * 0.02, size.height * 0.75),
      Paint()
        ..color = colors['brown']
        ..strokeWidth = globals.refscale * .003,
    );
    //Development Card Costs
    canvas.drawRect(
        Rect.fromLTWH(size.width - globals.refscale * 0.06, size.height * 0.84,
            globals.refscale * 0.04, globals.refscale * 0.04),
        Paint()..color = colors['o']);
    canvas.drawRect(
        Rect.fromLTWH(size.width - globals.refscale * 0.105, size.height * 0.84,
            globals.refscale * 0.04, globals.refscale * 0.04),
        Paint()..color = colors['w']);
    canvas.drawRect(
        Rect.fromLTWH(size.width - globals.refscale * 0.15, size.height * 0.84,
            globals.refscale * 0.04, globals.refscale * 0.04),
        Paint()..color = colors['s']);
    //separation line 5
    canvas.drawLine(
      Offset(globals.refscale * 0.02, size.height * 0.95),
      Offset(size.width - globals.refscale * 0.02, size.height * 0.95),
      Paint()
        ..color = colors['brown']
        ..strokeWidth = globals.refscale * .003,
    );
  }

  bool shouldRepaint(BuildingCostPainter oldDelegate) => false;
}

class PlaceGamePiece extends StatefulWidget {
  @override
  _PlacePiece createState() {
    return _PlacePiece();
  }
}

class _PlacePiece extends State<PlaceGamePiece> {
  double x = 0.0;
  double y = 0.0;

  void _updateLocation(PointerEvent details) {
    setState(() {
      x = details.position.dx;
      y = details.position.dy;
    });
    // print(x);
  }

  @override
  Widget build(BuildContext context) {
    print('yes');
    return GestureDetector(
        onTap: () {
          setState(() {
            globals.placeRoad = true;
          });
        },
        child: CustomPaint(
            painter: DrawGamePieces(x, y),
            child: MouseRegion(onHover: _updateLocation)));
  }
}

class DrawGamePieces extends CustomPainter {
  Canvas gpCanvas;
  // int nearestVert;
  double x, y;
  DrawGamePieces(this.x, this.y);

  void paint(Canvas canvas, Size size) {
    gpCanvas = canvas;
    var rect = Offset.zero & size;
    canvas.drawRect(
      rect,
      Paint()..color = Colors.transparent,
    );
    if (globals.placeSet) {
      globals.placeSet = false;
      Paint paint = Paint()..color = colors['selection'];
      Rect rect = Rect.fromLTWH(
          globals.vertices[globals.nearestVert][0] - globals.sW / 2,
          globals.vertices[globals.nearestVert][1] - globals.sH / 2,
          globals.sW,
          globals.sH);
      gpCanvas.drawRect(rect, paint);
    } else if (globals.placeCit) {
      globals.placeCit = false;
      Paint paint = Paint()..color = colors['selection'];
      Rect rect = Rect.fromLTWH(
          globals.vertices[globals.nearestVert][0] - globals.sW / 2,
          globals.vertices[globals.nearestVert][1],
          globals.sH,
          globals.sW);
      gpCanvas.drawRect(rect, paint);
    } else if (globals.placeRoad) {
      globals.placeRoad = false;
      Paint paint = Paint()
        ..color = colors['selection']
        ..style = PaintingStyle.stroke
        ..strokeWidth = globals.refscale * .008;
      gpCanvas.drawLine(
          Offset(globals.vertices[globals.nearestVert][0],
              globals.vertices[globals.nearestVert][1]),
          Offset(globals.vertices[globals.closest][0],
              globals.vertices[globals.closest][1]),
          paint);
    } else {
      roadVis();
    }
  }

  void roadVis() {
    if (!globals.start) {
      double nearestX, nearestY;
      bool found = false;
      //find nearest x
      for (int i = 0; i < globals.vertexXs.length; i++) {
        if (x < globals.vertexXs[i] + globals.vertexXd / 2) {
          nearestX = globals.vertexXs[i];
          found = true;
          break;
        }
      }
      if (!found) {
        nearestX = globals.vertexXs[globals.vertexXs.length - 1];
      }

      //find nearest y
      if (globals.storedNx != nearestX) {
        //list of possible
        globals.vertexYs = [];
        globals.possVerts = [];
        for (int i = 0; i < globals.vertices.length; i++) {
          if (globals.vertices[i][0].round() == nearestX &&
              !globals.vertexYs.contains(globals.vertices[i][1].round())) {
            globals.vertexYs.add(globals.vertices[i][1].round());
            globals.possVerts.add(i);
          }
        }
        globals.unsortedYs = [...globals.vertexYs];
        globals.vertexYs.sort();
      }
      //find nearest
      found = false;
      for (int i = 0; i < globals.vertexYs.length - 1; i++) {
        if (y <
            globals.vertexYs[i] +
                (globals.vertexYs[i + 1] - globals.vertexYs[i]) / 2) {
          nearestY = globals.vertexYs[i];
          found = true;
          break;
        }
      }
      if (!found) {
        nearestY = globals.vertexYs[globals.vertexYs.length - 1];
      }
      globals.nearestVert =
          globals.possVerts[globals.unsortedYs.indexOf(nearestY)];
      globals.storedNx = nearestX;

      //find nearest adjacent
      List adj = globals.vertGraph.getAdj(globals.nearestVert);
      double dist = (x - globals.vertices[adj[0]][0]).abs() +
          (y - globals.vertices[adj[0]][1]).abs();
      globals.closest = adj[0];
      for (int i = 1; i < adj.length; i++) {
        if ((x - globals.vertices[adj[i]][0]).abs() +
                (y - globals.vertices[adj[i]][1]).abs() <
            dist) {
          dist = (x - globals.vertices[adj[i]][0]).abs() +
              (y - globals.vertices[adj[i]][1]).abs();
          globals.closest = adj[i];
        }
      }
      Paint paint = Paint()
        ..color = colors['selection']
        ..style = PaintingStyle.stroke
        ..strokeWidth = globals.refscale * .008;
      gpCanvas.drawLine(
          Offset(globals.vertices[globals.nearestVert][0],
              globals.vertices[globals.nearestVert][1]),
          Offset(globals.vertices[globals.closest][0],
              globals.vertices[globals.closest][1]),
          paint);
    }
  }

  void settlementVis() {
    double nearestX, nearestY;
    bool found = false;
    var paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = globals.refscale * .006;
    //find nearest x
    for (int i = 0; i < globals.vertexXs.length; i++) {
      if (x < globals.vertexXs[i] + globals.vertexXd / 2) {
        nearestX = globals.vertexXs[i];
        found = true;
        break;
      }
    }
    if (!found) {
      nearestX = globals.vertexXs[globals.vertexXs.length - 1];
    }
    // gpCanvas.drawLine(Offset(nearestX, 0), Offset(nearestX, globals.h), paint);

    //find nearest y
    if (globals.storedNx != nearestX) {
      //list of possible
      globals.vertexYs = [];
      globals.possVerts = [];
      for (int i = 0; i < globals.vertices.length; i++) {
        if (globals.vertices[i][0].round() == nearestX &&
            !globals.vertexYs.contains(globals.vertices[i][1].round())) {
          globals.vertexYs.add(globals.vertices[i][1].round());
          globals.possVerts.add(i);
        }
      }
      globals.unsortedYs = [...globals.vertexYs];
      globals.vertexYs.sort();
    }
    //find nearest
    found = false;
    for (int i = 0; i < globals.vertexYs.length - 1; i++) {
      if (y <
          globals.vertexYs[i] +
              (globals.vertexYs[i + 1] - globals.vertexYs[i]) / 2) {
        nearestY = globals.vertexYs[i];
        found = true;
        break;
      }
    }
    if (!found) {
      nearestY = globals.vertexYs[globals.vertexYs.length - 1];
    }
    // gpCanvas.drawLine(Offset(0, nearestY), Offset(globals.w, nearestY), paint);
    globals.nearestVert =
        globals.possVerts[globals.unsortedYs.indexOf(nearestY)];
    globals.storedNx = nearestX;

    paint = Paint()..color = colors['selection'];
    Rect rect = Rect.fromLTWH(nearestX - globals.sW / 2,
        nearestY - globals.sH / 2, globals.sW, globals.sH);
    gpCanvas.drawRect(rect, paint);
  }

  bool shouldRepaint(DrawGamePieces oldDelegate) => true;
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
