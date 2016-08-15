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

class LinqUp extends Component {
  render() {
    return (
       <View style={{margin: 128}}>
          <Text> YOU ARE ON LINQ </Text>
      </View>
      
    );
  }
}

module.exports = LinqUp;