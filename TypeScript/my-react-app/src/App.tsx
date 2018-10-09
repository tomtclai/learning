import * as React from "react";
import "./App.css";
import Hello from "./components/Hello";
import * as ReactDOM from "react-dom";

class App extends React.Component {
  public render() {
    ReactDOM.render(
      <Hello name="TypeScript" enthusiasmLevel={10} />,
      document.getElementById("root") as HTMLElement
    );
  }
}

export default App;
