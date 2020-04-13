var canvas,
  ctx,
  bg_canvas,
  bg_ctx,
  h_canvas,
  h_ctx,
  gp_canvas,
  gp_ctx,
  s_canvas,
  s_ctx,
  ui_canvas,
  ui_ctx,
  w,
  h,
  r,
  c_r,
  refscale,
  input,
  colors,
  poss_play_colors,
  player_colors,//
  num_players,//
  past1,
  players,//
  b,
  vertices,//
  coast_verts,//
  game_type,
  hands,//
  hexagon,
  tiles,//
  vp,//
  s_w,
  s_h,
  r_w,
  r_h,
  vertex_xs,
  vertex_ys,
  vertex_xd,
  vertex_yd,
  stored_nx,
  nearest_vert,
  unsorted_ys,
  poss_verts,
  g,//
  closest,
  start,//
  curr_player,
  settlements,//
  dist,//
  owned,//
  curr_dice,//
  rolled,
  dev_cards,
  num_dev_cards,
  card_arr,//
  used_cards,//
  roads,//
  road_points,//
  longest_road,//
  lr_holder,//
  la_holder,//
  la_tracker,//
  trade_outbox,
  trade_inbox,
  no_more_out,
  no_more_in,
  trade_price,
  robber_loc,
  tile_centers,//
  robber_bool,
  total_cards,
  new_total,
  temp_player,
  card_count,
  cancel_opt,
  res_nums,
  road_g,//
  start_road_points,
  road_card_bool,
  yop_bool,
  mon_bool,
  dun_did,
  ports,//
  port_map; //global variables

//initializes the canvas and starts the menu
function start_draw() {
  // get canvas and resize to fit the whole window
  canvas = document.getElementById("canvas");
  w = window.innerWidth;
  h = window.innerHeight;
  canvas.width = w;
  canvas.height = h;
  if (w < h) refscale = w;
  else refscale = h;
  r = refscale * 0.08;
  c_r = r * 0.3;
  ctx = canvas.getContext("2d");
  prompt_play_type("Singleplayer", "Multiplayer");
  canvas.addEventListener("mousemove", highlight_selection, false);
  canvas.addEventListener("click", game_selection, false);
  // canvas.remove();
  // bg_canvas = document.createElement("CANVAS");
  // bg_canvas.setAttribute("id", "canvas");
  // document.body.appendChild(bg_canvas);
  // bg_canvas.width = w;
  // bg_canvas.height = h;
  // bg_ctx = bg_canvas.getContext("2d");
  // init_standard_board("random");
}

//determines the random player order and displays it and initializes the background canvas
function player_order() {
  bg_canvas = document.createElement("CANVAS");
  bg_canvas.setAttribute("id", "canvas");
  document.body.appendChild(bg_canvas);
  bg_canvas.width = w;
  bg_canvas.height = h;
  bg_ctx = bg_canvas.getContext("2d");
  let rand_players = [];
  while (players.length != 0) {
    rand_players.push(
      players.splice(Math.floor(Math.random() * players.length), 1).toString()
    );
  }
  players = rand_players;
  //draw
  bg_ctx.fillStyle = "#beb3aa";
  bg_ctx.fillRect(0, 0, w, h);
  bg_ctx.fillStyle = "black";
  bg_ctx.textAlign = "center";
  bg_ctx.font = refscale * 0.05 + "px Arial";
  bg_ctx.fillText("Order:", w / 2, 110);
  x = 140;
  for (i = 0; i < num_players; i++) {
    bg_ctx.fillText(players[i], w / 2, (x += 30));
  }
  poss_play_colors = [
    "#720000",
    "white",
    "#3d2707",
    "#915700",
    "#b3b00f",
    "#160b57",
    "#3b0b57",
    "#a32e99",
    "#2ea399",
    "#39642e",
  ];
  player_colors = new Array(num_players);
  curr_player = 0;
  disp_colors();
  bg_canvas.addEventListener("click", pick_colors, false);
}

//displays the color selection screen
function disp_colors() {
  //display player name
  bg_ctx.clearRect(0, 0, w, h);
  bg_ctx.font = refscale * 0.05 + "px Arial";
  bg_ctx.textBaseline = "top";
  bg_ctx.textAlign = "center";
  bg_ctx.fillStyle = "black";
  bg_ctx.fillText(players[curr_player] + " Pick Your Color", w / 2, 40);
  //draw color boxes
  var b_w = w * 0.15;
  var x = w / 2 - (b_w + w * 0.01) * 2 - b_w / 2;
  var y = h / 2 - b_w;
  for (i = 0; i < 10; i++) {
    bg_ctx.fillStyle = poss_play_colors[i];
    bg_ctx.fillRect(x, y, b_w, b_w);
    x += b_w + refscale * 0.01;
    if (i == 4) {
      y = h / 2 + refscale * 0.01;
      x = w / 2 - (b_w + w * 0.01) * 2 - b_w / 2;
    }
  }
}

//lets the players choose their colors
function pick_colors(e) {
  var b_w = w * 0.15;
  var x = w / 2 - (b_w + w * 0.01) * 2 - b_w / 2;
  var y = h / 2 - b_w;
  for (i = 0; i < 10; i++) {
    if (
      e.clientX > x &&
      e.clientX < x + b_w &&
      e.clientY > y &&
      e.clientY < y + b_w
    ) {
      if (poss_play_colors[i] != "#00000000") {
        player_colors[curr_player] = poss_play_colors[i];
        poss_play_colors[i] = "#00000000";
        curr_player++;
        disp_colors();
        if (curr_player == num_players) {
          bg_canvas.removeEventListener("click", pick_colors, false);
          init_standard_board("random");
        }
        break;
      }
    }
    x += b_w + refscale * 0.01;
    if (i == 4) {
      y = h / 2 + refscale * 0.01;
      x = w / 2 - (b_w + w * 0.01) * 2 - b_w / 2;
    }
  }
}

//adds player names to the players array and displays them on screen with a button to remove
function add_player(name) {
  if (name != null) {
    if (name.length > 11) {
      name = name.substring(0, 10);
    }

    players.push(name);
  }
  for (i = 0; i < b.length; i++) {
    b[i].remove();
  }

  for (i = 0; i < players.length; i++) {
    b.push(document.createElement("BUTTON"));
    b[i].innerHTML = players[i];
    b[i].appendChild(document.createElement("SPAN"));
    document.body.appendChild(b[i]);
  }
  if (players.length > 0) {
    b[0].onclick = function () {
      delete_button(0);
    };
  }
  if (players.length > 1) {
    b[1].onclick = function () {
      delete_button(1);
    };
  }
  if (players.length > 2) {
    b[2].onclick = function () {
      delete_button(2);
    };
  }
  if (players.length > 3) {
    b[3].onclick = function () {
      delete_button(3);
    };
  }
}

//deletes the button
function delete_button(j) {
  for (i = 0; i < b.length; i++) {
    b[i].remove();
  }
  b = [];
  players.splice(j, 1);
  add_player(null);
}

// creates a text box for entering the names of the the players
function enter_player_names() {
  players = [];
  b = [];
  canvas.remove();
  input = document.createElement("INPUT");
  input.setAttribute("type", "text");
  input.setAttribute("id", "pnames");
  document.body.appendChild(input);
  input.addEventListener("keypress", function (e) {
    if (e.key === "Enter") {
      add_player(input.value);
      input.value = "";
      if (players.length >= num_players) {
        for (i = 0; i < b.length; i++) {
          b[i].remove();
        }
        input.remove();
        player_order();
      }
    }
  });
}

//used for selecting the number of players
function player_selection(e) {
  x = w / 2 - refscale * 0.28;
  y = h / 2 - refscale * 0.16;

  for (i = 0; i < 4; i++) {
    x += refscale * 0.1;
    if (i % 4 == 0 && i != 0) {
      x = w / 2 - refscale * 0.4;
      y += refscale * 0.1;
    }
    if (
      e.clientX > x &&
      e.clientX < x + refscale * 0.08 &&
      e.clientY > y &&
      e.clientY < y + refscale * 0.08
    ) {
      if (i == 0) {
        ctx.fillStyle = "#beb3aa";
        ctx.fillRect(0, 0, w, h);
        ctx.fillStyle = "black";
        ctx.textAlign = "center";
        ctx.font = refscale * 0.05 + "px Arial";
        wrapText("You do not have enough brain cells to play", w / 2, 110, 50);
      } else {
        num_players = i + 1;
        prompt_play_type("Local", "Online");
        canvas.addEventListener("mousemove", highlight_selection, false);
        canvas.addEventListener("click", game_selection, false);
      }
      canvas.removeEventListener("mousemove", highlight_num_selection, false);
      canvas.removeEventListener("click", player_selection, false);
      break;
    }
  }
}

//creates a border around the buttons on the num players menu
function highlight_num_selection(e) {
  x = w / 2 - refscale * 0.28;
  y = h / 2 - refscale * 0.16;
  is_high = false;

  for (i = 0; i < 4; i++) {
    x += refscale * 0.1;
    if (i % 4 == 0 && i != 0) {
      x = w / 2 - refscale * 0.4;
      y += refscale * 0.1;
    }
    if (
      e.clientX > x &&
      e.clientX < x + refscale * 0.08 &&
      e.clientY > y &&
      e.clientY < y + refscale * 0.08
    ) {
      ctx.beginPath();
      ctx.lineWidth = refscale * 0.005;
      ctx.strokeStyle = "#e9dfb5";
      ctx.rect(x, y, refscale * 0.08, refscale * 0.08);
      ctx.stroke();
      is_high = true;
    }
  }
  if (!is_high) prompt_num_players();
}

//creates a menu with buttons for selecting the number of players
function prompt_num_players() {
  ctx.fillStyle = "#beb3aa";
  ctx.fillRect(0, 0, w, h);
  ctx.fillStyle = "black";
  ctx.textAlign = "center";
  ctx.font = refscale * 0.05 + "px Arial";
  ctx.fillText("Number of Players", w / 2, 110);
  max_players = 4;
  x = w / 2 - refscale * 0.28;
  y = h / 2 - refscale * 0.16;
  for (i = 0; i < max_players; i++) {
    if (i % 4 == 0 && i != 0) {
      x = w / 2 - refscale * 0.4;
      y += refscale * 0.1;
    }
    ctx.fillStyle = "#352d26";
    ctx.fillRect((x += refscale * 0.1), y, refscale * 0.08, refscale * 0.08);
    ctx.fillStyle = "white";
    ctx.textAlign = "center";
    ctx.font = refscale * 0.03 + "px Arial";
    ctx.fillText(i + 1, x + refscale * 0.04, y + refscale * 0.05);
  }

  canvas.addEventListener("mousemove", highlight_num_selection, false);
  canvas.addEventListener("click", player_selection, false);
}

//used in navigating the two button menus
function game_selection(e) {
  if (!past1) {
    if (
      e.clientX > w / 2 - refscale * 0.24 &&
      e.clientX < w / 2 - refscale * 0.04 &&
      e.clientY > h / 2 - refscale * 0.16 &&
      e.clientY < h / 2 - refscale * 0.06
    ) {
      console.log("Singleplayer not yet supported");
    } else if (
      e.clientX > w / 2 + refscale * 0.04 &&
      e.clientX < w / 2 + refscale * 0.24 &&
      e.clientY > h / 2 - refscale * 0.16 &&
      e.clientY < h / 2 - refscale * 0.06
    ) {
      console.log("Multiplayer");
      past1 = true;
      canvas.removeEventListener("mousemove", highlight_selection, false);
      canvas.removeEventListener("click", game_selection, false);
      prompt_num_players();
    }
  } else {
    if (
      e.clientX > w / 2 - refscale * 0.24 &&
      e.clientX < w / 2 - refscale * 0.04 &&
      e.clientY > h / 2 - refscale * 0.16 &&
      e.clientY < h / 2 - refscale * 0.06
    ) {
      canvas.removeEventListener("mousemove", highlight_selection, false);
      canvas.removeEventListener("click", game_selection, false);
      enter_player_names();
      console.log("Local");
      game_type = "local";
    } else if (
      e.clientX > w / 2 + refscale * 0.04 &&
      e.clientX < w / 2 + refscale * 0.24 &&
      e.clientY > h / 2 - refscale * 0.16 &&
      e.clientY < h / 2 - refscale * 0.06
    ) {
      console.log("Online not yet supported");
    }
  }
}

