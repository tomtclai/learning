let component = ReasonReact.statelessComponent("Foo");

/* In reactJS, youd create acomponent class and call it thru JSX which transforms into React.createElement(myClass, {prop1: 'hello'}) under the hood.*/
/* In reason react, instead of passing the whole class into a hypothetical reasonreact.createElement funcction, youd instead declare a make function*/
let make = (~name, ~age=?, _children) => {
  ...component,
  render: (_self) => <button>
   {
     switch (age) {
     | None => ReasonReact.string({j| hi 👋 $name|j})
     | Some(age) => ReasonReact.string({j| hi 👋 $name age $age|j})
     }
    } 
   </button>
};


let me: School.person = {age: 20, name: "Big Reason"};
/* or */
let me2 = School.{age: 20, name: "Big Reason"};
/* or */
let me3 = {School.age: 20, name: "Big Reason"};


Random.self_init();

let break = ref(false);

while (! break^) {
  if (Random.int(10) === 3) {
    break := true
  } else {
    print_endline("hello")
  }
};