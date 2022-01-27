import { StatusBar } from 'expo-status-bar';
import { StyleSheet, Text, View } from 'react-native';
import { createAppContainer } from 'react-navigation';
import { createStackNavigator } from 'react-navigation-stack';
import SearchScreen from './src/screens/SearchScreen';
import ResultsShowScreen from './src/screens/ResultsShowScreen';
const navigator = createStackNavigator(
  {
    Search: SearchScreen,
    ResultsShow: ResultsShowScreen,
  },
  {
    initialRouteName: 'Search',
    defaultNavigationOptions: {
      title: 'BusinessSearch'
    }
  }
)
/*
Client ID
n6m1vfK7AwV

-nTeTJb4R6g

API Key
s
yQI1tv0e-iQG0rhjtutRp4bXfO2WcXyUvB5fOE27m4rHkgk40g41looggMGsBRzIHi_

FSW10EPT9an1pwjqmRUUnRpYibZHhny109OlXVFM47uUOyDxAY3xkdP7uYXYx
*/
export default createAppContainer(navigator)

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
    alignItems: 'center',
    justifyContent: 'center',
  },
});
