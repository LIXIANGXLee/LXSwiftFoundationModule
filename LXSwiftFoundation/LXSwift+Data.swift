//
//  LXSwift+Data.swift
//  LXSwiftFoundation
//
//  Created by XL on 2020/9/24.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

/// const
private let pngHeader: [UInt8] = [0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A]
private let jpgHeaderSOI: [UInt8] = [0xFF, 0xD8]
private let jpgHeaderIF: [UInt8] = [0xFF]
private let gifHeader: [UInt8] = [0x47, 0x49, 0x46]

/// image type enum
public enum LXSwiftImageDataType {
    case Unknown, PNG, JPEG, GIF
}

extension Data: LXSwiftCompatible { }
extension NSData: LXSwiftCompatible { }

//MARK: -  Extending properties  for Data
extension LXSwiftBasics where Base == Data {
    
     /// Data transform utf8 string
     public var utf8String: String? {
        return String(data: base, encoding: .utf8)
     }
    
}

//MARK: -  Extending properties  for NSData
extension LXSwiftBasics where Base == NSData {
       
     /// return image type
     public var imageType: LXSwiftImageDataType {
          var buffer = [UInt8](repeating: 0, count: 8)
          base.getBytes(&buffer, length: 8)
          var type: LXSwiftImageDataType = .Unknown
          if buffer == pngHeader {
              type = .PNG
          } else if buffer[0] == jpgHeaderSOI[0] &&
              buffer[1] == jpgHeaderSOI[1] &&
              buffer[2] == jpgHeaderIF[0] {
              type = .JPEG
          } else if buffer[0] == gifHeader[0] &&
              buffer[1] == gifHeader[1] &&
              buffer[2] == gifHeader[2] {
              type = .GIF
          }
          return type
      }
}
