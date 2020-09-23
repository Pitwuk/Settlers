from django.shortcuts import render
from django.http import Http404
from rest_framework.views import APIView
from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status
from django.http import JsonResponse
from django.core import serializers
from django.conf import settings
import json
import random
import ast

file = 'GameData/game_data.json'
with open(file) as f:
    game_data = json.load(f)


@api_view(['PUT', 'GET'])
def GameData(new_data):
    new_data = json.load(new_data)
    print(new_data)
    game = new_data['game']
    if len(new_data.keys()) > 1:
        try:
            del new_data['game']
            if game not in game_data.keys() and 'num_players' in new_data.keys():
                game_data[game] = {
                    "players": {},
                    "num_players": 0,
                    "curr_player": 0,
                    "vertices": [],
                    "coast_verts": [],
                    "vertex_Xs": [],
                    "tiles": {},
                    "tile_centers": [],
                    "distribution": {},
                    "longest_road": 0,
                    "largest_army": 0,
                    "robber_loc": 0,
                    "player_order": [],
                    "next_scren": "false",
                    "taken_colors": [], "stored_settlements": [], "stored_roads": [], "stored_cities": [], "dice_num": 0, "monopoly": -1
                }

            for key in new_data:
                if '/' in key:  # enter data into objects within objects
                    key_arr = key.split('/')
                    if len(key_arr) == 2:
                        game_data[key_arr[0]][key_arr[1]] = new_data[key]
                    elif len(key) == 3:
                        game_data[key_arr[0]][key_arr[1]
                                              ][key_arr[2]] = new_data[key]
                    else:
                        print('Too Deep')
                elif key == '%new_player%':  # initialize new player
                    if new_data[key] in game_data[game]['players'].keys():
                        return Response(e.args[0], status.HTTP_400_BAD_REQUEST)
                    game_data[game]['players'][new_data[key]] = {"color": "",
                                                                 "hand": [0, 11, 2, 5, 20],
                                                                 "points": 0,
                                                                 "settlements": [],
                                                                 "roads": [],
                                                                 "road_graph": None,
                                                                 "road_verts": [],
                                                                 "ports": [],
                                                                 "dev_cards": [0, 0, 0, 0, 0],
                                                                 "used_dev_cards": [0, 0, 0, 0],
                                                                 "longest_road": False,
                                                                 "largest_army": False}
                    game_data[game]['player_order'].append(new_data[key])
                elif key == '%player_order%':  # initialize random player order
                    players = [*game_data[game]['players']]
                    print(players)
                    random.shuffle(players)
                    game_data[game]['player_order'] = players
                elif key[0] == '>':
                    game_data[game][key[1:]].append(new_data[key])
                else:
                    game_data[game][key] = new_data[key]
            print(game_data)
            with open(file, "w") as outfile:
                outfile.write(json.dumps(game_data))
            return JsonResponse(game_data[game])
        except ValueError as e:
            return Response(e.args[0], status.HTTP_400_BAD_REQUEST)
    else:
        try:
            return JsonResponse(game_data[game])
        except ValueError as e:
            return Response(e.args[0], status.HTTP_400_BAD_REQUEST)


@api_view(['GET'])
def PlayerHand(playername):
    try:

        player = str(json.loads(playername.body))
        hand = str(game_data['players'][player]['hand'])
        return JsonResponse("Hand: " + hand, safe=False)
    except ValueError as e:
        return Response(e.args[0], status.HTTP_400_BAD_REQUEST)
