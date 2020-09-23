import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:math';
import 'package:meta/meta.dart';

import 'globals.dart' as globals;
import 'main.dart';

class NameForm extends StatefulWidget {
  @override
  _NameFormState createState() {
    return _NameFormState();
  }
}

class _NameFormState extends State<NameForm> {
  void _showOrderScreen() {
    Navigator.of(context).pushNamed('/order');
  }

  final myController = TextEditingController();
  final FocusNode fn = FocusNode();
  void _requestFocus() {
    setState(() {
      FocusScope.of(context).requestFocus(fn);
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  void _submission() {
    var name = myController.text;
    myController.clear();
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(
        name,
        style:
            TextStyle(color: colors['white'], fontSize: globals.refscale * .05),
      ),
      backgroundColor: colors['brown'],
    ));

    Map a = new Map();
    a = {
      "color": "",
      "hand": [20, 20, 20, 20, 20],
      "points": 0,
      "settlements": [],
      "roads": [],
      "road_graph": Graph(50),
      "road_verts": [],
      "ports": [],
      "dev_cards": [0, 0, 0, 0, 0],
      "used_dev_cards": [0, 0, 0, 0],
      "longest_road": false,
      "largest_army": false
    };
    globals.players[name] = a;
    a = null;
  }

  int count = 0;

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    globals.w = screenSize.width;
    globals.h = screenSize.height;
    globals.refscale = (globals.w < globals.h) ? globals.w : globals.h;

    return Column(children: <Widget>[
      Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 7.0,
            color: colors['brown'],
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(30.0),
      ),
      Text('Enter Name',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 40.0, color: colors['black'])),
      Padding(
        padding: const EdgeInsets.all(30.0),
        child: TextFormField(
          controller: myController,
          onFieldSubmitted: (value) {
            if (!globals.players.containsKey(value) &&
                !['', ' ', null, false].contains(value)) {
              count++;
              print(globals.numPlayers);
              print(count);
              _submission();
              if (count == globals.numPlayers) {
                print('ye');
                _showOrderScreen();
              }
            }
          },
          focusNode: fn,
          onTap: _requestFocus,
          cursorColor: colors['brown'],
          style: TextStyle(
              color: colors['brown'], fontSize: globals.refscale * .08),
          decoration: InputDecoration(
            fillColor: colors['white'],
            filled: true,
            labelText: 'Name',
            labelStyle: TextStyle(
                color: colors['brown'], fontSize: globals.refscale * .03),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: colors['brown'], width: 5.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: colors['brown'], width: 5.0),
            ),
          ),
          validator: (value) {
            if (value.isEmpty) {
              return 'Please enter name';
            }
            return null;
          },
        ),
      ),
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
  void _showColorScreen() {
    Navigator.of(context).pushNamed('/local/colors');
  }

  @override
  Widget build(BuildContext context) {
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
              onTap: _showColorScreen,
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

class ColorChoice extends StatefulWidget {
  @override
  _ColorChoice createState() {
    return _ColorChoice();
  }
}

class _ColorChoice extends State<ColorChoice> {
  int count = 0;
  List<Widget> colorButtons = [];
  List<bool> _buttonDisabled = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];
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
  void _showGameScreen() {
    Navigator.of(context).pushNamed('/local/game');
  }

  void _nextPlayer(i) {
    globals.players[globals.playerOrder[count]]['color'] = playerColors[i];
    playerColors[i] = colors['beige'];
    _buttonDisabled[i] = true;
    count++;
    if (count == globals.numPlayers) _showGameScreen();
  }

  @override
  Widget build(BuildContext context) {
    var x = globals.w / 2 -
        (globals.w * 0.15 + globals.w * 0.01) * 2 -
        globals.w * 0.15 / 2;
    var y = globals.h / 2 - globals.w * 0.1;
    for (int i = 0; i < 10; i++) {
      colorButtons.add(colorButton(context, i, x, y));
      x += globals.w * 0.15 + globals.refscale * 0.01;
      if (i == 4) {
        y = globals.h / 2 + globals.refscale * 0.11;
        x = globals.w / 2 -
            (globals.w * 0.15 + globals.w * 0.01) * 2 -
            globals.w * 0.15 / 2;
      }
    }
    if (count == globals.numPlayers) {
      return Container();
    } else {
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
                    child: (Text(globals.playerOrder[count],
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 40.0))))),
            Stack(
              children: colorButtons,
            )
          ],
        ),
      );
    }
  }

  Widget colorButton(BuildContext context, i, x, y) {
    return Positioned(
        left: x,
        top: y,
        child: SizedBox(
            width: globals.w * 0.15,
            height: globals.w * 0.15,
            child: Container(
                child: MouseRegion(
                    onHover: (event) {
                      appContainer.style.cursor = 'pointer';
                    },
                    onExit: (event) {
                      appContainer.style.cursor = 'default';
                    },
                    child: FlatButton(
                        color: playerColors[i],
                        splashColor: colors['white'],
                        onPressed: () => _buttonDisabled[i]
                            ? null
                            : setState(() {
                                _nextPlayer(i);
                              }),
                        child: Container())))));
  }
}

class InitLocalGame extends StatelessWidget {
  //initializes the tiles
  void initTiles() {
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
      globals.tiles.add([newRes, diceNum]);
      if (newRes == "r") globals.robberLoc = i;
    }
  }

