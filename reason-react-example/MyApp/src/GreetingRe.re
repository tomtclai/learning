

let component = ReasonReact.statelessComponent("pageReason");
type something = { message: string, extraGreeting: string}
let make (~message, ~extraGreeting="How are u?", _children) => {
  ...component,
  render: _self => {
    let greeting = 
      switch (extraGreeting) {
      | None => "How are u?"
      | Some(g) => g
      };
    <div> <MyBannerRe show=true message={message ++ " " ++ greeting} /> </div>;
  },
};


/* The following exposes a jsComponent that the ReactJS side can use was require('greetingRe.js').jsComponent  */

[@bs.deriving abstract]
type jsProps = {
  message: string,
  extraGreeting: Js.nullable(string),
  children: array(ReasonReact.reactElement),
};

let jsComponent = 
  ReasonReact.wrapReasonForJs(~component, jsProps =>
    make(
      ~message=jsProps->messageGet,
      ~extraGreeting=?Js.Nullable.toOption(jsProps->extraGreetingGet),
      jsProps->childrenGet,
      )
    );