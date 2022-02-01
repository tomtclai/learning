import createDataContext from "./createDataContext";
import trackerapi from "../api/tracker";
import AsyncStorageLib from "@react-native-async-storage/async-storage";
import { navigate } from "../navigationRef";

const locationReducer = (state, action) => {
    switch (action.type) {
        case 'add_current_location':
            return {...state, currentLocation: action.payload}
        default: return state
    }
}


const startRecording = dispatch => () => { };
const stopRecording = dispatch => () => { };
const addLocation = dispatch => location => {

    dispatch({type: 'add_current_location', payload: location})
};

export const { Context, Provider } = createDataContext(
    locationReducer,
    { startRecording,stopRecording, addLocation },
    {recording: false, locations: [], currentLocation:null}
)