//stores the tile center coordinates
  void findCenters() {
    double right = (sqrt(3) * globals.r) / 2;
    double down = 1.5 * globals.r;
    double xi = globals.w / 2 - right * 4; // hexagon x
    double yi = globals.h / 2 - down * 2; // hexagon y
    double x = xi;
    double y = yi;
    for (int i = 0; i < globals.tiles.length; i++) {
      if (i == 3 || i == 7) {
        xi -= right;
        x = xi;
        y += down;
      } else if (i == 12 || i == 16) {
        xi += right;
        x = xi;
        y += down;
      }
      x += right * 2;

      globals.tileCenters.add([x, y]);
    }
  }

  //initializes the coordinates of the vertices
  void initVerts() {
    var hexagon = [
      0,
      globals.r,
      (sqrt(3) * globals.r) / 2,
      globals.r / 2,
      (sqrt(3) * globals.r) / 2,
      -globals.r / 2,
      0,
      -globals.r,
      -(sqrt(3) * globals.r) / 2,
      -globals.r / 2,
      -(sqrt(3) * globals.r) / 2,
      globals.r / 2,
    ];
    double right = (sqrt(3) * globals.r) / 2;
    double down = 1.5 * globals.r;
    double xi = globals.w / 2 - right * 4; // hexagon x
    double yi = globals.h / 2 - down * 2; // hexagon y
    double x = xi;
    double y = yi;
    for (int i = 0; i < globals.tiles.length; i++) {
      if (i == 3 || i == 7) {
        xi -= right;
        x = xi;
        y += down;
      } else if (i == 12 || i == 16) {
        xi += right;
        x = xi;
        y += down;
      }
      x += right * 2;
      for (int k = 0; k < 6; k++) {
        globals.dist.add([]);
        for (int j = 0; j < 12; j++)
          globals.dist[globals.dist.length - 1].add([0, 0, 0, 0, 0]);

        if (globals.tiles[i][0] != "r")
          globals.dist[globals.dist.length - 1][globals.tiles[i][1] - 1]
              [globals.resourceIndex[globals.tiles[i][0]]]++;
      }
      globals.vertices.add([hexagon[0] + x, hexagon[1] + y]);
      for (int l = 2; l < hexagon.length - 1; l += 2) {
        globals.vertices.add([hexagon[l] + x, hexagon[l + 1] + y]);
      }
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

  //sets a list of all vertex xs for use by gamepeice placement
  void vertexXs() {
    for (int i = 0; i < globals.vertices.length; i++) {
      if (!globals.vertexXs.contains(globals.vertices[i][0].round()))
        globals.vertexXs.add(globals.vertices[i][0].round());
    }
    globals.vertexXs.sort();
    globals.vertexXd = globals.vertexXs[1] - globals.vertexXs[0];
  }

  @override
  Widget build(BuildContext context) {
    print('Initializing Board...');
    initTiles();
    findCenters();
    initVerts();
    removeDuplicates();
    constructGraph();
    vertexXs();
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
        PlaceGamePiece()
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
    //draw background
    var rect = Offset.zero & size;
    canvas.drawRect(
      rect,
      Paint()..color = colors['water'],
    );
    drawTiles();
    drawThief();
    drawCoast();
  }

  @override
  bool shouldRepaint(GameBoard oldDelegate) => false;

  //draws all of the game tiles in the standard 3-4-5-4-3 config with the resource color and number chips
  void drawTiles() {
    double right = (sqrt(3) * globals.r) / 2;
    double down = 1.5 * globals.r;
    double xi = globals.w / 2 - right * 4; // hexagon x
    double yi = globals.h / 2 - down * 2; // hexagon y
    double x = xi;
    double y = yi;
    for (int i = 0; i < globals.tiles.length; i++) {
      if (i == 3 || i == 7) {
        xi -= right;
        x = xi;
        y += down;
      } else if (i == 12 || i == 16) {
        xi += right;
        x = xi;
        y += down;
      }
      x += right * 2;

      drawHexagon(x, y, i);
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

  //draws the theif at game start
  void drawThief() {
    Rect cirRect = Rect.fromCircle(
        center: Offset(globals.tileCenters[globals.robberLoc][0],
            globals.tileCenters[globals.robberLoc][1]),
        radius: globals.r * 0.3);
    var paint = Paint()..color = colors['darkgrey'];
    bgCanvas.drawArc(cirRect, 0, 2 * pi, true, paint);
  }

// draws a hexagon at the given position with a given tile
  void drawHexagon(double x, double y, int tile) {
    List hexagon = [
      0,
      globals.r,
      (sqrt(3) * globals.r) / 2,
      globals.r / 2,
      (sqrt(3) * globals.r) / 2,
      -globals.r / 2,
      0,
      -globals.r,
      -(sqrt(3) * globals.r) / 2,
      -globals.r / 2,
      -(sqrt(3) * globals.r) / 2,
      globals.r / 2,
    ];

    var paint = Paint()..color = colors[globals.tiles[tile][0]];
    final hex = Path();
    hex.moveTo(hexagon[0] + x, hexagon[1] + y);
    for (int i = 2; i < hexagon.length - 1; i += 2) {
      hex.lineTo(hexagon[i] + x, hexagon[i + 1] + y);
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

//draws circles at globals.vertices (used in debugging)
  // void drawVertices() {
  //   for (int i = 0; i < globals.vertices.length; i++) {
  //     Rect cirRect = Rect.fromCircle(
  //         center: Offset(globals.vertices[i][0], globals.vertices[i][1]),
  //         radius: globals.r * 0.3);
  //     var paint = Paint()..color = Colors.black;
  //     bgCanvas.drawArc(cirRect, 0, 2 * pi, true, paint);
  //   }
  //   int target = 10;
  //   Rect cirRect = Rect.fromCircle(
  //       center:
  //           Offset(globals.vertices[target][0], globals.vertices[target][1]),
  //       radius: globals.r * 0.3);
  //   var paint = Paint()..color = Colors.red;
  //   bgCanvas.drawArc(cirRect, 0, 2 * pi, true, paint);
  //   List adj = getAdj(target);
  //   for (int i = 0; i < adj.length; i++) {
  //     Rect cirRect = Rect.fromCircle(
  //         center:
  //             Offset(globals.vertices[adj[i]][0], globals.vertices[adj[i]][1]),
  //         radius: globals.r * 0.3);
  //     var paint = Paint()..color = Colors.white;
  //     bgCanvas.drawArc(cirRect, 0, 2 * pi, true, paint);
  //   }
  // }
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
    for (var i = 0; i < this.noOfVertices; i++) visited.add(false);

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
      var getElem = i;
      if (!visited[getElem]) this.dfsUtil(getElem, visited);
    }
  }
}

class UIWidget extends StatefulWidget {
  final Function() notifyParent;
  UIWidget({Key key, @required this.notifyParent});
  @override
  _UIState createState() {
    return _UIState(notifyParent: notifyParent);
  }
}

class _UIState extends State<UIWidget> {
  final Function() notifyParent;
  _UIState({Key key, @required this.notifyParent});

  void rollDice() {
    if (!globals.rolled) {
      setState(() {
        globals.rolled = true;
        var rand = Random();
        globals.diceNum = (rand.nextDouble() * 6).floor() +
            1 +
            (rand.nextDouble() * 6).floor() +
            1;
      });
      if (globals.diceNum != 7) {
        distributeResources();
      } else {
        setState(() {
          globals.placeP = 't';
          widget.notifyParent();
        });
      }
    }
  }

  void distributeResources() {
    double x = globals.tileCenters[globals.robberLoc][0];
    double y = globals.tileCenters[globals.robberLoc][1];
    List robberCoords = [];
    List robberVerts = [];
    List hexagon = [
      0,
      globals.r,
      (sqrt(3) * globals.r) / 2,
      globals.r / 2,
      (sqrt(3) * globals.r) / 2,
      -globals.r / 2,
      0,
      -globals.r,
      -(sqrt(3) * globals.r) / 2,
      -globals.r / 2,
      -(sqrt(3) * globals.r) / 2,
      globals.r / 2,
    ];

    for (int i = 0; i < hexagon.length - 1; i += 2) {
      robberCoords.add([
        (hexagon[i] + x).round(),
        (hexagon[i + 1] + y).round(),
      ]);
    }
    for (int j = 0; j < 6; j++) {
      for (int i = 0; i < globals.vertices.length; i++) {
        if ((globals.vertices[i][0]).round() == robberCoords[j][0] &&
            (globals.vertices[i][1]).round() == robberCoords[j][1]) {
          robberVerts.add(i);
        }
      }
    }

    for (int i = 0; i < globals.storedSettlements.length; i++) {
      for (int k = 0; k < 5; k++) {
        if (robberVerts
                .contains(globals.vertices[globals.storedSettlements[i][0]]) &&
            globals.tiles[globals.robberLoc][1] == globals.diceNum &&
            globals.resourceIndex[globals.tiles[globals.robberLoc][0]] == k) {
        } else {
          globals.players[globals.storedSettlements[i][1]]['hand'][k] += globals
              .dist[globals.storedSettlements[i][0]][globals.diceNum - 1][k];
        }
      }
    }
    for (int i = 0; i < globals.storedCities.length; i++) {
      for (int k = 0; k < 5; k++) {
        if (robberVerts
                .contains(globals.vertices[globals.storedCities[i][0]]) &&
            globals.tiles[globals.robberLoc][1] == globals.diceNum &&
            globals.resourceIndex[globals.tiles[globals.robberLoc][0]] == k) {
        } else {
          globals.players[globals.storedCities[i][1]]['hand'][k] +=
              globals.dist[globals.storedCities[i][0]][globals.diceNum - 1][k];
        }
      }
    }
  }

  void _getDevCard() {
    setState(() {
      globals.players[globals.playerOrder[globals.currPlayer]]['hand'][0]--;
      globals.players[globals.playerOrder[globals.currPlayer]]['hand'][1]--;
      globals.players[globals.playerOrder[globals.currPlayer]]['hand'][3]--;
    });
    int card;
    int rand = (Random().nextDouble() * 25).floor();
    if (rand <= 13)
      card = 0;
    else if (rand <= 18)
      card = 1;
    else if (rand <= 20)
      card = 2;
    else if (rand <= 22)
      card = 3;
    else
      card = 4;
    if (card == 4)
      globals.players[globals.playerOrder[globals.currPlayer]]['points']++;
    globals.players[globals.playerOrder[globals.currPlayer]]['dev_cards']
        [card]++;
  }

  void _handleButton(func) {
    if (func == 'trade') {
      setState(() {
        globals.dispTrade = true;
      });
    }
    if (func == 'end') {
      if (globals.rolled) {
        globals.rolled = false;
        setState(() {
          if (globals.currPlayer == globals.numPlayers - 1)
            globals.currPlayer = 0;
          else
            globals.currPlayer++;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double bcW = globals.refscale * 0.3;
    bool lrBool = false;
    bool laBool = false;
    if (globals.lrHolder == globals.currPlayer) lrBool = true;
    if (globals.laHolder == globals.currPlayer) laBool = true;

    return Stack(children: <Widget>[
      uiButton(context, globals.playerOrder[globals.currPlayer], 20, 20, null),
      //dice roll
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
                  onPressed: () => rollDice(),
                  child: SizedBox(
                      width: globals.refscale * .2,
                      height: globals.refscale * .1333334,
                      child: CustomPaint(
                        foregroundPainter: DicePainter(),
                        child: Container(),
                      ))))),
      //dice roll prompt and rolled number
      if (!globals.rolled && !globals.start)
        Align(
            alignment: Alignment(0, -0.9),
            child: (Text('Roll',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 40.0, color: colors['white']))))
      else if (!globals.start)
        Positioned(
            left: 20 + globals.refscale * .25,
            top: 40 + globals.refscale * 0.1,
            child: (Text(globals.diceNum.toString(),
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 40.0, color: colors['white'])))),
      //trade button
      uiButton(
          context, 'Trade', 20, 60 + (globals.refscale * 16) / 75, 'trade'),
      //end turn button
      uiButton(
          context, 'End Turn', 20, 80 + (globals.refscale * 22) / 75, 'end'),
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
                          color: globals.players[
                              globals.playerOrder[globals.currPlayer]]['color'],
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
                                      onPressed: () {
                                        if (globals.players[globals.playerOrder[
                                                        globals.currPlayer]]
                                                    ['hand'][2] >
                                                0 &&
                                            globals.players[globals.playerOrder[
                                                        globals.currPlayer]]
                                                    ['hand'][4] >
                                                0) {
                                          setState(() {
                                            globals.placeP = 'r';
                                          });
                                          widget.notifyParent();
                                        }
                                      },
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
                                      onPressed: () {
                                        if (globals.players[globals.playerOrder[globals.currPlayer]]
                                                    ['hand'][0] >
                                                0 &&
                                            globals.players[globals.playerOrder[globals.currPlayer]]
                                                    ['hand'][2] >
                                                0 &&
                                            globals.players[globals.playerOrder[globals.currPlayer]]
                                                    ['hand'][3] >
                                                0 &&
                                            globals.players[globals.playerOrder[
                                                        globals.currPlayer]]
                                                    ['hand'][4] >
                                                0) {
                                          setState(() {
                                            globals.placeP = 's';
                                          });
                                          widget.notifyParent();
                                        }
                                      },
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
                                      onPressed: () {
                                        if (globals.players[globals.playerOrder[
                                                        globals.currPlayer]]
                                                    ['hand'][1] >
                                                2 &&
                                            globals.players[globals.playerOrder[
                                                        globals.currPlayer]]
                                                    ['hand'][3] >
                                                1) {
                                          setState(() {
                                            globals.placeP = 'c';
                                          });
                                          widget.notifyParent();
                                        }
                                      },
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
                                      onPressed: () {
                                        if (globals.players[globals.playerOrder[globals.currPlayer]]
                                                    ['hand'][0] >
                                                0 &&
                                            globals.players[globals.playerOrder[
                                                        globals.currPlayer]]
                                                    ['hand'][1] >
                                                0 &&
                                            globals.players[globals
                                                        .playerOrder[globals.currPlayer]]
                                                    ['hand'][3] >
                                                0) {
                                          _getDevCard();
                                        }
                                      },
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
      //development card button
      Positioned(
          left: globals.w - 20 - globals.refscale * 0.15,
          top: 20 + globals.refscale * 0.46,
          child: MouseRegion(
              onHover: (event) {
                appContainer.style.cursor = 'pointer';
              },
              onExit: (event) {
                appContainer.style.cursor = 'default';
              },
              child: FlatButton(
                  padding: EdgeInsets.all(0),
                  color: colors['beige'],
                  splashColor: colors['brown'],
                  onPressed: () {
                    setState(() {
                      globals.dispDevCards = true;
                    });
                  },
                  child: SizedBox(
                      width: globals.refscale * 0.15,
                      height: globals.refscale * .21,
                      child: CustomPaint(
                        foregroundPainter: DCBackPainter(),
                        child: Container(),
                      ))))),
      //player hand
      CustomPaint(foregroundPainter: HandPainter(), child: Container()),
      //longest road card
      if (lrBool)
        Positioned(
          left: globals.w - globals.refscale * 0.3 - 20,
          top: globals.h - globals.refscale * 0.06,
          child: SizedBox(
              width: globals.refscale * 0.3,
              height: globals.refscale * 0.06,
              child: Container(
                  color: colors['brown'],
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Longest Road',
                            style: TextStyle(
                                fontSize: globals.refscale * 0.03,
                                color: colors['beige']),
                            textAlign: TextAlign.center)
                      ]))),
        ),
      //largest army card
      if (laBool)
        Positioned(
          left: globals.w - globals.refscale * 0.3 - 20,
          top: globals.h - globals.refscale * 0.12,
          child: SizedBox(
              width: globals.refscale * 0.3,
              height: globals.refscale * 0.06,
              child: Container(
                  color: colors['brown'],
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Largest Army',
                            style: TextStyle(
                                fontSize: globals.refscale * 0.03,
                                color: colors['beige']),
                            textAlign: TextAlign.center)
                      ]))),
        ),

      //gamepeice placement
      // if (globals.placeP != '')
      //   PlaceGamePiece(),
      //display dev cards
      if (globals.dispDevCards) DispDevCards(notifyParent: notifyParent),
      //disp trade screen
      if (globals.dispTrade) TradeScreen(),
    ]);
  }

  Widget uiButton(BuildContext context, txt, x, y, [func]) {
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
                      onPressed: () => _handleButton(func),
                      child: AutoSizeText(txt,
                          style:
                              TextStyle(fontSize: 30.0, color: colors['brown']),
                          maxLines: 1),
                    )))));
  }
}

class HandPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    List res = ["s", "o", "b", "w", "f"];
    double cardWidth = globals.refscale * 0.2;
    double cardHeight = globals.refscale * 0.1;
    double margin = globals.refscale * 0.01;
    double x = globals.w / 2 - 2.5 * cardWidth - 2 * margin;
    for (int i = 0; i < 5; i++) {
      canvas.drawRect(
          Rect.fromLTWH(x, globals.h - cardHeight, cardWidth, cardHeight),
          Paint()..color = colors[res[i]]);
      TextSpan span = new TextSpan(
          style: new TextStyle(
              color: colors['offwhite'], fontSize: globals.r * 0.5),
          text: globals.players[globals.playerOrder[globals.currPlayer]]['hand']
                  [i]
              .toString());
      TextPainter tp = new TextPainter(
          text: span,
          textScaleFactor: 1,
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr);
      tp.layout();
      tp.paint(
          canvas,
          new Offset(x + cardWidth / 2 - (tp.width / 2),
              globals.h - cardHeight / 2 - (tp.height / 2)));

      x += cardWidth + margin;
    }
  }

  bool shouldRepaint(HandPainter oldDelegate) => false;
}

class DicePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    //Dice
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
    //roll prompt
    if (!globals.rolled) {
      TextSpan span = new TextSpan(
          style:
              new TextStyle(color: colors['white'], fontSize: globals.r * 0.8),
          text: 'Roll');
      TextPainter tp = new TextPainter(
          text: span,
          textScaleFactor: 1,
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr);
      tp.layout();
      tp.paint(
          canvas, new Offset(globals.w / 2 - (tp.width / 2), globals.h * .05));
    }
  }

  bool shouldRepaint(DicePainter oldDelegate) => false;
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

class DCBackPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawArc(
        Rect.fromCircle(
            center: Offset(size.width / 2, size.height / 2),
            radius: globals.refscale * 0.05),
        0,
        2 * pi,
        true,
        Paint()..color = Color(0xffb39a2d));
    canvas.drawArc(
        Rect.fromCircle(
            center: Offset(size.width / 2, size.height / 2),
            radius: globals.refscale * 0.0425),
        0,
        2 * pi,
        false,
        Paint()
          ..color = Color(0xff7c1e1e)
          ..strokeWidth = globals.refscale * 0.015
          ..style = PaintingStyle.stroke);
    canvas.drawArc(
        Rect.fromCircle(
            center: Offset(size.width / 2, size.height / 2),
            radius: globals.refscale * 0.05),
        pi / 8,
        (pi * 6) / 8,
        false,
        Paint()..color = Color(0xff20195a));
    canvas.drawArc(
        Rect.fromCircle(
            center: Offset(size.width / 2, size.height / 2),
            radius: globals.refscale * 0.012),
        0,
        2 * pi,
        true,
        Paint()..color = Color(0xff797979));
    canvas.drawArc(
        Rect.fromCircle(
            center: Offset(size.width / 2, size.height / 2),
            radius: globals.refscale * 0.05),
        0,
        2 * pi,
        false,
        Paint()
          ..color = Color(0xff797979)
          ..strokeWidth = globals.refscale * 0.007
          ..style = PaintingStyle.stroke);
  }

  bool shouldRepaint(DCBackPainter oldDelegate) => false;
}

class DispDevCards extends StatefulWidget {
  final Function() notifyParent;
  DispDevCards({Key key, @required this.notifyParent});
  @override
  @override
  _DispDevCards createState() {
    return _DispDevCards(notifyParent: notifyParent);
  }
}

class _DispDevCards extends State<DispDevCards> {
  final Function() notifyParent;
  _DispDevCards({Key key, @required this.notifyParent});

  List<Widget> devCards = [];
  List<Widget> usedCards = [];
  List<Widget> vpCards = [];
  bool resSelect = false;
  bool exit = false;

  void addCard(card, x, y, cW, arr) {
    arr.add(Positioned(
        left: x,
        top: y,
        child: MouseRegion(
            onHover: (event) {
              appContainer.style.cursor = 'pointer';
            },
            onExit: (event) {
              appContainer.style.cursor = 'default';
            },
            child: FlatButton(
                padding: EdgeInsets.all(0),
                color: colors['beige'],
                splashColor: colors['brown'],
                onPressed: () => _devFunction(card),
                child: SizedBox(
                    width: cW,
                    height: 1.4 * cW,
                    child: Align(
                        alignment: Alignment(0, -0.7),
                        child: (AutoSizeText(globals.dispText[card],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: cW * .15,
                                color: colors['brown'])))))))));
  }

  void _initCards() {
    //dev cards
    List<int> cardArr = globals.players[globals.playerOrder[globals.currPlayer]]
            ['dev_cards']
        .sublist(0, 4);
    int numCards = cardArr.reduce((a, b) => a + b);
    double cW = globals.refscale * 0.2;
    double x = globals.w / 2 - cW - 10;
    double y = globals.h * 0.15;

    x -= (numCards / 2) * (cW + 10);
    for (int i = 0; i < cardArr.length; i++) {
      for (int j = 0; j < cardArr[i]; j++) {
        addCard(i, (x += cW + 10), y, cW, devCards);
      }
    }

    //used cards
    cardArr = globals.players[globals.playerOrder[globals.currPlayer]]
        ['used_dev_cards'];
    numCards = cardArr.reduce((a, b) => a + b);
    cW = globals.refscale * 0.1;
    x = globals.w / 2 - cW - 10;
    y = globals.h * 0.575;

    x -= (numCards / 2) * (cW + 10);
    for (int i = 0; i < cardArr.length; i++) {
      for (int j = 0; j < cardArr[i]; j++) {
        addCard(i, (x += cW + 10), y, cW, usedCards);
      }
    }

    //vp cards
    numCards = globals.players[globals.playerOrder[globals.currPlayer]]
        ['dev_cards'][4];
    x = globals.w / 2 - cW - 10;
    y = globals.h * 0.82;

    x -= (numCards / 2) * (cW + 10);
    for (int i = 0; i < numCards; i++) {
      addCard(4, (x += cW + 10), y, cW, vpCards);
    }
  }

  void _devFunction(card) {
    if (card == 0)
      knightCard();
    else if (card == 1)
      roadCard();
    else if (card == 2)
      yopCard();
    else if (card == 3) monopolyCard();
  }

  void knightCard() {
    //move the robber
    setState(() {
      globals.dispDevCards = false;
      globals.players[globals.playerOrder[globals.currPlayer]]['dev_cards']
          [0]--;
      globals.players[globals.playerOrder[globals.currPlayer]]['used_dev_cards']
          [0]++;
      globals.placeP = 't';
      widget.notifyParent();
    });
    //check for longest army
    if (globals.players[globals.playerOrder[globals.currPlayer]]
            ['used_dev_cards'][0] >
        2) {
      if (globals.laHolder > -1) {
        if (globals.players[globals.playerOrder[globals.currPlayer]]
                ['used_dev_cards'][0] >
            globals.players[globals.playerOrder[globals.laHolder]]
                ['used_dev_cards'][0]) {
          globals.laHolder = globals.currPlayer;
        }
      } else {
        globals.laHolder = globals.currPlayer;
      }
    }
  }

  void roadCard() {
    setState(() {
      globals.dispDevCards = false;
      globals.players[globals.playerOrder[globals.currPlayer]]['dev_cards']
          [1]--;
      globals.players[globals.playerOrder[globals.currPlayer]]['used_dev_cards']
          [1]++;
      globals.roadCardBool = true;
      globals.placeP = 'r';
      widget.notifyParent();
    });
  }

  void yopCard() {
    setState(() {
      globals.dispDevCards = false;
      globals.players[globals.playerOrder[globals.currPlayer]]['dev_cards']
          [2]--;
      globals.players[globals.playerOrder[globals.currPlayer]]['used_dev_cards']
          [2]++;
      globals.yopBool = true;
      resSelect = true;
    });
  }

  void monopolyCard() {
    setState(() {
      globals.dispDevCards = false;
      globals.players[globals.playerOrder[globals.currPlayer]]['dev_cards']
          [0]--;
      globals.players[globals.playerOrder[globals.currPlayer]]['used_dev_cards']
          [0]++;
      resSelect = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    _initCards();
    if (globals.placeP != '') {
      return PlaceGamePiece();
    } else if (resSelect) {
      resSelect = false;
      return ResSelectionScreen();
    } else if (exit) {
      exit = false;
      return Container();
    }
    return Scaffold(
      //background
      backgroundColor: colors['screenBG'],
      body: Stack(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              setState(() {
                exit = true;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 7.0,
                  color: colors['brown'],
                ),
              ),
            ),
          ),
          // Development Cards text
          Align(
              alignment: Alignment(0, -0.9),
              child: (Text('Development Cards',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: globals.refscale * 0.05,
                      color: colors['white'])))),

          // unused cards
          Stack(
            children: devCards,
          ),

          // Used Cards text
          Align(
              alignment: Alignment(0, 0.1),
              child: (Text('Used Cards',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: globals.refscale * 0.05,
                      color: colors['white'])))),

          //Used Cards
          Stack(
            children: usedCards,
          ),

          //Victory Points text
          Align(
              alignment: Alignment(0, 0.6),
              child: (Text('Victory Point Cards',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: globals.refscale * 0.05,
                      color: colors['white'])))),

          //Victory Point Cards
          Stack(
            children: vpCards,
          ),
        ],
      ),
    );
  }
}

