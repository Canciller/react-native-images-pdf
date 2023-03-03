import * as React from 'react';
import test1 from './test-1.jpeg';
import { StyleSheet, Image } from 'react-native';
import ImagesPdf from 'react-native-images-pdf';
export default function App() {
    React.useEffect(() => {
        const createPdf = async () => {
            const source = Image.resolveAssetSource(test1);
            ImagesPdf.create({
                path: 'test',
                filename: 'test.pdf',
                images: [source.uri, source.uri, source.uri],
            });
        };
        createPdf();
    }, []);
    return React.createElement(Image, { source: test1 });
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
