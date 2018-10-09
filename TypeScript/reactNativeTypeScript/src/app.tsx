import React from "react";
import { View, Text, StyleSheet, ImageBackground } from "react-native";

interface Props {}

interface State {
  name: string;
}

class App extends React.Component {
  state = { name: "Nadar" };
  render() {
    return (
      <View style={styles.container}>
        <Text style={styles.text}>Hello {this.state.name}</Text>
      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: "center",
    alignItems: "center",
    backgroundColor: "#f5fcff"
  },
  text: {
    fontSize: 28,
    textAlign: "center",
    margin: 10
  }
});

export default App;
