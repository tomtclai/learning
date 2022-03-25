import React, {useState} from 'react';
import { View, Text, TextInput, StyleSheet, FlatList } from 'react-native';

const TextScreen = () => {
  const [name, setName] = useState('');

  return (
    <View>
    <Text>name</Text>
    <TextInput
      style={styles.input}
      autoCapitalize="none"
      autoCorrect={false}
      value={name}
      onChangeText={newValue => setName(newValue)}
    ></TextInput>

      { name.length > 5 ? null : <Text>'Password must be longer than 5 characters'</Text> }
    </View>
  );
};

const styles = StyleSheet.create({
  input: {
    margin: 15,
    borderColor: 'black',
    borderWidth: 1
  }
});

export default TextScreen;
