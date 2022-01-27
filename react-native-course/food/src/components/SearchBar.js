import React, {useState} from 'react';
import { View, TextInput, StyleSheet, FlatList } from 'react-native';
import { Feather } from '@expo/vector-icons';

const SearchBar = ({ term, onTermChanged, onTermSubmit }) => {
  const [name, setName] = useState('');

  return (<View style={styles.background}>
    <Feather name="search" style={styles.iconStyle} color="black" />
    <TextInput
      autoCapitalize="none"
      autoCorrect={false}
      style={styles.inputStyle}
      placeholder='Search'
      value={term}
      onChangeText={onTermChanged}
      onEndEditing={onTermSubmit}
    />
    </View>
  );
};

const styles = StyleSheet.create({
  background: {
    marginTop: 15,
    backgroundColor: '#F0EEEE',
    height: 50,
    borderRadius: 5,
    marginHorizontal: 15,
    flexDirection: 'row',
    marginBottom: 10,
  },
  inputStyle: {
    flex: 1,
    fontSize: 18,
  },
  iconStyle: {
    fontSize: 35,
    alignSelf: "center",
    marginHorizontal: 15
  }
});

export default SearchBar;
