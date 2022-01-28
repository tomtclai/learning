import React, { useContext, useState } from 'react';
import { View, Text, StyleShee, StyleSheet, Button, TouchableOpacity } from 'react-native'
import { createAppContainer, FlatList } from 'react-navigation';
import { createStackNavigator } from 'react-navigation-stack';
import { Context } from '../context/BlogContext';
import { Feather } from '@expo/vector-icons';
import { TextInput } from 'react-native-gesture-handler';
import BlogPostForm from '../components/BlogPostForm';

const EditScreen = ({ navigation }) => {

    const id = navigation.getParam('id')
    const { state, editBlogPost } = useContext(Context)
    const blogPost = state.find((blogPost) => blogPost.id === id)
    const [ title, setTitle ] = useState(blogPost.title);
    const [ content, setContent ] = useState(blogPost.content);
    // const blogPost = state.find((blogPost) => blogPost.id === id)
//const BlogPostForm = ({ initialValues, onSubmit }) => {
    return <BlogPostForm
        initialValues={{ title: blogPost.title, content: blogPost.content }}
        onSubmit={(title, content) => {
        editBlogPost(id, title, content, () => {
            navigation.pop()
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

export default EditScreen;