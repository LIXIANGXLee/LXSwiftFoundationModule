//
//  LXSwift+String.swift
//  LXSwiftFoundation
//
//  Created by XL on 2020/9/23.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit
import CommonCrypto

/// String and NSString compliance
extension String: LXSwiftCompatible { }

//MARK: -  Extending methods and properties for String and NSString interception
extension LXSwiftBasics where Base: ExpressibleByStringLiteral {
  
    /// Extend String interception
    ///
    /// - Parameter r: 0..<2 string range
    ///   let str = "abc" ，subString(with: 0..<2)  result is "ab"
    /// - Return: substring
    public func subString(with r: Range<Int>) -> String {
        let string = base as! String
        if r.lowerBound < r.upperBound && r.upperBound <= string.count && r.lowerBound >= 0 {
            return string[r]
        }else{
            return string
        }
    }
    
    /// Extend String interception
    ///
    /// - Parameter index: start
    /// - Return:  substring
    public func substring(from index: Int) -> String {
        let string = base as! String
        if index <= string.count && index >= 0 {
            return subString(with: index..<string.count)
        }else{
            return string
        }
    }
    
    /// Extend String interception
    ///
    /// - Parameter index: end
    /// - Return:  substring
    public func substring(to index: Int) -> String {
        let string = base as! String
        if index <= string.count && index >= 0 {
            return subString(with: 0..<index)
        }else{
            return string
        }
    }
    
    /// Calculate the property and return the space before and after removing
    public var trim: String {
        let string = base as! String
        return string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }

}


//MARK: - Extending methods for String and NSString size
extension LXSwiftBasics where Base: ExpressibleByStringLiteral {
    
    ///Get the font size cgsize according to the font and width
    ///
    ///   - Parameters:
    ///   - font: font size
    ///   - width: width
    ///   - lineSpace: lineSpace
    public func size(font: UIFont, width: CGFloat, lineSpace: CGFloat = 5) -> CGSize {
        let string = base as! String
        let mulPara = NSMutableParagraphStyle()
        mulPara.lineSpacing = lineSpace
        let attrString = NSAttributedString(string: string, attributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.paragraphStyle: mulPara])
        return attrString.boundingRect(with: CGSize(width: width, height: 0), options: .usesLineFragmentOrigin, context: nil).size
    }
    
    ///Get the font width  according to the font
    ///
    /// - Parameters:
    ///   - font: font size
    public func width(font: UIFont) -> CGFloat {
        let size = self.size(font: font, width: CGFloat(MAXFLOAT))
        return size.width
    }
    
    ///Get the font height according to the font and width
    ///
    /// - Parameters:
    ///   - font: 字体大小
    ///   - width: 宽度
    public func height(font: UIFont, width: CGFloat) -> CGFloat {
        let size = self.size(font: font, width: width)
        return size.height
    }
}


//MARK: -  Extending properties for String and NSString tool
extension LXSwiftBasics where Base: ExpressibleByStringLiteral {
    
    /// base is contains string
    ///
    /// - Parameters:
    ///   - string: string
    public func contains(_ string: String) -> Bool {
        let string = base as! String
        return string.range(of: string) != nil
      }
      
      /// base is json
     public var isValidJSON: Bool {
          return jsonObject != nil
      }
      
      ///Convert to JSON object type
     public var jsonObject: Any? {
          let string = base as! String
          return try? JSONSerialization.jsonObject(with: string.data(using: .utf8) ?? Data(), options: .allowFragments)
      }
      
      /// Encode to JSON string
     public var jsonStringEncode: String? {
          let string = base as! String
          if !JSONSerialization.isValidJSONObject(string) { return nil }
          guard let jsonData = try? JSONSerialization.data(withJSONObject: string, options: .init(rawValue: 0)),
              let json = String(data: jsonData, encoding: .utf8) else {
                  return nil  }
          return json
      }
}


//MARK: -  String matching (hyperlink, phone number, emoticon) 😊 Etc.)
extension LXSwiftBasics where Base: ExpressibleByStringLiteral {
    ///string matching
     ///
     /// - Parameters:
     ///   - regex: want to  string matching
     ///   - usingBlock: callBack
     public func enumerateStringsMatchedByRegex(regex: String, usingBlock: (_ captureCount: Int, _ capturedStrings: String, _ range: NSRange) -> ()) {
         // regex is not nil
         if regex.count <= 0 { return }
         let string = base as! String

        guard let regex = try? NSRegularExpression(pattern: regex.lx.trim, options: []) else { return }
         let results = regex.matches(in: string, options: [], range: NSRange(location: 0, length: string.count))
         //can matching more string
         for result in results.reversed() {
             usingBlock(results.count,string[result.range.location..<(result.range.location + result.range.length)], result.range)
         }
     }
}

//MARK: -  Extending properties for String and NSString tool
extension LXSwiftBasics where Base: ExpressibleByStringLiteral {
     
    /// date  transform  string
    public func stringTranformDate(_ ymd: String = "yyyy-MM-dd HH:mm:ss") -> Date? {
         let string = base as! String
         let fmt = DateFormatter()
         fmt.dateFormat = ymd
         return fmt.date(from: string)
    }
    
      /// Methods of converting Chinese characters to Pinyin
     public var transformToPinYin: String{
         let string = base as! String
         let mutableString = NSMutableString(string: string)
         CFStringTransform(mutableString, nil, kCFStringTransformToLatin, false)
         CFStringTransform(mutableString, nil,  kCFStringTransformStripDiacritics, false)
         return String(mutableString).replacingOccurrences(of: " ", with: "")
      }

       /// The extended calculation attribute displays the corresponding g m KB B format according to the file size
     public var fileSize: String {
         let string = base as! String
         guard let size = Int(string) else {  return "" }
         if size >= 1024*1024*1024 {
            return String(format: "%.2fG", CGFloat(size) / CGFloat(1024*1024*1024))
         }else if size >= 1024*1024 {
             return String(format: "%.2fM", CGFloat(size) / CGFloat(1024*1024))
         }else if size >= 1024 {
            return String(format: "%.2fKB", CGFloat(size) / CGFloat(1024))
         }else if size > 0 {
            return String(format: "%dB", size)
         }else {
            return ""
        }
    }
}

//MARK: -  Extending methods for String and NSString md5
extension LXSwiftBasics where Base: ExpressibleByStringLiteral {
    
    /// MD5
    public var md5: String {
        let string = base as! String
        guard let data = string.data(using: .utf8, allowLossyConversion: true) else {  return string  }
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        #if swift(>=5.0)
        _ = data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) in
           return CC_MD5(bytes.baseAddress, CC_LONG(data.count), &digest)
        }
        #else
        _ = data.withUnsafeBytes { bytes in
           return CC_MD5(bytes, CC_LONG(data.count), &digest)
        }
        #endif
        return digest.reduce(into: "") { $0 += String(format: "%02x", $1) }
     }
}

///internal extension
internal extension String {
    
    ///internal String interception
     subscript (_ r: Range<Int>) -> String {
        get {
            let startIndex = index(self.startIndex, offsetBy: r.lowerBound)
            let endIndex = index(self.startIndex, offsetBy: r.upperBound)
            return  String(self[startIndex..<endIndex])
        }
    }
}
