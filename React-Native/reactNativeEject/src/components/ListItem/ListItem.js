import React from  'react';
import { StyleSheet, View, Text, TouchableOpacity } from  'react-native';

const listItem = (props) => (
	<TouchableOpacity onPress={props.onItemPressed}>
    <View style={styles.listItem}>
        <Text>{props.placeName}</Text>
    </View>
    </TouchableOpacity>
);

const styles = StyleSheet.create({
    listItem: {
        width: "100%",
        padding: 10,
        marginBottom: 5,
        backgroundColor: '#eee'
    }
});


export default listItem;