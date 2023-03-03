import PDFKit

@objc(ImagesPdf)
class ImagesPdf: NSObject {
  @objc(create:withResolver:withRejecter:)
  func create(options: NSDictionary, resolve:RCTPromiseResolveBlock, reject:RCTPromiseRejectBlock) {
    let images = options["images"] as! Array<NSString>
    let path = options["path"] as! NSString
    
    let format = UIGraphicsPDFRendererFormat()
    let metaData = [
      kCGPDFContextTitle: "Hello, World!",
      kCGPDFContextAuthor: "canciller"
    ]
    format.documentInfo = metaData as [String: Any]
    
    let pageRect = CGRect(x: 0, y: 0, width: 595, height: 842)
    let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
    
    let data = renderer.pdfData { (context) in
      for _ in images {
        context.beginPage()
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let attributes = [
          NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14),
          NSAttributedString.Key.paragraphStyle: paragraphStyle
        ]
        let text = "Hello, World!"
        let textRect = CGRect(x: 100, // left margin
                              y: 100, // top margin
                              width: 200,
                              height: 20)
        
        text.draw(in: textRect, withAttributes: attributes)
      }
    }
    
    var url = URL(string: String(path))!
    
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
    
    return resolve(path)
  }
  
  func getDocumentDirectoryURL() -> URL {
    let docDir = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    return docDir
  }
}
