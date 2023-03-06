@objc(ImagesPdf)
class ImagesPdf: NSObject {
  @objc
  func createPdf(_ options: NSDictionary, resolver resolve:RCTPromiseResolveBlock, rejecter reject: RCTPromiseRejectBlock) {
    let imagePaths = options["imagePaths"] as! Array<String>
    let outputDirectory = options["outputDirectory"] as! String
    let outputFilename = options["outputFilename"] as! String
    
    var urlComponent = URLComponents(string: outputDirectory)!
    urlComponent.scheme = "file"
    
    let url = urlComponent.url!.appendingPathComponent(outputFilename)
    
    if imagePaths.isEmpty {
      resolve(url.absoluteString)
      return
    }
    
    let renderer = UIGraphicsPDFRenderer()
    var errorOccurred = false
    
    let data = renderer.pdfData { (context) in
      for imagePath in imagePaths {
        var imageUrlComponent = URLComponents(string: imagePath)!
        imageUrlComponent.scheme = "file"
        
        var imageUrl = imageUrlComponent.url!
        var image: UIImage? = nil
        
        do {
          let imageData = try Data(contentsOf: imageUrl)
          image = UIImage(data: imageData)
        } catch {
          errorOccurred = true
          reject("PDF_PAGE_CREATE_ERROR", error.localizedDescription, error)
          return
        }
        
        if let image = image {
          let bounds = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
          // TODO: pageInfo?
          context.beginPage(withBounds: bounds, pageInfo: [:])
          image.draw(at: .zero)
        }
      }
    }
    
    if !errorOccurred {
      do {
        try data.write(to: url)
        resolve(url.absoluteString)
      } catch {
        reject("PDF_WRITE_ERROR", error.localizedDescription, error)
      }
    }
  }
  
  @objc
  func getDocumentsDirectory(_ resolve: RCTPromiseResolveBlock, rejecter reject: RCTPromiseRejectBlock) {
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
