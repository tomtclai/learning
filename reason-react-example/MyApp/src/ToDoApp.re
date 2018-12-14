open BsReactNative;

/* https://jaredforsyth.com/posts/a-reason-react-tutorial/#10-defining-a-component 
https://github.com/reasonml-community/reason-react-example/tree/master/src*/ 

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

type action = 
  | AddItem;

type item = {
  title: string,
  completed: bool
}

type state = {
  items: list(item)
}



let component = ReasonReact.reducerComponent("TodoApp");

let newItem = () => {title: "Click a button", completed: true};

let str = ReasonReact.string;

let newItem = () => {title: "Click a button", completed: true};

let make = (children) => {
  ...component,
  initialState: () => {
    items: [
      {title: "some things to do", completed: false}
    ]
  },
  reducer: (action, {items}) => 
    switch action {
    | AddItem => ReasonReact.Update({items: [newItem(), ...items]})
    },
  render: ({state: {items}, send}) => {
    let numberItems = List.length(items);
    let numberOfItemsString = {j|number of Items: $(numberItems)|j};
    <View>
      <Text style=styles##title>
        (ReasonReact.string("What to do"))
      </Text>
      <Text style=styles##body>
        (ReasonReact.string("Nothing"))
      </Text>
      <Button title="add" onPress=((_evt) => send(AddItem)) />
      <Text style=styles##body>
        (ReasonReact.string(numberOfItemsString))
      </Text>
  </View>
  }
};


