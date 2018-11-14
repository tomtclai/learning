open BsReactNative;
open MyLabel;


module Main = {
  let component = ReasonReact.statelessComponent("Main");
  let pressHandler = () => Js.Console.warn("Ouch");

  let x = [%bs.raw {| 'here is a string from javascript' |}];

  let make = _children => {
    ...component,
    render: _self =>
      <View>
        <SafeAreaView>
          <TouchableOpacity onPress=pressHandler>
            <Text> {ReasonReact.string("Something something " ++ x)} </Text>
            <MyLabel label="Something" />
          </TouchableOpacity>
        </SafeAreaView>
      </View>,
  };
};

let app = () => <Main />;