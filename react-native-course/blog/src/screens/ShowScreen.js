import React, { useContext } from 'react';
import { View, Text, StyleShee, StyleSheet, Button, TouchableOpacity } from 'react-native'
import { createAppContainer, FlatList } from 'react-navigation';
import { createStackNavigator } from 'react-navigation-stack';
import { Context } from '../context/BlogContext';
import { Feather } from '@expo/vector-icons';
import { EvilIcons } from '@expo/vector-icons';
/**
 *   return {
    headerRight: () => (
      <TouchableOpacity onPress={() => navigation.navigate('Edit')}>
        <EvilIcons name="pencil" size={35} />
      </TouchableOpacity>
    ),
  };
 */
const ShowScreen = ({ navigation }) => {
    const { state } = useContext(Context);
    const id = navigation.getParam('id')
    const blogPost = state.find((blogPost) => blogPost.id === id)
    return <View>
        <Text>
            {blogPost.title}
        </Text>
        <Text>
            {blogPost.content}
        </Text>
    </View>;
}
ShowScreen.navigationOptions = ({navigation}) => {
    return { headerRight: () => (
        <TouchableOpacity onPress={() =>
            navigation.navigate('Edit', {
                id: navigation.getParam('id')
            })
        }>
          <EvilIcons name="pencil" size={35} />
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

export default ShowScreen;