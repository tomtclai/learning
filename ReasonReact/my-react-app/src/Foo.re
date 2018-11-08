let component = ReasonReact.statelessComponent("Foo");

/* In reactJS, youd create acomponent class and call it thru JSX which transforms into React.createElement(myClass, {prop1: 'hello'}) under the hood.*/
/* In reason react, instead of passing the whole class into a hypothetical reasonreact.createElement funcction, youd instead declare a make function*/
let make = (~name, ~age=?, _children) => {
  ...component,
  render: (_self) => <button> {ReasonReact.string({j| foo 🔄 $name|j})} </button>
};


let me: School.person = {age: 20, name: "Big Reason"};
/* or */
let me2 = School.{age: 20, name: "Big Reason"};
/* or */
let me3 = {School.age: 20, name: "Big Reason"};
