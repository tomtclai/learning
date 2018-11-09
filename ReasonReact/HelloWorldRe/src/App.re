open BsReactNative;

open ReasonReact;

let pressed = () => Js.log("Hello");

module Styles = {
  open Style;
  let container =
    style([
      flex(1.),
      justifyContent(Center),
      alignItems(Center),
      backgroundColor("tomato"),
    ]);
  let text = style([color("#fff"), fontSize(Float(24.))]);
};

module Main = {
  let component = ReasonReact.statelessComponent("Main");
  let make = (~name, _children) => {
    ...component,
    render: _self =>
      <View style=Styles.container>
        <TouchableOpacity>
           ReasonReact.string ("Hello " ++ "!") </TouchableOpacity>
          /* <Text style=Styles.text value="Hello !" /> */
      </View>,
  };
};

let app = () => <Main name="Jon" />;