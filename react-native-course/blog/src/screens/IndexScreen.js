import React, {useContext} from 'react';
import { View, Text, StyleShee, StyleSheet, Button } from 'react-native'
import { createAppContainer, FlatList } from 'react-navigation';
import { createStackNavigator } from 'react-navigation-stack';
import BlogContext from '../context/BlogContext';
const IndexScreen = () => {
    const { data, addBlogPost } = useContext(BlogContext);
    console.log(data)
    return <View>
        <Button title={'Add'} onPress={() => addBlogPost()}/>
        <FlatList
            data={data}
            keyExtractor={(blogpost) => blogpost.title}
            renderItem={({ item }) => { return <Text>{item.title}</Text> }}
        />
    </View>;
}

const styles = StyleSheet.create({})

export default IndexScreen;