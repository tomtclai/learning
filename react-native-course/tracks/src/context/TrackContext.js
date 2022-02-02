import createDataContext from "./createDataContext";
import trackerapi from "../api/tracker";
import AsyncStorageLib from "@react-native-async-storage/async-storage";
import { navigate } from "../navigationRef";
const authReducer = (state, action) => {
    switch (action.type) {
        default: return state;
        case 'signin':
            return { ...state, errorMessage: '', token: action.payload }
        case 'add_error':
            return { ...state, errorMessage: action.payload }
        case 'clear_error_message':
            return { ...state, errorMessage: '' }
        case 'signout':
            return {...state, errorMessage:'', token: null}
    }
};

const fetchTracks = dispatch => () => { };
const createTracks = dispatch => () => { };

export const { Provider, Context } = createDataContext(
    trackReducer,
    { fetchTracks, createTracks }
)