import React, { useState } from 'react';
import { View, Text, StyleSheet, Image } from 'react-native';
import { Feather } from '@expo/vector-icons';

const ResultsDetail = ({ result }) => {

    return <View style={styles.container}>

        <Image style={styles.image} source={{ uri: result.image_url }} />

        <Text style={styles.name}>{result.name}</Text>
        <Text style={styles.stars}>{result.rating} Stars, {result.review_count} Reviews</Text>
    </View>
};

const styles = StyleSheet.create({
    container: {
        marginLeft: 15
    },
    stars: {
    },
    name: {

        fontWeight: 'bold'
    },
    image: {
        width: 250,
        height: 120,
        borderRadius: 4,
    }
});

export default ResultsDetail;
