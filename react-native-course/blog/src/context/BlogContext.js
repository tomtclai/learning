import React, { useReducer } from 'react';
import createDataContext from './createDataContext';

import jsonServer from '../api/jsonServer';

const SLASH_BLOGPOSTS = '/blogposts';
const getBlogPosts = dispatch => {
    return async () => {
        const response = await jsonServer.get(SLASH_BLOGPOSTS)
        console.log(response)
        dispatch({type: 'get_blogposts', payload: response.data})
    };
}

const addBlogPost = (dispatch) => {
    return async (title, content, callback) => {
        // dispatch({ type: 'add_blogpost', payload: { title, content } })
        await jsonServer.post(SLASH_BLOGPOSTS, {title, content})
        callback()
    };
};

const deleteBlogpost = (dispatch) => {
    return async (id) => {
        await jsonServer.delete(`${SLASH_BLOGPOSTS}/${id}`)
        // can just refresh but not necessary
        dispatch({ type: 'delete_blogpost', payload: id })
    };
};

const editBlogPost = (dispatch) => {
    return async (id, title, content, callback) => {
        await jsonServer.put(`${SLASH_BLOGPOSTS}/${id}`, {title, content})
        dispatch({ type: 'edit_blogpost', payload: { id, title, content }})
        callback()
    };
}

const blogReducer = (state, action) => {
    switch (action.type) {
        case 'get_blogposts':
            return action.payload
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
    { addBlogPost, deleteBlogpost, editBlogPost, getBlogPosts },
    []
)

//reducer
//action