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

class Main extends Component {
  render() {
    return (
      <View style={{margin: 128}}>
          <Text> YOU ARE ON MAIN </Text>
          <Text onPress={Actions.LinqUp}> LinqUp </Text>
          <Text onPress={Actions.Contact}> Contact </Text>
          <Text onPress={Actions.Profile}> Profile </Text>
      </View>
      
    );
  }
}

module.exports = Main;