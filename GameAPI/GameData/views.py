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

with open('GameData/game_data.json') as f:
    game_data = json.load(f)


@api_view(['GET'])
def PlayerHand(playername):
    try:
        player = str(json.loads(playername.body))
        hand = str(game_data['players'][player]['hand'])
        return JsonResponse("Hand: " + hand, safe=False)
    except ValueError as e:
        return Response(e.args[0], status.HTTP_400_BAD_REQUEST)