//creates a border around the buttons on the two button menus
function highlight_selection(e) {
  if (
    e.clientX > w / 2 - refscale * 0.24 &&
    e.clientX < w / 2 - refscale * 0.04 &&
    e.clientY > h / 2 - refscale * 0.16 &&
    e.clientY < h / 2 - refscale * 0.06
  ) {
    ctx.beginPath();
    ctx.lineWidth = refscale * 0.005;
    ctx.strokeStyle = "#e9dfb5";
    ctx.rect(
      w / 2 - refscale * 0.24,
      h / 2 - refscale * 0.16,
      refscale * 0.2,
      refscale * 0.1
    );
    ctx.stroke();
  } else if (
    e.clientX > w / 2 + refscale * 0.04 &&
    e.clientX < w / 2 + refscale * 0.24 &&
    e.clientY > h / 2 - refscale * 0.16 &&
    e.clientY < h / 2 - refscale * 0.06
  ) {
    ctx.beginPath();
    ctx.lineWidth = refscale * 0.005;
    ctx.strokeStyle = "#e9dfb5";
    ctx.rect(
      w / 2 + refscale * 0.04,
      h / 2 - refscale * 0.16,
      refscale * 0.2,
      refscale * 0.1
    );
    ctx.stroke();
  } else if (!past1) {
    prompt_play_type("Singleplayer", "Multiplayer");
  } else {
    prompt_play_type("Local", "Online");
  }
}

// creates a menu with 2 buttons with the given text
function prompt_play_type(first, second) {
  ctx.fillStyle = "#beb3aa";
  ctx.fillRect(0, 0, w, h);
  ctx.fillStyle = "#352d26";
  ctx.fillRect(
    w / 2 - refscale * 0.24,
    h / 2 - refscale * 0.16,
    refscale * 0.2,
    refscale * 0.1
  );
  ctx.fillRect(
    w / 2 + refscale * 0.04,
    h / 2 - refscale * 0.16,
    refscale * 0.2,
    refscale * 0.1
  );
  if (first == "Singleplayer") {
    ctx.fillStyle = "black";
    ctx.textAlign = "center";
    ctx.font = refscale * 0.05 + "px Arial";
    ctx.fillText("Welcome to The Settlers of Chlamydia", w / 2, 110);
  }
  ctx.fillStyle = "white";
  ctx.font = refscale * 0.03 + "px Arial";
  ctx.fillText(first, w / 2 - refscale * 0.14, h / 2 - refscale * 0.1);
  ctx.fillText(second, w / 2 + refscale * 0.14, h / 2 - refscale * 0.1);
}

