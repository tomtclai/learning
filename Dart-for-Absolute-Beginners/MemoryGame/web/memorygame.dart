// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:html';
import 'dart:async';

// A lot of constants makes for maintainable code as opposed
// to using magic numbers (or magic Strings for that matter)

const int NUM_CARDS = 16;
const int NUM_OF_EACH = 4;
const String CARD_BACK = "images/card_back.png";
const List<String> CARD_FILE_NAMES = const ["images/dog.png", "images/cat.png",
                                            "images/giraffe.png", "images/turtle.png"];

int stirkes, cardsLeft;
List<String> cards; // actual deck
ImageElement lastClicked;

// Resets the game board for a new game

void reset() {
  strikes = 0;
  cardsLeft = NUM_CARDS;
  querySelector("#num_strikes").text = strikes.toString();
  querySelector("#num_left").text = cardsLeft.toString();
  // find all <img> Elements in the DOM and change their src
  // attribute to be that of the facedown card
  for (ImageElement img in querySelectorAll("img")) {
    img.src = CARD_BACK;
  }
  // create the randomly ordered deck of cards
  cards = new List();

  for (String cardFileName in CARD_FILE_NAMES) {
    for (int i = 0; i < NUM_OF_EACH; i ++) {
      cards.add(cardFileName);
    }
  }
  cards.shuffle();
}


void main() {

}
