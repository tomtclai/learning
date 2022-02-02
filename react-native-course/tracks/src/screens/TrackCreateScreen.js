import '../_mockLocation';
import React, { useState, useEffect, useContext, useCallback } from 'react';
import { StyleSheet } from 'react-native';
import { Text } from 'react-native-elements';
import { withNavigationFocus } from 'react-navigation';
import { SafeAreaView } from 'react-native-safe-area-context';
import Map from '../components/Map';
import { requestForegroundPermissionsAsync, watchPositionAsync, Accuracy } from 'expo-location';
import { Context as LocationContext } from '../context/LocationContext';
import useLocation from '../hooks/useLocation';
import TrackForm from '../components/TrackForm';
const TrackCreateScreen = ({ isFocused }) => {
    const { state: { recording }, addLocation } = useContext(LocationContext);
    const callback = useCallback((location) => {
        addLocation(location, recording)
    },[recording])
    const [err] = useLocation(isFocused || recording, callback);

    return <SafeAreaView>
        <Text h3> Create Track</Text>
        <Map />
        {err ? <Text> Enable location pls</Text> : null}
        <TrackForm/>
    </SafeAreaView>
}



const styles = StyleSheet.create({});
export default withNavigationFocus(TrackCreateScreen);