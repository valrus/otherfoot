from __future__ import (absolute_import, division, print_function, unicode_literals)
from builtins import *

import json
import sys
from argparse import ArgumentParser, ArgumentDefaultsHelpFormatter

from flask import Flask, jsonify, request

APP = Flask(__name__)

ROOMS = {}


class OtherfootGame(object):
    def __init__(self, players):
        self.cards = []
        self.players = players


@app.route('/submitcard', methods=['POST'])
def submit_card():
    pass


# Rooms, joining and starting games


@app.route('/getrooms', methods=['GET'])
def get_rooms():
    return jsonify(ROOMS)


@app.route('/join', methods=['POST'])
def join_room():
    player = request.args.get('player')
    room = request.args.get('room')
    if not room in ROOMS:
        # fail
        pass


@app.route('/start', methods=['POST'])
def start_game():
    pass


if __name__ == "__main__":
    APP.run(debug=True)