class ResSelectionScreen extends StatefulWidget {
  @override
  _ResSelectionScreen createState() {
    return _ResSelectionScreen();
  }
}

class _ResSelectionScreen extends State<ResSelectionScreen> {
  List res = ['s', 'o', 'b', 'w', 'f'];
  List<Widget> resButtons = [];
  bool done = false;
  bool one = false;

  void _cardFunc(res) {
    if (globals.yopBool) {
      globals.players[globals.playerOrder[globals.currPlayer]]['hand'][res]++;
      if (one) {
        globals.yopBool = false;
        setState(() {
          done = true;
        });
      } else {
        setState(() {
          one = true;
        });
      }
    } else {
      int quantStolen = 0;
      for (String i in globals.playerOrder) {
        quantStolen += globals.players[i]['hand'][res];
        globals.players[i]['hand'][res] = 0;
      }
      globals.players[globals.playerOrder[globals.currPlayer]]['hand'][res] =
          quantStolen;
      setState(() {
        done = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double x = globals.w / 2 -
        (globals.w * 0.15 + globals.w * 0.01) * 2 -
        globals.w * 0.15 / 2;
    double y = globals.h / 2 - globals.w * 0.1;
    for (int i = 0; i < 5; i++) {
      resButtons.add(resButton(context, i, x, y));
      x += globals.w * 0.15 + globals.refscale * 0.01;
      if (i == 4) {
        y = globals.h / 2 + globals.refscale * 0.11;
        x = globals.w / 2 -
            (globals.w * 0.15 + globals.w * 0.01) * 2 -
            globals.w * 0.15 / 2;
      }
    }
    if (done) {
      return Container();
    } else {
      return Scaffold(
        backgroundColor: colors['screenBG'],
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
                    child: (Text(
                      'Select Resource',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 40.0, color: colors['white']),
                    )))),
            Stack(
              children: resButtons,
            )
          ],
        ),
      );
    }
  }

  Widget resButton(BuildContext context, i, x, y) {
    return Positioned(
        left: x,
        top: y,
        child: SizedBox(
            width: globals.w * 0.15,
            height: globals.w * 0.15,
            child: Container(
                child: MouseRegion(
                    onHover: (event) {
                      appContainer.style.cursor = 'pointer';
                    },
                    onExit: (event) {
                      appContainer.style.cursor = 'default';
                    },
                    child: FlatButton(
                        color: colors[res[i]],
                        splashColor: colors['white'],
                        onPressed: () => _cardFunc(i),
                        child: Container())))));
  }
}

class TradeScreen extends StatefulWidget {
  @override
  _TradeScreen createState() {
    return _TradeScreen();
  }
}

class _TradeScreen extends State<TradeScreen> {
  List res = ['s', 'o', 'b', 'w', 'f'];
  List<Widget> expResButtons = [];
  List<Widget> impResButtons = [];
  List<Widget> expRes = [];
  List<Widget> impRes = [];
  List<int> expBox = [];
  List<int> impBox = [];
  List ports = [];
  List<Widget> portWidgets = [];
  bool noMoreOut = false;
  bool noMoreIn = false;
  bool done = false;
  bool equal = true;
  int price = 4;

  _completeTrade() {
    if (expBox.length == impBox.length * price) {
      for (int i in impBox) {
        setState(() {
          globals.players[globals.playerOrder[globals.currPlayer]]['hand'][i]++;
          done = true;
        });
      }
    } else {
      setState(() {
        equal = false;
      });
    }
  }

  void _removeRes(box, i) {
    if (box == 'e') {
      setState(() {
        equal = true;
        globals.players[globals.playerOrder[globals.currPlayer]]['hand']
            [expBox[i]]++;
        expBox.removeRange(i, i + 1);
      });

      // for (int j = 0; j < expBox.length; j++) _addRes(box, expBox[j]);
    } else {
      setState(() {
        equal = true;
        impBox.removeRange(i, i + 1);
      });
      // for (int j = 0; j< impBox.length; j++) _addRes(box, impBox[j]);
    }
  }

  _initRes() {
    expRes = [];
    for (int n = 0; n < expBox.length; n++) {
      int i = expBox[n];
      expRes.add(Positioned(
          left:
              (globals.w * 11) / 50 + globals.h / 100 + (globals.w / 27) * (n),
          top: (globals.h * 23) / 100,
          child: SizedBox(
              width: globals.w / 30,
              height: globals.h * 23 / 100,
              child: Container(
                  child: MouseRegion(
                      onHover: (event) {
                        appContainer.style.cursor = 'pointer';
                      },
                      onExit: (event) {
                        appContainer.style.cursor = 'default';
                      },
                      child: FlatButton(
                          color: colors[res[i]],
                          splashColor: colors['white'],
                          onPressed: () => _removeRes('e', n),
                          child: Container()))))));
    }
    impRes = [];
    for (int n = 0; n < impBox.length; n++) {
      int i = impBox[n];
      impRes.add(Positioned(
          left:
              (globals.w * 11) / 50 + globals.h / 100 + (globals.w / 27) * (n),
          top: (globals.h * 3) / 5,
          child: SizedBox(
              width: globals.w / 30,
              height: globals.h * 23 / 100,
              child: Container(
                  child: MouseRegion(
                      onHover: (event) {
                        appContainer.style.cursor = 'pointer';
                      },
                      onExit: (event) {
                        appContainer.style.cursor = 'default';
                      },
                      child: FlatButton(
                          color: colors[res[i]],
                          splashColor: colors['white'],
                          onPressed: () => _removeRes('i', n),
                          child: Container()))))));
    }
  }

