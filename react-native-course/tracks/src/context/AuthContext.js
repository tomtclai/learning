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

const clearErrorMessage = dispatch => () => {
    dispatch({type: 'clear_error_message'})
}

const tryLocalSignIn = dispatch => async () => {
    const token = await AsyncStorageLib.getItem('token');
    if (token) {
        dispatch({ type: 'signin', payload: token })
        navigate('TrackList')
    } else {
        navigate('Signup')
    }
}

const signup = (dispatch) => async ({ email, password }) => {
    try {
        // make api request to sign up
        const response = await trackerapi.post('/signup', { email, password });

        await AsyncStorageLib.setItem('token', response.data.token)

        // if we signed up , sign in too
        dispatch({ type: 'signin', payload: response.data.token })

        navigate('TrackList')

    } catch (err) {
        // if sign up fails, show error message
        dispatch({
            type: 'add_error',
            payload: 'something went wrong during sign up'
        })
    }
}

const signin = dispatch => async ({ email, password }) => {
    try {
        // make api request to sign up
        const response = await trackerapi.post('/signin', { email, password });

        await AsyncStorageLib.setItem('token', response.data.token)

        // if we signed up , sign in too
        dispatch({ type: 'signin', payload: response.data.token })

        navigate('TrackList')

    } catch (err) {
        // if sign up fails, show error message
        console.log(err.message)
        dispatch({
            type: 'add_error',
            payload: 'something went wrong during sign in'
        })

    }
}

const signout = dispatch => async () => {
    await AsyncStorageLib.removeItem('token')
    dispatch({ type: 'signout' })
    navigate('loginFlow')
}

export const { Provider, Context } = createDataContext(
    authReducer,
    {signin, signout, signup, tryLocalSignIn, clearErrorMessage},
    {
        token: null,
        errorMessage: ''
    }
)
