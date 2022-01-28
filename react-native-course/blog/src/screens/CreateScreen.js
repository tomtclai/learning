import React, { useContext, useState } from 'react';
import { View, Text, StyleShee, StyleSheet, Button, TouchableOpacity } from 'react-native'
import { createAppContainer, FlatList } from 'react-navigation';
import { createStackNavigator } from 'react-navigation-stack';
import { Context } from '../context/BlogContext';
import { Feather } from '@expo/vector-icons';
import { TextInput } from 'react-native-gesture-handler';
import BlogPostForm from '../components/BlogPostForm';
const CreateScreen = ({ navigation }) => {
    const [ title, setTitle ] = useState('');
    const [ content, setContent ] = useState('');
    const id = navigation.getParam('id')
    const { addBlogPost } = useContext(Context)
    // const blogPost = state.find((blogPost) => blogPost.id === id)
    return <BlogPostForm onSubmit={(title, content) => {
        addBlogPost(title, content, () => {
            navigation.navigate('Index')
        })
    }}/>;
}

const styles = StyleSheet.create({
    input: {
        fontSize: 18,
        borderWidth: 1,
        borderColor: 'black',
        marginBottom: 15,
        padding: 5,
        margin: 5
    },
    label: {
        marginLeft: 5,
        fontSize: 20,
        marginBottom:5
    },
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

export default CreateScreen;