  void _addRes(box, i) {
    if (box == 'e') {
      equal = true;
      setState(() {
        globals.players[globals.playerOrder[globals.currPlayer]]['hand'][i]--;
        expBox.add(i);
      });
    } else {
      equal = true;
      setState(() {
        impBox.add(i);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    globals.dispTrade = false;
    if (expResButtons.length == 0) {
      //set export selection buttons
      for (int i = 0; i < 5; i++) {
        expResButtons.add(Positioned(
            left: (globals.w * 13) / 25,
            top: (globals.h * 11) / 50 + (globals.h / 20) * i,
            child: SizedBox(
                width: globals.h / 20,
                height: globals.h / 20,
                child: Container(
                    child: MouseRegion(
                        onHover: (event) {
                          appContainer.style.cursor = 'pointer';
                        },
                        onExit: (event) {
                          appContainer.style.cursor = 'default';
                        },
                        child: FlatButton(
                            color: colors[res[i]],
                            splashColor: colors['white'],
                            onPressed: () => _addRes('e', i),
                            child: Text(
                                globals.players[
                                        globals.playerOrder[globals.currPlayer]]
                                        ['hand'][i]
                                    .toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: globals.h * 0.3,
                                    color: colors['white']))))))));
      }

      //set import selection buttons
      for (int i = 0; i < 5; i++) {
        impResButtons.add(Positioned(
            left: (globals.w * 13) / 25,
            top: (globals.h * 59) / 100 + (globals.h / 20) * i,
            child: SizedBox(
                width: globals.h / 20,
                height: globals.h / 20,
                child: Container(
                    child: MouseRegion(
                        onHover: (event) {
                          appContainer.style.cursor = 'pointer';
                        },
                        onExit: (event) {
                          appContainer.style.cursor = 'default';
                        },
                        child: FlatButton(
                            color: colors[res[i]],
                            splashColor: colors['white'],
                            onPressed: () => _addRes('i', i),
                            child: Container()))))));
      }
      //set ports
      ports =
          (globals.players[globals.playerOrder[globals.currPlayer]]['ports']);
      ports.sort();
      ports.toSet().toList();
      Color col = colors['white'];
      String str = '';
      double x = (globals.w * 125) / 200;
      for (int i = 0; i < ports.length; i++) {
        if (ports[i] != 0) {
          col = colors[res[ports[i] - 1]];
          str = '';
        } else {
          str = '?';
        }
        portWidgets.add(Positioned(
            left: x,
            top: (globals.h * 45) / 200,
            child: SizedBox(
                width: globals.w * 13 / 600,
                height: globals.h * 9 / 100,
                child: Container(
                    color: col,
                    child: Align(
                        alignment: Alignment(0.0, 0.2),
                        child: Text(str,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: globals.w * 0.03,
                                color: colors['brown'])))))));
        x += (globals.w * 2) / 75;
      }
    } else {
      //initialize selected resources
      _initRes();
    }

    //set trade price
    price = 4;
    if (ports.length != 0) {
      if (ports[0] == 0) price = 3;
      //checks if the expBox only contains one resource type
      if (expBox.length != 0) {
        int first = expBox[0];
        bool ye = true;
        for (int i in expBox) {
          if (i != first) ye = false;
        }
        if (ye && ports.contains(first + 1)) price = 2;
      }
    }

    //exit if done
    if (done) {
      done = false;
      expBox = [];
      impBox = [];
      expRes = [];
      impRes = [];
      return Container();
    } else {
      //draw
      return Scaffold(
        backgroundColor: colors['screenBG'],
        body: Stack(
          children: <Widget>[
            GestureDetector(
              onTap: () => setState(() {
                done = true;
              }),
              child: //border
                  Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 7.0,
                    color: colors['brown'],
                  ),
                ),
              ),
            ),
            //background
            Positioned(
              left: 0,
              top: 0,
              child: SizedBox(
                  width: globals.w * 1 / 5,
                  height: globals.h,
                  child: Container(
                      child: MouseRegion(
                    onHover: (event) {
                      appContainer.style.cursor = 'pointer';
                    },
                    onExit: (event) {
                      appContainer.style.cursor = 'default';
                    },
                  ))),
            ),
            Positioned(
                left: 0,
                top: 0,
                child: SizedBox(
                  width: globals.w,
                  height: globals.h / 10,
                  child: Container(
                      child: MouseRegion(onHover: (event) {
                    appContainer.style.cursor = 'pointer';
                  }, onExit: (event) {
                    appContainer.style.cursor = 'default';
                  })),
                )),
            Positioned(
                left: globals.w * 4 / 5,
                top: 0,
                child: SizedBox(
                  width: globals.w * 1 / 5,
                  height: globals.h,
                  child: Container(
                      child: MouseRegion(onHover: (event) {
                    appContainer.style.cursor = 'pointer';
                  }, onExit: (event) {
                    appContainer.style.cursor = 'default';
                  })),
                )),
            Positioned(
                left: 0,
                top: globals.h * 9 / 10,
                child: SizedBox(
                  width: globals.w,
                  height: globals.h / 10,
                  child: Container(
                      child: MouseRegion(onHover: (event) {
                    appContainer.style.cursor = 'pointer';
                  }, onExit: (event) {
                    appContainer.style.cursor = 'default';
                  })),
                )),

            //main box
            Positioned(
                left: globals.w / 5,
                top: globals.h / 10,
                child: SizedBox(
                  width: globals.w * 3 / 5,
                  height: globals.h * 4 / 5,
                  child: Container(color: colors['beige']),
                )),
            //trade label
            Positioned(
                left: (globals.w * 11) / 50,
                top: (globals.h * 7) / 50,
                child: (Text('Trade',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: globals.refscale * 0.06,
                        color: colors['brown'])))),
            //export box
            Positioned(
                left: (globals.w * 11) / 50,
                top: (globals.h * 11) / 50,
                child: SizedBox(
                  width: globals.w * 0.3,
                  height: globals.h * 0.25,
                  child: Container(color: colors['TB']),
                )),
            //export box resorces
            Stack(
              children: expRes,
            ),
            //export box resource selection
            Stack(
              children: expResButtons,
            ),
            //says no more than 8 resources at a time
            if (noMoreOut)
              Positioned(
                  left: (globals.w * 13) / 25,
                  top: (globals.h * 11) / 50,
                  child: (Text('No more than 8 at a time',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          fontSize: globals.refscale * 0.03,
                          color: Color(0xff7c1e1e))))),
            // for label
            Positioned(
                left: (globals.w * 11) / 50,
                top: (globals.h * 51) / 100,
                child: (Text('For',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: globals.refscale * 0.06,
                        color: colors['brown'])))),
            //import box
            Positioned(
                left: (globals.w * 11) / 50,
                top: (globals.h * 59) / 100,
                child: SizedBox(
                  width: globals.w * 0.3,
                  height: globals.h * 0.25,
                  child: Container(color: colors['TB']),
                )),
            //import resources
            Stack(
              children: impRes,
            ),
            //import resource selection
            Stack(
              children: impResButtons,
            ),
            //says no more than 5 resources at a time
            if (noMoreIn)
              Positioned(
                  left: (globals.w * 13) / 25,
                  top: (globals.h * 59) / 100,
                  child: (Text('No more than 5 at a time',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          fontSize: globals.refscale * 0.03,
                          color: Color(0xff7c1e1e))))),
            // Ports label
            Positioned(
                left: (globals.w * 31) / 50,
                top: (globals.h * 7) / 50,
                child: (Text('Ports',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: globals.refscale * 0.06,
                        color: colors['brown'])))),
            //ports box
            Positioned(
                left: (globals.w * 31) / 50,
                top: (globals.h * 11) / 50,
                child: SizedBox(
                  width: globals.w * 4 / 25,
                  height: globals.h / 10,
                  child: Container(color: colors['TB']),
                )),
            //port box ports
            Stack(
              children: portWidgets,
            ),
            // trade price
            Positioned(
                left: (globals.w * 31) / 50,
                top: (globals.h * 9) / 25,
                child: (Text('Trade Price',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: globals.refscale * 0.06,
                        color: colors['brown'])))),
            // trade price box and price text
            Positioned(
                left: (globals.w * 31) / 50,
                top: (globals.h * 11) / 25,
                child: SizedBox(
                  width: globals.w * 4 / 25,
                  height: globals.h / 10,
                  child: Container(
                    color: colors['TB'],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          price.toString() + ' : 1',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: globals.refscale * 0.06,
                              color: colors['brown']),
                        ),
                      ],
                    ),
                  ),
                )),

            //says trade not equal if it aint
            if (!equal)
              Positioned(
                  left: (globals.w * 39) / 50,
                  top: (globals.h * 73) / 100,
                  child: (Text('Trade not equal',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          fontSize: globals.refscale * 0.03,
                          color: Color(0xff7c1e1e))))),
            //Trade Button
            Positioned(
                left: (globals.w * 31) / 50,
                top: (globals.h * 77) / 100,
                child: SizedBox(
                    width: (globals.w * 4) / 25,
                    height: (globals.h * 7) / 100,
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
                              onPressed: () => _completeTrade(),
                              child: Text('Trade',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: globals.refscale * 0.06,
                                      color: colors['white'])),
                            ))))),
          ],
        ),
      );
    }
  }
}

