import React, { useContext, useState } from 'react';
import { View, Text, StyleShee, StyleSheet, Button, TouchableOpacity } from 'react-native'
import { createAppContainer, FlatList } from 'react-navigation';
import { createStackNavigator } from 'react-navigation-stack';
import { Context } from '../context/BlogContext';
import { Feather } from '@expo/vector-icons';
import { TextInput } from 'react-native-gesture-handler';

const BlogPostForm = ({ initialValues, onSubmit }) => {

    // const id = navigation.getParam('id')
    const { state, editBlogPost } = useContext(Context)
    // const blogPost = state.find((blogPost) => blogPost.id === navigation.getParam('id'))
    const [ title, setTitle ] = useState(initialValues.title);
    const [ content, setContent ] = useState(initialValues.content);
    // const blogPost = state.find((blogPost) => blogPost.id === id)
    return <View>

        <Text style={styles.label}>Enter new Title</Text>
        <TextInput style={styles.input} value={title} onChangeText={text => setTitle(text)}/>
        <Text style={styles.label}>Enter new Content</Text>
        <TextInput style={styles.input} value={content} onChangeText={text => setContent(text)} />
        <Button
            title='Save Blog Post'
            onPress={
                () => {
                    onSubmit(title,content)
                }
        } />
    </View>;
}

BlogPostForm.defaultProps = {
    initialValues: {
        title: '',
        content: ''
    }
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

export default BlogPostForm;