import React, { useState } from 'react';
import { Text, StyleSheet, View, Button, TouchableOpacity } from 'react-native';
import ColorCounter from '../components/ColorCounter';
const COLOR_INCREMENT = 10

const SquareScreen = () => {
    const [red, setRed] = useState(0);
    const [green, setGreen] = useState(0);
    const [blue, setBlue] = useState(0);
    console.log(red)
    const setColor = (color, change) => {
        // color === 'red, 'green', 'blue'
        switch (color) {
            case 'red': red + change > 255 || red + change < 0 ? null : setRed(red + change);
                return;
            case 'green': green + change > 255 || green + change < 0 ? null : setGreen(green + change);
                return;
            case 'blue': blue + change > 255 || blue + change < 0 ? null : setBlue(blue + change)
                return;
            default: return;
        }
    }
    return (<View>
        <ColorCounter color="Red"
            onIncrease={() => setColor('red', COLOR_INCREMENT)}
            onDecrease={() =>  setColor('red', -COLOR_INCREMENT)}
        />
        <ColorCounter color="Green"
            onIncrease={() =>  setColor('green', COLOR_INCREMENT)}
            onDecrease={() =>  setColor('green', -COLOR_INCREMENT)}
        />
        <ColorCounter color="Blue"
            onIncrease={() => setColor('blue', COLOR_INCREMENT)}
            onDecrease={() => setColor('blue', -COLOR_INCREMENT)}
        />
        <View style={{ height: 150, width: 150, backgroundColor: `rgb(${red},${green},${blue})` }}></View>
    </View>
    );
};

const styles = StyleSheet.create({});

export default SquareScreen;