class PlaceGamePiece extends StatefulWidget {
  @override
  _PlacePiece createState() {
    globals.nearestVert = null;
    globals.closest = null;
    return _PlacePiece();
  }
}

class _PlacePiece extends State<PlaceGamePiece> {
  double x = 0.0;
  double y = 0.0;

  void refresh() {
    setState(() {});
  }

  void _updateLocation(PointerEvent details) {
    setState(() {
      x = details.position.dx;
      y = details.position.dy;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (globals.placeP != '') {
      return GestureDetector(
          onTap: () {
            setState(() {
              globals.placeP += 'p';
            });
          },
          child: CustomPaint(
              painter: DrawGamePieces(x, y, notifyParent: refresh),
              child: MouseRegion(
                  onHover: _updateLocation,
                  child: Stack(
                    children: <Widget>[
                      if (globals.start)
                        Align(
                            alignment: Alignment(0, -0.9),
                            child: (Text('Place Beginning Settlements',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 40.0, color: colors['white'])))),
                      UIWidget(notifyParent: refresh)
                    ],
                  ))));
    }
    globals.start = false;
    return CustomPaint(
        painter: DrawGamePieces(x, y, notifyParent: refresh),
        child: UIWidget(notifyParent: refresh));
  }
}

class DrawGamePieces extends CustomPainter {
  final Function() notifyParent;

  Canvas gpCanvas;
  double x, y;
  DrawGamePieces(this.x, this.y, {Key key, @required this.notifyParent});

  @override
  void paint(Canvas canvas, Size size) {
    gpCanvas = canvas;
    var rect = Offset.zero & size;
    canvas.drawRect(
      rect,
      Paint()..color = Colors.transparent,
    );
    if (globals.placeP == 'sp') {
      placeSettlement();
    } else if (globals.placeP == 'cp') {
      placeCity();
    } else if (globals.placeP == 'rp') {
      placeRoad();
    } else if (globals.placeP == 'r') {
      roadVis();
    } else if (globals.placeP == 's' || globals.placeP == 'c') {
      settlementVis();
    } else if (globals.placeP == 't') {
      robberVis();
    } else if (globals.placeP == 'tp') {
      globals.placeP = '';
    }
    drawStored();
  }

  void drawStored() {
    //draw settlements
    for (int i = 0; i < globals.storedSettlements.length; i++) {
      Paint paint = Paint()
        ..color = globals.players[globals.storedSettlements[i][1]]['color'];
      int vert = globals.storedSettlements[i][0];
      Rect rect = Rect.fromLTWH(globals.vertices[vert][0] - globals.sW / 2,
          globals.vertices[vert][1] - globals.sH / 2, globals.sW, globals.sH);
      gpCanvas.drawRect(rect, paint);
    }
    //draw roads
    for (int i = 0; i < globals.storedRoads.length; i++) {
      Paint paint = Paint()
        ..color = globals.storedRoads[i][2]
        ..style = PaintingStyle.stroke
        ..strokeWidth = globals.refscale * .008;

      int vert1 = globals.storedRoads[i][0];
      int vert2 = globals.storedRoads[i][1];

      gpCanvas.drawLine(
          Offset(globals.vertices[vert1][0], globals.vertices[vert1][1]),
          Offset(globals.vertices[vert2][0], globals.vertices[vert2][1]),
          paint);
    }
    //draw cities
    for (int i = 0; i < globals.storedCities.length; i++) {
      Paint paint = Paint()
        ..color = globals.players[globals.storedCities[i][1]]['color'];
      int vert = globals.storedCities[i][0];
      Rect rect = Rect.fromLTWH(globals.vertices[vert][0] - globals.sW / 2,
          globals.vertices[vert][1], globals.sH, globals.sW);
      gpCanvas.drawRect(rect, paint);
    }
  }

  void placeSettlement() {
    //check if the space is open
    bool isEmpty = true;
    List adj = globals.vertGraph.getAdj(globals.nearestVert);
    for (int n = 0; n < globals.storedSettlements.length; n++) {
      List vert = globals.vertices[globals.storedSettlements[n][0]];
      if (globals.vertices[globals.nearestVert][0] == vert[0] &&
          globals.vertices[globals.nearestVert][1] == vert[1]) {
        isEmpty = false;
        break;
      }
      for (int i = 0; i < adj.length; i++) {
        if (globals.vertices[adj[i]][0] == vert[0] &&
            globals.vertices[adj[i]][1] == vert[1]) {
          isEmpty = false;
          break;
        }
      }
    }
    if (isEmpty &&
        (globals.players[globals.playerOrder[globals.currPlayer]]['road_verts']
                .contains(globals.nearestVert) ||
            globals.start)) {
      //draw settlement
      globals.placeP = '';
      Paint paint = Paint()
        ..color =
            globals.players[globals.playerOrder[globals.currPlayer]]['color'];
      Rect rect = Rect.fromLTWH(
          globals.vertices[globals.nearestVert][0] - globals.sW / 2,
          globals.vertices[globals.nearestVert][1] - globals.sH / 2,
          globals.sW,
          globals.sH);
      gpCanvas.drawRect(rect, paint);
      //store the settlement
      globals.storedSettlements
          .add([globals.nearestVert, globals.playerOrder[globals.currPlayer]]);
      globals.players[globals.playerOrder[globals.currPlayer]]['points']++;
      globals.players[globals.playerOrder[globals.currPlayer]]['settlements']
          .add(globals.nearestVert);
      //add to ports if on a harbor
      if (globals.portMap.containsKey(globals.nearestVert)) {
        if (!globals.players[globals.playerOrder[globals.currPlayer]]['ports']
            .contains(globals.portMap[globals.nearestVert])) {
          globals.players[globals.playerOrder[globals.currPlayer]]['ports']
              .add(globals.portMap[globals.nearestVert]);
        }
      }

      if (globals.start) {
        globals.placeP = 'r';
      } else {
        //take the resources
        globals.players[globals.playerOrder[globals.currPlayer]]['hand'][0]--;
        globals.players[globals.playerOrder[globals.currPlayer]]['hand'][2]--;
        globals.players[globals.playerOrder[globals.currPlayer]]['hand'][3]--;
        globals.players[globals.playerOrder[globals.currPlayer]]['hand'][4]--;
      }
    } else
      globals.placeP = 's';
  }

