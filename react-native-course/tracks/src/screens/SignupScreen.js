import React, {useContext, useEffect} from 'react';
import { View, StyleSheet } from 'react-native';
import { Context as AuthContext } from '../context/AuthContext';
import AuthForm from '../components/AuthForm';
import NavLink from '../components/NavLink';
import { NavigationEvents } from 'react-navigation';
const SignupScreen = ({ navigation }) => {
    const { state, signup, clearErrorMessage } = useContext(AuthContext);
        return <View style={styles.container}>
             <NavigationEvents onWillFocus={clearErrorMessage}/>
        <AuthForm
            headerText="Sign up for Tracker"
            errorMessage={state.errorMessage}
            onSubmit={signup}
            submitButtonText="Sign Up"
        />
        <NavLink routeName="Signin"
            text="Already have an account? Sign in"
        />
    </View>

}

/*
<NavigationEvents onWillFocus={clearErrorMessage}wqe


 */
SignupScreen.navigationOptions = () => {
    return {
        headerShown: false,
    };
};


const styles = StyleSheet.create({
    container: {
        flex: 1,
        justifyContent: 'center',
        marginBottom: '75%'
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
export default SignupScreen;