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

class Profile extends Component {
  render() {
    return (
       <View>
          <Text> YOU ARE ON Profile </Text>
      </View>
      
    );
  }
}

module.exports = Profile;