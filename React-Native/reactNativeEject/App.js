/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 * @flow
 */

import React, {Component} from 'react';
import {
  Platform,
  StyleSheet,
  Text,
  View,
  TextInput,
  Button,
  SafeAreaView 
} from 'react-native';

const instructions = Platform.select({
  ios: 'Press Cmd+R to reload,\n' + 'Cmd+D or shake for dev menu',
  android:
    'Double tap R on your keyboard to reload,\n' +
    'Shake or press menu button for dev menu',
});

type Props = {};
export default class App extends Component<Props> {

  state = {
    placeName: ''
  }

  placeNameChangedHandler = val => {
    this.setState({
      placeName: val
    });
  };

  render() {
    return (
      <SafeAreaView style={styles.container}>
        <View style={styles.inputContainer}>
          <TextInput 
          style={styles.placeInput}
          placeholder="An awesome place"
          value={this.state.placeName}
          onChangeText={this.placeNameChangedHandler}/>
          <Button title="Add" style={styles.placeButton}/>
        </View>
      </SafeAreaView>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
    justifyContent: 'flex-start'
  },
  inputContainer: {
    width: "80%",
    flexDirection: "row",
    justifyContent: "space-between",
    alignItems: "center"
  },
  placeInput: {
    width: "70%"
  },
  placeButton: {
    width: "30%"
  }
});
