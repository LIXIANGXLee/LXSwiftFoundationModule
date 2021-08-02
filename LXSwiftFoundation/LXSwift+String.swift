//
//  LXSwift+String.swift
//  LXSwiftFoundation
//
//  Created by XL on 2020/9/23.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit
import CommonCrypto

/// Switch 的匹配模式，匹配字符串开头 是否包含此字符串
public func has_prefix(_ prefix: String) -> ((String) -> (Bool)) {
     { $0.hasPrefix(prefix) }
}

/// Switch 的匹配模式，匹配字符串结尾 是否包含此字符串
public func has_suffix(_ suffix: String) -> ((String) -> (Bool)) {
     { $0.hasSuffix(suffix) }
}

/// Switch 的匹配模式，匹配字符串被包含 是否包含此字符串
public func has_contains(_ text: String) -> ((String) -> (Bool)) {
     { $0.contains(text) }
}

/// String and NSString compliance
extension String: LXSwiftCompatible {
   
    ///开关反匹配模式，匹配
    ///第一个字符串包含还是最后一个字符串包含
    public static func ~= (pattern: (String) -> Bool, value: String) -> Bool {
        pattern(value)
    }
}

//MARK: -  Extending methods and properties for String and NSString interception
extension LXSwiftBasics where Base: ExpressibleByStringLiteral {
    
    /// 扩展字符串截取
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
    
    ///  扩展字符串截取
    public func substring(from index: Int) -> String {
        let string = base as! String
        if index <= string.count && index >= 0 {
            return subString(with: index..<string.count)
        }else{
            return string
        }
    }
    
    ///  扩展字符串截取
    public func substring(to index: Int) -> String {
        let string = base as! String
        if index <= string.count && index >= 0 {
            return subString(with: 0..<index)
        }else{
            return string
        }
    }
    
    /// 分割字符
    public func split(_ s: String) -> [String] {
        let string = base as! String
        if string.isEmpty {
            return []
        }
        return string.components(separatedBy: s)
    }
    
    /// 替换字符串中的字符串
    public func replace(_ old: String, new: String) -> String {
        let string = base as! String
        return string.replacingOccurrences(of: old, with: new, options: NSString.CompareOptions.numeric, range: nil)
    }
    
    /// 字符串转bool
    public var strToBool: Bool? {
        let string = base as! String
        switch string {
        case "True", "true", "yes", "YES", "1":
            return true
        case "False", "false", "no", "NO", "0":
            return false
        default:
            return nil
        }
    }
    
    /// 去除两边空格
    public var trim: String {
        let string = base as! String
        return string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    /// 是否包含表情符号表达式
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
    
    /// 版本比较大小 Returns: big: base > two  ,small:two  < base, equal:base == two
    public func versionCompare(with v: String) -> LXSwiftUtils.VersionCompareResult {
        let string = base as! String
        return LXSwiftUtils.lx.versionCompare(string, v)
    }
    
    /// 在小数点后保留几个有效数字
    public func formatDecimalString(by digits: Int) -> String {
        let string = base as! String
        guard let m =  Double(string) else { return string }
        return NSNumber(value: m).numberFormatter(with: .down, minDigits: digits, maxDigits: digits) ?? string
    }
    
    /// 小数点后保留两个有效数字。
    public var formatDecimalStringTwo: String {
        return formatDecimalString(by: 2)
    }
    
    /// 小数点后保留三个有效数字。
    public var formatDecimalStringThree: String {
        return formatDecimalString(by: 3)
    }
    
    /// 小数点后保留四个有效数字。
    public var formatDecimalStringFour: String {
        return formatDecimalString(by: 4)
    }
}

//MARK: - Extending methods for String and NSString size
extension LXSwiftBasics where Base: ExpressibleByStringLiteral {
    
    /// 根据字体和宽度获取字体大小cgsize
    public func size(font: UIFont, width: CGFloat) -> CGSize {
        let string = base as! String
        let attrString = NSAttributedString(string: string, attributes: [NSAttributedString.Key.font: font])
        return attrString.lx.size(width: width)
    }
    
    /// 根据字体获取字体宽度
    public func width(font: UIFont) -> CGFloat {
        let size = self.size(font: font, width: LXSwiftApp.screenW)
        return size.width
    }
    
    /// 根据字体和宽度获取字体高度
    public func height(font: UIFont, width: CGFloat) -> CGFloat {
        let size = self.size(font: font, width: width)
        return size.height
    }
}

//MARK: -  Extending properties for String and NSString tool
extension LXSwiftBasics where Base: ExpressibleByStringLiteral {
    
    /// 基是包含字符串的
    public func contains(_ string: String) -> Bool {
        let string = base as! String
        return string.range(of: string) != nil
    }
    
    /// 是否包含指定的特殊字符
    func contains(characters: CharacterSet) -> Bool {
        let string = base as! String
        return string.rangeOfCharacter(from: characters) != nil
    }
    
