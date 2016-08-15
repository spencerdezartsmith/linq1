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

class Contact extends Component {
  render() {
    return (
       <View style={{margin: 128}}>
          <Text> YOU ARE ON Contact </Text>
      </View>
    );
  }
}

module.exports = Contact;