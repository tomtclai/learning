import React, {useState, useContext} from 'react';
import { View, StyleSheet, TouchableOpacity } from 'react-native';
import { Text, Button, Input } from 'react-native-elements';
import Spacer from '../components/Spacer';
import { Context as AuthContext } from '../context/AuthContext';
const AuthForm = ({ headerText, errorMessage, onSubmit, submitButtonText }) => {
    const [email, setEmail] = useState('');
    const [password, setPassword] = useState('');

    return <>
        <Spacer>
            <Text h3>{headerText}</Text>
        </Spacer>

        <Input autoCapitalize='none' autoCorrect={false} label="Email" value={email} onChangeText={setEmail}/>
        <Spacer/>
        <Input autoCapitalize='none' autoCorrect={false} secureTextEntry label="Password" value={password} onChangeText={setPassword} />
        {errorMessage ? <Text style={styles.errorMessage}>{errorMessage}</Text>:null}
        <Spacer>
            <Button title={submitButtonText}
                onPress={() => onSubmit({email, password})} />
        </Spacer>
    </>

}


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
export default AuthForm;