open BsReactNative;


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
      </TouchableOpacity>
    </SafeAreaView>;
    }
  };
};


let app = () => <Main />;