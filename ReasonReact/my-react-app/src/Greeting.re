let component = ReasonReact.statelessComponent("Greeting");

let make = (~name, _children) => {
  ...component,
  render: (_self) => <button> {ReasonReact.string(name)} </button>
};