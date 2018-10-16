import React from "react";
import {
  View,
  Image,
  Text,
  Button,
  StyleSheet,
  SafeAreaView,
  TouchableOpacity
} from "react-native";

import Icon from "react-native-vector-icons/Ionicons";

const placeDetail = props => {

  return (
      <SafeAreaView style={styles.container}>
        <View>
          <Image source={props.selectedPlace.image} style={styles.placeImage} />
          <Text style={styles.placeName}>{props.selectedPlace.name}</Text>
        </View>
        <View>
          <TouchableOpacity onPress={props.onItemDeleted}>
            <View style={styles.deleteButton}>
              <Icon name="ios-trash" size={30} color="red" />
            </View>
          </TouchableOpacity>
        </View>
      </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  container: {
    margin: 22
  },
  placeImage: {
    width: "100%",
    height: 200
  },
  placeName: {
    fontWeight: "bold",
    textAlign: "center",
    fontSize: 28
  },
  deleteButton: {
    alignItems: "center"
  }
});

export default placeDetail;
