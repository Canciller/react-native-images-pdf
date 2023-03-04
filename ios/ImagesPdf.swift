@objc(ImagesPdf)
class ImagesPdf: NSObject {
  @objc(createPdf:withResolver:withRejecter:)
  func createPdf(options: NSDictionary, resolve: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) {
    let images = options["images"] as! Array<String>
    let filename = options["filename"] as! String
    let directory = options["directory"] as! String
    
    let renderer = UIGraphicsPDFRenderer()
    
    let data = renderer.pdfData { (context) in
      for imagePath in images {
        let imageUrl = URL(string: imagePath)!

        var image: UIImage? = nil
        
        do {
          let imageData = try Data(contentsOf: imageUrl)
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
    
    let url = URL(string: directory)!
      .appendingPathComponent(filename)
    
    do {
      try data.write(to: url)
    } catch {
      return reject("WRITE_PDF_ERROR", error.localizedDescription, error)
    }
  }
  
  @objc
  func getDocumentsDirectory(_ resolve:RCTPromiseResolveBlock, rejecter reject: RCTPromiseRejectBlock) {
    let docDir = getDocumentsDirectoryURL()
    
    var path = docDir.absoluteString
    path.removeLast()
    
    resolve(path)
  }
  
  func getDocumentsDirectoryURL() -> URL {
    let docDir = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    return docDir
  }
}
