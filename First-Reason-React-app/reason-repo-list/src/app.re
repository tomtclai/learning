type state = {repoData: option(array(RepoData.repo))};

type action =
  | Loaded(array(RepoData.repo))

  /* If you didnt have the pip characters here, then you would be defining a list intead of an array. In reason Lists are immutable, wheras arrays are mutable. However lists are easier to work with if you are dealing with a variable mumber of elements. Anyway here we're using an array */

let dummyRepos: array(RepoData.repo) = [|
  {
  full_name: "jsdf/reason-react-hacker-news",
  stargazers_count: 27,
  html_url: "https://github.com/jsdf/reason-react-hacker-news"
  },
  {
    stargazers_count: 93,
    full_name: "reasonml/reason-tools",
    html_url: "https://github.com/reasonml/reason-tools"
  }
|];

  
let component = ReasonReact.reducerComponent("App");
let make = (_children) => {
  ...component,
  initialState: () => {
    repoData: None
  },
  render: (self) => {
    let repoItems = switch (self.state.repoData) {
    | Some(repos) => ReasonReact.array(
        Array.map(
          (repo: RepoData.repo) => <RepoItem key=repo.full_name repo=repo />,
          repos
        )
      )
    | None => ReasonReact.string("Loading")
    };
    <div className="App">
      <h1>{ReasonReact.string("Reason Projects")}</h1>
        {repoItems}
    </div>
  },  
  reducer: (action, _state) => {
    switch action {
      | Loaded(loadedRepo) =>
        ReasonReact.Update({
          repoData: Some(loadedRepo)
        })
    }
  }
};