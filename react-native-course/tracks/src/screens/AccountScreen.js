import React, { useContext } from 'react';
import { View, StyleSheet, Text } from 'react-native';
import { Button } from 'react-native-elements';
import Spacer from '../components/Spacer';
import { SafeAreaView } from 'react-navigation';
import { Context as AuthContext } from '../context/AuthContext';
const AccountScreen = () => {
    const { signout } = useContext(AuthContext)
    return <SafeAreaView forceInset={{top: 'always'}}>
        <Text style={{ fontSize: 108 }}> AccountScreen</Text>
        <Button title="Sign out" onPress={signout}/>
    </SafeAreaView>
}

const styles = StyleSheet.create({});
export default AccountScreen;