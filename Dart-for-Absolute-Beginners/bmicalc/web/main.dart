// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:html';

bool imperial = true;
const int IMPERIAL_MULTIPLER = 703;
void main() {
  querySelector("#unit_type1").onChange.listen(changeUnits);
  querySelector("#unit_type2").onChange.listen(changeUnits);
  querySelector("#submit").onClick.listen(calculate);
}

/// Change the units displayed by the inputs
/// and update [imperial]

void changeUnits(Event e) {
  // if imperial is checked
  if ((querySelector("#unit_type1") as RadioButtonInputElement).checked) {
    imperial = true;
    querySelector("#weight_units").text = "pounds";
    querySelector("#height_units").text = "inches";
  } else { // metric is checked
    imperial = false;
    querySelector("#weight_units").text = "kilograms";
    querySelector("#height_units").text = "meters";
  }
}

/// Check the heigh and weight inputs are valid
/// Calculate the bmi and display the results

void calculate(MouseEvent event) {
  double height, weight;
  // get the height and weight
  try {
    weight = double.parse((querySelector("#weight_input") as InputElement).value);
    height = double.parse((querySelector("#height_input") as InputElement).value);
  } on FormatException { // could not turn into a double
    window.alert("Only numbers are valid input.");
    return;
  }

  // do calculations
  double bmi = weight / (height * height);
  if (imperial) {
    bmi *= IMPERIAL_MULTIPLER;
  }

  // update display
  querySelector("#result1").text = "Your BMI is " + bmi.toStringAsFixed(1);
  String comment;

  if (bmi < 18.5 ) {
    comment = "Underweight";
  } else if ( bmi < 25.0) {
    comment = "Normal";
  } else if ( bmi < 30.0) {
    comment = "Overweight";
  } else {
    comment = "Obese";
  }

  querySelector("#result2").text = comment;
}