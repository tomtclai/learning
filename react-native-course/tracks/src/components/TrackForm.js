import React, { useContext } from 'react';
import { StyleSheet, TouchableOpacity } from 'react-native';
import { Text } from 'react-native-elements';
import Spacer from '../components/Spacer';
import { withNavigation } from 'react-navigation';
import { Button, Input } from 'react-native-elements';
import { Context as LocationContext } from '../context/LocationContext';
const TrackForm = () => {
    const { state: { name, recording, locations }, startRecording, stopRecording, changeName } = useContext(LocationContext);
    console.log(locations.length);
    return <>
            <Input value={name} onChangeText={changeName} placeholder="Enter Name" />
        {
            recording ?
                <Button title="Stop" onPress={stopRecording}></Button> :
                <Button title="Start recording" onPress={startRecording}></Button>
        }

        {!recording && locations.length ?
            <Button title="Save Recording" onPress={startRecording}></Button> : null
        }
    </>


}


const styles = StyleSheet.create({
    container: {
        flex: 1,
        justifyContent: 'center',
        marginBottom: '50%'
    },
    errorMessage: {
        fontSize: 16,
        color: 'red',
        margin: 15
    },
    link: {
        color: 'blue'
    }
});
export default TrackForm;