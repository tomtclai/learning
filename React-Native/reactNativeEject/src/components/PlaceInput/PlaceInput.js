import React, { Component } from 'react';
import { StyleSheet, View, Text, TextInput, Button } from  'react-native';

export class PlaceInput extends Component {

  state = {
    placeName: ''
  }

  placeNameChangedHandler = val => {
    this.setState({
      placeName: val,
    });
  };

  placeSubmitHandler = () => {
    if (this.state.placeName.trim() === "") {
      return;
    }

    this.props.onPlaceAdded(this.state.placeName);
  };

  render() {
    return (
    <View style={styles.inputContainer}>
      <TextInput 
      style={styles.placeInput}
      placeholder="An awesome place"
      value={this.state.placeName}
      onChangeText={this.placeNameChangedHandler}
      />
      <Button 
      title="Add" 
      style={styles.placeButton} 
      onPress={this.placeSubmitHandler}
      />
    </View>
    );
  }
}

const styles = StyleSheet.create({
inputContainer: {
  width: "80%",
  flexDirection: "row",
  justifyContent: "space-between",
  alignItems: "center"
},
placeButton: {
  width: "30%"
}});


export default PlaceInput;
