open BsReactNative;

module Main = {
  let component = ReasonReact.statelessComponent("Main")
  let pressHandler = () => {
    Js.Console.warn("Ouch")
  };

  let make = (_children) => {
    ...component,
    render: _self => {
      <SafeAreaView>
      <TouchableOpacity onPress=pressHandler>
        <Text> {ReasonReact.string("Something something")} </Text>
      </TouchableOpacity>
    </SafeAreaView>;
    }
  }
};




let app = () => <Main />;



