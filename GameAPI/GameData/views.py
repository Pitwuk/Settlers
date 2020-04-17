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

file = 'GameData/game_data_format_example.json'
with open(file) as f:
    game_data = json.load(f)


@api_view(['PUT', 'GET'])
def GameData(new_data):
    if new_data.method == 'PUT':
        try:

            new_data = json.load(new_data)
            print(new_data)

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
                    game_data['players'][new_data[key]
                                         ] = game_data['player_blank']
                elif key == '%player_order%':  # initialize random player order
                    players = [*game_data['players']]
                    print(players)
                    random.shuffle(players)
                    game_data['player_order'] = players
                elif key[0] == '>':
                    game_data[key[1:]].append(new_data[key])
                else:
                    game_data[key] = new_data[key]
            with open(file, "w") as outfile:
                outfile.write(json.dumps(game_data))
            return JsonResponse(game_data)
        except ValueError as e:
            return Response(e.args[0], status.HTTP_400_BAD_REQUEST)
    else:
        try:
            return JsonResponse(game_data)
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
