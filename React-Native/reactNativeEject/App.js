/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 * @flow
 */

import React, { Component } from "react";
import {
  StyleSheet,
  SafeAreaView
} from "react-native";

import PlaceInput from "./src/components/PlaceInput/PlaceInput";
import PlaceList from "./src/components/PlaceList/PlaceList";
import PlaceDetail from "./src/components/PlaceDetail/PlaceDetails";

type Props = {};
export default class App extends Component<Props> {
  state = {
    places: [],
    selectedPlace: null
  };

  placeAddedHandler = placeName => {
    this.setState(prevState => {
      return {
        places: prevState.places.concat({
          key: "" + Math.random(),
          name: placeName,
          image: {
            uri:
              "https://web.fdcanet.com/data/files/mall/article/201509071644139049.jpg"
          }
        })
      };
    });
  };

  placeDeletedHandler = () => {
    this.setState(prevState => {
      return {
        places: prevState.places.filter(place => {
          return place.key !== prevState.selectedPlace.key;
        }),
        selectedPlace: null
      };
    });
  }

  onModalClosedHandler = () => {
    this.setState(
      {
        selectedPlace: null
      }
    );
  }

  placeSelectedHandler = key => {
    this.setState(prevState => {
      return {
        selectedPlace: prevState.places.find(place => {
          return place.key === key;
        })
      };
    });
  };

  render() {
    return (
      <SafeAreaView style={styles.container}>
        <PlaceDetail
        selectedPlace={this.state.selectedPlace} 
        onItemDeleted={this.placeDeletedHandler} 
        onModalClosed={this.onModalClosedHandler}
         />
        <PlaceInput onPlaceAdded={this.placeAddedHandler} />
        <PlaceList
          places={this.state.places}
          onItemSelected={this.placeSelectedHandler}
        />
      </SafeAreaView>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: "center",
    backgroundColor: "#F5FCFF",
    justifyContent: "flex-start"
  },
  inputContainer: {
    width: "80%",
    flexDirection: "row",
    justifyContent: "space-between",
    alignItems: "center"
  }
});
