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
                if key in game_data.keys():
                    game_data[key] = new_data[key]
                else:
                    return Response(e.args[0], status.HTTP_400_BAD_REQUEST)
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
