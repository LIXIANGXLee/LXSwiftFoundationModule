//
//  Swift+String.swift
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

/// Switch 的匹配模式，匹配字符串被包含 字符串是否相等
public func has_equal(_ text: String) -> ((String) -> (Bool)) {
    { $0 == text }
}

extension String {
    public static func ~= (pattern: (String) -> Bool, value: String) -> Bool {
        pattern(value)
    }
}

// MARK: - 字符串操作扩展
// 提供字符串截取、分割、替换和去空格等常用功能
extension SwiftBasics where Base == String {
    
    /// 根据范围截取子字符串
    ///
    /// - Parameter r: 范围表达式，如 0..<2
    /// - Returns: 截取后的子字符串
    /// - 示例:
    ///   let str = "abc"
    ///   str.subString(with: 0..<2) // 返回 "ab"
    /// - 注意:
    ///   1. 如果范围无效（下界大于上界、超出字符串长度或为负数），返回原字符串
    ///   2. 范围遵循左闭右开原则 [lowerBound, upperBound)
    public func subString(with r: Range<Int>) -> String {
        // 检查范围是否有效：下界小于上界，上界不超过字符串长度，下界不小于0
        if r.lowerBound < r.upperBound && r.upperBound <= base.count && r.lowerBound >= 0 {
            return base[r]
        }
        return base
    }
    
    /// 从指定位置开始截取到字符串末尾
    ///
    /// - Parameter index: 开始截取的位置索引
    /// - Returns: 截取后的子字符串
    /// - 注意:
    ///   1. 如果索引无效（超出字符串长度或为负数），返回原字符串
    ///   2. 索引从0开始
    public func substring(from index: Int) -> String {
        // 检查索引是否有效
        if index <= base.count && index >= 0 {
            return subString(with: index..<base.count)
        }
        return base
    }
    
    /// 从字符串开头截取到指定位置
    ///
    /// - Parameter index: 结束截取的位置索引
    /// - Returns: 截取后的子字符串
    /// - 注意:
    ///   1. 如果索引无效（超出字符串长度或为负数），返回原字符串
    ///   2. 索引从0开始，遵循左闭右开原则
    public func substring(to index: Int) -> String {
        // 检查索引是否有效
        if index <= base.count && index >= 0 {
            return subString(with: 0..<index)
        }
        return base
    }

    /// 已废弃的分割字符方法（兼容旧版本）
    @available(*, deprecated, message: "请使用 split(by:) 方法替代")
    public func split(with character: String) -> [String] {
        split(by: character)
    }
    
    /// 使用指定分隔符分割字符串
    ///
    /// - Parameter character: 分隔符字符串
    /// - Returns: 分割后的字符串数组
    /// - 注意:
    ///   1. 如果原字符串为空，返回空数组
    ///   2. 分隔符可以是任意字符串
    public func split(by character: String) -> [String] {
        // 空字符串检查
        if base.isEmpty {
            return []
        }
        return base.components(separatedBy: character)
    }
    
    /// 替换字符串中的子串
    ///
    /// - Parameters:
    ///   - old: 需要被替换的子串
    ///   - new: 替换后的新子串
    /// - Returns: 替换后的新字符串
    /// - 注意: 替换是全局进行的（所有匹配项都会被替换）
    public func replace(old: String, new: String) -> String {
        base.replacingOccurrences(
            of: old,
            with: new,
            options: .literal,  // 使用字面匹配方式
            range: nil         // 搜索整个字符串
        )
    }

