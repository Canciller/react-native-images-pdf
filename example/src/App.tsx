import * as React from 'react';

import { getDocumentDirectory, createPdf } from 'react-native-images-pdf';
import { launchImageLibrary } from 'react-native-image-picker';
import { Button, StyleSheet, View } from 'react-native';

export default function App() {
  const selectImages = async () => {
    try {
      const result = await launchImageLibrary({
        mediaType: 'photo',
        selectionLimit: 0,
      });

      if (result.assets) {
        const assets = result.assets;
        const images = assets.map((asset) => asset.uri) as string[];

        const docsDir = await getDocumentDirectory();
        const path = `${docsDir}/example.pdf`;

        await createPdf({
          path,
          images,
        });
      }
    } catch (e) {
      console.error(e);
    }
  };

  return (
    <View style={styles.root}>
      <Button title="Select images" onPress={selectImages} />
    </View>
  );
}

const styles = StyleSheet.create({
  root: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
});
