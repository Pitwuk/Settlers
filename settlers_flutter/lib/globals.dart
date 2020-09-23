//online variables

import 'package:flutter/painting.dart';

String gameCode = '';
var gameData;
String tempName;
bool error = false;
bool lobbyFull = false;
int playerNum = -1;
var roadGraph;
String putData = '';
Color playerColor;
String update = '';
int monopoly = -1;

//canvas variables
double w, h;
double xScale = 1;
double yScale = 1;
double scalar = 1;
double refscale = 0;
double r = refscale * .08;

//local game player variables
int numPlayers;
int currPlayer = 0;
List playerOrder;
var players = {};

//game board variables
String gametype = 'local';
List tiles = [];
List initCenters = [];
List tileCenters = []; // list of tiles with coordinate : [resource, dice num]
List initVertices = [];

List vertices = [];
var vertGraph;
List coastVerts = [];
Map portMap = {};
List dist = [];
Map resourceIndex = {'s': 0, 'o': 1, 'b': 2, 'w': 3, 'f': 4};

//gamepiece variables
bool start = true;
double sW = refscale * 0.03;
double sH = refscale * 0.05;
String placeP = 's';
List initvertexXs = [],
    vertexXs = [],
    vertexYs = [],
    possVerts = [],
    unsortedYs = [],
    storedSettlements = [],
    storedRoads = [],
    storedCities = [];
double storedNx;
double vertexXd;
int nearestVert, closest;
int robberLoc;
int longestRoad = 0;
int largestArmy = 0;
int lrHolder = -1;
int laHolder = -1;

//Development Card Variables
bool dispDevCards = false;
bool roadCardBool = false;
bool yopBool = false;
List dispText = [
  'Knight Card',
  'Road Building',
  'Year of Plenty',
  'Monopoly',
  'Victory Point'
];
bool resSelect = false;

//gameplay variables
bool rolled = false;
int diceNum = 0;

//trade variables
bool dispTrade = false;