    /// 去除字符串两端的空格和换行符
    ///
    /// - Returns: 去除空白字符后的字符串
    /// - 注意: 只会去除开头和结尾的空白字符，中间的空白字符不会被去除
    public var trim: String {
        base.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

//MARK: - 字符串尺寸计算
extension SwiftBasics where Base == String {
    
    /// 计算字符串在指定字体和宽度约束下的尺寸
    /// - Parameters:
    ///   - font: 使用的字体
    ///   - width: 最大允许宽度
    /// - Returns: 计算出的尺寸 (CGSize)
    public func size(font: UIFont, width: CGFloat) -> CGSize {
        // 创建属性字符串，设置字体属性
        let attr = NSAttributedString(
            string: base,
            attributes: [NSAttributedString.Key.font: font]
        )
        
        // 调用扩展方法计算尺寸（假设 lx 是 NSAttributedString 的扩展）
        return attr.lx.size(width)
    }
    
    /// 计算字符串在指定字体下的宽度（无宽度约束）
    /// - Parameter font: 使用的字体
    /// - Returns: 计算出的宽度 (CGFloat)
    public func width(font: UIFont) -> CGFloat {
        // 使用屏幕宽度作为最大宽度约束
        self.size(font: font, width: SCREEN_WIDTH_TO_WIDTH).width
    }
    
    /// 计算字符串在指定字体和宽度约束下的高度
    /// - Parameters:
    ///   - font: 使用的字体
    ///   - width: 最大允许宽度
    /// - Returns: 计算出的高度 (CGFloat)
    public func height(font: UIFont, width: CGFloat) -> CGFloat {
        self.size(font: font, width: width).height
    }
}

// MARK: - 字符串匹配功能扩展 (超链接、电话号码、表情符号等)
extension SwiftBasics where Base == String {
    /// 使用正则表达式枚举字符串中的所有匹配结果
    /// - 参数:
    ///   - regex: 正则表达式字符串（自动去除首尾空格）
    ///   - usingBlock: 处理每个匹配结果的回调闭包
    ///     - 参数1 captureCount: 捕获组的数量（不包含完整匹配组）
    ///     - 参数2 matchedString: 匹配到的完整字符串
    ///     - 参数3 range: 匹配结果在原始字符串中的范围(NSRange)
    public func enumerateMatches(regex: String,
                                usingBlock: (_ captureCount: Int,
                                             _ matchedString: String,
                                             _ range: NSRange) -> Void) {
        
        // 检查正则表达式是否为空
        guard !regex.isEmpty else {
            SwiftLog.log("错误：正则表达式不能为空")
            return
        }
        
        // 清理正则表达式（去除首尾空格）
        let cleanedRegex = regex.lx.trim
        
        // 尝试创建NSRegularExpression实例
        guard let regularExpression = try? NSRegularExpression(pattern: cleanedRegex) else {
            SwiftLog.log("错误：无效的正则表达式格式[\(cleanedRegex)]")
            return
        }
        
        // 创建整个字符串的NSRange范围
        let fullRange = NSRange(location: 0, length: base.utf16.count)
        
        // 查找所有匹配结果（使用正向匹配）
        let matches = regularExpression.matches(in: base, options: [], range: fullRange)
        
        // 注意：逆向遍历可防止替换操作导致范围偏移
        // 例如在枚举过程中修改字符串时，从后往前处理可保持原始位置信息有效
        for match in matches.reversed() {
            // 获取完整匹配范围
            let matchRange = match.range
            
            // 验证范围有效性（防止越界访问）
            guard matchRange.location != NSNotFound,
                  let stringRange = Range(matchRange, in: base) else {
                continue // 跳过无效范围
            }
            
            // 提取匹配的完整子字符串
            let matchedString = String(base[stringRange])
            
            // 计算捕获组数量（总范围数减1，因为索引0始终是完整匹配）
            let captureGroupCount = match.numberOfRanges - 1
            
            // 传递匹配信息给调用方
            usingBlock(captureGroupCount, matchedString, matchRange)
        }
    }
}

// MARK: - 字符串转换功能扩展
extension SwiftBasics where Base == String {
    
    /// 判断路径文件是否为GIF图片
    /// - 返回值: Bool类型，true表示是GIF文件，false表示不是
    public var isGIFFile: Bool {
        guard let data = NSData(contentsOfFile: base) else {
            return false
        }
        return data.lx.imageType == SwiftImageDataType.gif
    }
    
    /// 检查字符串是否包含指定子串
    /// - 参数 string: 要检查的子字符串
    /// - 返回值: 如果包含返回true，否则返回false
    public func isContains(_ string: String) -> Bool {
        base.range(of: string) != nil
    }
    
    /// 检查字符串是否包含指定字符集中的字符
    /// - 参数 characters: 要检查的字符集
    /// - 返回值: 如果包含返回true，否则返回false
    public func isContains(characters: CharacterSet) -> Bool {
        base.rangeOfCharacter(from: characters) != nil
    }
    
    /// 检查字符串是否为有效的JSON格式
    /// - 返回值: 如果是有效JSON返回true，否则返回false
    public var isValidJSON: Bool {
        jsonObject != nil
    }
    
    /// 将JSON字符串转换为字典
    /// - 返回值: 转换后的字典，如果转换失败返回空字典
    public var toDictionary: [String: Any] {
        (base.lx.jsonObject as? [String: Any]) ?? [:]
    }
    
    /// 将JSON字符串转换为数组
    /// - 返回值: 转换后的数组，如果转换失败返回空数组
    public var toArray: [Any] {
        (base.lx.jsonObject as? [Any]) ?? []
    }
    
    /// 将字符串转换为Plist格式的字典
    /// - 返回值: 转换后的字典，如果转换失败返回nil
    public var toPlistDictionary: Dictionary<String, Any>? {
        guard let data = base.data(using: .utf8) else {
            return nil
        }
        return data.lx.dataToPlistDictionary
    }
    
    /// 将字符串转换为JSON对象
    /// - 返回值: 转换后的JSON对象，如果转换失败返回nil
    public var jsonObject: Any? {
        // 1. 检查字符串能否转换为UTF-8格式的Data
        // 转换失败则返回nil，避免后续无效操作
        guard let data = base.data(using: .utf8) else {
            return nil
        }
        
        // 2. 尝试将Data解析为JSON对象
        // 使用.allowFragments选项允许解析非集合类型（如字符串/数字）的顶层JSON
        // try? 表示解析失败时静默返回nil（不抛出错误）
        return try? JSONSerialization.jsonObject(
            with: data,
            options: .allowFragments
        )
    }
    
    /// 对字符串进行UTF-8编码
    /// - 返回值: 编码后的字符串，如果编码失败返回空字符串
    public var toUtf8: String {
        base.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    }
    
    /// 将字符串转换为Bool值
    /// - 返回值: 转换后的Bool值，如果无法识别返回nil
    public var toBool: Bool? {
        switch base.lowercased() {
        case "true", "yes", "1":
            return true
        case "false", "no", "0":
            return false
        default:
            return nil
        }
    }
    
    /// 将中文字符串转换为拼音
    /// - 返回值: 转换后的拼音字符串（不带音标和空格）
    public var toPinYin: String {
        let mutableString = NSMutableString(string: base)
        // 转换为拉丁字母
        CFStringTransform(mutableString, nil, kCFStringTransformToLatin, false)
        // 去除音标
        CFStringTransform(mutableString, nil, kCFStringTransformStripDiacritics, false)
        return String(mutableString).replacingOccurrences(of: " ", with: "")
    }
    
    /// 检查字符串是否包含表情符号
    /// - 返回值: 如果包含表情符号返回true，否则返回false
    public var isContainsEmoji: Bool {
        for scalar in base.unicodeScalars {
            switch scalar.value {
            case 0x00A0...0x00AF,     // 特殊字符范围
                 0x2030...0x204F,     // 通用标点符号
                 0x2120...0x213F,     // 字母符号
                 0x2190...0x21AF,     // 箭头
                 0x2310...0x329F,     // 技术符号、装饰符号等
                 0x1F000...0x1F9CF:   // 表情符号范围
                return true
            default:
                continue
            }
        }
        return false
    }
    
    /// 比较版本号
    /// - 参数 version: 要比较的版本号字符串
    /// - 返回值: 比较结果枚举(.big, .small, .equal)
    public func compareVersion(with version: String) -> SwiftUtils.CompareResult {
        SwiftUtils.versionCompareSwift(v1: base, v2: version)
    }
    
    /// 格式化小数字符串，保留指定小数位数
    /// - 参数 digits: 要保留的小数位数
    /// - 返回值: 格式化后的字符串
    public func formatDecimalString(by digits: Int) -> String {
        guard let mValue = Double(base) else {
            return base
        }
        
        let number = NSNumber(value: mValue)
        return number.lx.numberFormatter(with: .down,
                                       minDigits: digits,
                                       maxDigits: digits) ?? base
    }
    
    /// 将文件大小字符串格式化为更易读的格式 (GB, MB, KB, B)
    /// - 返回值: 格式化后的文件大小字符串
    public var fileSize: String {
        guard let size = Double(base) else {
            return ""
        }
        return size.lx.sizeFileToString
    }
    
    /// 从URL字符串中获取参数并转为字典 (方法1)
    /// - 返回值: 参数字典，如果解析失败返回nil
    public var urlParametersParsing: [String: String]? {
        guard let url = URL(string: base) else {
            return nil
        }
        return url.lx.urlParametersParsing
    }
    
    /// 从URL字符串中获取参数并转为字典 (方法2)
    /// - 返回值: 参数字典，如果解析失败返回nil
    public var urlParametersHighParsing: [String: String]? {
        guard let url = URL(string: base) else {
            return nil
        }
        return url.lx.urlParametersHighParsing
    }
    
    /// 删除最后一个路径组件
    /// - 返回值: 删除后的字符串
    public var stringByDeletingLastPathComponent: String {
        (base as NSString).deletingLastPathComponent
    }
    
    /// 删除路径扩展名
    /// - 返回值: 删除后的字符串
    public var stringByDeletingPathExtension: String {
        (base as NSString).deletingPathExtension
    }
    
    /// 获取路径的所有组件
    /// - 返回值: 路径组件数组
    public var pathComponents: [String] {
        (base as NSString).pathComponents
    }
    
    /// 获取最后一个路径组件
    /// - 返回值: 最后一个路径组件
    public var lastPathComponent: String {
        (base as NSString).lastPathComponent
    }
    
    /// 获取路径扩展名
    /// - 返回值: 路径扩展名
    public var pathExtension: String {
        (base as NSString).pathExtension
    }

    /// 金钱格式化 (方法1) - 每隔三位加逗号，保留两位小数
    /// - 返回值: 格式化后的金钱字符串
    public var moneyFormat: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        guard let number = numberFormatter.number(from: base) else {
            return ""
        }
        let formatter = NumberFormatter()
        formatter.positiveFormat = "###,##0.00"
        return formatter.string(from: number) ?? ""
    }
    
}

// MARK: - 字符串日期相关功能扩展
extension SwiftBasics where Base == String {
    
