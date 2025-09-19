import React, { useCallback, useEffect } from 'react';
import { Text, View, StyleSheet, Button } from 'react-native';
import { NitroBaiduGeolocation } from 'react-native-nitro-baidu-geolocation';

function App(): React.JSX.Element {
  useEffect(() => {
    NitroBaiduGeolocation.agreePrivacyPolicy(true);
  }, []);

  const onInit = useCallback(async() => {
    const result = await NitroBaiduGeolocation.initialize('ak')
    console.log(result)
  }, [])
  

  return (
    <View style={styles.container}>
      <Button title='初始化' onPress={onInit} />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
  text: {
    fontSize: 40,
    color: 'green',
  },
});

export default App;
