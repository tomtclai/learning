type state = {
  count: int,
  show: bool
};

type action = 
  | Click
  | Toggle;

let component = ReasonReact.reducerComponent("Example");

let make = (~greeting, _children) => {
  ...component,
  initialState: () => {count: 0, show: true},

  /*  In ReasonReact, you'd gather all these state-setting handlers into a single place, the component's reducer!  */
  reducer: (action, state) =>
    switch (action) {
    | Click => ReasonReact.Update({...state, count: state.count+1})
    | Toggle => ReasonReact.Update({...state, show: !state.show})
    },

  render: self => {
    let message = "You've clicked this " ++ string_of_int(self.state.count) ++ " times(s)";
    <div>
      <button onClick=(_event => self.send(Click))>
        (ReasonReact.string(message))
      </button>
      <button onClick=(_event => self.send(Toggle))>
        (ReasonReact.string("Toggle greeting"))
      </button>
      (
        self.state.show 
          ? ReasonReact.string(greeting)
          : ReasonReact.null
      )
      </div>;
  },
};