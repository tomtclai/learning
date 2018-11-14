/* This allows us to include plain JS code between the braces. In this case we're just using it to incliude a CSS file in the usual webpack way.  */
[%%bs.raw {|
  require('./index.css');
|}]

ReactDOMRe.renderToElementWithId(<App />, "root");