    /// 将日期字符串转换为Date对象
    /// - 参数 ymd: 日期格式字符串 (默认: "yyyy-MM-dd HH:mm:ss")
    /// - 返回值: 转换后的Date对象，如果转换失败返回nil
    public func stringTranformDate(_ ymd: String = "yyyy-MM-dd HH:mm:ss") -> Date? {
        let fmt = DateFormatter()
        fmt.dateFormat = ymd
        return fmt.date(from: base)
    }
    
    /// 将时间戳字符串转换为日期字符串
    /// - 参数 ymd: 目标日期格式 (默认: "yyyy-MM-dd HH:mm:ss")
    /// - 返回值: 格式化后的日期字符串
    public func timeStampToString(with ymd: String = "yyyy-MM-dd HH:mm:ss") -> String {
        guard let iTime = Int(base) else {
            return base
        }
        return iTime.lx.timeStampToString(with: ymd)
    }
    
    /// 将时间戳字符串转换为Date对象
    /// - 返回值: 转换后的Date对象，如果转换失败返回nil
    public func timeStampToDate() -> Date? {
        guard let iTime = Int(base) else {
            return nil
        }
        return iTime.lx.timeStampToDate()
    }
    
    /// 将时间戳转换为更友好的描述格式
    /**
     规则:
     - 60秒内: "刚刚"
     - 1-60分钟: "X分钟前"
     - 今天内: "X小时前"
     - 1-7天内: "X天前"
     - 今年内: "MM-dd HH:mm"
     - 去年及以前: "yyyy-MM-dd HH:mm"
     */
    public var timeDateDescription: String {
        guard let intTime = Int(base) else {
            return base
        }
        return intTime.lx.timeDateDescription
    }
}

// MARK: - 加密、编码、解码功能扩展
extension SwiftBasics where Base == String {
    
