ReactDOMRe.renderToElementWithId(<Component1 message="Hello!" />, "index1");

ReactDOMRe.renderToElementWithId(<Component2 greeting="Hello!" />, "index2");

/* ReactDOMRe.renderToElementWithId(<Greeting name="JON" />, "greeting"); */

/* The make function is whats called by ReasonReact's JSX. For now, the JSX less way of calling/rendering a component is  */


ReactDOMRe.renderToElementWithId(ReasonReact.element(Foo.make(~name="John", ~age=232, [||])), "greeting");