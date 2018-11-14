open BsReactNative;

/* https://jaredforsyth.com/posts/a-reason-react-tutorial/#10-defining-a-component 
https://github.com/reasonml-community/reason-react-example/tree/master/src*/ 

type item = {
  title: string,
  completed: bool
}

type state = {
  items: list(item)
}

let component = ReasonReact.reducerComponent("TodoApp");

let str = ReasonReact.string;

type action = 
  | AddItem;

let styles = 
StyleSheet.create(
  Style.(
    {
      "title":
        style([
          color(String("black")),
          fontWeight(`_100),
          fontSize(Float(30.))
          ]),
      "body":
      style([
        fontSize(Float(12.))
        ])
    }
  )
);

let newItem = () => {
  {
    title: "string",
    completed: false
  }
}

let make = (_children) => {
  ...component,
  initialState: () => {
    items: [
      {title: "some things to do", completed: false}
    ]
  },
  reducer: ((), _) => ReasonReact.NoUpdate,
  render: ({state: {items}}) => {
    let numberItems = List.length(items);
    let numberOfItemsString = {j|number of Items: $(numberItems)|j};
    <View>
      <Text style=styles##title>
        (ReasonReact.string("What to do"))
      </Text>
      <Text style=styles##body>
        (ReasonReact.string("Nothing"))
      </Text>
      <Button title="add" onPress=((_event) => Js.Console.warn("Pressed")) />
      <Text style=styles##body>
        (ReasonReact.string(numberOfItemsString))
      </Text>
  </View>
  }
};