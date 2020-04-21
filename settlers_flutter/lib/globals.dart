//canvas variables

double w, h;
double refscale = 0;
double r = refscale * .08;

//local game player variables
int numPlayers;
int currPlayer = 0;
List playerOrder;
var players = {};

//game board variables
String gametype = 'local';
var tiles; // hashmap of tiles with coordinate : [resource, dice num]
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
List vertexXs = [],
    vertexYs = [],
    possVerts = [],
    unsortedYs = [],
    storedSettlements = [],
    storedRoads = [];
double storedNx;
double vertexXd;
int nearestVert, closest;
int robberLoc;
int longestRoad = 0;
int lrHolder = -1;
Map settlements = {};

//Development Card Variables
bool roadCardBool = false;

//gameplay variables
bool rolled = false;
int diceNum;
