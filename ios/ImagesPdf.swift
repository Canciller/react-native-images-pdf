@objc(ImagesPdf)
class ImagesPdf: NSObject {
  @objc
  func createPdf(_ options: NSDictionary, resolver resolve:RCTPromiseResolveBlock, rejecter reject: RCTPromiseRejectBlock) {
    do {
      let createPdfOptions = try parseOptions(options: options)
      
      let imagePaths = createPdfOptions.imagePaths
      let outputDirectory = createPdfOptions.outputDirectory
      let outputFilename = createPdfOptions.outputFilename
      
      if imagePaths.isEmpty {
        resolve(nil)
        return
      }
      
      let data = try renderPdfData(imagePaths)
      
      let outputUrl = try writePdfData(data: data,
                                           outputDirectory: outputDirectory,
                                           outputFilename: outputFilename)
      
      resolve(outputUrl.absoluteString)
    } catch {
      reject("PDF_CREATE_ERROR", error.localizedDescription, error)
    }
  }
  
  func renderPdfData(_ imagePaths: [String]) throws -> Data {
    let renderer = UIGraphicsPDFRenderer()
    var pageError: Error? = nil
    
    let data = renderer.pdfData {(context) in
      for imagePath in imagePaths {
        var imageUrlComponent = URLComponents(string: imagePath)!
        imageUrlComponent.scheme = "file"
        
        var imageUrl = imageUrlComponent.url!
        var image: UIImage? = nil
        
        do {
          let imageData = try Data(contentsOf: imageUrl)
          image = UIImage(data: imageData)
        } catch {
          pageError = error
          break
        }
        
        if let image = image {
          let bounds = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
          // TODO: pageInfo?
          context.beginPage(withBounds: bounds, pageInfo: [:])
          image.draw(at: .zero)
        }
      }
    }
    
    if let pageError = pageError {
      throw pageError
    }
    
    return data
  }
  
  func writePdfData(data: Data, outputDirectory: String, outputFilename: String) throws -> URL {
    var urlComponent = URLComponents(string: outputDirectory)!
    urlComponent.scheme = "file"
    
    let url = urlComponent.url!.appendingPathComponent(outputFilename)
    
    try data.write(to: url)
    
    return url
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
  
  func parseOptions(options: NSDictionary) throws -> CreatePdfOptions {
    // Convert the NSDictionary to Data
    let jsonData = try JSONSerialization.data(withJSONObject: options, options: [])
    
    // Decode the data to the CreatePdfOptions struct
    let pdfCreateOptions = try JSONDecoder().decode(CreatePdfOptions.self, from: jsonData)
    
    return pdfCreateOptions
  }
}
