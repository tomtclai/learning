import React from 'react';
import { FlatList, StyleSheet } from 'react-native';
import ListItem from '../ListItem/ListItem';

const placeList = props => {
    return (
        <FlatList 
        style={styles.listContainer}
        data={props.places}
        renderItem={(info) => (
            <ListItem 
                placeName={info.item.value} 
                onItemPressed={() => props.onItemDeleted(info.item.key)}
            />
        )}
        />
    );
};


const styles = StyleSheet.create({
  listContainer: {
    width: "100%",
    padding: 10
  }
});



export default placeList;