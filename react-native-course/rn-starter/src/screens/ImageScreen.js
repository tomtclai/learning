import React from 'react';

import { View, Text, StyleSheet } from 'react-native';
import ImageDetail from '../components/ImageDetail';

const ImageScreen = () => {
    return <View>
        <ImageDetail title="Forest" imageSource={require('../../images/forest.jpg')} score={1}/>
        <ImageDetail title="Beach" imageSource={require('../../images/beach.jpg')} score={2}/>
        <ImageDetail title="Mountain" imageSource={require('../../images/mountain.jpg')} score={3} />
    </View>
}

const styles = StyleSheet.create({});

export default ImageScreen