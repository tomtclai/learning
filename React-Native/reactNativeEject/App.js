/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 * @flow
 */

import React, {Component} from 'react';
import {Platform, StyleSheet, Text, View, TextInput, SafeAreaView } from 'react-native';

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
        <TextInput 
        style={{width: 300}}
        placeholder="An awesome place"
        value={this.state.placeName}
        onChangeText={this.placeNameChangedHandler}/>
      </SafeAreaView>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex:1,
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
    justifyContent: 'flex-start'
  },
  welcome: {
    fontSize: 20,
    textAlign: 'center',
    margin: 10,
  },
  instructions: {
    textAlign: 'center',
    color: '#333333',
    marginBottom: 5,
  },
});
