import React, { useReducer } from 'react';
import createDataContext from './createDataContext';



const addBlogPost = (dispatch) => {
    return (title, content, callback) => {
        dispatch({ type: 'add_blogpost', payload: { title, content } })
        callback()
    };
};

const deleteBlogpost = (dispatch) => {
    return (id) => {
        dispatch({ type: 'delete_blogpost', payload: id })
    };
};

const editBlogPost = (dispatch) => {
    return (id, title, content, callback) => {
        dispatch({ type: 'edit_blogpost', payload: { id, title, content }})
        callback()
    };
}

const blogReducer = (state, action) => {
    switch (action.type) {
        case 'delete_blogpost':
            console.log('action payload' + action.payload)
            return state.filter((item) => item.id !== action.payload )
        case 'add_blogpost':
            return [...state, {
                id: Math.floor(Math.random() * 99999),
                title: action.payload.title,
                content: action.payload.content
            }];
        case 'edit_blogpost':
            return state.map((blogPost) => {
                return blogPost.id === action.payload.id ? action.payload : blogPost
            })

        default:
            return state
    }
};



export const { Context, Provider } = createDataContext(
    blogReducer,
    { addBlogPost, deleteBlogpost, editBlogPost },
    [{title: 'TEST POST', content: 'test content', id: 1}]
)

//reducer
//action