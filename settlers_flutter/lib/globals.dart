import 'dart:math';

//canvas variables
double w, h, refscale, r;

//game board variables
String gametype = 'local';
var tiles; // hashmap of tiles with coordinate : [resource, dice num]
var vertices = [];

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
