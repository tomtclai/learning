'use strict';

var Block = require("bs-platform/lib/js/block.js");
var ReasonReact = require("reason-react/src/ReasonReact.js");
var Js_primitive = require("bs-platform/lib/js/js_primitive.js");
var Text$BsReactNative = require("bs-react-native/src/components/text.js");
var View$BsReactNative = require("bs-react-native/src/components/view.js");
var Style$BsReactNative = require("bs-react-native/src/style.js");

var container = Style$BsReactNative.style(/* :: */[
      Style$BsReactNative.flex(1),
      /* :: */[
        Style$BsReactNative.justifyContent(/* Center */2),
        /* :: */[
          Style$BsReactNative.alignItems(/* Center */2),
          /* :: */[
            Style$BsReactNative.backgroundColor(/* String */Block.__(0, ["tomato"])),
            /* [] */0
          ]
        ]
      ]
    ]);

var text = Style$BsReactNative.style(/* :: */[
      Style$BsReactNative.color(/* String */Block.__(0, ["#fff"])),
      /* :: */[
        Style$BsReactNative.fontSize(/* Float */Block.__(0, [24])),
        /* [] */0
      ]
    ]);

var Styles = /* module */[
  /* container */container,
  /* text */text
];

var component = ReasonReact.statelessComponent("Main");

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
          /* render */(function (_self) {
              return ReasonReact.element(undefined, undefined, View$BsReactNative.make(undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, Js_primitive.some(container), undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined)(/* array */[ReasonReact.element(undefined, undefined, Text$BsReactNative.make(undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, Js_primitive.some(text), undefined, undefined, undefined, undefined, undefined, undefined, undefined, /* array */["RN with reason ML"]))]));
            }),
          /* initialState */component[/* initialState */10],
          /* retainedProps */component[/* retainedProps */11],
          /* reducer */component[/* reducer */12],
          /* jsElementWrapped */component[/* jsElementWrapped */13]
        ];
}

var Main = /* module */[
  /* component */component,
  /* make */make
];

function app(param) {
  return ReasonReact.element(undefined, undefined, make(/* array */[]));
}

exports.Styles = Styles;
exports.Main = Main;
exports.app = app;
/* container Not a pure module */
