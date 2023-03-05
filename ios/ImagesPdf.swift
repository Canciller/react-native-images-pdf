@objc(ImagesPdf)
class ImagesPdf: NSObject {
  @objc(createPdf:withResolver:withRejecter:)
  func createPdf(options: NSDictionary, resolve: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) {
    let imagePaths = options["imagePaths"] as! Array<String>
    let outputDirectory = options["outputDirectory"] as! String
    let outputFilename = options["outputFilename"] as! String
    
    if imagePaths.isEmpty {
      return resolve(nil)
    }
    
    let renderer = UIGraphicsPDFRenderer()
    
    let data = renderer.pdfData { (context) in
      for imagePath in imagePaths {
        let imageUrl = URL(string: imagePath)!

        var image: UIImage? = nil
        
        do {
          let imageData = try Data(contentsOf: imageUrl)
          image = UIImage(data: imageData)
        } catch {
          return reject("PDF_PAGE_CREATE_ERROR", error.localizedDescription, error)
        }
        
        if let image = image {
          let bounds = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
          // TODO: pageInfo?
          context.beginPage(withBounds: bounds, pageInfo: [:])
          image.draw(at: .zero)
        }
      }
    }
    
    let url = URL(string: outputDirectory)!
      .appendingPathComponent(outputFilename)
    
    do {
      try data.write(to: url)
    } catch {
      return reject("PDF_WRITE_ERROR", error.localizedDescription, error)
    }
  }
  
  @objc
  func getDocumentsDirectory(_ resolve:RCTPromiseResolveBlock, rejecter reject: RCTPromiseRejectBlock) {
    let docsDir = getDocumentsDirectoryURL()
    
    var path = docsDir.absoluteString
    path.removeLast()
    
    resolve(path)
  }
  
  func getDocumentsDirectoryURL() -> URL {
    let docsDir = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    return docsDir
  }
}