    /// 是否属于json字符串
    public var isValidJSON: Bool {
        return jsonObject != nil
    }
    
    /// json字符串转换成字典
    public var jsonStrToDic: [String: Any] {
        let string = base as! String
        return (string.lx.jsonObject as? [String: Any]) ?? [:]
    }
    
    /// json字符串转换成数组
    public var jsonStrToArr: [Any] {
        let string = base as! String
        return (string.lx.jsonObject as? [Any]) ?? []
    }
    
    /// 字符串转换plist字典
    public var stringToPlistDictionary: Dictionary<String, Any>?  {
        let string = base as! String
        guard let data = string.data(using: .utf8) else { return nil }
        return data.lx.dataToPlistDictionary
    }
    
    /// 转换为JSON对象类型
    public var jsonObject: Any? {
        let string = base as! String
        guard let data = string.data(using: .utf8) else { return nil }
        return try? JSONSerialization.jsonObject(with:data, options: .allowFragments)
    }
}

//MARK: -  String matching (hyperlink, phone number, emoticon) 😊 Etc.)
extension LXSwiftBasics where Base: ExpressibleByStringLiteral {

    /// 字符串匹配
    public func enumerateStringsMatchedByRegex(regex: String, usingBlock: (_ captureCount: Int, _ capturedStrings: String, _ range: NSRange) -> ()) {
        // regex is not nil
        if regex.count <= 0 { return }
        let string = base as! String
        
        guard let regex = try? NSRegularExpression(pattern: regex.lx.trim, options: []) else { return }
        let results = regex.matches(in: string, options: [], range: NSRange(location: 0, length: string.count))
        //can matching more string
        for result in results.reversed() {
            usingBlock(results.count, string[result.range.location..<(result.range.location + result.range.length)], result.range)
        }
    }
}

//MARK: -  Extending properties for String and NSString tool
extension LXSwiftBasics where Base: ExpressibleByStringLiteral {
    
    /// 日期转换字符串
    public func stringTranformDate(_ ymd: String = "yyyy-MM-dd HH:mm:ss") -> Date? {
        let string = base as! String
        let fmt = DateFormatter()
        fmt.dateFormat = ymd
        return fmt.date(from: string)
    }
    
    /// 汉字拼音转换方法
    public var transformToPinYin: String {
        let string = base as! String
        let mutableString = NSMutableString(string: string)
        CFStringTransform(mutableString, nil, kCFStringTransformToLatin, false)
        CFStringTransform(mutableString, nil, kCFStringTransformStripDiacritics, false)
        return String(mutableString).replacingOccurrences(of: " ", with: "")
    }
    
    /// 字符串转码uft8
    public var utf8: String {
        let string = base as! String
        return string.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
    }
    
    ///“扩展计算”属性显示相应的
    ///g m KB B格式，根据文件大小而定
    public var fileSize: String {
        let string = base as! String
        guard let size = Double(string) else {  return "" }
        return size.lx.sizeFileToStr
    }
    
    /// 从URL String 中获取参数，并将参数转为字典类型
    public var getUrlParams1: [String: String]? {
        let string = base as! String
        guard let url = URL(string: string) else { return nil }
        return url.lx.getUrlParams1
    }
    
    /// 从URL String 中获取参数，并将参数转为字典类型
    public var getUrlParams2: [String: String]? {
        let string = base as! String
        guard let url = URL(string: string) else { return nil }
        return url.lx.getUrlParams2
    }
    
    /// 将原始的url编码为合法的url
    public var urlEncoded: String {
        let string = base as! String
        let encodeUrlString = string.addingPercentEncoding(withAllowedCharacters:
            .urlQueryAllowed)
        return encodeUrlString ?? ""
    }
    
    /// 将编码后的url转换回原始的url
    public var urlDecoded: String {
        let string = base as! String
        return string.removingPercentEncoding ?? ""
    }
}

//MARK: -  Extending methods for String and NSString md5
extension LXSwiftBasics where Base: ExpressibleByStringLiteral {
    
    /// MD5
    public var md5: String {
        let string = base as! String
        guard let data = string.data(using: .utf8, allowLossyConversion: true) else { return string }
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
    
    /// 字符串转换utf8数据
    public var utf8Data: Data? {
        let string = base as! String
        return string.data(using: .utf8)
    }
    
    /// 字符串转换base64EncodedData
    public var base64EncodingString: String? {
        let string = base as! String
        guard let utf8EncodeData = string.data(using: .utf8,
                allowLossyConversion: true) else { return nil }
        return utf8EncodeData.base64EncodedString(options: NSData.Base64EncodingOptions.init(rawValue: 0))
    }
    
    /// base64EncodedData转换字符串
    public var base64DecodingString: String? {
        let string = base as! String
        guard  let utf8DecodedData =  Data(base64Encoded: string, options: Data.Base64DecodingOptions.init(rawValue: 0)) else { return nil }
        return  String(data: utf8DecodedData, encoding: String.Encoding.utf8)
    }
    
    /// image base64格式uiimage的字符串
    public var base64EncodingImage: UIImage? {
        let string = base as! String
        guard let base64Data = Data(base64Encoded: string, options: .ignoreUnknownCharacters) else { return nil }
        return UIImage(data: base64Data)
    }
}

//MARK: -  Extending methods for String and NSString md5
extension LXSwiftBasics where Base: ExpressibleByStringLiteral {
    
