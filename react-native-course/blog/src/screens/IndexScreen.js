import React, { useContext, useEffect } from 'react';
import { View, Text, StyleShee, StyleSheet, Button, TouchableOpacity } from 'react-native'
import { createAppContainer, FlatList } from 'react-navigation';
import { createStackNavigator } from 'react-navigation-stack';
import { Context } from '../context/BlogContext';
import { Feather } from '@expo/vector-icons';


/**
 *   return {
    headerRight: () => (
      <TouchableOpacity onPress={() => navigation.navigate('Create')}>
        <Feather name="plus" size={30} />
      </TouchableOpacity>
    ),
  };

 */
const IndexScreen = ({navigation}) => {
    const { state, getBlogPosts, deleteBlogpost } = useContext(Context);
    //console.log(props)
    //<Button title={'Add'} onPress={() => addBlogPost()} />
    useEffect(() => {
        getBlogPosts();
        const listener = navigation.addListener('didFocus', () => {
            getBlogPosts();
        })

        return () => {
            listener.remove();
        }
    },[])
    return <View>

        <FlatList
            data={state}
            keyExtractor={(blogpost) => blogpost.title}
            renderItem={({ item }) => {
                return (
                    <TouchableOpacity onPress={() => navigation.navigate('Show', { id: item.id })}>
                    <View style={styles.row}>
                    <Text style={styles.title}>
                        {item.title} - {item.id}
                    </Text>
                    <TouchableOpacity onPress={() => deleteBlogpost(item.id)}>
                        <Feather name="trash" style={styles.icon} color="black" />
                    </TouchableOpacity>
                        </View>
                    </TouchableOpacity>
                )
            }}
        />
    </View>;
}
IndexScreen.navigationOptions = ({navigation}) => {
    return { headerRight: () => (
        <TouchableOpacity onPress={() => navigation.navigate('Create')}>
          <Feather name="plus" size={30} />
        </TouchableOpacity>
      ),
    };
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