//assigns random numbers for the resource distribution and number chips
function init_standard_board(state) {
  bg_ctx.fillStyle = "#253d4b";
  bg_ctx.fillRect(0, 0, w, h);
  hexagon = [
    0,
    r,
    (Math.sqrt(3) * r) / 2,
    r / 2,
    (Math.sqrt(3) * r) / 2,
    -r / 2,
    0,
    -r,
    -(Math.sqrt(3) * r) / 2,
    -r / 2,
    -(Math.sqrt(3) * r) / 2,
    r / 2,
  ];
  if (state == "random") {
    var res_arr = [
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
    res_nums = { 0: "s", 1: "o", 2: "b", 3: "w", 4: "f" };
    tiles = {}; // hashmap of tiles with coordinate : [resource, dice num]

    var startlen = res_arr.length;
    for (i = 0; i < startlen; i++) {
      new_res = res_arr.splice(
        Math.floor(Math.random() * res_arr.length),
        1
      )[0];
      dice_num = Math.floor(Math.random() * 10 + 3);
      if (dice_num == 7) dice_num = 2;
      tiles[i] = [new_res, dice_num];
      if (new_res == "r") robber_loc = i;
    }
    num_verts = 1;
    vertices = [];
    dist = [];
    coast_verts = [];
    tile_centers = {};

    port_map = new Map();

    draw_tiles();
    remove_duplicates();
    // draw_vertices();
    construct_graph();
    draw_coast();

    start = true;
    settlements = [];
    settlements.length = parseInt(Object.keys(vertices).length, 10);
    settlements.fill(0);
    owned = new Array(num_players);
    for (i = 0; i < num_players; i++) owned[i] = [];
    roads = new Array(num_players);
    for (i = 0; i < num_players; i++) roads[i] = [];
    road_points = new Array(num_players);
    for (i = 0; i < num_players; i++) road_points[i] = [];
    start_road_points = new Array(num_players);
    for (i = 0; i < num_players; i++) start_road_points[i] = [];
    //construct road graphs
    var num_verts = parseInt(Object.keys(vertices).length, 10);
    road_g = new Array(num_players);
    for (i = 0; i < players.length; i++) {
      road_g[i] = new Graph(num_verts);
    }
    longest_road = -1;
    lr_holder = -1;
    la_holder = -1;
    la_tracker = new Array(num_players);
    la_tracker.fill(0);
    vp_cards = new Array(num_players);
    vp_cards.fill(0);
    used_cards = new Array(num_players);
    ports = new Array(num_players);
    for (var i = 0; i < num_players; i++) ports[i] = [0, 0, 0, 0, 0, 0]; //null, s, o, b, w, f
    init_player_hands();
    curr_player = 0;
    ui_canvas = document.createElement("CANVAS");
    ui_canvas.setAttribute("id", "canvas");
    document.body.appendChild(ui_canvas);
    ui_canvas.width = w;
    ui_canvas.height = h;
    ui_ctx = ui_canvas.getContext("2d");
    cancel_opt = false;
    start_placement();
    // trade_screen();
  }
}

//draws the UI (player turn, building costs/selection, dice roll, trade button, and next turn button)
function draw_ui() {
  ui_ctx.clearRect(0, 0, w, h);
  ui_ctx.textBaseline = "alphabetic";
  //draw name box
  ui_ctx.fillStyle = "#beb3aa";
  ui_ctx.fillRect(20, 20, refscale * 0.3, refscale * 0.08);
  ui_ctx.fillStyle = "#352d26";

  ui_ctx.textAlign = "center";
  ui_ctx.font = refscale * 0.05 + "px Arial";
  ui_ctx.fillText(
    players[curr_player],
    20 + refscale * 0.15,
    20 + refscale * 0.06
  );
  // draw robber
  ui_ctx.fillStyle = "#202020";
  ui_ctx.beginPath();
  ui_ctx.arc(
    tile_centers[robber_loc][0],
    tile_centers[robber_loc][1],
    c_r,
    0,
    2 * Math.PI
  );
  ui_ctx.fill();
  if (!start) {
    //draw dice
    ui_ctx.fillStyle = "#e9e9e9";
    ui_ctx.fillRect(20, 40 + refscale * 0.08, refscale * 0.1, refscale * 0.1);
    ui_ctx.fillRect(
      20 + refscale * 0.1,
      40 + refscale * 0.08 + (refscale * 0.1) / 3,
      refscale * 0.1,
      refscale * 0.1
    );
    ui_ctx.fillStyle = "#1d1d1d";
    ui_ctx.beginPath();
    ui_ctx.arc(
      20 + (refscale * 0.1) / 2,
      40 + refscale * 0.08 + (refscale * 0.1) / 2,
      refscale * 0.01,
      0,
      2 * Math.PI
    );
    ui_ctx.fill();
    ui_ctx.beginPath();
    ui_ctx.arc(
      20 + refscale * 0.1 * 1.5,
      40 + refscale * 0.08 + refscale / 12,
      refscale * 0.01,
      0,
      2 * Math.PI
    );
    ui_ctx.fill();
    ui_ctx.beginPath();
    ui_ctx.arc(
      20 + refscale * 0.1 * 1.5 - refscale / 45,
      40 + refscale * 0.08 + refscale / 12 - refscale / 45,
      refscale * 0.01,
      0,
      2 * Math.PI
    );
    ui_ctx.fill();
    ui_ctx.fill();
    ui_ctx.beginPath();
    ui_ctx.arc(
      20 + refscale * 0.1 * 1.5 + refscale / 45,
      40 + refscale * 0.08 + refscale / 12 + refscale / 45,
      refscale * 0.01,
      0,
      2 * Math.PI
    );
    ui_ctx.fill();
    //dice roll
    if (rolled) {
      ui_ctx.fillStyle = "#e9e9e9";
      ui_ctx.textAlign = "left";
      ui_ctx.textBaseline = "middle";
      ui_ctx.font = refscale * 0.1 + "px Arial";
      ui_ctx.fillText(curr_dice, 40 + refscale / 5, 40 + (refscale * 11) / 75);
    } else {
      ui_ctx.textBaseline = "top";
      ui_ctx.textAlign = "center";
      ui_ctx.fillStyle = "#e9e9e9";
      ui_ctx.font = refscale * 0.05 + "px Arial";
      ui_ctx.fillText("Roll", w / 2, 40);
    }
    ui_ctx.textBaseline = "alphabetic";

    //draw trade box
    ui_ctx.fillStyle = "#beb3aa";
    ui_ctx.fillRect(
      20,
      60 + (refscale * 16) / 75,
      refscale * 0.3,
      refscale * 0.08
    );
    ui_ctx.fillStyle = "#352d26";
    ui_ctx.textAlign = "center";
    ui_ctx.font = refscale * 0.05 + "px Arial";
    ui_ctx.fillText("Trade", 20 + refscale * 0.15, 60 + (refscale * 41) / 150);

    //draw end turn button
    ui_ctx.fillStyle = "#beb3aa";
    ui_ctx.fillRect(
      20,
      80 + (refscale * 22) / 75,
      refscale * 0.3,
      refscale * 0.08
    );
    ui_ctx.fillStyle = "#352d26";
    ui_ctx.textAlign = "center";
    ui_ctx.font = refscale * 0.05 + "px Arial";
    ui_ctx.fillText(
      "End Turn",
      20 + refscale * 0.15,
      80 + (refscale * 53) / 150
    );

    //draw building costs card
    var bc_w = refscale * 0.3;
    //background rectangle
    ui_ctx.fillStyle = "#beb3aa";
    ui_ctx.fillRect(w - bc_w - 20, 20, bc_w, refscale * 0.44);
    //border
    ui_ctx.strokeStyle = player_colors[curr_player];
    ui_ctx.lineWidth = refscale * 0.01;
    ui_ctx.beginPath();
    ui_ctx.moveTo(w - bc_w - 20, 20);
    ui_ctx.lineTo(w - bc_w - 20, 20 + refscale * 0.44);
    ui_ctx.lineTo(w - 20, 20 + refscale * 0.44);
    ui_ctx.lineTo(w - 20, 20);
    ui_ctx.lineTo(w - bc_w - 20, 20);
    ui_ctx.stroke();
    //title
    ui_ctx.fillStyle = "#352d26";
    ui_ctx.textAlign = "center";
    ui_ctx.font = refscale * 0.04 + "px Arial";
    ui_ctx.fillText("Building Costs", w - bc_w / 2 - 20, 20 + refscale * 0.045);
    //seperation line 1
    ui_ctx.strokeStyle = "#352d26";
    ui_ctx.lineWidth = refscale * 0.003;
    ui_ctx.beginPath();
    ui_ctx.moveTo(w - bc_w - 20 + refscale * 0.02, 20 + refscale * 0.06);
    ui_ctx.lineTo(w - 20 - refscale * 0.02, 20 + refscale * 0.06);
    ui_ctx.stroke();
    // road label
    ui_ctx.textBaseline = "top";
    ui_ctx.textAlign = "left";
    ui_ctx.font = refscale * 0.03 + "px Arial";
    ui_ctx.fillText(
      "Road",
      w - bc_w - 20 + refscale * 0.02,
      20 + refscale * 0.07
    );
    //road cost boxes
    ui_ctx.fillStyle = colors["f"];
    ui_ctx.fillRect(
      w - 20 - refscale * 0.06,
      20 + refscale * 0.1,
      refscale * 0.04,
      refscale * 0.04
    );
    ui_ctx.fillStyle = colors["b"];
    ui_ctx.fillRect(
      w - 20 - refscale * 0.11,
      20 + refscale * 0.1,
      refscale * 0.04,
      refscale * 0.04
    );
    //seperation line 2
    ui_ctx.beginPath();
    ui_ctx.moveTo(w - bc_w - 20 + refscale * 0.02, 20 + refscale * 0.15);
    ui_ctx.lineTo(w - 20 - refscale * 0.02, 20 + refscale * 0.15);
    ui_ctx.stroke();
    //settlement label
    ui_ctx.fillStyle = "#352d26";
    ui_ctx.fillText(
      "Settlement",
      w - bc_w - 20 + refscale * 0.02,
      20 + refscale * 0.16
    );
    //settlement cost boxes
    ui_ctx.fillStyle = colors["s"];
    ui_ctx.fillRect(
      w - 20 - refscale * 0.06,
      20 + refscale * 0.19,
      refscale * 0.04,
      refscale * 0.04
    );
    ui_ctx.fillStyle = colors["w"];
    ui_ctx.fillRect(
      w - 20 - refscale * 0.11,
      20 + refscale * 0.19,
      refscale * 0.04,
      refscale * 0.04
    );
    ui_ctx.fillStyle = colors["f"];
    ui_ctx.fillRect(
      w - 20 - refscale * 0.16,
      20 + refscale * 0.19,
      refscale * 0.04,
      refscale * 0.04
    );
    ui_ctx.fillStyle = colors["b"];
    ui_ctx.fillRect(
      w - 20 - refscale * 0.21,
      20 + refscale * 0.19,
      refscale * 0.04,
      refscale * 0.04
    );
    //seperation line 3
    ui_ctx.beginPath();
    ui_ctx.moveTo(w - bc_w - 20 + refscale * 0.02, 20 + refscale * 0.24);
    ui_ctx.lineTo(w - 20 - refscale * 0.02, 20 + refscale * 0.24);
    ui_ctx.stroke();
    //city label
    ui_ctx.fillStyle = "#352d26";
    ui_ctx.fillText(
      "City",
      w - bc_w - 20 + refscale * 0.02,
      20 + refscale * 0.25
    );
    //city cost boxes
    ui_ctx.fillStyle = colors["o"];
    ui_ctx.fillRect(
      w - 20 - refscale * 0.06,
      20 + refscale * 0.28,
      refscale * 0.04,
      refscale * 0.04
    );
    ui_ctx.fillRect(
      w - 20 - refscale * 0.11,
      20 + refscale * 0.28,
      refscale * 0.04,
      refscale * 0.04
    );
    ui_ctx.fillRect(
      w - 20 - refscale * 0.16,
      20 + refscale * 0.28,
      refscale * 0.04,
      refscale * 0.04
    );
    ui_ctx.fillStyle = colors["w"];
    ui_ctx.fillRect(
      w - 20 - refscale * 0.21,
      20 + refscale * 0.28,
      refscale * 0.04,
      refscale * 0.04
    );
    ui_ctx.fillRect(
      w - 20 - refscale * 0.26,
      20 + refscale * 0.28,
      refscale * 0.04,
      refscale * 0.04
    );
    //seperation line 4
    ui_ctx.beginPath();
    ui_ctx.moveTo(w - bc_w - 20 + refscale * 0.02, 20 + refscale * 0.33);
    ui_ctx.lineTo(w - 20 - refscale * 0.02, 20 + refscale * 0.33);
    ui_ctx.stroke();
    //Development Card label
    ui_ctx.fillStyle = "#352d26";
    ui_ctx.fillText(
      "Development",
      w - bc_w - 20 + refscale * 0.02,
      20 + refscale * 0.34
    );
    ui_ctx.fillText(
      "Card",
      w - bc_w - 20 + refscale * 0.02,
      20 + refscale * 0.37
    );
    //development cost boxes
    ui_ctx.fillStyle = colors["o"];
    ui_ctx.fillRect(
      w - 20 - refscale * 0.06,
      20 + refscale * 0.37,
      refscale * 0.04,
      refscale * 0.04
    );
    ui_ctx.fillStyle = colors["w"];
    ui_ctx.fillRect(
      w - 20 - refscale * 0.11,
      20 + refscale * 0.37,
      refscale * 0.04,
      refscale * 0.04
    );
    ui_ctx.fillStyle = colors["s"];
    ui_ctx.fillRect(
      w - 20 - refscale * 0.16,
      20 + refscale * 0.37,
      refscale * 0.04,
      refscale * 0.04
    );
    //seperation line 5
    ui_ctx.beginPath();
    ui_ctx.moveTo(w - bc_w - 20 + refscale * 0.02, 20 + refscale * 0.42);
    ui_ctx.lineTo(w - 20 - refscale * 0.02, 20 + refscale * 0.42);
    ui_ctx.stroke();

    // draw dev card stack
    ui_ctx.fillStyle = "#beb3aa";
    ui_ctx.fillRect(
      w - 20 - refscale * 0.15,
      20 + refscale * 0.46,
      refscale * 0.15,
      refscale * 0.21
    );
    //dev card emblem
    ui_ctx.fillStyle = "#b39a2d"; //yellow
    ui_ctx.beginPath();
    ui_ctx.arc(
      w - 20 - refscale * 0.075,
      20 + refscale * 0.565,
      refscale * 0.05,
      0,
      2 * Math.PI
    );
    ui_ctx.fill();
    ui_ctx.strokeStyle = "#7c1e1e"; //red
    ui_ctx.lineWidth = refscale * 0.015;
    ui_ctx.beginPath();
    ui_ctx.arc(
      w - 20 - refscale * 0.075,
      20 + refscale * 0.565,
      refscale * 0.05 - (refscale * 0.015) / 2,
      0,
      2 * Math.PI
    );
    ui_ctx.stroke();

    ui_ctx.fillStyle = "#20195a"; //blue
    ui_ctx.beginPath();
    ui_ctx.arc(
      w - 20 - refscale * 0.075,
      20 + refscale * 0.565,
      refscale * 0.05,
      Math.PI / 8,
      (Math.PI * 7) / 8
    );
    // ui_ctx.lineTo()
    ui_ctx.fill();
    ui_ctx.fillStyle = "#797979"; //grey
    ui_ctx.beginPath();
    ui_ctx.arc(
      w - 20 - refscale * 0.075,
      20 + refscale * 0.565,
      refscale * 0.012,
      0,
      2 * Math.PI
    );
    ui_ctx.fill();
    ui_ctx.strokeStyle = "#797979"; //grey
    ui_ctx.lineWidth = refscale * 0.007;
    ui_ctx.beginPath();
    ui_ctx.arc(
      w - 20 - refscale * 0.075,
      20 + refscale * 0.565,
      refscale * 0.05,
      0,
      2 * Math.PI
    );
    ui_ctx.stroke();

    //display Victory Points
    ui_ctx.textBaseline = "top";
    ui_ctx.textAlign = "left";
    ui_ctx.fillStyle = "#e9e9e9";
    ui_ctx.font = refscale * 0.048 + "px Arial";
    ui_ctx.fillText(
      "VPs: " + vp[curr_player],
      w - 20 - refscale * 0.15,
      20 + refscale * 0.69
    );

    //cancel button
    if (cancel_opt) {
      ui_ctx.fillStyle = "#7c1e1e";
      ui_ctx.fillRect(
        w - bc_w - 20,
        20 + refscale * 0.46,
        refscale * 0.1,
        refscale * 0.1
      );
      ui_ctx.textBaseline = "middle";
      ui_ctx.textAlign = "center";
      ui_ctx.fillStyle = "#beb3aa";
      ui_ctx.font = refscale * 0.1 + "px Arial";
      ui_ctx.fillText(
        "X",
        w - bc_w - 20 + refscale * 0.05,
        20 + refscale * 0.52
      );
    }

    //longest road card
    if (curr_player == lr_holder) {
      ui_ctx.fillStyle = "#352d26";
      ui_ctx.fillRect(
        w - refscale * 0.3 - 20,
        h - refscale * 0.06,
        refscale * 0.3,
        refscale * 0.06
      );
      ui_ctx.textBaseline = "middle";
      ui_ctx.textAlign = "center";
      ui_ctx.fillStyle = "#beb3aa";
      ui_ctx.font = refscale * 0.03 + "px Arial";
      ui_ctx.fillText(
        "Longest Road",
        w - 20 - refscale * 0.15,
        h - refscale * 0.03
      );
    }
    //longest road card
    if (curr_player == la_holder) {
      ui_ctx.fillStyle = "#352d26";
      ui_ctx.fillRect(
        w - refscale * 0.3 - 20,
        h - refscale * 0.12,
        refscale * 0.3,
        refscale * 0.06
      );
      ui_ctx.textBaseline = "middle";
      ui_ctx.textAlign = "center";
      ui_ctx.fillStyle = "#beb3aa";
      ui_ctx.font = refscale * 0.03 + "px Arial";
      ui_ctx.fillText(
        "Largest Army",
        w - 20 - refscale * 0.15,
        h - refscale * 0.09
      );
    }
  }
}

//starts the game and continues by taking turns
function start_turns() {
  //initialize ui
  ui_canvas.remove();
  ui_canvas = document.createElement("CANVAS");
  ui_canvas.setAttribute("id", "canvas");
  document.body.appendChild(ui_canvas);
  ui_canvas.width = w;
  ui_canvas.height = h;
  ui_ctx = ui_canvas.getContext("2d");
  draw_ui();
  rolled = false;
  ui_canvas.addEventListener("click", ui_click, false);
}

//connects the location of the user click on the ui elements to their functions
function ui_click(e) {
  //dice button
  if (
    e.clientX < refscale * 0.3 + 20 &&
    e.clientX > 20 &&
    e.clientY > 40 + refscale * 0.07 &&
    e.clientY < 40 + refscale * 0.21 &&
    !rolled
  )
    roll_dice();
  //trade button
  if (
    e.clientX < refscale * 0.3 + 20 &&
    e.clientX > 20 &&
    e.clientY > 60 + (refscale * 16) / 75 &&
    e.clientY < 60 + (refscale * 22) / 75 &&
    rolled
  )
    trade_screen();
  //end turn button
  if (
    e.clientX < refscale * 0.3 + 20 &&
    e.clientX > 20 &&
    e.clientY > 80 + (refscale * 22) / 75 &&
    e.clientY < 80 + (refscale * 28) / 75 &&
    rolled
  )
    next_player();

  //road button
  if (
    e.clientX > w - refscale * 0.3 - 20 &&
    e.clientX > 20 &&
    e.clientY > 20 + refscale * 0.06 &&
    e.clientY < 20 + refscale * 0.15 &&
    rolled &&
    hands[players[curr_player]][2] >= 1 &&
    hands[players[curr_player]][4] >= 1
  ) {
    cancel_opt = true;
    draw_ui();
    place_road();
  }

  //settlement button
  if (
    e.clientX > w - refscale * 0.3 - 20 &&
    e.clientX < w - 20 &&
    e.clientY > 20 + refscale * 0.15 &&
    e.clientY < 20 + refscale * 0.24 &&
    rolled &&
    hands[players[curr_player]][2] >= 1 &&
    hands[players[curr_player]][4] >= 1 &&
    hands[players[curr_player]][0] >= 1 &&
    hands[players[curr_player]][3] >= 1
  ) {
    cancel_opt = true;
    draw_ui();
    place_settlement();
  }

  //city button
  if (
    e.clientX > w - refscale * 0.3 - 20 &&
    e.clientX < w - 20 &&
    e.clientY > 20 + refscale * 0.24 &&
    e.clientY < 20 + refscale * 0.33 &&
    rolled &&
    hands[players[curr_player]][1] >= 3 &&
    hands[players[curr_player]][3] >= 2
  ) {
    cancel_opt = true;
    draw_ui();
    make_city();
  }
  //buy development card button
  if (
    e.clientX > w - refscale * 0.3 - 20 &&
    e.clientX < w - 20 &&
    e.clientY > 20 + refscale * 0.33 &&
    e.clientY < 20 + refscale * 0.42 &&
    rolled &&
    hands[players[curr_player]][0] >= 1 &&
    hands[players[curr_player]][1] >= 1 &&
    hands[players[curr_player]][3] >= 1
  )
    get_dev_card();
  //view development cards
  if (
    e.clientX > w - 20 - refscale * 0.15 &&
    e.clientX < w - 20 &&
    e.clientY > 20 + refscale * 0.46 &&
    e.clientY < 20 + refscale * 0.67 &&
    rolled
  )
    disp_dev_cards();
}
//makes the current player the next player and displays their hand
function next_player() {
  rolled = false;
  if (curr_player < num_players - 1) curr_player++;
  else curr_player = 0;
  draw_hand(players[curr_player]);
  draw_ui();
}

//returns a random number between 2 and 12 with the probability distribution of rolling 2 6 sided die and displays it
function roll_dice() {
  curr_dice =
    Math.floor(Math.random() * 6) + 1 + Math.floor(Math.random() * 6) + 1;
  if (curr_dice != 7) {
    distribute_resources();
  } else {
    move_robber();
  }
  rolled = true;
  draw_ui();
}

//distributes the resources to each player for the latest roll
function distribute_resources() {
  var x = tile_centers[robber_loc][0];
  var y = tile_centers[robber_loc][1];
  var robber_coords = [];
  var robber_verts = [];
  for (i = 0; i < hexagon.length - 1; i += 2) {
    robber_coords.push([
      Math.round(hexagon[i] + x),
      Math.round(hexagon[i + 1] + y),
    ]);
  }
  for (j = 0; j < 6; j++) {
    for (i = 0; i < parseInt(Object.keys(vertices).length, 10); i++) {
      if (
        Math.round(vertices[i][0]) == robber_coords[j][0] &&
        Math.round(vertices[i][1]) == robber_coords[j][1]
      ) {
        robber_verts.push(i);
      }
    }
  }

  for (i = 0; i < owned.length; i++) {
    for (j = 0; j < owned[i].length; j++) {
      for (k = 0; k < 5; k++) {
        if (
          robber_verts.includes(owned[i][j]) &&
          tiles[robber_loc][1] == curr_dice &&
          resource_index[tiles[robber_loc][0]] == k
        ) {
          console.log("robbed");
        } else {
          hands[players[i]][k] += dist[owned[i][j]][curr_dice - 1][k];
        }
      }
    }
  }
  draw_hand(players[curr_player]);
}

//checks if the player has more than 7 cards and ends the discard sequence when done
function discard_check() {
  if (curr_player == num_players) {
    ui_canvas.removeEventListener("click", discard_click, false);
    ui_canvas.addEventListener("click", ui_click, false);
    curr_player = temp_player;
    draw_hand(players[curr_player]);
    draw_ui();
    return null;
  }
  var total_cards = 0;
  for (m = 0; m < 5; m++) {
    total_cards += hands[players[curr_player]][m];
  }
  if (total_cards > 7) {
    draw_hand(players[curr_player]);
    draw_ui();
    ui_ctx.textBaseline = "top";
    ui_ctx.textAlign = "center";
    ui_ctx.fillStyle = "#e9e9e9";
    ui_ctx.font = refscale * 0.05 + "px Arial";
    ui_ctx.fillText("Discard Half Your Deck", w / 2, 40);
    new_total = total_cards;
    card_count = total_cards;
    ui_canvas.addEventListener("click", discard_click, false);
  } else {
    curr_player++;
    console.log(curr_player);
    discard_check();
  }
}

//prompts players with more than 7 cards in hand to discard half of their hand (rounding down if odd) and removes the selected cards from the players hand
function discard_click(e) {
  card_width = refscale * 0.2;
  card_height = refscale * 0.1;
  margin = 5;
  x = w / 2 - 2.5 * card_width - 2 * margin;
  for (i = 0; i < 5; i++) {
    if (
      e.clientX > x &&
      e.clientX < x + card_width &&
      e.clientY > h - card_height
    ) {
      if (hands[players[curr_player]][i] != 0) {
        hands[players[curr_player]][i]--;
        new_total--;
      }
    }
    x += card_width + margin;
  }
  draw_hand(players[curr_player]);
  if (new_total <= Math.floor(card_count / 2) + 1) {
    curr_player++;
    ui_canvas.removeEventListener("click", discard_click, false);
    discard_check();
  }
}

//allows the current player to choose the new location of the robber
function move_robber() {
  ui_canvas.removeEventListener("click", ui_click, false);
  ui_ctx.textBaseline = "top";
  ui_ctx.textAlign = "center";
  ui_ctx.fillStyle = "#e9e9e9";
  ui_ctx.font = refscale * 0.05 + "px Arial";
  ui_ctx.fillText("Move Robber", w / 2, 40);
  make_selection_canvas();
  robber_bool = false;
  s_canvas.addEventListener("mousemove", robber_vis, false);
  s_canvas.addEventListener("click", robber_click, false);
}

function robber_click(e) {
  s_canvas.removeEventListener("mousemove", robber_vis, false);
  s_canvas.removeEventListener("click", robber_click, false);
  s_canvas.remove();
  draw_ui();

  if (curr_dice == 7) {
    temp_player = curr_player;
    discard_check();
  } else ui_canvas.addEventListener("click", ui_click, false);
}

//visualizes a grey circle at the center of every hexagon the user is hovering over
function robber_vis(e) {
  s_ctx.clearRect(0, 0, w, h);
  for (i = 0; i < parseInt(Object.keys(tile_centers).length); i++) {
    if (
      e.clientX < tile_centers[i][0] + r &&
      e.clientX > tile_centers[i][0] - r &&
      e.clientY < tile_centers[i][1] + r &&
      e.clientY > tile_centers[i][1] - r
    ) {
      robber_bool = true;
      robber_loc = i;
      break;
    }
  }

  s_ctx.fillStyle = "#cfcfcfce";
  s_ctx.beginPath();
  s_ctx.arc(
    tile_centers[robber_loc][0],
    tile_centers[robber_loc][1],
    c_r,
    0,
    2 * Math.PI
  );
  s_ctx.fill();
}

//the settlement and road placement for all players at the start of the game / creates the gamepiece canvas and the selection canvas
function start_placement() {
  //game piece canvas
  gp_canvas = document.createElement("CANVAS");
  gp_canvas.setAttribute("id", "canvas");
  document.body.appendChild(gp_canvas);
  gp_canvas.width = w;
  gp_canvas.height = h;
  gp_ctx = gp_canvas.getContext("2d");

  s_w = refscale * 0.03;
  s_h = refscale * 0.05;
  draw_ui();

  //prompts players to place settlements
  ui_ctx.textBaseline = "top";
  ui_ctx.fillStyle = "#e9e9e9";
  ui_ctx.font = refscale * 0.05 + "px Arial";
  ui_ctx.fillText("Place Beginning Settlements", w / 2, 40);

  place_settlement();
}

//initializes the selection canvas
function make_selection_canvas() {
  //selection canvas
  s_canvas = document.createElement("CANVAS");
  s_canvas.setAttribute("id", "canvas");
  document.body.appendChild(s_canvas);
  s_canvas.width = w;
  s_canvas.height = h;
  s_ctx = s_canvas.getContext("2d");
}

//calls the functions for the trade screen
function trade_screen() {
  trade_outbox = [];
  trade_inbox = [];
  no_more_in = false;
  no_more_out = false;
  trade_price = 4;
  trade_equal = true;
  draw_trade_screen();
  ui_canvas.removeEventListener("click", ui_click, false);
  ui_canvas.addEventListener("click", trade_click, false);
}

//handles the functionality of the trade sceen
function trade_click(e) {
  //export resource selection
  for (n = 0; n < 5; n++) {
    if (
      e.clientX > (w * 13) / 25 &&
      e.clientX < (w * 13) / 25 + h / 20 &&
      e.clientY > (h * 11) / 50 + (h / 20) * n &&
      e.clientY < (h * 11) / 50 + (h / 20) * n + h / 20 &&
      hands[players[curr_player]][n] != 0
    ) {
      if (trade_outbox.length == 8) {
        no_more_out = true;
        draw_trade_screen();
      } else {
        hands[players[curr_player]][n]--;
        trade_outbox.push(n);
        trade_price = 4;
        if (ports[curr_player][n + 1] != 0 && trade_outbox.length > 1) {
          var only_n = true;
          for (var m = 0; m < trade_outbox.length; m++) {
            if (trade_outbox[m] != n) {
              only_n = false;
              break;
            }
          }
          if (only_n) trade_price = 2;
        }
        draw_trade_screen();
      }
    }
  }

  //import resource selection
  for (n = 0; n < 5; n++) {
    if (
      e.clientX > (w * 13) / 25 &&
      e.clientX < (w * 13) / 25 + h / 20 &&
      e.clientY > (h * 59) / 100 + (h / 20) * n &&
      e.clientY < (h * 59) / 100 + (h / 20) * n + h / 20 &&
      trade_outbox.length >= trade_price * (trade_inbox.length + 1)
    ) {
      if (trade_inbox.length == 5) {
        no_more_in = true;
        draw_trade_screen();
      } else {
        trade_inbox.push(n);
        draw_trade_screen();
      }
    }
  }

  //remove from outbox
  for (n = 0; n < trade_outbox.length; n++) {
    if (
      e.clientX > (w * 11) / 50 + h / 100 + (w / 27) * n &&
      e.clientX < (w * 11) / 50 + h / 100 + (w / 27) * n + w / 30 &&
      e.clientY > (h * 23) / 100 &&
      e.clientY < (h * 23) / 50
    ) {
      hands[players[curr_player]][trade_outbox[n]]++;
      trade_outbox.splice(n, 1);
      draw_trade_screen();
    }
  }
  //remove from inbox
  for (n = 0; n < trade_inbox.length; n++) {
    if (
      e.clientX > (w * 11) / 50 + h / 100 + (w / 18) * n &&
      e.clientX < (w * 11) / 50 + h / 100 + (w / 18) * n + w / 20 &&
      e.clientY > (h * 3) / 5 &&
      e.clientY < (h * 83) / 100
    ) {
      trade_inbox.splice(n, 1);
      draw_trade_screen();
    }
  }
  //Trade button
  if (
    e.clientX > (w * 31) / 50 &&
    e.clientX < (w * 39) / 50 &&
    e.clientY > (h * 77) / 100 &&
    e.clientY < (h * 84) / 100
  ) {
    if (trade_outbox.length == trade_inbox.length * trade_price) {
      trade_equal = true;
      for (n = 0; n < trade_inbox.length; n++) {
        hands[players[curr_player]][trade_inbox[n]]++;
      }
      trade_inbox = [];
      trade_outbox = [];
      draw_trade_screen();
    } else {
      trade_equal = false;
      draw_trade_screen();
    }
  }

  //exit trade screen
  if (
    e.clientX > (w * 4) / 5 ||
    e.clientX < w / 5 ||
    e.clientY > (h * 9) / 10 ||
    e.clientY < h / 10
  ) {
    ui_canvas.removeEventListener("click", trade_click, false);
    ui_canvas.addEventListener("click", ui_click, false);
    draw_hand(players[curr_player]);
    draw_ui();
  }
}

//draws the current state of the trade screen
function draw_trade_screen() {
  //main frame
  ui_ctx.clearRect(0, 0, w, h);
  ui_ctx.fillStyle = "#242424e1";
  ui_ctx.fillRect(0, 0, w, h);
  ui_ctx.fillStyle = "#beb3aa";
  ui_ctx.fillRect(w / 5, h / 10, (w * 3) / 5, (h * 4) / 5);
  //border
  ui_ctx.strokeStyle = "#352d26";
  ui_ctx.lineWidth = refscale * 0.02;
  ui_ctx.moveTo(w / 5, h / 10);
  ui_ctx.lineTo(w / 5, (h * 9) / 10);
  ui_ctx.lineTo((w * 4) / 5, (h * 9) / 10);
  ui_ctx.lineTo((w * 4) / 5, h / 10);
  ui_ctx.lineTo(w / 5 - refscale * 0.01, h / 10);
  ui_ctx.stroke();
  //trade
  ui_ctx.fillStyle = "#352d26";
  ui_ctx.textBaseline = "top";
  ui_ctx.textAlign = "left";
  ui_ctx.font = refscale * 0.06 + "px Arial";
  ui_ctx.fillText("Trade", (w * 11) / 50, (h * 7) / 50);
  //export box
  ui_ctx.fillStyle = "#919191e1";
  ui_ctx.fillRect((w * 11) / 50, (h * 11) / 50, w * 0.3, h * 0.25);
  //eport box resources

  for (i = 0; i < trade_outbox.length; i++) {
    ui_ctx.fillStyle = colors[res_nums[trade_outbox[i]]];
    ui_ctx.fillRect(
      (w * 11) / 50 + h / 100 + (w / 27) * i,
      (h * 23) / 100,
      w / 30,
      (h * 23) / 100
    );
  }
  //export resource selection
  ui_ctx.font = h * 0.03 + "px Arial";
  for (i = 0; i < 5; i++) {
    ui_ctx.fillStyle = colors[res_nums[i]];
    ui_ctx.fillRect(
      (w * 13) / 25,
      (h * 11) / 50 + (h / 20) * i,
      h / 20,
      h / 20
    );
    ui_ctx.fillStyle = "#e9e9e9";
    ui_ctx;
    ui_ctx.textAlign = "center";
    ui_ctx.textBaseline = "middle";
    ui_ctx.fillText(
      hands[players[curr_player]][i],
      (w * 13) / 25 + h / 40,
      h / 4 + (h / 20) * i
    );
  }
  // says no more than 8 resources at a time
  if (no_more_out) {
    ui_ctx.fillStyle = "#7c1e1e";
    ui_ctx.textBaseline = "bottom";
    ui_ctx.textAlign = "right";
    ui_ctx.font = refscale * 0.03 + "px Arial";
    ui_ctx.fillText("No more than 8 at a time", (w * 13) / 25, (h * 11) / 50);
  }
  //for
  ui_ctx.fillStyle = "#352d26";
  ui_ctx.textBaseline = "top";
  ui_ctx.textAlign = "left";
  ui_ctx.font = refscale * 0.06 + "px Arial";
  ui_ctx.fillText("For", (w * 11) / 50, (h * 51) / 100);
  //import box
  ui_ctx.fillStyle = "#919191e1";
  ui_ctx.fillRect((w * 11) / 50, (h * 59) / 100, (w * 3) / 10, h / 4);
  //import box resources
  for (i = 0; i < trade_inbox.length; i++) {
    ui_ctx.fillStyle = colors[res_nums[trade_inbox[i]]];
    ui_ctx.fillRect(
      (w * 11) / 50 + h / 100 + (w / 18) * i,
      (h * 3) / 5,
      w / 20,
      (h * 23) / 100
    );
  }
  //import resource selection
  for (i = 0; i < 5; i++) {
    ui_ctx.fillStyle = colors[res_nums[i]];
    ui_ctx.fillRect(
      (w * 13) / 25,
      (h * 59) / 100 + (h / 20) * i,
      h / 20,
      h / 20
    );
  }
  // says no more than 5 resources at a time
  if (no_more_in) {
    ui_ctx.fillStyle = "#7c1e1e";
    ui_ctx.textBaseline = "bottom";
    ui_ctx.textAlign = "right";
    ui_ctx.font = refscale * 0.03 + "px Arial";
    ui_ctx.fillText("No more than 5 at a time", (w * 13) / 25, (h * 59) / 100);
  }
  //Ports
  ui_ctx.fillStyle = "#352d26";
  ui_ctx.textBaseline = "top";
  ui_ctx.textAlign = "left";
  ui_ctx.font = refscale * 0.06 + "px Arial";
  ui_ctx.fillText("Ports", (w * 31) / 50, (h * 7) / 50);
  //Port box
  ui_ctx.fillStyle = "#919191e1";
  ui_ctx.fillRect((w * 31) / 50, (h * 11) / 50, (w * 4) / 25, h / 10);
  // Port box ports

  var x = (w * 125) / 200;
  for (i = 0; i < 6; i++) {
    if (ports[curr_player][i] != 0) {
      if (i == 0) ui_ctx.fillStyle = "#e9e9e9";
      else ui_ctx.fillStyle = colors[res_nums[i - 1]];
      ui_ctx.fillRect(x, (h * 45) / 200, (w * 13) / 600, (h * 9) / 100);
      if (i == 0) {
        if (trade_price != 2) trade_price = 3;
        ui_ctx.fillStyle = "#352d26";
        ui_ctx.textBaseline = "middle";
        ui_ctx.textAlign = "center";
        ui_ctx.font = w * 0.03 + "px Arial";
        ui_ctx.fillText(
          "?",
          x + (w * 13) / 1200,
          (h * 45) / 200 + (h * 9) / 200
        );
      }
      x += (w * 2) / 75;
    }
  }
  // Trade Price
  ui_ctx.fillStyle = "#352d26";
  ui_ctx.textAlign = "left";
  ui_ctx.fillText("Trade Price", (w * 31) / 50, (h * 9) / 25);
  //Trade price box
  ui_ctx.fillStyle = "#919191e1";
  ui_ctx.fillRect((w * 31) / 50, (h * 11) / 25, (w * 4) / 25, h / 10);
  //Trade Pice Text
  ui_ctx.fillStyle = "#352d26";
  ui_ctx.textAlign = "center";
  ui_ctx.textBaseline = "middle";
  ui_ctx.fillText(trade_price + " : 1", (w * 7) / 10, (h * 49) / 100);
  //says the trade not equal if it aint
  if (!trade_equal) {
    ui_ctx.fillStyle = "#7c1e1e";
    ui_ctx.textBaseline = "bottom";
    ui_ctx.textAlign = "right";
    ui_ctx.font = refscale * 0.03 + "px Arial";
    ui_ctx.fillText("Trade not equal", (w * 39) / 50, (h * 77) / 100);
  }
  //Trade Button
  ui_ctx.fillStyle = "#352d26";
  ui_ctx.fillRect((w * 31) / 50, (h * 77) / 100, (w * 4) / 25, (h * 7) / 100);
  ui_ctx.fillStyle = "#e9e9e9";
  ui_ctx.textAlign = "center";
  ui_ctx.textBaseline = "top";
  ui_ctx.font = refscale * 0.06 + "px Arial";
  ui_ctx.fillText("Trade", (w * 7) / 10, (h * 39) / 50);
  //Under the table button (Online only)
  // ui_ctx.fillRect(w / 2 + w * 0.3 - w * 0.18, h - h * 0.29, w * 0.16, h * 0.13);
  // ui_ctx.fillStyle = "#e9e9e9";
  // ui_ctx.textAlign = "center";
  // ui_ctx.textBaseline = "top";
  // ui_ctx.fillText("Under The", w / 2 + w * 0.3 - w * 0.1, h - h * 0.28);
  // ui_ctx.fillText("Table", w / 2 + w * 0.3 - w * 0.1, h - h * 0.22);
}

//puts a random development card in the players dev card stack with probability(14/25 knight cards, 5/25 victory point cards, 2/25 road building, 2/25 year of plenty, and 2/25 monopoly)
function get_dev_card() {
  hands[players[curr_player]][0]--;
  hands[players[curr_player]][1]--;
  hands[players[curr_player]][3]--;
  draw_hand(players[curr_player]);
  var card;
  var rand = Math.floor(Math.random() * 25);
  if (rand <= 13) card = 0;
  else if (rand <= 18) card = 1;
  else if (rand <= 20) card = 2;
  else if (rand <= 22) card = 3;
  else card = 4;
  if (card == 4) {
    vp_cards[curr_player]++;
    vp[curr_player]++;
  } else dev_cards[curr_player][card]++;
}

//displays the development cards in the player's hand
function disp_dev_cards() {
  ui_canvas.removeEventListener("click", ui_click, false);
  ui_ctx.clearRect(0, 0, w, h);
  // background
  ui_ctx.fillStyle = "#242424e1";
  ui_ctx.fillRect(0, 0, w, h);
  // Development Cards text
  ui_ctx.textBaseline = "top";
  ui_ctx.textAlign = "center";
  ui_ctx.fillStyle = "#e9e9e9";
  ui_ctx.font = refscale * 0.05 + "px Arial";
  ui_ctx.fillText("Development Cards", w / 2, h * 0.07);
  // unused cards
  var c_w = refscale * 0.2;
  var x = w / 2 - c_w - 10;
  var y = h * 0.15;
  num_dev_cards = 0;
  card_arr = [];
  for (i = 0; i < 4; i++) {
    for (j = 0; j < dev_cards[curr_player][i]; j++) {
      num_dev_cards++;
    }
  }
  x -= (num_dev_cards / 2) * (c_w + 10);
  for (i = 0; i < dev_cards[curr_player].length; i++) {
    for (j = 0; j < dev_cards[curr_player][i]; j++) {
      card_arr.push(i);
      draw_dev_card(i, (x += c_w + 10), y, c_w);
    }
  }
  // Used Cards text
  ui_ctx.textBaseline = "top";
  ui_ctx.textAlign = "center";
  ui_ctx.fillStyle = "#e9e9e9";
  ui_ctx.font = refscale * 0.05 + "px Arial";
  ui_ctx.fillText("Used Cards", w / 2, h * 0.25 + 1.4 * c_w);
  //Used Cards
  c_w = refscale * 0.1;
  x = w / 2 - c_w - 10;
  y = h * 0.32 + 1.4 * refscale * 0.2;
  var num_cards = 0;
  for (i = 0; i < 4; i++) {
    for (j = 0; j < used_cards[curr_player][i]; j++) {
      num_cards++;
    }
  }
  x -= (num_cards / 2) * (c_w + 10);
  for (i = 0; i < used_cards[curr_player].length; i++) {
    for (j = 0; j < used_cards[curr_player][i]; j++) {
      draw_dev_card(i, (x += c_w + 10), y, c_w);
    }
  }
  //Victory Points text
  ui_ctx.textBaseline = "top";
  ui_ctx.textAlign = "center";
  ui_ctx.fillStyle = "#e9e9e9";
  ui_ctx.font = refscale * 0.05 + "px Arial";
  ui_ctx.fillText(
    "Victory Point Cards",
    w / 2,
    h * 0.34 + 1.4 * c_w + 1.4 * refscale * 0.2
  );

  //Victory Point Cards
  x = w / 2 - c_w - 10;
  y = h * 0.41 + 1.4 * c_w + 1.4 * refscale * 0.2;
  num_cards = vp_cards[curr_player];
  x -= (num_cards / 2) * (c_w + 10);
  for (i = 0; i < num_cards; i++) {
    draw_dev_card(4, (x += c_w + 10), y, c_w);
  }

  ui_canvas.addEventListener("click", dev_card_click, false);
}

//draws the specified dev card at the specified position with the specified width
function draw_dev_card(num, x, y, width) {
  var height = 1.4 * width;
  ui_ctx.fillStyle = "#beb3aa";
  ui_ctx.fillRect(x, y, width, height);
  ui_ctx.textBaseline = "top";
  ui_ctx.fillStyle = "#352d26";
  ui_ctx.textAlign = "center";
  ui_ctx.font = width * 0.15 + "px Arial";
  ui_ctx.fillText(dev_card_names[num], x + width / 2, y + 10);
}

//handles the functionality of the development card screen
function dev_card_click(e) {
  var c_w = refscale * 0.2;
  var x = w / 2 - c_w - 10;
  var y = h * 0.15;
  x -= (num_dev_cards / 2) * (c_w + 10);
  var bool = true;
  for (i = 0; i < num_dev_cards; i++) {
    x += c_w + 10;
    if (
      e.clientX > x &&
      e.clientX < x + c_w &&
      e.clientY > y &&
      e.clientY < y + 1.4 * c_w
    ) {
      if (card_arr[i] == 0) {
        knight_card();
        bool = false;
      } else if (card_arr[i] == 1) {
        road_card();
        bool = false;
      } else if (card_arr[i] == 2) {
        yop_card();
        bool = false;
      } else if (card_arr[i] == 3) {
        monopoly_card();
        bool = false;
      }
    }
  }
  if (bool) {
    ui_canvas.removeEventListener("click", dev_card_click, false);
    ui_canvas.addEventListener("click", ui_click, false);
    draw_ui();
  }
}

//lets the player move the robber, move the card to used, and adds to the largest army tracker
function knight_card() {
  ui_canvas.removeEventListener("click", dev_card_click, false);
  draw_ui();
  la_tracker[curr_player]++;
  var curr_la = 0;
  if (la_holder != -1) curr_la = la_tracker[la_holder];
  if (la_tracker[curr_player] > 2 && la_tracker[curr_player] > curr_la) {
    if (la_holder != -1) vp[la_holder] -= 2;
    vp[curr_player] += 2;
    la_holder = curr_player;
  }

  dev_cards[curr_player][0]--;
  used_cards[curr_player][0]++;
  move_robber();
}

//lets the player place two roads
function road_card() {
  ui_canvas.removeEventListener("click", dev_card_click, false);
  draw_ui();
  dev_cards[curr_player][1]--;
  used_cards[curr_player][1]++;
  road_card_bool = true;
  place_road();
}

//handles the year of plenty function calling
function yop_card() {
  ui_canvas.removeEventListener("click", dev_card_click, false);
  dev_cards[curr_player][2]--;
  used_cards[curr_player][2]++;
  yop_bool = true;
  dun_did = false;
  draw_dev_res();
  ui_canvas.addEventListener("click", dev_res_click, false);
}

//handles the monopoly function calling
function monopoly_card() {
  ui_canvas.removeEventListener("click", dev_card_click, false);
  dev_cards[curr_player][2]--;
  used_cards[curr_player][2]++;
  mon_bool = true;
  draw_dev_res();
  ui_canvas.addEventListener("click", dev_res_click, false);
}

//draws the resource selection screen used in the year of plenty and monopoly cards
function draw_dev_res() {
  //background
  ui_ctx.clearRect(0, 0, w, h);
  ui_ctx.fillStyle = "#242424e1";
  ui_ctx.fillRect(0, 0, w, h);
  //draw resource boxes
  var b_w = w * 0.15;
  var x = w / 2 - (b_w + w * 0.01) * 2 - b_w / 2;
  for (i = 0; i < 5; i++) {
    ui_ctx.fillStyle = colors[res_nums[i]];
    ui_ctx.fillRect(x, h / 2 - b_w / 2, b_w, b_w);
    x += b_w + refscale * 0.01;
  }
}

//handles the resource selection for the year of plenty and monopoly cards
function dev_res_click(e) {
  var b_w = w * 0.15;
  var x = w / 2 - (b_w + w * 0.01) * 2 - b_w / 2;
  for (i = 0; i < 5; i++) {
    if (
      e.clientX > x &&
      e.clientX < x + b_w &&
      e.clientY > h / 2 - b_w / 2 &&
      e.clientY < h / 2 + b_w / 2
    ) {
      if (yop_bool) {
        hands[players[curr_player]][i]++;
        draw_hand(players[curr_player]);
        if (dun_did) {
          yop_bool = false;
          dun_did = false;
          ui_canvas.removeEventListener("click", dev_res_click, false);
          ui_canvas.addEventListener("click", ui_click, false);
          draw_ui();
        }
        dun_did = true;
      } else {
        for (n = 0; n < num_players; n++) {
          hands[players[curr_player]][i] += hands[players[n]][i];
          hands[players[n]][i] = 0;
        }
        draw_hand(players[curr_player]);
        ui_canvas.removeEventListener("click", dev_res_click, false);
        ui_canvas.addEventListener("click", ui_click, false);
        draw_ui();
      }
    }
    x += b_w + refscale * 0.01;
  }
}

//checks if the current player has a settlement at the vertex and upgrades it
function make_city() {
  make_selection_canvas();
  vertex_xs = [];
  vertex_ys = [];
  poss_verts = [];
  for (i = 0; i < parseInt(Object.keys(vertices).length, 10); i++) {
    if (!vertex_xs.includes(Math.round(vertices[i][0])))
      vertex_xs.push(Math.round(vertices[i][0]));
  }
  vertex_xs.sort(function (a, b) {
    return a - b;
  });
  vertex_xd = vertex_xs[1] - vertex_xs[0];

  gp_ctx.fillStyle = player_colors[curr_player];
  s_canvas.addEventListener("mousemove", settlement_vis, false);
  s_canvas.addEventListener("click", city_click, false);
}
//upgrades the chosen settlement to a city
function city_click(e) {
  if (
    e.clientX > w - refscale * 0.3 - 20 &&
    e.clientX < w - refscale * 0.2 - 20 &&
    e.clientY > 20 + refscale * 0.46 &&
    e.clientY < 20 + refscale * 0.56 &&
    cancel_opt
  ) {
    s_canvas.removeEventListener("mousemove", settlement_vis, false);
    s_canvas.removeEventListener("click", city_click, false);
    s_canvas.remove();
    ui_canvas.addEventListener("click", ui_click, false);
    cancel_opt = false;
    draw_ui();
  } else if (owned[curr_player].includes(nearest_vert)) {
    hands[players[curr_player]][3] -= 2;
    hands[players[curr_player]][1] -= 3;
    draw_hand(players[curr_player]);
    s_canvas.removeEventListener("mousemove", settlement_vis, false);
    s_canvas.removeEventListener("click", city_click, false);
    s_ctx.clearRect(0, 0, w, h);
    s_canvas.remove();
    settlements[nearest_vert] = 1;
    gp_ctx.fillRect(
      vertices[nearest_vert][0] - s_w / 2,
      vertices[nearest_vert][1],
      s_h,
      s_w
    );
    vp[curr_player] += 1;
    owned[curr_player].push(nearest_vert);
    cancel_opt = false;
    draw_ui();
  }
}
//places a road where the user chooses
function place_road() {
  ui_canvas.removeEventListener("click", ui_click, false);
  make_selection_canvas();
  vertex_xs = [];
  vertex_ys = [];
  poss_verts = [];
  for (i = 0; i < parseInt(Object.keys(vertices).length, 10); i++) {
    if (!vertex_xs.includes(Math.round(vertices[i][0])))
      vertex_xs.push(Math.round(vertices[i][0]));
  }
  vertex_xs.sort(function (a, b) {
    return a - b;
  });
  vertex_xd = vertex_xs[1] - vertex_xs[0];

  gp_ctx.fillStyle = player_colors[curr_player];
  gp_ctx.strokeStyle = player_colors[curr_player];
  s_canvas.addEventListener("mousemove", road_vis, false);
  s_canvas.addEventListener("click", road_click, false);
}

//places a road at chosen given edge
function road_click(e) {
  if (
    e.clientX > w - refscale * 0.3 - 20 &&
    e.clientX < w - refscale * 0.2 - 20 &&
    e.clientY > 20 + refscale * 0.46 &&
    e.clientY < 20 + refscale * 0.56 &&
    cancel_opt
  ) {
    s_canvas.removeEventListener("mousemove", road_vis, false);
    s_canvas.removeEventListener("click", road_click, false);
    s_canvas.remove();
    ui_canvas.addEventListener("click", ui_click, false);
    cancel_opt = false;
    draw_ui();
  } else {
    var already_owned = false;
    for (i = 0; i < num_players; i++) {
      for (j = 0; j < roads[i].length; j++) {
        if (
          (roads[i][j][0] == nearest_vert && roads[i][j][1] == closest) ||
          (roads[i][j][0] == closest && roads[i][j][1] == nearest_vert)
        ) {
          already_owned = true;
          break;
        }
      }
    }

    if (
      !already_owned &&
      (road_points[curr_player].includes(nearest_vert) ||
        road_points[curr_player].includes(closest) ||
        owned[curr_player].includes(nearest_vert))
    ) {
      if (!start) {
        if (!road_card_bool) {
          hands[players[curr_player]][2]--;
          hands[players[curr_player]][4]--;
        }
        draw_hand(players[curr_player]);
        cancel_opt = false;
      } else {
        start_road_points[curr_player].push(nearest_vert);
      }
      s_canvas.removeEventListener("mousemove", road_vis, false);
      s_canvas.removeEventListener("click", road_click, false);
      s_ctx.clearRect(0, 0, w, h);
      s_canvas.remove();
      gp_ctx.lineWidth = refscale * 0.01;
      gp_ctx.beginPath();
      gp_ctx.moveTo(vertices[nearest_vert][0], vertices[nearest_vert][1]);
      gp_ctx.lineTo(vertices[closest][0], vertices[closest][1]);
      gp_ctx.stroke();
      roads[curr_player].push([nearest_vert, closest]);
      if (!road_points[curr_player].includes(nearest_vert)) {
        road_points[curr_player].push(nearest_vert);
        road_g[curr_player].addVertex(nearest_vert);
      }
      if (!road_points[curr_player].includes(closest)) {
        road_points[curr_player].push(closest);
        road_g[curr_player].addVertex(closest);
      }
      road_g[curr_player].addEdge(nearest_vert, closest);
      // road_g[curr_player].printGraph();
      var l1 = road_g[curr_player].dfs(start_road_points[curr_player][0]);
      var l2 = road_g[curr_player].dfs(start_road_points[curr_player][1]);
      if (l1.length > 5 && l1.length > longest_road) {
        if (lr_holder != -1) vp[lr_holder] -= 2;
        lr_holder = curr_player;
        vp[lr_holder] += 2;
        longest_road = l1.length;
      }
      if (l2.length > 5 && l2.length > longest_road) {
        if (lr_holder != -1) vp[lr_holder] -= 2;
        lr_holder = curr_player;
        vp[lr_holder] += 2;
        longest_road = l2.length;
      }
      ui_canvas.addEventListener("click", ui_click, false);
      draw_ui();
      if (road_card_bool) {
        hands[players[curr_player]][2]++;
        hands[players[curr_player]][4]++;
        road_card_bool = false;
        place_road();
      }
      if (start && vp[0] == 2) {
        start = false;
        start_turns();
      }
      if (start) {
        if (vp[vp.length - 1] == 0) {
          curr_player++;
        } else if (vp[vp.length - 1] == 2) {
          curr_player--;
        }
        draw_ui();
        ui_ctx.textBaseline = "top";
        ui_ctx.fillStyle = "#e9e9e9";
        ui_ctx.font = refscale * 0.05 + "px Arial";
        ui_ctx.fillText("Place Beginning Settlements", w / 2, 40);

        place_settlement();
      }
    }
  }
}

//visualises a grey line at edge user is hovering over
function road_vis(e) {
  s_ctx.clearRect(0, 0, w, h);
  if (!start) {
    var nearest_x, nearest_y;
    var found = false;

    //find nearest x
    for (i = 0; i < vertex_xs.length; i++) {
      if (e.clientX < vertex_xs[i] + vertex_xd / 2) {
        nearest_x = vertex_xs[i];
        found = true;
        break;
      }
    }
    if (!found) {
      nearest_x = vertex_xs[vertex_xs.length - 1];
    }

    //find nearest y
    if (stored_nx != nearest_x) {
      //list of possible
      vertex_ys = [];
      poss_verts = [];
      for (i = 0; i < parseInt(Object.keys(vertices).length, 10); i++) {
        if (
          Math.round(vertices[i][0]) == nearest_x &&
          !vertex_ys.includes(Math.round(vertices[i][1]))
        ) {
          vertex_ys.push(Math.round(vertices[i][1]));
          poss_verts.push(i);
        }
      }
      unsorted_ys = [...vertex_ys];
      vertex_ys.sort(function (a, b) {
        return a - b;
      });
    }

    //find nearest
    var found = false;
    for (i = 0; i < vertex_ys.length - 1; i++) {
      if (e.clientY < vertex_ys[i] + (vertex_ys[i + 1] - vertex_ys[i]) / 2) {
        nearest_y = vertex_ys[i];
        found = true;
        break;
      }
    }
    if (!found) {
      nearest_y = vertex_ys[vertex_ys.length - 1];
    }
    nearest_vert = poss_verts[unsorted_ys.indexOf(nearest_y)];
    stored_nx = nearest_x;
  }
  adj = g.getAdj(nearest_vert);
  var dist =
    Math.abs(e.clientX - vertices[adj[0]][0]) +
    Math.abs(e.clientY - vertices[adj[0]][1]);
  closest = adj[0];
  for (i = 1; i < adj.length; i++) {
    if (
      Math.abs(e.clientX - vertices[adj[i]][0]) +
        Math.abs(e.clientY - vertices[adj[i]][1]) <
      dist
    ) {
      dist =
        Math.abs(e.clientX - vertices[adj[i]][0]) +
        Math.abs(e.clientY - vertices[adj[i]][1]);
      closest = adj[i];
    }
  }

  s_ctx.strokeStyle = "#cfcfcf9f";
  s_ctx.lineWidth = refscale * 0.01;
  s_ctx.beginPath();
  s_ctx.moveTo(vertices[nearest_vert][0], vertices[nearest_vert][1]);
  s_ctx.lineTo(vertices[closest][0], vertices[closest][1]);
  s_ctx.stroke();
}

//places a settlemet where the user chooses
function place_settlement() {
  make_selection_canvas();
  vertex_xs = [];
  vertex_ys = [];
  poss_verts = [];
  for (i = 0; i < parseInt(Object.keys(vertices).length, 10); i++) {
    if (!vertex_xs.includes(Math.round(vertices[i][0])))
      vertex_xs.push(Math.round(vertices[i][0]));
  }
  vertex_xs.sort(function (a, b) {
    return a - b;
  });
  vertex_xd = vertex_xs[1] - vertex_xs[0];

  gp_ctx.fillStyle = player_colors[curr_player];
  s_canvas.addEventListener("mousemove", settlement_vis, false);
  s_canvas.addEventListener("click", settlement_click, false);
}

//places the settlement if its a valid location
function settlement_click(e) {
  if (
    e.clientX > w - refscale * 0.3 - 20 &&
    e.clientX < w - refscale * 0.2 - 20 &&
    e.clientY > 20 + refscale * 0.46 &&
    e.clientY < 20 + refscale * 0.56 &&
    cancel_opt
  ) {
    s_canvas.removeEventListener("mousemove", settlement_vis, false);
    s_canvas.removeEventListener("click", settlement_click, false);
    s_canvas.remove();
    ui_canvas.addEventListener("click", ui_click, false);
    cancel_opt = false;
    draw_ui();
  } else {
    if (
      is_empty(nearest_vert) &&
      (start || road_points[curr_player].includes(nearest_vert))
    ) {
      s_canvas.removeEventListener("mousemove", settlement_vis, false);
      s_canvas.removeEventListener("click", settlement_click, false);
      s_ctx.clearRect(0, 0, w, h);
      s_canvas.remove();
      settlements[nearest_vert] = 1;
      gp_ctx.fillRect(
        vertices[nearest_vert][0] - s_w / 2,
        vertices[nearest_vert][1] - s_h / 2,
        s_w,
        s_h
      );
      vp[curr_player] += 1;
      owned[curr_player].push(nearest_vert);
      if (Object.keys(port_map).includes(nearest_vert.toString())) {
        ports[curr_player][port_map[nearest_vert]] = 1;
      }
      if (start) {
        place_road();
      } else {
        hands[players[curr_player]][0]--;
        hands[players[curr_player]][2]--;
        hands[players[curr_player]][3]--;
        hands[players[curr_player]][4]--;
        draw_hand(players[curr_player]);
        cancel_opt = false;
        draw_ui();
      }
    }
  }
}

//visualises a grey box at vertex user is hovering over
function settlement_vis(e) {
  s_ctx.clearRect(0, 0, w, h);

  var nearest_x, nearest_y;
  var found = false;
  s_ctx.strokeStyle = "white";
  //find nearest x
  for (i = 0; i < vertex_xs.length; i++) {
    if (e.clientX < vertex_xs[i] + vertex_xd / 2) {
      // s_ctx.beginPath();
      // s_ctx.moveTo(vertex_xs[i], 0);
      // s_ctx.lineTo(vertex_xs[i], h);
      // s_ctx.stroke();
      nearest_x = vertex_xs[i];
      found = true;
      break;
    }
  }
  if (!found) {
    // s_ctx.beginPath();
    // s_ctx.moveTo(vertex_xs[vertex_xs.length - 1], 0);
    // s_ctx.lineTo(vertex_xs[vertex_xs.length - 1], h);
    // s_ctx.stroke();
    nearest_x = vertex_xs[vertex_xs.length - 1];
  }

  //find nearest y
  if (stored_nx != nearest_x) {
    //list of possible
    vertex_ys = [];
    poss_verts = [];
    for (i = 0; i < parseInt(Object.keys(vertices).length, 10); i++) {
      if (
        Math.round(vertices[i][0]) == nearest_x &&
        !vertex_ys.includes(Math.round(vertices[i][1]))
      ) {
        vertex_ys.push(Math.round(vertices[i][1]));
        poss_verts.push(i);
      }
    }
    unsorted_ys = [...vertex_ys];
    vertex_ys.sort(function (a, b) {
      return a - b;
    });
  }

  //find nearest
  var found = false;
  for (i = 0; i < vertex_ys.length - 1; i++) {
    if (e.clientY < vertex_ys[i] + (vertex_ys[i + 1] - vertex_ys[i]) / 2) {
      // s_ctx.beginPath();
      // s_ctx.moveTo(0, vertex_ys[i]);
      // s_ctx.lineTo(w, vertex_ys[i]);
      // s_ctx.stroke();
      nearest_y = vertex_ys[i];
      found = true;
      break;
    }
  }
  if (!found) {
    // s_ctx.beginPath();
    // s_ctx.moveTo(0, vertex_ys[vertex_ys.length - 1]);
    // s_ctx.lineTo(w, vertex_ys[vertex_ys.length - 1]);
    // s_ctx.stroke();
    nearest_y = vertex_ys[vertex_ys.length - 1];
  }
  nearest_vert = poss_verts[unsorted_ys.indexOf(nearest_y)];
  stored_nx = nearest_x;

  s_ctx.fillStyle = "#cfcfcf9f";
  s_ctx.fillRect(nearest_x - s_w / 2, nearest_y - s_h / 2, s_w, s_h);
}

//checks to see if there is a settlement at the given vertices or adjacent
function is_empty(vert) {
  if (settlements[vert] == 0) {
    adj = g.getAdj(vert);
    for (i = 0; i < adj.length; i++) {
      if (settlements[adj[i]] != 0) {
        return false;
      }
    }
    return true;
  }
  return false;
}

//creates a map of player hands and victory point array, creates the hand canvas, and displays the first players hand if local
function init_player_hands() {
  h_canvas = document.createElement("CANVAS");
  h_canvas.setAttribute("id", "canvas");
  document.body.appendChild(h_canvas);
  h_canvas.width = w;
  h_canvas.height = h;
  h_ctx = h_canvas.getContext("2d");

  hands = {};
  dev_cards = [];
  dev_card_names = [
    "Knight Card",
    "Road Building",
    "Year of Plenty",
    "Monopoly",
    "Victory Point",
  ];
  vp = [];
  for (i = 0; i < players.length; i++) {
    hands[players[i]] = [0, 0, 0, 0, 0]; // sheep, ore, brick, wheat, forest(wood)
    dev_cards[i] = [0, 0, 0, 0]; // knight, road, year of plenty, monopoly, victory point
    used_cards[i] = [0, 0, 0, 0];
    vp.push(0);
  }
  // hands[players[0]] = [3, 0, 2, 4, 1];
  if (game_type == "local") {
    draw_hand(players[0]);
  }
}

//draws the hand of resource cards for the given player
function draw_hand(player) {
  res = ["s", "o", "b", "w", "f"];
  card_width = refscale * 0.2;
  card_height = refscale * 0.1;
  margin = 5;
  x = w / 2 - 2.5 * card_width - 2 * margin;
  for (i = 0; i < 5; i++) {
    h_ctx.fillStyle = colors[res[i]];
    h_ctx.fillRect(x, h - card_height, card_width, card_height);
    h_ctx.fillStyle = "#e9dfb5";
    h_ctx.textAlign = "center";
    h_ctx.font = 0.5 * r + "px Arial";
    h_ctx.fillText(
      hands[player][i],
      x + card_width / 2,
      h - card_height / 2 + r * 0.17
    );
    x += card_width + margin;
  }
}

//draws the coast and calls the function to draw the harbors
function draw_coast() {
  var covered = [];
  covered.push(coast_verts[0]);
  for (var i = 1; i < coast_verts.length; i++) {
    var adj_list = g.getAdj(covered[covered.length - 1]);
    for (var j = 0; j < adj_list.length; j++) {
      if (coast_verts.includes(adj_list[j]) && !covered.includes(adj_list[j])) {
        covered.push(adj_list[j]);
        bg_ctx.lineTo(vertices[adj_list[j]][0], vertices[adj_list[j]][1]);
        break;
      }
    }
  }
  coast_verts = covered;

  draw_stand_harbors();
  bg_ctx.strokeStyle = "#fff3bd";
  bg_ctx.lineWidth = refscale * 0.003;
  bg_ctx.beginPath();
  bg_ctx.moveTo(vertices[coast_verts[0]][0], vertices[coast_verts[0]][1]);
  for (var i = 1; i < coast_verts.length; i++)
    bg_ctx.lineTo(vertices[coast_verts[i]][0], vertices[coast_verts[i]][1]);

  bg_ctx.lineTo(vertices[coast_verts[0]][0], vertices[coast_verts[0]][1]);
  bg_ctx.stroke();
}

function draw_stand_harbors() {
  draw_harbor(coast_verts[1], coast_verts[2], "w");
  draw_harbor(coast_verts[5], coast_verts[6], "o");
  draw_harbor(coast_verts[8], coast_verts[9], null);
  draw_harbor(coast_verts[11], coast_verts[12], "s");
  draw_harbor(coast_verts[15], coast_verts[16], null);
  draw_harbor(coast_verts[18], coast_verts[19], null);
  draw_harbor(coast_verts[21], coast_verts[22], "b");
  draw_harbor(coast_verts[25], coast_verts[26], "f");
  draw_harbor(coast_verts[28], coast_verts[29], null);
}

// draws a harbor at the given vertices with the given resource
function draw_harbor(pv1, pv2, res) {
  var inds = [null, "s", "o", "b", "w", "f"];

  //make v1 south of v2
  if (vertices[pv1][1] < vertices[pv2][1]) {
    var v1 = pv2;
    var v2 = pv1;
  } else {
    var v1 = pv1;
    var v2 = pv2;
  }

  port_map[v1] = inds.indexOf(res);
  port_map[v2] = inds.indexOf(res);

  bg_ctx.fillStyle = " #5a4832";
  bw_w = r / 5; // boardwalk width
  bw_l = r / 2; // boardwalk length

  if (harbor_direction(v1, v2) == "E" || harbor_direction(v1, v2) == "W") {
    if (harbor_direction(v1, v2) == "W") bw_l = -bw_l;
    bg_ctx.fillRect(vertices[v2][0], vertices[v2][1], bw_l, bw_w);
    bg_ctx.fillRect(vertices[v2][0], vertices[v1][1] - bw_w, bw_l, bw_w);
    bg_ctx.fillStyle = "#beb3aa";
    bg_ctx.beginPath();
    bg_ctx.arc(
      vertices[v2][0] + bw_l * 2,
      vertices[v2][1] + r / 2,
      c_r,
      0,
      2 * Math.PI
    );
    bg_ctx.fill();
    if (res == null) {
      bg_ctx.textBaseline = "bottom";
      bg_ctx.textAlign = "center";
      bg_ctx.fillStyle = "#352d26";
      bg_ctx.font = refscale * 0.02 + "px Arial";
      bg_ctx.fillText("?", vertices[v2][0] + bw_l * 2, vertices[v2][1] + r / 2);
      bg_ctx.textBaseline = "top";
      bg_ctx.fillText(
        "3:1",
        vertices[v2][0] + bw_l * 2,
        vertices[v2][1] + r / 2
      );
    } else {
      bg_ctx.fillStyle = colors[res];
      bg_ctx.beginPath();
      bg_ctx.arc(
        vertices[v2][0] + bw_l * 2,
        vertices[v2][1] + r / 2 - c_r / 2,
        c_r / 2,
        0,
        2 * Math.PI
      );
      bg_ctx.fill();
      bg_ctx.textAlign = "center";
      bg_ctx.fillStyle = "#352d26";
      bg_ctx.font = refscale * 0.02 + "px Arial";
      bg_ctx.textBaseline = "top";
      bg_ctx.fillText(
        "2:1",
        vertices[v2][0] + bw_l * 2,
        vertices[v2][1] + r / 2
      );
    }
  } else {
    //harbor at angle (default NE)
    //boardwalk 1
    if (harbor_direction(v1, v2) == "SE") var angle = 150;
    else if (harbor_direction(v1, v2) == "SW") {
      var angle = 210;
      v2 = v1;
    } else if (harbor_direction(v1, v2) == "NW") {
      var angle = -30;
      v2 = v1;
    } else var angle = 30;
    bg_ctx.beginPath();
    bg_ctx.moveTo(vertices[v2][0], vertices[v2][1]);
    bg_ctx.lineTo(
      vertices[v2][0] + Math.sin((Math.PI / 180) * angle) * bw_l,
      vertices[v2][1] - Math.cos((Math.PI / 180) * angle) * bw_l
    );
    bg_ctx.lineTo(
      vertices[v2][0] +
        Math.sin((Math.PI / 180) * angle) * bw_l +
        Math.cos((Math.PI / 180) * angle) * bw_w,
      vertices[v2][1] -
        Math.cos((Math.PI / 180) * angle) * bw_l +
        Math.sin((Math.PI / 180) * angle) * bw_w
    );
    bg_ctx.lineTo(
      vertices[v2][0] + Math.cos((Math.PI / 180) * angle) * bw_w,
      vertices[v2][1] + Math.sin((Math.PI / 180) * angle) * bw_w
    );
    bg_ctx.lineTo(vertices[v2][0], vertices[v2][1]);
    bg_ctx.fill();
    // boardwalk 2
    bg_ctx.beginPath();
    bg_ctx.moveTo(
      vertices[v2][0] + Math.cos((Math.PI / 180) * angle) * (r - bw_w),
      vertices[v2][1] + Math.sin((Math.PI / 180) * angle) * (r - bw_w)
    );
    bg_ctx.lineTo(
      vertices[v2][0] +
        Math.cos((Math.PI / 180) * angle) * (r - bw_w) +
        Math.sin((Math.PI / 180) * angle) * bw_l,
      vertices[v2][1] +
        Math.sin((Math.PI / 180) * angle) * (r - bw_w) -
        Math.cos((Math.PI / 180) * angle) * bw_l
    );
    bg_ctx.lineTo(
      vertices[v2][0] +
        Math.cos((Math.PI / 180) * angle) * (r - bw_w) +
        Math.sin((Math.PI / 180) * angle) * bw_l +
        Math.cos((Math.PI / 180) * angle) * bw_w,
      vertices[v2][1] +
        Math.sin((Math.PI / 180) * angle) * (r - bw_w) -
        Math.cos((Math.PI / 180) * angle) * bw_l +
        Math.sin((Math.PI / 180) * angle) * bw_w
    );
    bg_ctx.lineTo(
      vertices[v2][0] +
        Math.cos((Math.PI / 180) * angle) * (r - bw_w) +
        Math.cos((Math.PI / 180) * angle) * bw_w,
      vertices[v2][1] +
        Math.sin((Math.PI / 180) * angle) * (r - bw_w) +
        Math.sin((Math.PI / 180) * angle) * bw_w
    );
    bg_ctx.lineTo(
      vertices[v2][0] + Math.cos((Math.PI / 180) * angle) * (r - bw_w),
      vertices[v2][1] + Math.sin((Math.PI / 180) * angle) * (r - bw_w)
    );
    bg_ctx.fill();
    //port function circle
    bg_ctx.fillStyle = "#beb3aa";
    bg_ctx.beginPath();
    bg_ctx.arc(
      vertices[v2][0] +
        Math.sin((Math.PI / 180) * (angle + 30)) *
          Math.sqrt(Math.pow(r / 2, 2) + Math.pow(bw_l * 2, 2)),
      vertices[v2][1] -
        Math.cos((Math.PI / 180) * (angle + 30)) *
          Math.sqrt(Math.pow(r / 2, 2) + Math.pow(bw_l * 2, 2)),
      c_r,
      0,
      2 * Math.PI
    );
    bg_ctx.fill();
    // port function resource and text
    if (res == null) {
      bg_ctx.textBaseline = "bottom";
      bg_ctx.textAlign = "center";
      bg_ctx.fillStyle = "#352d26";
      bg_ctx.font = refscale * 0.02 + "px Arial";
      bg_ctx.fillText(
        "?",
        vertices[v2][0] +
          Math.sin((Math.PI / 180) * (angle + 30)) *
            Math.sqrt(Math.pow(r / 2, 2) + Math.pow(bw_l * 2, 2)),
        vertices[v2][1] -
          Math.cos((Math.PI / 180) * (angle + 30)) *
            Math.sqrt(Math.pow(r / 2, 2) + Math.pow(bw_l * 2, 2))
      );
      bg_ctx.textBaseline = "top";
      bg_ctx.fillText(
        "3:1",
        vertices[v2][0] +
          Math.sin((Math.PI / 180) * (angle + 30)) *
            Math.sqrt(Math.pow(r / 2, 2) + Math.pow(bw_l * 2, 2)),
        vertices[v2][1] -
          Math.cos((Math.PI / 180) * (angle + 30)) *
            Math.sqrt(Math.pow(r / 2, 2) + Math.pow(bw_l * 2, 2))
      );
    } else {
      bg_ctx.fillStyle = colors[res];
      bg_ctx.beginPath();
      bg_ctx.arc(
        vertices[v2][0] +
          Math.sin((Math.PI / 180) * (angle + 30)) *
            Math.sqrt(Math.pow(r / 2, 2) + Math.pow(bw_l * 2, 2)),
        vertices[v2][1] -
          Math.cos((Math.PI / 180) * (angle + 30)) *
            Math.sqrt(Math.pow(r / 2, 2) + Math.pow(bw_l * 2, 2)) -
          c_r / 2,
        c_r / 2,
        0,
        2 * Math.PI
      );
      bg_ctx.fill();
      bg_ctx.textAlign = "center";
      bg_ctx.fillStyle = "#352d26";
      bg_ctx.font = refscale * 0.02 + "px Arial";
      bg_ctx.textBaseline = "top";
      bg_ctx.fillText(
        "2:1",
        vertices[v2][0] +
          Math.sin((Math.PI / 180) * (angle + 30)) *
            Math.sqrt(Math.pow(r / 2, 2) + Math.pow(bw_l * 2, 2)),
        vertices[v2][1] -
          Math.cos((Math.PI / 180) * (angle + 30)) *
            Math.sqrt(Math.pow(r / 2, 2) + Math.pow(bw_l * 2, 2))
      );
    }
  }
}

//determines the direction of the coast
function harbor_direction(v1, v2) {
  var right = (Math.sqrt(3) * r) / 2;
  if (Math.round(vertices[v1][0]) == Math.round(vertices[v2][0])) {
    if (
      Math.round(vertices[coast_verts[coast_verts.indexOf(v2) + 1]][0]) ==
        Math.round(vertices[v2][0] + right) ||
      Math.round(vertices[coast_verts[coast_verts.indexOf(v1) - 1]][0]) ==
        Math.round(vertices[v2][0] + right)
    )
      return "W";
    else return "E";
  } else {
    var dir = "";

    if (Math.round(vertices[v1][1]) < h / 2) dir = "N";

    if (Math.round(vertices[v1][0] - right) == Math.round(vertices[v2][0])) {
      if (dir == "N") dir = "NE";
      else dir = "SW";
    } else if (dir == "N") {
      dir = "NW";
    } else {
      dir = "SE";
    }
    return dir;
  }
}
//constructs an undirected graph of all vertices and edges
function construct_graph() {
  var num_verts = parseInt(Object.keys(vertices).length, 10);
  g = new Graph(num_verts);
  for (var i = 0; i < num_verts; i++) {
    g.addVertex(i);
  }
  for (var i = 0; i < num_verts; i++) {
    var adj = get_adj(i);
    for (var j = 0; j < adj.length; j++) {
      if (adj[j] > i) {
        g.addEdge(i, adj[j]);
      }
    }
  }
  // g.printGraph();
}

//checks the possible adjacent vertices and returns their indeces
function get_adj(i) {
  var adj = [];
  var xi = vertices[i][0];
  var yi = vertices[i][1];
  var x = xi;
  var y = yi - r;
  var up = -r / 2;
  var right = (Math.sqrt(3) * r) / 2;
  for (k = 0; k < 6; k++) {
    if (k == 1) {
      y = yi + r;
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

    for (j = 0; j < parseInt(Object.keys(vertices).length, 10); j++) {
      if (
        Math.round(vertices[j][0]) == Math.round(x) &&
        Math.round(vertices[j][1]) == Math.round(y)
      ) {
        adj.push(j);
      }
    }
  }
  return adj;
}

//draws circles at vertices (used in debugging)
function draw_vertices() {
  bg_ctx.fillStyle = "green";
  for (i = 0; i < parseInt(Object.keys(vertices).length, 10); i++) {
    bg_ctx.fillStyle = "black";
    bg_ctx.beginPath();
    bg_ctx.arc(vertices[i][0], vertices[i][1], c_r, 0, 2 * Math.PI);
    bg_ctx.fill();
  }
  target = 10;
  bg_ctx.fillStyle = "red";
  bg_ctx.beginPath();
  bg_ctx.arc(vertices[target][0], vertices[target][1], c_r, 0, 2 * Math.PI);
  bg_ctx.fill();
  adj = get_adj(target);
  for (i = 0; i < adj.length; i++) {
    bg_ctx.fillStyle = "white";
    bg_ctx.beginPath();
    bg_ctx.arc(vertices[adj[i]][0], vertices[adj[i]][1], c_r, 0, 2 * Math.PI);
    bg_ctx.fill();
  }
}
//removes overlapping vertices
function remove_duplicates() {
  for (i = 0; i < parseInt(Object.keys(vertices).length, 10); i++) {
    var count = 0;
    for (j = i + 1; j < parseInt(Object.keys(vertices).length, 10); j++) {
      if (
        Math.round(vertices[j][0]) == Math.round(vertices[i][0]) &&
        Math.round(vertices[j][1]) == Math.round(vertices[i][1])
      ) {
        for (k = 0; k < 12; k++) {
          for (l = 0; l < 5; l++) {
            dist[i][k][l] += dist[j][k][l];
          }
        }

        dist.splice(j, 1);
        vertices.splice(j, 1);
        count++;
        j -= 1;
      }
    }
    if (count < 2) coast_verts.push(i);
  }
}
//draws all of the game tiles in the standard 34543 config with the resource color and number chips
function draw_tiles() {
  colors = {
    s: "#09af11",
    o: "#555555",
    b: "#693117",
    w: "#b39a2d",
    f: "#063300",
    r: "#c4bf98",
  };
  resource_index = { s: 0, o: 1, b: 2, w: 3, f: 4 };

  var right = (Math.sqrt(3) * r) / 2;
  var down = 1.5 * r;
  var xi = w / 2 - right * 4; // hexagon x
  var yi = h / 2 - down * 2; // hexagon y
  var num_tiles = parseInt(Object.keys(tiles).length, 10);

  var x = xi;
  var y = yi;
  for (let i = 0; i < num_tiles; i++) {
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
    bg_ctx.textBaseline = "alphabetic";
    draw_hexagon(x, y, tiles[i]);
    tile_centers[i] = [x, y];
    if (tiles[i][0] != "r") {
      bg_ctx.fillStyle = "#e9dfb5";
      bg_ctx.beginPath();
      bg_ctx.arc(x, y, c_r, 0, 2 * Math.PI);
      bg_ctx.fill();
      bg_ctx.font = 0.5 * r + "px Arial";
      bg_ctx.fillStyle = "black";
      bg_ctx.textAlign = "center";
      bg_ctx.fillText(tiles[i][1], x, y + r * 0.17);
    }
  }
}

// draws a hexagon at the given position with a given tile
function draw_hexagon(x, y, tile) {
  bg_ctx.fillStyle = colors[tile[0]];

  bg_ctx.beginPath();
  bg_ctx.moveTo(hexagon[0] + x, hexagon[1] + y);
  vertices.push([hexagon[0] + x, hexagon[1] + y]);
  for (i = 0; i < 6; i++) {
    dist.push([]);
    for (j = 0; j < 12; j++) dist[dist.length - 1].push([0, 0, 0, 0, 0]);

    if (tile[0] != "r")
      dist[dist.length - 1][tile[1] - 1][resource_index[tile[0]]]++;
  }

  for (i = 2; i < hexagon.length - 1; i += 2) {
    bg_ctx.lineTo(hexagon[i] + x, hexagon[i + 1] + y);
    vertices.push([hexagon[i] + x, hexagon[i + 1] + y]);
  }

  bg_ctx.closePath();
  bg_ctx.fill();
}

//wraps the given text to the width of the canvas and displays it
function wrapText(text, x, y, lineHeight, width) {
  var words = text.split(" ");
  var line = "";

  for (var n = 0; n < words.length; n++) {
    var testLine = line + words[n] + " ";
    var metrics = ctx.measureText(testLine);
    var testWidth = metrics.width;
    if (testWidth > width && n > 0) {
      ctx.fillText(line, x, y);
      line = words[n] + " ";
      y += lineHeight;
    } else {
      line = testLine;
    }
  }
  ctx.fillText(line, x, y);
}
