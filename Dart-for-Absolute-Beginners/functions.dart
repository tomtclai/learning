
// optional positional parameters


void repeat(String word, [int repetitions]){ //repetitions is optional
  if (repetitions != nill) { // check if repetitions was supplied
    for (int i = 0; i < repetitions; i++) {
      print(word);
    }
  } else { // repetitions was not supplied, so just print once
    print(word);
  }
}


// named optional parameters


void repeat(String word, {int repetitions: 1, String exclamation: ""}) {
  for (int i = 0 ; i < repetitions; i++) {
    print(word + exclamation); // the + operator can concatenate strings
  }
}

void main() {
  repeat("Dog"); // legal
  repeat("Dog", repetition: 2, exclamation: "!"); // legal
  repeat("Dog", exclamation: "!"); // legal
  repeat("Dog", exclamation: "!", repetitions:2); // legal
}


// functions within functions
void talkAbout(String toShout, shoutFunc) {
  print(shoutFUnc(toShout));
}

void main() {
  String exclame(String toExclame) => toExclame +"!";

  String manyTalk(String toMany) {
    String allTogether ="";
    for (int i = 0; i < 10; i++) {
      allTogether = allTogether + toMany; // keep contatenation toMany onto the end of itself
    }
    return allTogether
  }

  talkAbout("Hello", exclame);
  talkAbout("TicToc", manyTalk);
  talkAbout("Wow", (String s) => s.toUpperCase());
}
