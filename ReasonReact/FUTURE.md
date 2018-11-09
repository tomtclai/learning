Like HISTORY.md, but for planned future versions and subject to change. The vocabulary here uses the past tense, to pretend that the versions are already published.

# 0.4.3

- Move artifacts generation back out-of-source. Sorry for the churn.

# Medium/Long-term

- Static tree (prevents top-level component switching, enables destructuring of owned tree).
- Getting rid of ref.
- Making a great list abstraction to model dynamically changing lists/scrollers.
- Preparation for namespace
- Set lifecycles to null when they do nothing. React skips over lifecycles that are set to null, we currently have wrappers around all of them, so things like didMount are enqueued for *every* component.
- `ReactDOMRe.createElement` (usually used through the JSX `<div> foo </div>`) has a new implementation that fixes an inadvertent children key warning in the previous version.
- remove `retainedProps` and `willReceiveProps` in favour of `getDerivedStateFromProps`
- better modeling for `ReasonReact.stateless` type from `unit` to something else
- expose `ReasonReact.publicComponentSpec(state, action)` for less cryptic component type annotation.
- Get rid of implicit keys on a component (likely non-breaking)
