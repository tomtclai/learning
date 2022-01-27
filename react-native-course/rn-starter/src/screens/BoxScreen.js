import React from 'react';

import { View, Text, StyleSheet } from 'react-native';
import ImageDetail from '../components/ImageDetail';

const BoxScreen = () => {
    return <View style={styles.viewStyle}>
        <Text style={styles.textStyle1}>1</Text>
        <Text style={styles.textStyle2}>2222</Text>
        <Text style={styles.textStyle3}>3333333</Text>
    </View>
}

const styles = StyleSheet.create({
    viewStyle: {
        borderWidth: 3,
        borderColor: 'black',
        flexDirection: 'row',
        height: 200,
        alignItems: 'center'
    },
    textStyle1: {
        height: 100,
        borderWidth: 3,
        borderColor: 'red',
        flex: 1,
        bottom: 50,
    },
    textStyle2: {
        top: 50,
        height: 100,
        borderWidth: 3,
        borderColor: 'red',
        flex: 1,
        marginHorizontal: 30
    },
    textStyle3: {
        height: 100,
        borderWidth: 3,
        borderColor: 'red',
        flex: 1,
        bottom: 50,
    }
});

export default BoxScreen