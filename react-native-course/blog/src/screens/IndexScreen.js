import React, { useContext } from 'react';
import { View, Text, StyleShee, StyleSheet, Button, TouchableOpacity } from 'react-native'
import { createAppContainer, FlatList } from 'react-navigation';
import { createStackNavigator } from 'react-navigation-stack';
import { Context } from '../context/BlogContext';
import { Feather } from '@expo/vector-icons';

const IndexScreen = () => {
    const { state, addBlogPost, deleteBlogpost } = useContext(Context);
    console.log(state)
    return <View>
        <Button title={'Add'} onPress={() => addBlogPost()} />
        <FlatList
            data={state}
            keyExtractor={(blogpost) => blogpost.title}
            renderItem={({ item }) => {
                return <View style={styles.row}>
                    <Text style={styles.title}>
                        {item.title} - {item.id}
                    </Text>
                    <TouchableOpacity onPress={() => deleteBlogpost(item.id)}>
                        <Feather name="trash" style={styles.icon} color="black" />
                    </TouchableOpacity>
                </View>
            }}
        />
    </View>;
}

const styles = StyleSheet.create({
    row: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        paddingVertical: 20,
        paddingHorizontal: 10,
        borderTopWidth: 1,
        borderColor: 'gray'
    },
    title: {
        fontSize: 18
    },
    icon: {
        fontSize: 24
    }

})

export default IndexScreen;