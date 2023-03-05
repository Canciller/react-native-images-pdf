# react-native-images-pdf

Easily generate PDF documents from images in React Native.

## Installation

```sh
yarn add react-native-images-pdf
```

### iOS

Run `pod install` in the `ios` directory.

## Usage

```javascript
import { createPdf } from 'react-native-images-pdf';

const options = {
  imagePaths: ['/path/to/image1.jpg', '/path/to/image2.jpg'],
  outputDirectory: '/path/to/output',
  outputFilename: 'output.pdf',
};

createPdf(options)
  .then(() => console.log('PDF created successfully'))
  .catch((error) => console.log(`Failed to create PDF: ${error}`));
```

## API

### `createPdf(options: CreatePdfOptions) => Promise<void>`

#### `CreatePdfOptions`


| Option | Type | Description |
| --- | --- | --- |
| `imagePaths` | `string[]` | An array of paths to the images that should be included in the PDF. Images will be added to the PDF in the order specified. |
| `outputDirectory` | `string` | The path to the directory where the output PDF file should be saved. |
| `outputFilename` | `string` | The name of the output PDF file. |

## Example

Check the `example` folder for a usage demo.

## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

## License

MIT

---

Made with [create-react-native-library](https://github.com/callstack/react-native-builder-bob)
