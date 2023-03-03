import { NativeModules, Platform } from 'react-native';

const LINKING_ERROR =
  `The package 'react-native-images-pdf' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo Go\n';

const ImagesPdfModule = NativeModules.ImagesPdf
  ? NativeModules.ImagesPdf
  : new Proxy(
      {},
      {
        get() {
          throw new Error(LINKING_ERROR);
        },
      }
    );

export interface CreateOptions {
  images: string[];
  path: string;
}

export default class ImagesPdf {
  static create(options: CreateOptions): Promise<void> {
    return ImagesPdfModule.create(options);
  }

  static getDocumentDirectory(): Promise<string> {
    return ImagesPdfModule.getDocumentDirectory();
  }
}
