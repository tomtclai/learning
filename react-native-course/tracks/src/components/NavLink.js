import React, {} from 'react';
import { StyleSheet, TouchableOpacity } from 'react-native';
import { Text } from 'react-native-elements';
import Spacer from '../components/Spacer';
import { withNavigation } from 'react-navigation';
const NavLink = ({ navigation, text, routeName }) => {
    return <TouchableOpacity
                onPress={() => navigation.navigate(routeName)} >
                <Spacer>
            <Text style={styles.link}>{text}</Text>
                    </Spacer>
                </TouchableOpacity>


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
export default withNavigation(NavLink);