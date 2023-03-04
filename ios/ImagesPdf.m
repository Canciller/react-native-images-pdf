#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(ImagesPdf, NSObject)

RCT_EXTERN_METHOD(
                  createPdf: (NSDictionary)options
                  withResolver: (RCTPromiseResolveBlock)resolve
                  withRejecter: (RCTPromiseRejectBlock)reject
                  )

RCT_EXTERN_METHOD(
                  getDocumentDirectory: (RCTPromiseResolveBlock)resolve
                  rejecter: (RCTPromiseRejectBlock)reject
                  )

+ (BOOL)requiresMainQueueSetup
{
  return NO;
}

@end
