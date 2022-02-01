import React, { useState, useEffect, useContext } from 'react';
import { requestForegroundPermissionsAsync, watchPositionAsync, Accuracy } from 'expo-location';


export default (callBack) => {
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
                callBack(location);
            })
        } catch (e) {
          setErr(e);
        }
    };

    useEffect(() => {
        startWatching();
    }, []);

    return [err]
}