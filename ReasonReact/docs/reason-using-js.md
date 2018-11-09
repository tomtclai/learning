---
title: ReasonReact using ReactJS
---

`MyBanner.js:`

```javascript
var ReactDOM = require('react-dom');
var React = require('react');

var MyBanner = function(props) {
   if (props.show) {
    return React.createElement('div', null,
      'Here\'s the message from the owner: ' + props.message
    );
  } else {
    return null;
  }
};

module.exports = MyBanner;
```

`MyBannerRe.re`

```reason
/* ReactJS used by ReasonReact */
/* This component wraps a ReactJS one, so that ReasonReact components can consume it */
/* Typing the myBanner.js component's output as a `reactClass`. */
[@bs.module] external myBanner : ReasonReact.reactClass = "./MyBanner";

[@bs.deriving abstract]
type jsProps = {
  show: bool,
  message: string,
};

/* This is like declaring a normal ReasonReact component's `make` function, except the body is a the interop hook wrapJsForReason */
let make = (~show, ~message, children) =>
  ReasonReact.wrapJsForReason(
    ~reactClass=myBanner,
    ~props=jsProps(~show, ~message),
    children,
  );
```