    /// 计算字符串的MD5哈希值
    /// - 返回值: 32位MD5哈希字符串
    public var md5: String {
        guard let data = base.data(using: .utf8, allowLossyConversion: true) else { return base }
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        
        #if swift(>=5.0)
        _ = data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) in
            CC_MD5(bytes.baseAddress, CC_LONG(data.count), &digest)
        }
        #else
        _ = data.withUnsafeBytes { bytes in
            CC_MD5(bytes, CC_LONG(data.count), &digest)
        }
        #endif
        
        return digest.reduce(into: "") { $0 += String(format: "%02x", $1) }
    }
    
    /// 将字符串转换为UTF-8编码的Data
    /// - 返回值: UTF-8编码的Data，如果转换失败返回nil
    public var utf8Data: Data? {
        base.data(using: .utf8)
    }
    
    /// 将字符串进行Base64编码
    /// - 返回值: Base64编码后的字符串，如果编码失败返回nil
    public var base64EncodingString: String? {
        guard let utf8EncodeData = base.data(using: .utf8,
                allowLossyConversion: true) else {
            return nil
        }
        return utf8EncodeData.base64EncodedString(options: .init(rawValue: 0))
    }
    
    /// 将Base64编码的字符串解码
    /// - 返回值: 解码后的原始字符串，如果解码失败返回nil
    public var base64DecodingString: String? {
        guard let utf8DecodedData = Data(base64Encoded: base, options: .init(rawValue: 0)) else {
            return nil
        }
        return String(data: utf8DecodedData, encoding: .utf8)
    }
    
    /// 将Base64编码的图片字符串转换为UIImage
    /// - 返回值: 解码后的UIImage，如果解码失败返回nil
    public var base64EncodingImage: UIImage? {
        guard let base64Data = Data(base64Encoded: base, options: .ignoreUnknownCharacters) else {
            return nil
        }
        return UIImage(data: base64Data)
    }
    
    /// 对URL字符串进行编码
    /// - 返回值: 编码后的URL字符串，如果编码失败返回空字符串
    public var urlEncoded: String {
        base.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    }
    
    /// 对URL字符串进行解码
    /// - 返回值: 解码后的原始URL字符串，如果解码失败返回空字符串
    public var urlDecoded: String {
        base.removingPercentEncoding ?? ""
    }
}

