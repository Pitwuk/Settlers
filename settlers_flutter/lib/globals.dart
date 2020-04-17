import 'dart:math';

//canvas variables
double w, h, refscale, r;

//local game player variables
int numPlayers;
List playerOrder;
var players = {};
var playerBlank = {
  "color": "",
  "hand": [0, 0, 0, 0, 0],
  "points": 0,
  "settlements": [],
  "roads": [],
  "road_verts": [],
  "dev_cards": [0, 0, 0, 0, 0],
  "used_dev_cards": [0, 0, 0, 0],
  "longest_road": false,
  "largest_army": false
};

//game board variables
String gametype = 'local';
var tiles; // hashmap of tiles with coordinate : [resource, dice num]
List vertices = [];
List dist = [];
Map resourceIndex = {'s': 0, 'o': 1, 'b': 2, 'w': 3, 'f': 4};
int robberLoc;

//hexagon drawing variables
var hexagon = [
  0,
  r,
  (sqrt(3) * r) / 2,
  r / 2,
  (sqrt(3) * r) / 2,
  -r / 2,
  0,
  -r,
  -(sqrt(3) * r) / 2,
  -r / 2,
  -(sqrt(3) * r) / 2,
  r / 2,
];

double right = (sqrt(3) * r) / 2;
double down = 1.5 * r;
