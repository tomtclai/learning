import React, { useReducer } from 'react';
import { Text, StyleSheet, View, Button, TouchableOpacity } from 'react-native';
import ColorCounter from '../components/ColorCounter';
const COLOR_INCREMENT = 10

const isLegal = (number) => {
    return 0 < number && number < 255
}
const ACTION_CHANGE_RED = 'change_red';
const ACTION_CHANGE_GREEN = 'change_green';
const ACTION_CHANGE_BLUE = 'change_blue';
const reducer = (state, action) => {
    //state === {red: number, green: number, blue: number}
    //action === {type: red || green || blue, payload: 15 || -15}
    switch (action.type) {
        case ACTION_CHANGE_RED: return {
            ...state,
            red: isLegal(state.red + action.payload) ? state.red + action.payload : state.red}
        case ACTION_CHANGE_GREEN:  return {
            ...state,
            green: isLegal(state.green + action.payload) ? state.green+action.payload : state.green}
        case ACTION_CHANGE_BLUE:  return {
            ...state,
            blue: isLegal(state.blue + action.payload) ? state.blue + action.payload : state.blue}
        default: return
    }
}
const SquareScreen = () => {


    const [state, dispatch] = useReducer(reducer, {
        red: 0,
        green: 0,
        blue: 0
    })
    const { red, green, blue } = state;

    console.log(state) // red green blue

    return (<View>
        <ColorCounter color="Red"
            onIncrease={() => { dispatch({type: ACTION_CHANGE_RED, payload: COLOR_INCREMENT}) }}
            onDecrease={() => { dispatch({type: ACTION_CHANGE_RED, payload: -COLOR_INCREMENT}) }}
        />
        <ColorCounter color="Green"
            onIncrease={() => { dispatch({type: ACTION_CHANGE_GREEN, payload: COLOR_INCREMENT}) }}
            onDecrease={() => { dispatch({type: ACTION_CHANGE_GREEN, payload: -COLOR_INCREMENT}) }}
        />
        <ColorCounter color="Blue"
            onIncrease={() => { dispatch({type: ACTION_CHANGE_BLUE, payload: COLOR_INCREMENT}) }}
            onDecrease={() => { dispatch({type: ACTION_CHANGE_BLUE, payload: -COLOR_INCREMENT}) }}
        />
        <View style={{ height: 150, width: 150, backgroundColor: `rgb(${red},${green},${blue})` }}></View>
    </View>
    );
};

const styles = StyleSheet.create({});

export default SquareScreen;