// MARK: - 正则表达式验证功能扩展
extension SwiftBasics where Base == String {
    
    /// 验证字符串是否匹配指定的正则表达式模式
    /// - 参数 pattern: 正则表达式模式
    /// - 返回值: 如果匹配返回true，否则返回false
    public func isSuit(pattern: String) -> Bool {
        base.verification(pattern: pattern)
    }
    
    /// 验证是否为合法的车牌号
    /// - 返回值: 如果是合法车牌号返回true，否则返回false
    public func isValidCarid() -> Bool {
        base.verification(pattern: "^[京津沪渝冀豫云辽黑湘皖鲁新苏浙赣鄂桂甘晋蒙陕吉闽贵粤青藏川宁琼使领A-Z]{1}[A-Z]{1}[A-Z0-9]{4,5}[A-Z0-9挂学警港澳]{1}$")
    }
    
    /// 检查字符串是否包含特殊字符
    /// - 返回值: 如果包含特殊字符返回true，否则返回false
    public func isContainSpecialChar() -> Bool {
        base.verification(pattern: "[\\$\\(\\)\\*\\+\\[\\]\\?\\^\\{\\|]")
    }
    
    /// 验证是否为合法的电子邮件地址
    /// - 返回值: 如果是合法邮箱返回true，否则返回false
    public func isValidEmail() -> Bool {
        base.verification(pattern: "^(\\w)+(\\.\\w+)*@(\\w)+((\\.\\w{1,}){1,3})$")
    }
    
