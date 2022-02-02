import createDataContext from "./createDataContext";
import trackerapi from "../api/tracker";
import AsyncStorageLib from "@react-native-async-storage/async-storage";
import { navigate } from "../navigationRef";

const locationReducer = (state, action) => {
    switch (action.type) {
        case 'start_recording':
            return { ...state, recording: true}
        case 'stop_recording':
            return { ...state, recording: false}
        case 'add_current_location':
            return { ...state, currentLocation: action.payload }
        case 'add_location':
            return { ...state, locations: [...state.locations, action.payload] }
        case 'change_name':
            return {...state, name: action.payload}
        default: return state
    }
}

const changeName = dispatch => () => {
    dispatch({type: 'change_name'})
};
const startRecording = dispatch => () => {
    dispatch({type: 'start_recording'})
};
const stopRecording = dispatch => () => {
    dispatch({type: 'stop_recording'})
};
const addLocation = dispatch => (location, recording) => {
    dispatch({ type: 'add_current_location', payload: location })

    if (recording) {
        dispatch({type: 'add_location', payload: location})
    }
};


export const { Context, Provider } = createDataContext(
    locationReducer,
    { startRecording,stopRecording, addLocation, changeName },
    {recording: false, locations: [], currentLocation:null, name:""}
)