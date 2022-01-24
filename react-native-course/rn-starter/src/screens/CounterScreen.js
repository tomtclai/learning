import React, { useReducer } from 'react';
import { View, Text, StyleSheet, Button } from 'react-native';
const ACTION_CHANGE_COUNT = 'change_count';
const reducer = (state, action) => {
    //state === {red: number, green: number, blue: number}
    //action === {type: red || green || blue, payload: 15 || -15}
    switch (action.type) {
        case ACTION_CHANGE_COUNT: return {
            ...state,
            count: state.count + action.payload
        }
        default: return
    }
}

const CounterScreen = () => {
    const [state, dispatch] = useReducer(reducer, {
        count: 0
    })
    const { count } = state;
    return <View>
        <Button title="+" onPress={() => { dispatch({type: ACTION_CHANGE_COUNT, payload: 1}) }} />
        <Button title="-" onPress={() => { dispatch({type: ACTION_CHANGE_COUNT, payload: -1}) }} />
        <Text> Current Count: { count }</Text>
    </View>
}

const styles = StyleSheet.create({})

export default CounterScreen;