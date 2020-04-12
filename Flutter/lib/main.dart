import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:html' as html;

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
void main() => runApp(Menu());

class Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (context) => StartMenu(),
        '/singleplayer': null,
        '/multiplayer': (context) => MultiplayerMenu()
      },
    );
  }
}

class StartMenu extends StatelessWidget {
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
          MenuButtons()
        ],
      ),
    );
  }
}

class MenuButtons extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<MenuButtons> {
  void _showNextScreen(route) {
    Navigator.of(context).pushNamed(route);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Stack(children: <Widget>[
      menuButton(context, 'Singleplayer', -0.22, 0, .16, .16, '/singleplayer'),
      menuButton(context, 'Multiplayer', 0.22, 0, .16, .16, '/multiplayer')
    ]));
  }

  Widget menuButton(BuildContext context, txt, x, y, width, height, route) {
    return Align(
        alignment: Alignment(x, y),
        child: FractionallySizedBox(
            widthFactor: width,
            heightFactor: height,
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
                          style: TextStyle(fontSize: 60.0, color: Colors.white),
                          maxLines: 1),
                    )))));
  }
}

class MultiplayerMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Woo!', style: Theme.of(context).textTheme.headline2),
      ),
    );
  }
}
