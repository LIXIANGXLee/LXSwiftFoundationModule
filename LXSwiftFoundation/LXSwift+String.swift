//
//  LXSwift+String.swift
//  LXSwiftFoundation
//
//  Created by XL on 2020/9/23.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit
import CommonCrypto

/// Switch de matching pattern, matching whether the first string contains
public func has_prefix(_ prefix: String) -> ((String) -> (Bool)) {
     { $0.hasPrefix(prefix) }
}

/// Switch de matching pattern, matching whether the last string contains
public func has_suffix(_ suffix: String) -> ((String) -> (Bool)) {
     { $0.hasSuffix(suffix) }
}

/// Switch de matching pattern, matching whether the all string contains  text
public func has_contains(_ text: String) -> ((String) -> (Bool)) {
     { $0.contains(text) }
}

/// String and NSString compliance
extension String: LXSwiftCompatible {
    
    /// Switch de matching pattern, matching whether the first string contains or last string  contains
    public static func ~= (pattern: (String) -> Bool, value: String) -> Bool {
        pattern(value)
    }
}

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
    
    /// Split character
    public func split(_ s: String) -> [String] {
        let string = base as! String
        if string.isEmpty {
            return []
        }
        return string.components(separatedBy: s)
    }
    
    /// Replace string in string
    public func replace(_ old: String, new: String) -> String {
        let string = base as! String
        return string.replacingOccurrences(of: old, with: new, options: NSString.CompareOptions.numeric, range: nil)
    }
    
    /// Calculate the property and return the space before and after removing
    public var trim: String {
        let string = base as! String
        return string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    /// is contain Emoji expression
    public var containsEmoji: Bool {
        let string = base as! String
        for scalar in string.unicodeScalars {
            switch scalar.value {
            case
            0x00A0...0x00AF,
            0x2030...0x204F,
            0x2120...0x213F,
            0x2190...0x21AF,
            0x2310...0x329F,
            0x1F000...0x1F9CF:
                return true
            default:
                continue
            }
        }
        return false
    }
    
    /// one version campare two version
    ///
    /// - Parameters:
    ///   - base: one version
    ///   - v: two version
    /// - Returns: big: base > two  ,small:two  < base, equal:base == two
    public  func versionCompare(_ v: String) -> LXSwiftUtil.VersionCompareResult {
        let string = base as! String
        return LXSwiftUtil.lx.versionCompare(string, v)
    }
    
    /// Keep a few significant digits after the decimal point
    ///digits
    public func formatDecimalString(_ digits: Int) -> String {
        let string = base as! String
        guard let m =  Double(string) else { return string }
        return NSNumber(value: m).numberFormatter(with: .down, minDigits: digits, maxDigits: digits) ?? string
    }
    
    ///Keep two valid digits after the decimal point.
    public var formatDecimalStringTwo: String {
       return formatDecimalString(2)
    }
    
    ///Keep three  valid digits after the decimal point.
    public var formatDecimalStringThree: String {
       return formatDecimalString(3)
    }
    
    ///Keep Four valid digits after the decimal point.
    public var formatDecimalStringFour: String {
       return formatDecimalString(4)
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
    public func size(font: UIFont, width: CGFloat) -> CGSize {
        let string = base as! String
        let attrString = NSAttributedString(string: string, attributes: [NSAttributedString.Key.font: font])
        return attrString.lx.size(width: width)
    }
    
    ///Get the font width  according to the font
    ///
    /// - Parameters:
    ///   - font: font size
    public func width(font: UIFont) -> CGFloat {
        let size = self.size(font: font, width: LXSwiftApp.screenW)
        return size.width
    }
    
    ///Get the font height according to the font and width
    ///
    /// - Parameters:
    ///   - font: font size
    ///   - width: with
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
    
    /// Whether the specified special characters are included
    func contains(characters: CharacterSet) -> Bool {
        let string = base as! String
        return string.rangeOfCharacter(from: characters) != nil
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
    public var transformToPinYin: String {
        let string = base as! String
        let mutableString = NSMutableString(string: string)
        CFStringTransform(mutableString, nil, kCFStringTransformToLatin, false)
        CFStringTransform(mutableString, nil,  kCFStringTransformStripDiacritics, false)
        return String(mutableString).replacingOccurrences(of: " ", with: "")
    }
    
    ///String transcoding uft8
    public var utf8: String {
        let string = base as! String
        return string.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
    }
    
    /// The extended calculation attribute displays the corresponding g m KB B format according to the file size
    public var fileSize: String {
        let string = base as! String
        guard let size = Double(string) else {  return "" }
        return size.lx.sizeToStr()
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
    
    /// string transform utf8 data
    public var utf8Data: Data? {
        let string = base as! String
        return string.data(using: .utf8)
    }
    
    /// string transform base64EncodedData
    public var base64EncodingString: String? {
        let string = base as! String
        guard let utf8EncodeData = string.data(using: .utf8, allowLossyConversion: true) else { return nil}
        return utf8EncodeData.base64EncodedString(options: NSData.Base64EncodingOptions.init(rawValue: 0))
    }
    
    /// base64EncodedData transform  string
    public var base64DecodingString: String? {
        let string = base as! String
        guard  let utf8DecodedData =  Data(base64Encoded: string, options: Data.Base64DecodingOptions.init(rawValue: 0)) else { return nil }
        return  String(data: utf8DecodedData, encoding: String.Encoding.utf8)
    }
    
    /// string of  image base64 tranform uiimage
    public var base64EncodingImage: UIImage? {
        let string = base as! String
        guard let base64Data = Data(base64Encoded: string, options: .ignoreUnknownCharacters) else { return nil }
        return UIImage(data: base64Data)
    }
}

//MARK: -  Extending methods for String and NSString md5
extension LXSwiftBasics where Base: ExpressibleByStringLiteral {
    
    ///Verify that the string is consistent with the regular expression pattern
    public func isSuit(pattern: String) -> Bool {
        let string = base as! String
        return string.verification(pattern: pattern)
    }
    
    ///Judge whether it is a legal license plate number
    ///"^[京津沪渝冀豫云辽黑湘皖鲁新苏浙赣鄂桂甘晋蒙陕吉闽贵粤青藏川宁琼使领A-Z]{1}[A-Z]{1}[A-Z0-9]{4,5}[A-Z0-9挂学警港澳]{1}"
    public func isValidCarid() -> Bool {
        let string = base as! String
        let pattern = "^[京津沪渝冀豫云辽黑湘皖鲁新苏浙赣鄂桂甘晋蒙陕吉闽贵粤青藏川宁琼使领A-Z]{1}[A-Z]{1}[A-Z0-9]{4,5}[A-Z0-9挂学警港澳]{1}$"
        return string.verification(pattern: pattern)
    }
    
    ///Does it contain special characters
    ///
    ///- Returns: results
    public func isContainSpecialChar() -> Bool {
        let string = base as! String
        let emojiPattern = "[\\$\\(\\)\\*\\+\\[\\]\\?\\^\\{\\|]"
        return string.verification(pattern: emojiPattern)
    }
    
    ///Verify legal email
    public func isValidEmail() -> Bool {
        let string = base as! String
        let emailPattern = "^(\\w)+(\\.\\w+)*@(\\w)+((\\.\\w{1,}){1,3})$"
        return string.verification(pattern: emailPattern)
    }
    
    ///Verify that it is a legitimate Web address
    public func isValidUrl() -> Bool {
        let string = base as! String
        let urlPattern = "^http(s)?://"
        return string.verification(pattern: urlPattern)
    }
    
    ///Verify legal mobile phone number
    public func isValidPhoneNumber() -> Bool {
        let string = base as! String
        let phonePattern = "^1\\d{10}$"
        return string.verification(pattern: phonePattern)
    }
    
    ///Verify legal ID number
    public func isValidIDCard() -> Bool {
        let string = base as! String
        let iaCardPattern = "(^[1-9]\\d{5}(18|19|([23]\\d))\\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\\d{3}[0-9Xx]$)|(^[1-9]\\d{5}\\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\\d{2}$)"
        return string.verification(pattern: iaCardPattern)
    }
    
    ///Verify that it is a legitimate IP
    public func isValidIP() -> Bool {
        let string = base as! String
        let ipPattern = "^((2[0-4]\\d|25[0-5]|[01]?\\d\\d?).){3}(2[0-4]\\d|25[0-5]|[01]?\\d\\d?)$"
        return string.verification(pattern: ipPattern)
    }
    
    ///Verify all Chinese characters
    public func isChinese() -> Bool {
        let string = base as! String
        let chinesePattern = "^[\\u0391-\\uFFE5]+$"
        return string.verification(pattern: chinesePattern)
    }
    
    ///Validation is legal, pure numbers
    public func isNumber() -> Bool {
        let string = base as! String
        let numberPattern = "^[0-9]+(.[0-9]+)?$"
        return string.verification(pattern: numberPattern)
    }
    
    ///Validation is a positive integer
    public func isInteger() -> Bool {
        let string = base as! String
        let numberPattern = "^[0-9]+$"
        return string.verification(pattern: numberPattern)
    }
    
    /// Determine whether it is a standard decimal (two decimal places)
    public func isStandardDecimal() -> Bool {
        let string = base as! String
        let decimalPattern = "^[0-9]+(\\.[0-9]{2})$"
        return string.verification(pattern: decimalPattern)
    }
    
    /// Determine whether it is a standard password
    public func isValidPasswd() -> Bool {
        let string = base as! String
        let passwdPattern = "^[a-zA-Z0-9]{6,18}$"
        return string.verification(pattern: passwdPattern)
    }
    
    /// Verify that there are spaces or empty lines
    public func isContainBlank() -> Bool {
        let string = base as! String
        let blank = "[\\s]"
        return string.verification(pattern: blank)
    }
    
    /// Returns the range of numbers in a string, which can be one or more. If there are no numbers, an empty array is returned
    public func numberRanges() -> [NSRange] {
        let string = base as! String
        guard let results = string.lx.matching(pattern: "[0-9]+(.[0-9]+)?") else {
            return []
        }
        var ranges = [NSRange]()
        for item in results {
            ranges.append(item.range)
        }
        return ranges
    }
    
    ///Gets an array of matching results
    public func matching(pattern: String,
                         options: NSRegularExpression.Options = .caseInsensitive) -> [NSTextCheckingResult]? {
        let string = base as! String
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        let results = regex?.matches(in: string, options: NSRegularExpression.MatchingOptions.init(rawValue: 0), range: NSMakeRange(0, string.count))
        return results
    }
}

///internal extension
extension String {
    
    ///internal String interception
    internal subscript (_ r: Range<Int>) -> String {
        get {
            let startIndex = index(self.startIndex, offsetBy: r.lowerBound)
            let endIndex = index(self.startIndex, offsetBy: r.upperBound)
            return  String(self[startIndex..<endIndex])
        }
    }
    
    ///Verify whether the string matching results meet the requirements, and return bool value
    internal func verification(pattern: String) -> Bool {
        return (self.lx.matching(pattern: pattern)?.count ?? -1) > 0
    }
}
