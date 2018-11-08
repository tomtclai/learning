
/* ReasonReact doesnt use/need classes */
/* The component creation API gives your a plain record, whoee fields (like render) you can provide */
let component = ReasonReact.statelessComponent("Greeting");

/* In reactJS, youd create acomponent class and call it thru JSX which transforms into React.createElement(myClass, {prop1: 'hello'}) under the hood.*/
/* In reason react, instead of passing the whole class into a hypothetical reasonreact.createElement funcction, youd instead declare a make function*/
let make = (~name, _children) => {
  ...component,
  render: (_self) => <button> {ReasonReact.string("Hello " ++ name ++ "!")} </button>
};
