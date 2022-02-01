import React from 'react';
import { View, StyleSheet, Text, Button } from 'react-native';

const TrackListScreen = ({ navigation }) => {
    return <>
    <Text style={{ fontSize: 108 }}>TrackList Screen</Text>
    <Button title="TrackDetail"
        onPress={() => navigation.navigate('TrackDetail')} />
    <Button title="Main"
        onPress={() => navigation.navigate('mainFlow')} />
</>
}

const styles = StyleSheet.create({});
export default TrackListScreen;