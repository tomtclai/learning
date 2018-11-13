open BsReactNative;
open MyLabel;

module Main = {
  let component = ReasonReact.statelessComponent("Main")
  let pressHandler = () => {
    Js.Console.warn("Ouch")
  };

  let x = [%bs.raw {| 'here is a string from javascript' |}];

  let make = (_children) => {
    ...component,
    render: _self => {
      <SafeAreaView>
      <TouchableOpacity onPress=pressHandler>
        <Text> {ReasonReact.string("Something something " ++ x)} </Text>
        <MyLabel label="1"/>
        <MyLabel label="something"> </MyLabel> /* */
      </TouchableOpacity>
    </SafeAreaView>;
    }
  };
};


let app = () => <Main />;