    /// 验证字符串是否与正则表达式模式一致
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
    
    /// 它包含特殊字符吗
    public func isContainSpecialChar() -> Bool {
        let string = base as! String
        let emojiPattern = "[\\$\\(\\)\\*\\+\\[\\]\\?\\^\\{\\|]"
        return string.verification(pattern: emojiPattern)
    }
    
    /// 核实合法电子邮件
    public func isValidEmail() -> Bool {
        let string = base as! String
        let emailPattern = "^(\\w)+(\\.\\w+)*@(\\w)+((\\.\\w{1,}){1,3})$"
        return string.verification(pattern: emailPattern)
    }
    
    /// 验证它是否是合法的http或https地址
    public func isValidUrl() -> Bool {
        let string = base as! String
        let urlPattern = "^http(s)?://"
        return string.verification(pattern: urlPattern)
    }
    
    /// 核实合法手机号码
    public func isValidPhoneNumber() -> Bool {
        let string = base as! String
        let phonePattern = "^1\\d{10}$"
        return string.verification(pattern: phonePattern)
    }
    
    /// 核实合法身份证号码
    public func isValidIDCard() -> Bool {
      let string = base as! String
      let iaCardPattern = "(^[1-9]\\d{5}(18|19|([23]\\d))\\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\\d{3}[0-9Xx]$)|(^[1-9]\\d{5}\\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\\d{2}$)"
        return string.verification(pattern: iaCardPattern)
    }
    
    /// 验证它是否为合法IP
    public func isValidIP() -> Bool {
        let string = base as! String
        let ipPattern = "^((2[0-4]\\d|25[0-5]|[01]?\\d\\d?).){3}(2[0-4]\\d|25[0-5]|[01]?\\d\\d?)$"
        return string.verification(pattern: ipPattern)
    }
    
    /// 验证所有中文字符
    public func isChinese() -> Bool {
        let string = base as! String
        let chinesePattern = "^[\\u0391-\\uFFE5]+$"
        return string.verification(pattern: chinesePattern)
    }
    
    /// 验证是合法的，纯数字
    public func isNumber() -> Bool {
        let string = base as! String
        let numberPattern = "^[0-9]+(.[0-9]+)?$"
        return string.verification(pattern: numberPattern)
    }
    
    /// 验证是一个正整数
    public func isInteger() -> Bool {
        let string = base as! String
        let numberPattern = "^[0-9]+$"
        return string.verification(pattern: numberPattern)
    }
    
    /// 确定是否为标准小数（小数点后两位）
    public func isStandardDecimal() -> Bool {
        let string = base as! String
        let decimalPattern = "^[0-9]+(\\.[0-9]{2})$"
        return string.verification(pattern: decimalPattern)
    }
    
    /// 确定它是否是标准密码
    public func isValidPasswd() -> Bool {
        let string = base as! String
        let passwdPattern = "^[a-zA-Z0-9]{6,18}$"
        return string.verification(pattern: passwdPattern)
    }
    
    /// 确认有空格或空行
    public func isContainBlank() -> Bool {
        let string = base as! String
        let blank = "[\\s]"
        return string.verification(pattern: blank)
    }
    
    ///返回字符串中的数字范围，可以是一个或多个。如果没有数字，则返回一个空数组
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
    
    /// 获取匹配结果的数组
    public func matching(pattern: String, options: NSRegularExpression.Options = .caseInsensitive) -> [NSTextCheckingResult]? {
        let string = base as! String
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        let results = regex?.matches(in: string, options: NSRegularExpression.MatchingOptions.init(rawValue: 0), range: NSMakeRange(0, string.count))
        return results
    }
}

///internal extension
extension String {
    
    /// internal 下标字符串截取
    subscript (_ r: Range<Int>) -> String {
        get {
            let startIndex = index(self.startIndex, offsetBy: r.lowerBound)
            let endIndex = index(self.startIndex, offsetBy: r.upperBound)
            return  String(self[startIndex..<endIndex])
        }
    }
    
    /// 验证字符串匹配结果是否符合要求，返回布尔值
    func verification(pattern: String) -> Bool {
        return (self.lx.matching(pattern: pattern)?.count ?? -1) > 0
    }
}
