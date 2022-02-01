import React, {useContext} from 'react';
import { View, StyleSheet } from 'react-native';
import { Context as AuthContext } from '../context/AuthContext';
import AuthForm from '../components/AuthForm';
import NavLink from '../components/NavLink';
import { NavigationEvents } from 'react-navigation';

const SigninScreen = ({ navigation }) => {
    const { state, signin, clearErrorMessage } = useContext(AuthContext);

    return <View style={styles.container}>
            <NavigationEvents onWillFocus={clearErrorMessage}/>
        <AuthForm
            headerText="Sign in"
            errorMessage={state.errorMessage}
            onSubmit={signin}
            submitButtonText="Sign In"
        />
        <NavLink routeName="Signup"
            text="Don't have an account? Sign up"
        />
    </View>

}
SigninScreen.navigationOptions = () => {
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
export default SigninScreen;