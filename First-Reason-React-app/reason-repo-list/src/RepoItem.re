/* https://jamesfriend.com.au/a-first-reason-react-app-for-js-developers */

let component = ReasonReact.statelessComponent("RepoItem");

/* Every reason react component is a reason module which defines a function called make. Which defines props and children arguments. The props are specified as Labelled Arguments */
let make = (~repo: RepoData.repo, _children) =>
{
  ...component,
  render: (_self) => 
        <div className="RepoItem">
        <a href=repo.html_url>
          <h2>{ReasonReact.string(repo.full_name)}</h2>
        </a>
        {ReasonReact.string(string_of_int(repo.stargazers_count) ++ " stars")}
      </div>
};
/* THe make function returns a record. The first thing in the record is ...componnet, this is the requrned value of reducerComponent / statelessComponenet */