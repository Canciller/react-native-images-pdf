@objc(ImagesPdf)
class ImagesPdf: NSObject {
  @objc(createPdf:withResolver:withRejecter:)
  func createPdf(options: NSDictionary, resolve: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) {
    let images = options["images"] as! Array<NSString>
    let path = options["path"] as! NSString
    
    let renderer = UIGraphicsPDFRenderer()
    
    let data = renderer.pdfData { (context) in
      for path in images {
        let url = URL(string: String(path))!
        
        var image: UIImage? = nil
        
        do {
          let imageData = try Data(contentsOf: url)
          image = UIImage(data: imageData)
        } catch {
          return reject("LOAD_IMAGE_ERROR", error.localizedDescription, error)
        }
        
        if let image = image {
          let bounds = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
          // TODO: pageInfo?
          context.beginPage(withBounds: bounds, pageInfo: [:])
          image.draw(at: .zero)
        }
      }
    }
    
    let url = URL(string: String(path))!
    
    do {
      try data.write(to: url)
    } catch {
      return reject("WRITE_PDF_ERROR", error.localizedDescription, error)
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