    /// 验证是否为合法的HTTP/HTTPS URL
    /// - 返回值: 如果是合法URL返回true，否则返回false
    public func isValidUrl() -> Bool {
        base.verification(pattern: "^http(s)?://")
    }
    
    /// 验证是否为合法的手机号码 (中国)
    /// - 返回值: 如果是合法手机号返回true，否则返回false
    public func isValidPhoneNumber() -> Bool {
        base.verification(pattern: "^1\\d{10}$")
    }
    
    /// 验证是否为合法的身份证号码 (中国)
    /// - 返回值: 如果是合法身份证号返回true，否则返回false
    public func isValidIDCard() -> Bool {
        base.verification(pattern: "(^[1-9]\\d{5}(18|19|([23]\\d))\\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\\d{3}[0-9Xx]$)|(^[1-9]\\d{5}\\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\\d{2}$)")
    }
    
    /// 验证是否为合法的IP地址
    /// - 返回值: 如果是合法IP返回true，否则返回false
    public func isValidIP() -> Bool {
        base.verification(pattern: "^((2[0-4]\\d|25[0-5]|[01]?\\d\\d?).){3}(2[0-4]\\d|25[0-5]|[01]?\\d\\d?)$")
    }
    
    /// 验证字符串是否全部为中文字符
    /// - 返回值: 如果全部为中文返回true，否则返回false
    public func isChinese() -> Bool {
        base.verification(pattern: "^[\\u0391-\\uFFE5]+$")
    }
    
    /// 验证字符串是否为纯数字 (可包含小数点)
    /// - 返回值: 如果是纯数字返回true，否则返回false
    public func isNumber() -> Bool {
        base.verification(pattern: "^[0-9]+(.[0-9]+)?$")
    }
    
    /// 验证字符串是否为正整数
    /// - 返回值: 如果是正整数返回true，否则返回false
    public func isInteger() -> Bool {
        base.verification(pattern: "^[0-9]+$")
    }
    
    /// 验证是否为标准小数 (保留两位小数)
    /// - 返回值: 如果是标准小数返回true，否则返回false
    public func isStandardDecimal() -> Bool {
        base.verification(pattern: "^[0-9]+(\\.[0-9]{2})$")
    }
    
    /// 验证是否为合法密码 (6-18位字母数字组合)
    /// - 返回值: 如果是合法密码返回true，否则返回false
    public func isValidPasswd() -> Bool {
        base.verification(pattern: "^[a-zA-Z0-9]{6,18}$")
    }
    
    /// 检查字符串是否包含空格或空行
    /// - 返回值: 如果包含空格或空行返回true，否则返回false
    public func isContainBlank() -> Bool {
        base.verification(pattern: "[\\s]")
    }
    
    /// 获取字符串中所有数字的范围
    /// - 返回值: 数字范围的数组，如果没有数字返回空数组
    public func numberRanges() -> [NSRange] {
        if let results = base.lx.matching(pattern: "[0-9]+(.[0-9]+)?") {
            return results.map { $0.range }
        }
        return []
    }
    
    /// 使用正则表达式匹配字符串
    /// - 参数:
    ///   - pattern: 正则表达式模式
    ///   - options: 正则表达式选项 (默认不区分大小写)
    /// - 返回值: 匹配结果数组，如果没有匹配返回nil
    public func matching(pattern: String, options: NSRegularExpression.Options = .caseInsensitive) -> [NSTextCheckingResult]? {
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        return regex?.matches(in: base,
                              options: .init(rawValue: 0),
                              range: NSRange(location: 0, length: base.count))
    }
}

/// 内部使用的扩展方法
extension String {
    
    /// 内部方法: 通过整数范围截取子字符串
    fileprivate subscript (_ r: Range<Int>) -> String {
        get {
            let startIndex = index(self.startIndex, offsetBy: r.lowerBound)
            let endIndex = index(self.startIndex, offsetBy: r.upperBound)
            return String(self[startIndex..<endIndex])
        }
    }
    
    /// 内部方法: 验证字符串是否匹配正则表达式
    fileprivate func verification(pattern: String) -> Bool {
        (self.lx.matching(pattern: pattern)?.count ?? 0) > 0
    }
}
