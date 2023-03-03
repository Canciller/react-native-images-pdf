import * as React from 'react';

import ImagesPdf from 'react-native-images-pdf';

export default function App() {
  React.useEffect(() => {
    const createPdf = async () => {
      const docsDir = await ImagesPdf.getDocumentDirectory();
      const path = `${docsDir}/test2.pdf`;

      ImagesPdf.create({
        path,
        images: ['path', 'path', 'path'],
      });
    };

    createPdf();
  }, []);

  return null;
}
