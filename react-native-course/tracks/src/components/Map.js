import React, {useContext} from 'react';
import { ActivityIndicator, StyleSheet, TouchableOpacity } from 'react-native';
import { Text } from 'react-native-elements';
import Spacer from '../components/Spacer';
import MapView, { Polyline, Circle } from 'react-native-maps';
import { Context as LocationContext } from '../context/LocationContext';


const Map = ({  }) => {
    const { state: { currentLocation, locations } } = useContext(LocationContext);

    console.log(locations);

    if (!currentLocation) {
        return <ActivityIndicator size="large" style={{ marginTop: 200 }}/>
    }
    const initialLocation = {
        longitude: -122.0312186,
        latitude: 37.33233141,
      };
    return <MapView
        style={styles.map}
        initialRegion={{
            ...initialLocation,
            latitudeDelta: 0.01,
            longitudeDelta: 0.01,
        }}

      region={{
        ...currentLocation.coords,
        latitudeDelta: 0.01,
        longitudeDelta: 0.01
      }}
    >
        <Circle center={currentLocation.coords}
            radius={120}
            strokeColor="rgba(158,158,255,1.0)"
            fillColor="rgba(158,158,255,0.3)"
        />

        {/* <Polyline coordinates={ locations.map(loc => loc.coordinates)}/> */}
    </MapView>
}


const styles = StyleSheet.create({
    map: {height: 500}
});
export default Map;