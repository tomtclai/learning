import React, {useState} from 'react';
import { View, Text, StyleSheet, FlatList } from 'react-native';
import { Feather } from '@expo/vector-icons';
import ResultsDetail from '../components/ResultsDetail';
import { TouchableOpacity } from 'react-native-gesture-handler';
import { withNavigation } from 'react-navigation';
const ResultsList = ({ title, results, navigation }) => {
  return (<View style={styles.container}>
    <Text style={styles.title}>{title}</Text>

    <FlatList
      horizontal
      data={results}
      keyExtractor={result => result.id}
      renderItem={({ item }) => {
        return (<TouchableOpacity onPress={() => {
          navigation.navigate('ResultsShow', {
          id: item.id
        }) } }>
          <ResultsDetail result={item} />
          </TouchableOpacity>
        )
      }}
      showsHorizontalScrollIndicator={false}
    />
    </View>
  );
};

const styles = StyleSheet.create({
  title: {
    marginLeft: 15,
    fontSize: 18,
    fontWeight: 'bold',
    marginBottom: 5,
  },
  container: {
    marginBottom: 10,
  }
});

export default withNavigation(ResultsList);
