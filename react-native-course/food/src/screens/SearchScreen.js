import React, {useState, useEffect} from 'react';
import { ScrollView, View, Text, TextInput, StyleSheet, FlatList } from 'react-native';
import SearchBar from '../components/SearchBar'
import useResults from '../hooks/useResults';
import ResultsList from '../components/ResultsList';
const SearchScreen = () => {
    const [term, setTerm] = useState('');
    const [searchApi, results, error] = useResults();

  const filterResultsByPrice = (price) => {
    return results.filter(result => { return result.price === price });
  }
  return (
    <>
          <SearchBar term={term}
              onTermChanged={(newTerm) => setTerm(newTerm)}
              onTermSubmit={() => {
                  console.log(term)
                  searchApi(term)
              }} />
          {error ? <Text>{error}</Text> : null}
      <ScrollView>
        <ResultsList results={filterResultsByPrice('$')} title="Cost Effective" />
        <ResultsList results={filterResultsByPrice('$$')}  title="Bit Pricier" />
        <ResultsList results={filterResultsByPrice('$$$')} title="Big Spender" />
        <ResultsList results={filterResultsByPrice('$$$')}  title="Big Spender" />
        <ResultsList results={filterResultsByPrice('$$$')}  title="Big Spender" />

          </ScrollView>
      </>

  );
};

const styles = StyleSheet.create({
  input: {
    margin: 15,
    borderColor: 'black',
        borderWidth: 1
    },
  background: {
    flex:1,//only use visible screen
        backgroundColor: 'white',
    }
});

export default SearchScreen;
