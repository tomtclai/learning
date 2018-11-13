// Generated by BUCKLESCRIPT VERSION 4.0.7, PLEASE EDIT WITH CARE
'use strict';

var List = require("bs-platform/lib/js/list.js");
var Block = require("bs-platform/lib/js/block.js");
var ReasonReact = require("reason-react/lib/js/src/ReasonReact.js");
var Js_primitive = require("bs-platform/lib/js/js_primitive.js");
var Text$BsReactNative = require("bs-react-native/lib/js/src/components/text.js");
var View$BsReactNative = require("bs-react-native/lib/js/src/components/view.js");
var Style$BsReactNative = require("bs-react-native/lib/js/src/style.js");
var StyleSheet$BsReactNative = require("bs-react-native/lib/js/src/styleSheet.js");

var component = ReasonReact.reducerComponent("TodoApp");

function str(prim) {
  return prim;
}

function convertToString(_number) {
  return "seomtthing";
}

var styles = StyleSheet$BsReactNative.create({
      title: Style$BsReactNative.style(/* :: */[
            Style$BsReactNative.color(/* String */Block.__(0, ["black"])),
            /* :: */[
              Style$BsReactNative.fontWeight(/* _100 */1055956338),
              /* :: */[
                Style$BsReactNative.fontSize(/* Float */Block.__(0, [30])),
                /* [] */0
              ]
            ]
          ]),
      body: Style$BsReactNative.style(/* :: */[
            Style$BsReactNative.fontSize(/* Float */Block.__(0, [12])),
            /* [] */0
          ])
    });

function make(_children) {
  return /* record */[
          /* debugName */component[/* debugName */0],
          /* reactClassInternal */component[/* reactClassInternal */1],
          /* handedOffState */component[/* handedOffState */2],
          /* willReceiveProps */component[/* willReceiveProps */3],
          /* didMount */component[/* didMount */4],
          /* didUpdate */component[/* didUpdate */5],
          /* willUnmount */component[/* willUnmount */6],
          /* willUpdate */component[/* willUpdate */7],
          /* shouldUpdate */component[/* shouldUpdate */8],
          /* render */(function (param) {
              var numberItems = List.length(param[/* state */1][/* items */0]);
              var numberOfItemsString = "number of Items: " + (String(numberItems) + "");
              return ReasonReact.element(undefined, undefined, View$BsReactNative.make(undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined)(/* array */[
                              ReasonReact.element(undefined, undefined, Text$BsReactNative.make(undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, Js_primitive.some(styles.title), undefined, undefined, undefined, undefined, undefined, undefined, undefined, /* array */["What to do"])),
                              ReasonReact.element(undefined, undefined, Text$BsReactNative.make(undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, Js_primitive.some(styles.body), undefined, undefined, undefined, undefined, undefined, undefined, undefined, /* array */["Nothing"])),
                              ReasonReact.element(undefined, undefined, Text$BsReactNative.make(undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, Js_primitive.some(styles.body), undefined, undefined, undefined, undefined, undefined, undefined, undefined, /* array */[numberOfItemsString]))
                            ]));
            }),
          /* initialState */(function (param) {
              return /* record */[/* items : :: */[
                        /* record */[
                          /* title */"some things to do",
                          /* completed */false
                        ],
                        /* [] */0
                      ]];
            }),
          /* retainedProps */component[/* retainedProps */11],
          /* reducer */(function (param, param$1) {
              return /* NoUpdate */0;
            }),
          /* subscriptions */component[/* subscriptions */13],
          /* jsElementWrapped */component[/* jsElementWrapped */14]
        ];
}

exports.component = component;
exports.str = str;
exports.convertToString = convertToString;
exports.styles = styles;
exports.make = make;
/* component Not a pure module */
