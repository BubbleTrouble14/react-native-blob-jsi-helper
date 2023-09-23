import * as React from 'react';

import { Button, StyleSheet, View } from 'react-native';
import { addNumbersTest } from 'react-native-blob-jsi-helper';

declare global {
  var performance: {
    now: () => number;
  };
}

export default function App() {
  return (
    <View style={styles.container}>
      <Button
        title="BigNumber"
        onPress={() => {
          console.log(addNumbersTest(1, 2));
        }}
      />
      <Button title="bigint" onPress={() => {}} />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  box: {
    width: 60,
    height: 60,
    marginVertical: 20,
  },
});
