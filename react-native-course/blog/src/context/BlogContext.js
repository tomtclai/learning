import React, { useReducer } from 'react';
import createDataContext from './createDataContext';



const addBlogPost = (dispatch) => {
    return () => {
        dispatch({ type: 'add_blogpost' })
    };
};

const deleteBlogpost = (dispatch) => {
    return (id) => {
        dispatch({ type: 'delete_blogpost', payload: id })
    };
};

const blogReducer = (state, action) => {
    switch (action.type) {
        case 'delete_blogpost':
            console.log('action payload' + action.payload)
            return state.filter((item) => item.id !== action.payload )
        case 'add_blogpost':
            return [...state, {
                id: Math.floor(Math.random() * 99999),
                title: `Blogpost #${state.length + 1}`
            }];
        default:
            return state
    }
};



export const { Context, Provider } = createDataContext(
    blogReducer,
    { addBlogPost, deleteBlogpost },
    []
)

//reducer
//action