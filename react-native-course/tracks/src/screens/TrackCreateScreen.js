import '../_mockLocation';
import React, { useState, useEffect, useContext } from 'react';
import { StyleSheet } from 'react-native';
import { Text } from 'react-native-elements';
import { SafeAreaView } from 'react-native-safe-area-context';
import Map from '../components/Map';
import { requestForegroundPermissionsAsync, watchPositionAsync, Accuracy } from 'expo-location';
import { Context as LocationContext } from '../context/LocationContext';

const TrackCreateScreen = () => {
    const { addLocation } = useContext(LocationContext);
    const [err, setErr] = useState(null)
    const startWatching = async () => {
        try {
          const { granted } = await requestForegroundPermissionsAsync();
            if (!granted) {
            throw new Error('Location permission not granted');
            }
            await watchPositionAsync(
            {
                accuracy: Accuracy.BestForNavigation,
                timeInterval: 1000,
                distanceInterval: 10
            }, (location) => {
                addLocation(location);
            })
        } catch (e) {
          setErr(e);
        }
    };

    useEffect(() => {
      startWatching();
    }, []);

    return <SafeAreaView>
        <Text h3> Create Track</Text>
        <Map />
        {err ? <Text> Enable location pls</Text>: null}
    </SafeAreaView>
}



const styles = StyleSheet.create({});
export default TrackCreateScreen;