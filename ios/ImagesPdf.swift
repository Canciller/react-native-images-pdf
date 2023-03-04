import PDFKit

@objc(ImagesPdf)
class ImagesPdf: NSObject {
  @objc(create:withResolver:withRejecter:)
  func create(options: NSDictionary, resolve:RCTPromiseResolveBlock, reject:RCTPromiseRejectBlock) {
    let images = options["images"] as! Array<NSString>
    let path = options["path"] as! NSString
    
    let renderer = UIGraphicsPDFRenderer()
    
    let data = renderer.pdfData { (context) in
      for path in images {
        let url = URL(string: String(path))!
        
        let image = UIImage(contentsOfFile: url.path)
        
        if let image = image {
          let bounds = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
          context.beginPage(withBounds: bounds, pageInfo: [:])
          image.draw(at: .zero)
        }
      }
    }
    
    let url = URL(string: String(path))!
    
    let pdfDocument = PDFDocument(data: data)
    
    if let pdfDocument = pdfDocument {
      pdfDocument.write(to: url)
    }
  }
  
  @objc
  func getDocumentDirectory(_ resolve:RCTPromiseResolveBlock, rejecter reject: RCTPromiseRejectBlock) {
    let docDir = getDocumentDirectoryURL()
    
    var path = docDir.absoluteString
    path.removeLast()
    
    resolve(path)
  }
  
  func getDocumentDirectoryURL() -> URL {
    let docDir = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    return docDir
  }
}
