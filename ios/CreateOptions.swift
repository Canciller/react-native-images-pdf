//
//  CreateOptions.swift
//  ImagesPdf
//
//  Created by Gabriel Emilio Lopez Ojeda on 03/03/23.
//  Copyright © 2023 Facebook. All rights reserved.
//

import Foundation

protocol CreateOptions {
  var images: [String] { get }
  var path: String { get }
}
