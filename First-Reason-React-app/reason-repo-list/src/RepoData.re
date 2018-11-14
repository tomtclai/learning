type repo = {
  full_name: string,
  stargazers_count: int,
  html_url: string
};

/* Reason has some handy syntax to help us when we need to refer to the exports of a particular module over and over again. One option is to Open the module. Which means all of its expoets become avaialbe in the current scope. So we can ditch the JsonDecode qualifier 

open Json.Decode;

let parseRepoJson = (json: Js.Json.t): repo => {
  full_name: field("full_name", string, json), 
  stargazers_count: field("stargazers_count", int, json),
  html_url: field("html_url", string, json)
};

*/

/* However this does introduce the risk of name collisions if you're opening multiple modules. Another option is to use the module name, followed by a period before an expression. Inside the expression we can use any export of the moduel without qualifying it with the module name */


let parseRepoJson = (json: Js.Json.t): repo => {
  Json.Decode.{
    full_name: field("full_name", string, json), 
    stargazers_count: field("stargazers_count", int, json),
    html_url: field("html_url", string, json)
  }
};


let parseReposResponseJson = json => Json.Decode.field("items", Json.Decode.array(parseRepoJson), json)


let reposUrl = "https://api.github.com/search/repositories?q=topic%3Areasonml&type=Repositories";

let fetchRepos = () =>
Js.Promise.(
  Bs_fetch.fetch(reposUrl)
    |> then_(Bs_fetch.Response.text)
    |> then_(
      jsonText => 
        resolve(parseReposResponseJson(Js.Json.parseExn(jsonText)))
    )
);