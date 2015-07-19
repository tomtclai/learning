import 'dart:html';

void main() {
  querySelector("#button").onClick.listen(sayHello);
  // #button : id button
  // .onClikc.listen(sayHello) : call sayHello when click occurs
}

void sayHello(MouseEvent event) {
  querySelector('#name').text = (querySelector('#name_box') as InputElement).value;
  // element with the id "name" 's text
  // represent "name_box" as an InputElement
  (querySelector("#name_box") as InputElement).value = "";
}