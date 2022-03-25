import React, {useState, useEffect} from 'react';
import { View, Text, StyleSheet, FlatList, Image, ScrollView } from 'react-native';
import { Feather } from '@expo/vector-icons';
import ResultsDetail from '../components/ResultsDetail';
import yelp from '../api/yelp';
const ResultsShowScreen = ({ navigation }) => {
    const id = navigation.getParam('id')
    const [result, setResult] = useState(null)

    const getResult = async (id) => {
        const response = await yelp.get(`/${id}`)
        console.log(response.data)
        setResult(response.data)
    }

    useEffect(() => {
        getResult(id)
    }, [])

    console.log(result)
    if (!result) {
        return null
    }
    return (<View style={styles.container}>
        <ScrollView>
            <Text>{result.name}</Text>
            <FlatList
                data={result.photos}
                keyExtractor={(photo) => photo}
                renderItem={({ item }) => {
                    console.log(item)
                    return <Image style={styles.image} source={{ uri: item }}/>
                }}
                />
        </ScrollView>


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
    },
    image: {
        height: 200,
        width: 300
  }
});

export default ResultsShowScreen;
