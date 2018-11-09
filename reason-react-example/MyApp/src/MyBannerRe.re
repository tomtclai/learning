/* reactJS used by ReasonReact */

[@bs.module] external myBanner: ReasonReact.reactClass = "./MyBanner";

[@bs.deriving abstract]
type jsProps ={
  show: bool,
  message: string,
};

let make = (~show, ~message, children) =>
  ReasonReact.wrapJsForReason(
    ~reactClass=myBanner,
    ~props=jsProps(~show, ~message),
    children,
  )