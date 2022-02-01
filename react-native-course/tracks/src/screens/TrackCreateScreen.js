import '../_mockLocation';
import React, { useState, useEffect, useContext } from 'react';
import { StyleSheet } from 'react-native';
import { Text } from 'react-native-elements';
import { SafeAreaView } from 'react-native-safe-area-context';
import Map from '../components/Map';
import { requestForegroundPermissionsAsync, watchPositionAsync, Accuracy } from 'expo-location';
import { Context as LocationContext } from '../context/LocationContext';
import useLocation from '../hooks/useLocation';
const TrackCreateScreen = () => {
    const { addLocation } = useContext(LocationContext);
    const [err] = useLocation((location) => addLocation(location));

    return <SafeAreaView>
        <Text h3> Create Track</Text>
        <Map />
        {err ? <Text> Enable location pls</Text>: null}
    </SafeAreaView>
}



const styles = StyleSheet.create({});
export default TrackCreateScreen;