  void placeCity() {
    if (globals.players[globals.playerOrder[globals.currPlayer]]['settlements']
        .contains(globals.nearestVert)) {
      //store city
      globals.storedCities
          .add([globals.nearestVert, globals.playerOrder[globals.currPlayer]]);
      globals.players[globals.playerOrder[globals.currPlayer]]['points']++;
      globals.players[globals.playerOrder[globals.currPlayer]]['settlements']
          .add(globals.nearestVert);
      //take resources
      globals.players[globals.playerOrder[globals.currPlayer]]['hand'][3] -= 2;
      globals.players[globals.playerOrder[globals.currPlayer]]['hand'][1] -= 3;
      //draw city
      globals.placeP = '';
      Paint paint = Paint()
        ..color =
            globals.players[globals.playerOrder[globals.currPlayer]]['color'];
      Rect rect = Rect.fromLTWH(
          globals.vertices[globals.nearestVert][0] - globals.sW / 2,
          globals.vertices[globals.nearestVert][1],
          globals.sH,
          globals.sW);
      gpCanvas.drawRect(rect, paint);
    } else
      globals.placeP = 'c';
  }

  void placeRoad() {
    bool alreadyOwned = false;
    for (List verts in globals.storedRoads) {
      if ((verts[0] == globals.nearestVert && verts[1] == globals.closest) ||
          (verts[1] == globals.nearestVert && verts[0] == globals.closest)) {
        alreadyOwned = true;
        break;
      }
    }

    if (!alreadyOwned &&
        (globals.players[globals.playerOrder[globals.currPlayer]]['road_verts']
                .contains(globals.nearestVert) ||
            globals.players[globals.playerOrder[globals.currPlayer]]
                    ['road_verts']
                .contains(globals.closest) ||
            globals.players[globals.playerOrder[globals.currPlayer]]
                    ['settlements']
                .contains(globals.nearestVert))) {
      if (!globals.start && !globals.roadCardBool) {
        globals.players[globals.playerOrder[globals.currPlayer]]['hand'][2]--;
        globals.players[globals.playerOrder[globals.currPlayer]]['hand'][4]--;
      }

      globals.placeP = '';
      //draw road
      Paint paint = Paint()
        ..color =
            globals.players[globals.playerOrder[globals.currPlayer]]['color']
        ..style = PaintingStyle.stroke
        ..strokeWidth = globals.refscale * .008;
      gpCanvas.drawLine(
          Offset(globals.vertices[globals.nearestVert][0],
              globals.vertices[globals.nearestVert][1]),
          Offset(globals.vertices[globals.closest][0],
              globals.vertices[globals.closest][1]),
          paint);

      //store road in player roads, stored roads, and add to road graph
      globals.storedRoads.add([
        globals.nearestVert,
        globals.closest,
        globals.players[globals.playerOrder[globals.currPlayer]]['color']
      ]);

      if (!globals.players[globals.playerOrder[globals.currPlayer]]
              ['road_verts']
          .contains(globals.nearestVert)) {
        globals.players[globals.playerOrder[globals.currPlayer]]['road_verts']
            .add(globals.nearestVert);
        globals.players[globals.playerOrder[globals.currPlayer]]['road_graph']
            .addVertex(globals.nearestVert);
      }

      if (!globals.players[globals.playerOrder[globals.currPlayer]]
              ['road_verts']
          .contains(globals.closest)) {
        globals.players[globals.playerOrder[globals.currPlayer]]['road_verts']
            .add(globals.closest);
        globals.players[globals.playerOrder[globals.currPlayer]]['road_graph']
            .addVertex(globals.closest);
      }
      globals.players[globals.playerOrder[globals.currPlayer]]['road_graph']
          .addEdge(globals.nearestVert, globals.closest);

      //dfs for longest road
      if (!globals.start) {
        int v1 = globals.players[globals.playerOrder[globals.currPlayer]]
            ['road_verts'][0];
        int v2 = globals.players[globals.playerOrder[globals.currPlayer]]
            ['road_verts'][2];

        var l1 = globals.players[globals.playerOrder[globals.currPlayer]]
                ['road_graph']
            .dfs(v1);
        List l2 = globals.players[globals.playerOrder[globals.currPlayer]]
                ['road_graph']
            .dfs(v2);
        if (l1.length > 5 && l1.length > globals.longestRoad) {
          if (globals.lrHolder != -1)
            globals.players[globals.playerOrder[globals.lrHolder]]['points'] -=
                2;
          globals.lrHolder = globals.currPlayer;
          globals.players[globals.playerOrder[globals.currPlayer]]['points'] +=
              2;
          globals.longestRoad = l1.length;
        }
        if (l2.length > 5 && l2.length > globals.longestRoad) {
          if (globals.lrHolder != -1)
            globals.players[globals.playerOrder[globals.lrHolder]]['points'] -=
                2;
          globals.lrHolder = globals.currPlayer;
          globals.players[globals.playerOrder[globals.currPlayer]]['points'] +=
              2;
          globals.longestRoad = l2.length;
        }

        //road dev card
        if (globals.roadCardBool) {
          globals.players[globals.playerOrder[globals.currPlayer]]['hand'][2]++;
          globals.players[globals.playerOrder[globals.currPlayer]]['hand'][4]++;
          globals.roadCardBool = false;
          globals.placeP = 'r';
        }
      }
      //start sequence comparisons
      if (globals.start &&
          globals.players[globals.playerOrder[0]]['points'] != 2) {
        globals.placeP = 's';
        if (globals.players[globals.playerOrder[globals.playerOrder.length - 1]]
                ['points'] ==
            0) {
          globals.currPlayer++;
        } else if (globals.players[globals
                .playerOrder[globals.playerOrder.length - 1]]['points'] ==
            2) {
          globals.currPlayer--;
        }
      }
    } else {
      globals.placeP = 'r';
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
    }
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

  void robberVis() {
    for (int i = 0; i < globals.tileCenters.length; i++) {
      if (x < globals.tileCenters[i][0] + globals.r &&
          x > globals.tileCenters[i][0] - globals.r &&
          y < globals.tileCenters[i][1] + globals.r &&
          y > globals.tileCenters[i][1] - globals.r) {
        globals.robberLoc = i;
        break;
      }
    }
  }

  bool shouldRepaint(DrawGamePieces oldDelegate) => true;
}
