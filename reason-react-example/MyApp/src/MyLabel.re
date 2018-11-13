/* like import Component from react */
open BsReactNative;

let component = ReasonReact.statelessComponent("MyLabel")

let styles = 
StyleSheet.create(
  Style.(
    {
      "container":
      style([
        borderRadius(4.),
        paddingHorizontal(Pt(10.)),
        paddingVertical(Pt(2.)),
        backgroundColor(String("#00FF00"))
      ]),
      "label":
        style([
          color(String("black")), 
          textAlign(Center), 
          fontSize(Float(11.))])
    }
  )
);

let make = (~label, _children) => {
  ...component,
  render: _self => 
  <View style=styles##container>
    <Text style=styles##label>
    (ReasonReact.string(label))
    </Text>
  </View>
};

let default = 
  ReasonReact.wrapReasonForJs(
    ~component, 
    jsProps => make(~label=jsProps##label, [||])
  );