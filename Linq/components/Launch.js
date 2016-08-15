import React, { Component } from 'react';
import {
  View,
  Navigator,
  TouchableHighlight,
  ListView,
  StyleSheet,
  Text,
  Image
} from 'react-native';

import { Actions } from 'react-native-router-flux';

class Launch extends Component {
  render() {
    return (
      <View style={styles.home}>
        <Text>Welcome to Linq!</Text>
        <View>
        <Image style={{marginTop: 5, height: 350, width: 350}} source={require('../linq.jpg')} />
        </View>
        <Text onPress={Actions.Main}> Login </Text>
      </View>
    );
  }
}

const styles = StyleSheet.create({
  home:{
    flex: 1,
    justifyContent: 'center',
      alignItems: 'center',

  }
 });

module.exports = Launch;