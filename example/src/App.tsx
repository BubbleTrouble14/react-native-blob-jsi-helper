import * as React from 'react';

import { StyleSheet, View } from 'react-native';
import { Program } from './types/Program';

export default function App() {
  React.useEffect(() => {
    console.log(Program.fromInt(1).toHex());
  }, []);

  return <View style={styles.container} />;
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
