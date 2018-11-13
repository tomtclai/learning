open BsReactNative;

type item = {
  title: string,
  completed: bool
}

type state = {
  items: list(item)
}

let component = ReasonReact.reducerComponent("TodoApp");

let str = ReasonReact.string;

let convertToString = (~_number) => {
    /* "convert number to string " ++ String(number) */
    "seomtthing"
};
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
      <Text style=styles##body>
        (ReasonReact.string(numberOfItemsString))
      </Text>
  </View>
  }
};
