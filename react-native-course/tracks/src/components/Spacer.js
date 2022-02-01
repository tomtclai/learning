import React from 'react';
import { View, StyleSheet } from 'react-native';
import { Text, Button, Input } from 'react-native-elements';
const Spacer = ({ children }) => {
    return <View style={styles.spacer}>{children}</View>

}

const styles = StyleSheet.create({
    spacer: { margin: 15 }
});
export default Spacer;