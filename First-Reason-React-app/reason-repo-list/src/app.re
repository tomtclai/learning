type state = {repoData: option(array(RepoData.repo))};

type action =
  | Loaded(array(RepoData.repo))

  /* If you didnt have the pip characters here, then you would be defining a list intead of an array. In reason Lists are immutable, wheras arrays are mutable. However lists are easier to work with if you are dealing with a variable mumber of elements. Anyway here we're using an array */

let dummyRepos: array(RepoData.repo) = [|
  RepoData.parseRepoJson(
    Js.Json.parseExn(
      {js|
        {
        "stargazers_count": 27,
        "full_name": "jsdf/reason-react-hacker-news",
        "html_url": "https://github.com/jsdf/reason-react-hacker-news"
        }
        |js}
    )
  )

|];

  
let component = ReasonReact.reducerComponent("App");
let make = (_children) => {
  ...component,
  initialState: () => {
    repoData: None
  },
  /* First we implement the did mount method */
  didMount: (self) => {
    /* We use self.send to create a function called handleReposLoaded to handle our loaded data and update the component state */
    let handleReposLoaded = (repoData) => self.send(Loaded(repoData));
    RepoData.fetchRepos()
      |> Js.Promise.then_(repoData => {
          handleReposLoaded(repoData);
          Js.Promise.resolve();
        })
      |> ignore;
  },
  reducer: (action, _state) => {
    switch action {
      | Loaded(loadedRepo) => ReasonReact.Update({
          repoData: Some(loadedRepo)
        })
    };
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
  }
};