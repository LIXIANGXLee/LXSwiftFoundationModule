//
//  Swift+String.swift
//  LXSwiftFoundation
//
//  Created by XL on 2020/9/23.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit
import CommonCrypto

/// 正则处理类型配置模型
/// 用于定义不同的正则匹配规则及其对应的样式
public struct SwiftRegexType {
    /// 初始化正则类型配置
    /// - Parameters:
    ///   - regexPattern: 正则表达式字符串，用于匹配目标文本
    ///   - color: 匹配文本的颜色（仅对非表情类型有效）
    ///   - font: 匹配文本的字体（仅对非表情类型有效）
    ///   - isExpression: 是否为表情类型（会替换为图片，需确保此类配置在规则数组末尾）
    public init(
        regexPattern: String,
        color: UIColor = .orange,
        font: UIFont = UIFont.systemFont(ofSize: 15),
        isExpression: Bool = false
    ) {
        self.regexPattern = regexPattern
        self.isExpression = isExpression
        self.color = color
        self.font = font
    }
    
    public var regexPattern: String      // 正则表达式
    public var color: UIColor = .orange  // 文本高亮颜色
    public var font: UIFont = UIFont.systemFont(ofSize: 15) // 文本字体
    public var isExpression: Bool = false // 是否为表情类型
    
    // 自定义富文本属性键
    public static let textLinkAttributeKey = "textLinkAttributeKey"   // 超链接标识键
    public static let imageLinkAttributeKey = "imageLinkAttributeKey" // 表情图片标识键
 
    /// 预定义正则表达式模式
    public static let defaultHttpRegex = "http(s)?://([a-zA-Z|\\d]+\\.)+[a-zA-Z|\\d]+(\\[a-zA-Z|\\d|\\-|\\+|_./?%&=]*)?"
    public static let defaultPhoneRegex = "\\d{3,4}[- ]?\\d{7,8}"
    public static let defaultExpressionRegex = "\\[(.*?)\\]"  // 匹配形如[表情名]的格式
    
    /// 默认正则配置数组（注意：表情类型必须放在数组末尾）
    public static let defaultRegexTypes: [SwiftRegexType] = [
        SwiftRegexType(regexPattern: defaultHttpRegex, color: .blue),   // 超链接匹配（蓝色高亮）
        SwiftRegexType(regexPattern: defaultPhoneRegex, color: .green), // 电话匹配（绿色高亮）
        SwiftRegexType(regexPattern: defaultExpressionRegex, isExpression: true) // 表情匹配（最后处理）
    ]
}

/// 版本比较结果枚举
public enum CompareResult: Int {
    case big = 1     /// 版本大于目标版本
    case equal = 0   /// 版本等于目标版本
    case small = -1  /// 版本小于目标版本
}

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

// MARK: - 字符串匹配功能扩展 (超链接、电话号码、表情符号等)
extension SwiftBasics where Base == String {
    /// 使用正则表达式枚举字符串中的所有匹配结果
    /// - 参数:
    ///   - regex: 正则表达式字符串（自动去除首尾空格）
    ///   - completionHandler: 处理每个匹配结果的回调闭包
    ///     - 参数1 captureCount: 捕获组的数量（不包含完整匹配组）
    ///     - 参数2 matchedString: 匹配到的完整字符串
    ///     - 参数3 range: 匹配结果在原始字符串中的范围(NSRange)
    public func enumerateMatches(regex: String,
                                 completionHandler: (_ captureCount: Int,
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
            completionHandler(captureGroupCount, matchedString, matchRange)
        }
    }
    
    /// 生成富文本（支持多规则匹配）
    /// - Parameters:
    ///   - text: 原始文本内容
    ///   - textColor: 基础文本颜色（默认黑色）
    ///   - textFont: 基础字体（默认系统字体15pt）
    ///   - lineSpacing: 行间距（默认4pt）
    ///   - wordSpacing: 字间距（默认0）
    ///   - regexTypes: 使用的正则配置数组（默认使用defaultRegexTypes）
    /// - Returns: 处理后的富文本对象（可能为nil）
    public func createAttributedString(
        textColor: UIColor = .black,
        textFont: UIFont = .systemFont(ofSize: 15),
        lineSpacing: CGFloat = 4,
        wordSpacing: CGFloat = 0,
        regexTypes: [SwiftRegexType] = SwiftRegexType.defaultRegexTypes
    ) -> NSAttributedString? {
        // 空文本检查
        guard !base.isEmpty else { return nil }
        
        // 1. 初始化富文本基础属性
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing  // 设置行间距
        
        // 基础文本属性配置
        let baseAttributes: [NSAttributedString.Key: Any] = [
            .font: textFont,                      // 字体
            .foregroundColor: textColor,           // 文本颜色
            .paragraphStyle: paragraphStyle,       // 段落样式
            .kern: wordSpacing                    // 字间距
        ]
        
        // 2. 创建可变的富文本对象
        let attributedString = NSMutableAttributedString(string: base, attributes: baseAttributes)
        
        // 3. 按顺序处理每个正则规则
        for regexType in regexTypes {
            if regexType.isExpression {
                // 表情类型处理（图片替换）
                processExpressionMatches(in: attributedString, regexType: regexType)
            } else {
                // 文本类型处理（颜色/字体高亮）
                processTextAttributes(in: attributedString, regexType: regexType)
            }
        }
        return attributedString
    }
    
    // MARK: - 私有处理函数
    
    /// 处理文本属性匹配（颜色、字体高亮）
    /// - Parameters:
    ///   - attributedString: 待处理的富文本（可修改）
    ///   - regexType: 当前处理的正则配置
    private func processTextAttributes(
        in attributedString: NSMutableAttributedString,
        regexType: SwiftRegexType) {
        let text = attributedString.string
        
        // 遍历所有匹配项
        text.lx.enumerateMatches(regex: regexType.regexPattern) { _, matchedString, range in
            // 添加高亮属性
            let highlightAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: regexType.color,
                .font: regexType.font
            ]
            attributedString.addAttributes(highlightAttributes, range: range)
            
            // 添加自定义链接标识（用于后续点击事件处理）
            let customKey = NSAttributedString.Key(rawValue: SwiftRegexType.textLinkAttributeKey)
            attributedString.addAttribute(customKey, value: matchedString, range: range)
        }
    }
    
    /// 处理表情图片替换
    /// - Parameters:
    ///   - attributedString: 待处理的富文本（可修改）
    ///   - regexType: 当前处理的正则配置
    private func processExpressionMatches(
        in attributedString: NSMutableAttributedString,
        regexType: SwiftRegexType) {
        let text = attributedString.string
        
        // 注意：表情处理必须最后执行，因为替换操作会改变文本长度
        text.lx.enumerateMatches(regex: regexType.regexPattern) { _, matchedString, range in
            // 1. 提取表情名称（移除方括号）
            let expressionName = String(matchedString.dropFirst().dropLast())
            
            // 2. 获取对应图片资源
            guard let image = UIImage(named: expressionName) else {
                SwiftLog.log("表情图片未找到: \(expressionName)")
                return
            }
            
            // 3. 创建文本附件（图片容器）
            let attachment = NSTextAttachment()
            attachment.image = image
            
            // 4. 计算图片尺寸（与当前字体行高对齐）
            let lineHeight = regexType.font.lineHeight
            attachment.bounds = CGRect(
                x: 0,
                y: -3,  // Y轴微调，实现垂直居中
                width: lineHeight,
                height: lineHeight
            )
            
            // 5. 将图片附件转为富文本
            let imageAttr = NSAttributedString(attachment: attachment)
            
            // 6. 执行替换操作（用图片替换文本）
            attributedString.replaceCharacters(in: range, with: imageAttr)
            
            // 7. 添加自定义图片标识（用于后续事件处理）
            // 注意：替换后range长度变为1（单个字符表示图片）
            let newRange = NSRange(location: range.location, length: 1)
            let customKey = NSAttributedString.Key(rawValue: SwiftRegexType.imageLinkAttributeKey)
            attributedString.addAttribute(customKey, value: expressionName, range: newRange)
        }
    }
    
    
    /// 使用正则表达式匹配当前字符串
    /// - 参数:
    ///   - pattern: 正则表达式模式字符串
    ///   - options: 正则表达式选项，默认为 `.caseInsensitive` (不区分大小写)
    /// - 返回值:
    ///     - 成功: 包含所有匹配结果的数组 `[NSTextCheckingResult]`
    ///     - 失败: 当正则表达式编译失败时返回 `nil`
    /// - 注意:
    ///     1. 当正则表达式模式无效时会静默失败（返回 nil）
    ///     2. 匹配范围覆盖整个字符串（从起始位置到末尾）
    ///     3. 默认启用不区分大小写匹配，可通过 options 参数修改
    public func matching(
        pattern: String,
        options: NSRegularExpression.Options = .caseInsensitive
    ) -> [NSTextCheckingResult]? {
        // 尝试编译正则表达式（使用传入的选项）
        // 使用 try? 避免抛出异常，编译失败时返回 nil
        guard let regex = try? NSRegularExpression(
            pattern: pattern,
            options: options
        ) else {
            // 正则表达式模式无效，返回 nil
            return nil
        }
        
        // 在整个字符串范围内执行匹配
        let fullRange = NSRange(
            location: 0,
            length: base.count
        )
        
        // 返回所有匹配结果（可能为空数组表示无匹配）
        return regex.matches(
            in: base,
            options: [],          // 匹配选项使用默认值
            range: fullRange      // 指定完整匹配范围
        )
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
    

    // MARK: - 版本比较
    
    /// 比较两个语义化版本号 (Semantic Versioning)
    /// - Parameters:
    ///   - v1: 版本号字符串1 (格式: "主版本.次版本.修订号")
    ///   - v2: 版本号字符串2
    /// - Returns: 比较结果枚举值
    ///
    /// 示例:
    ///   compareVersion(v1: "2.3.1", v2: "2.1.4") -> .big
    public static func compareVersion(v1: String, v2: String) -> CompareResult {
        
        let result = v1.compare(v2, options: .numeric);
        switch result {
        case .orderedAscending: return CompareResult.small
        case .orderedSame: return CompareResult.equal
        case .orderedDescending: return CompareResult.big
        }
    }
}

// MARK: - 字符串转换功能扩展
extension SwiftBasics where Base == String {
    
    /// 对手机号中间四位进行脱敏处理（替换为星号）
    /// - Parameter phoneNumber: 原始手机号码字符串
    /// - mark: 分隔符（默认为****）
    /// - Returns: 脱敏后的手机号字符串（格式：前3位 + **** + 后4位）
    ///
    /// 处理规则：
    /// 1. 移除输入字符串中的所有非数字字符
    /// 2. 当纯数字长度为11位时，进行脱敏处理
    /// 3. 不符合11位时返回原始字符串
    ///     // 测试用例
    /// maskPhoneNumber("13800138000")) // 138****8000
    /// maskPhoneNumber("138 0013 8000") // 138****8000
    /// maskPhoneNumber("+86 138-0013-8000") // 138****8000
    /// maskPhoneNumber("12345")) // 12345（不符合规则返回原始值）
    func maskPhoneNumber(_ phoneNumber: String, mark: String = "****") -> String {
        // 过滤非数字字符
        let digits = phoneNumber.filter { $0.isNumber }
        
        // 验证是否为11位手机号
        guard digits.count == 11 else {
            return phoneNumber // 返回原始输入
        }
        
        // 提取手机号各段
        let prefix = digits.prefix(3)      // 前3位
        let suffix = digits.suffix(4)      // 后4位
        
        // 拼接脱敏字符串
        return "\(prefix)\(mark)\(suffix)"
    }
    
    /// 格式化手机号码为 3-4-4 的分段格式
    /// - Parameters:
    ///   - phoneNumber: 原始手机号码字符串
    ///   - mark: 分隔符（默认为空格）
    /// - Returns: 格式化后的手机号码，长度非11位时返回原始输入
    func formatPhoneNumber(_ phoneNumber: String, mark: String = " ") -> String {
        // 预处理：移除所有空格和非数字字符（增强鲁棒性）
        let cleanedNumber = phoneNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        
        // 验证有效性：仅处理11位纯数字
        guard cleanedNumber.count == 11,
                cleanedNumber.allSatisfy({ $0.isNumber }) else {
            return phoneNumber
        }
        
        // 分割三段式结构 (使用Substring避免额外内存分配)
        let prefix = cleanedNumber.prefix(3)
        let middle = cleanedNumber.dropFirst(3).prefix(4)
        let suffix = cleanedNumber.dropFirst(7)
        
        // 高效拼接结果
        return "\(prefix)\(mark)\(middle)\(mark)\(suffix)"
    }
    
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

    /// 将中文字符串转换为拼音（无音标、无空格）
    /// - 返回值: 转换后的拼音字符串（小写字母连续拼接）
    public var toPinYin: String {
        // 1. 空字符串快速返回
        guard !base.isEmpty else { return "" }
        
        // 2. 创建可变字符串用于转换操作
        let mutableString = NSMutableString(string: base)
        
        // 3. 第一阶段转换：汉字转拉丁字母（含音标）
        // 参数说明：
        // - mutableString: 输入/输出的字符串
        // - nil: 转换范围指针（默认整个字符串）
        // - kCFStringTransformToLatin: 转换为拉丁字母的转换标识
        // - false: 不逆向转换
        CFStringTransform(mutableString, nil, kCFStringTransformToLatin, false)
        
        // 4. 第二阶段转换：去除音调符号
        // 参数说明：
        // - kCFStringTransformStripDiacritics: 去除变音符号的转换标识
        CFStringTransform(mutableString, nil, kCFStringTransformStripDiacritics, false)
        
        // 5. 转换为标准String类型
        let converted = String(mutableString)
        
        // 6. 清理操作：
        // - 移除所有空格（拼音间原有空格）
        // - 转换为小写字母（保证拼音统一格式）
        // - 过滤非字母字符（处理转换产生的特殊字符）
        return converted
            .replacingOccurrences(of: " ", with: "")  // 移除拼音间的空格
            .lowercased()                             // 统一转换为小写
            .filter { $0.isLetter }                   // 过滤保留字母字符
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
    
    /// 格式化小数字符串，保留指定小数位数
    /// - 参数 digits: 要保留的小数位数
    ///   - mode: 舍入模式 (默认向下取整)
    /// - 返回值: 格式化后的字符串
    public func formatDecimalString(by digits: Int,
                                    mode: NumberFormatter.RoundingMode = .down) -> String {
        // 1. 清理输入字符串
        let cleanText = base
            .replacingOccurrences(of: ",", with: "")
            .trimmingCharacters(in: .whitespaces)
        
        // 2. 验证并转换数值
        guard !cleanText.isEmpty, let value = Double(cleanText) else {
            return base
        }
        
       // 配置数字格式化器 返回格式化结果
        return NSNumber(value: value).lx.numberFormatter(with: mode, minDigits: digits, maxDigits: digits) ?? base
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
        // 步骤1：将原始字符串转换为UTF8编码的Data对象
        // 使用allowLossyConversion: true参数允许转换时丢弃无法编码的字符（替换为UTF8替换字符U+FFFD）
        guard let utf8EncodeData = base.data(
            using: .utf8,
            allowLossyConversion: true
        ) else {
            // 转换失败时返回nil（通常因编码问题导致）
            return nil
        }
        
        // 步骤2：将UTF8编码的Data对象进行Base64编码
        // 使用options: .init(rawValue: 0)表示默认编码选项（无换行/填充等特殊处理）
        let base64String = utf8EncodeData.base64EncodedString(
            options: .init(rawValue: 0)
        )
        
        return base64String
    }
    
    /// 将Base64编码的字符串解码为原始字符串
    /// - 返回值: 解码后的原始字符串（UTF-8编码），如果输入非合法Base64字符串或解码后非有效UTF-8数据则返回nil
    public var base64DecodingString: String? {
        // 步骤1：尝试将Base64字符串解码为Data对象
        // 使用默认解码选项（.ignoreUnknownCharacters），自动忽略非法字符（如换行符、空格等）
        guard let decodedData = Data(base64Encoded: base, options: .ignoreUnknownCharacters) else {
            // 输入字符串不符合Base64规范（长度非法/包含非法字符）
            return nil
        }
        
        // 步骤2：将解码后的二进制数据转换为UTF-8字符串
        // 注意：此操作假设原始编码为UTF-8，若原始数据非文本或使用其他编码（如GBK/ASCII）可能失败
        guard let decodedString = String(data: decodedData, encoding: .utf8) else {
            // 解码后的二进制数据不符合UTF-8编码规范
            return nil
        }
        
        return decodedString
    }
    
    /*// 含URL头的多行Base64字符串
     let base64String = """
     data:image/png;base64,
     iVBORw0KGgoAAAANSUhEUgAAABwAAAAcCAYAAAByDd+UAAAAAXNSR0IArs4c6QAAAARnQU1BAACx
     jwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAAZdEVYdFNvZnR3YXJlAHBhaW50Lm5ldCA0LjAu
     MTnU1rJkAAAAi0lEQVRIie2VMQqAMAwFfYGcexQv4Ik8goJgq1YQ3JS2KbgYB7+0UAr5L1BC0Lz0
     pdC0EBERERERERERERGRf+IFKAAWcCKsAcuZcG1M6N1F2CxPwsQ+wiY1QbCbMNhMEGwjCLYQBNsH
     wvZ9sH0fbN8H2/fB9n2wfR9s3wf8H0BERERERERERERERERERERERP6UD8koxSuBzQMSAAAAAElF
     TkSuQmCC
     """

     // 自动处理URL头和多行格式
     let image = base64String.base64DecodingImage*/
    
    /// 将Base64编码的字符串解码为UIImage对象
    public var base64DecodingImage: UIImage? {
        // 0. 预处理：移除Base64字符串中的URL头标识（如"data:image/png;base64,"）和非法字符
        // - 截取逗号后的有效数据部分（常见于Web传输的Base64格式）
        // - 过滤换行符/空格等干扰字符（确保符合Base64规范）
        let processedBase = base
            .components(separatedBy: ",")  // 分割可能存在的URL头标识
            .last?                         // 取最后部分（有效数据）
            .filter { !$0.isWhitespace } ?? base  // 过滤空白字符，保底使用原字符串
        
        // 1. Base64字符串解码为Data对象
        guard let base64Data = Data(
            base64Encoded: processedBase,
            options: .ignoreUnknownCharacters  // 关键容错选项：忽略非法字符（如换行符/特殊符号）
        ) else {
            // 解码失败可能原因：
            // - 字符串包含非Base64字符（字母表外字符）
            // - 字符串长度不是4的整数倍（Base64规范要求）
            // - 填充字符'='位置错误
            return nil
        }
        
        // 2. 二进制数据转UIImage对象
        // 注意：可能因以下原因失败：
        //   - 数据实际格式与声明不符（如声明PNG实际是JPG）
        //   - 图片文件头损坏或数据截断
        //   - 系统不支持该图片格式（如WebP需额外支持）
        //   - 内存不足（超大图片）
        return UIImage(data: base64Data)
    }
    
    /// 生成高清晰度二维码图片
    /// - Parameters:
    ///   - size: 生成图片的边长，单位：点（默认800px）
    /// - Returns: 生成的二维码图片 (失败返回nil)
    ///
    /// 特性说明：
    /// 1. 使用"H"级容错率（约30%纠错能力）
    /// 2. 采用最近邻插值算法保持边缘锐利
    /// 3. 显式处理颜色空间确保跨平台兼容性
    public func createQrCodeImage(size: CGFloat = 800) -> UIImage? {
        // 确保原始字符串非空
        guard !base.isEmpty else {
            SwiftLog.log("⚠️ 二维码生成失败：输入内容为空")
            return nil
        }
        
        // 使用系统内置的二维码生成过滤器
        guard let filter = CIFilter(name: "CIQRCodeGenerator") else {
            SwiftLog.log("❌ 二维码生成失败：CIQRCodeGenerator过滤器不可用")
            return nil
        }
        
        // 将字符串转为UTF8编码的二进制数据
        guard let inputData = base.data(using: .utf8) else {
            SwiftLog.log("❌ 二维码生成失败：字符串编码转换失败")
            return nil
        }
        
        // 设置输入信息
        filter.setValue(inputData, forKey: "inputMessage")
        // 设置容错级别为最高（H级，30%纠错能力）
        filter.setValue("H", forKey: "inputCorrectionLevel")
        
        // 获取未缩放的CIImage对象
        guard let outputImage = filter.outputImage else {
            SwiftLog.log("❌ 二维码生成失败：过滤器未输出图像")
            return nil
        }
        
        // 原始二维码图像尺寸（通常较小，如33x33）
        let originalSize = outputImage.extent.size
        // 计算目标尺寸到原始尺寸的缩放比例
        let scale = size / originalSize.width
        
        // 使用仿射变换进行缩放
        let transformedImage = outputImage.transformed(
            by: CGAffineTransform(scaleX: scale, y: scale)
        )
        
        // 创建Core Image上下文（使用GPU加速）
        let context: CIContext
        if let metalDevice = MTLCreateSystemDefaultDevice() {
            // 优先使用Metal硬件加速
            context = CIContext(mtlDevice: metalDevice)
        } else {
            // 回退到软件渲染
            context = CIContext(options: [CIContextOption.useSoftwareRenderer: false])
        }
        
        // 创建RGB颜色空间（确保跨平台兼容性）
        guard let colorSpace = CGColorSpace(name: CGColorSpace.sRGB) else {
            SwiftLog.log("❌ 二维码生成失败：颜色空间创建失败")
            return nil
        }
        
        // 渲染CoreImage到CGImage（关键步骤：提高清晰度）
        guard let cgImage = context.createCGImage(
            transformedImage,
            from: transformedImage.extent,
            format: .RGBA8,
            colorSpace: colorSpace
        ) else {
            SwiftLog.log("❌ 二维码生成失败：CGImage渲染失败")
            return nil
        }
        
        // 注意：此处使用init(cgImage:)保持图像方向正确
        return UIImage(cgImage: cgImage)
    }
    
    /// 对URL字符串进行百分比编码
    ///
    /// 此计算属性将原始字符串转换为符合URL规范的格式，主要处理以下情况：
    /// 1. 将非ASCII字符（如中文）转换为`%`编码格式
    /// 2. 保留URL查询字符串允许的合法字符集
    /// 3. 处理空格、特殊符号等需要转义的字符
    ///
    /// 编码规则说明：
    /// - 使用系统提供的URL查询字符集（.urlQueryAllowed）作为允许保留的字符
    /// - 该字符集包含：字母数字字符（A-Z/a-z/0-9）、连字符（-）、下划线（_）、点（.）、波浪线（~）
    /// - 其他字符均会被转换为`%`后跟两位十六进制数的形式
    ///
    /// 示例：
    ///   "搜索 terms!&" 编码后 → "搜索%20terms!%26"
    ///   "price=$100&discount=50%" 编码后 → "price%3D%24100%26discount%3D50%25"
    ///
    /// - 返回值: 安全合法的URL编码字符串，若编码失败将返回空字符串（理论上不会发生，此处为安全处理）
    public var urlEncoded: String {
        // 使用系统预定义的URL查询允许字符集进行编码
        // 注意：此字符集不会编码保留字符（如：?、&、=），适合查询参数使用
        let encodedString = base.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        // 空值保护：理论上仅当字符串包含非法UTF8序列时返回nil，此时返回安全空字符串
        return encodedString ?? ""
    }
    
    /// 对URL字符串进行百分比解码
    /// - 说明:
    ///   1. 此方法用于处理URL中经过百分比编码(%xx格式)的字符串
    ///   2. 解码规则遵循RFC 3986标准，将%xx格式的序列转换为原始字符
    ///   3. 支持解码多字节字符（如中文）和特殊符号
    /// - 返回值:
    ///   - 成功: 返回解码后的原始字符串
    ///   - 失败: 当遇到无效百分比编码序列时返回空字符串
    /// - 注意事项:
    ///   1. 若字符串不包含百分号编码，将原样返回原始内容
    ///   2. 百分号后必须跟随两个十六进制数字（0-9, A-F, a-f）
    ///   3. 空字符串或全空格的输入将直接返回原值
    ///   4. 主要应用场景：处理URL参数、路径片段等需要还原原始字符的场景
    public var urlDecoded: String {
        // 使用系统API进行百分比解码
        // removingPercentEncoding 方法特性：
        //   - 自动识别%xx格式的编码序列
        //   - 遇到无效编码（如%后非十六进制字符、不完整编码）时返回nil
        //   - 保留未编码部分的原始内容
        guard let decodedString = base.removingPercentEncoding else {
            // 解码失败处理（包含以下情况）：
            //   - 字符串包含非法百分比序列（例如"%G"、"%%"）
            //   - 百分比编码格式错误（如"%A"不完整）
            return ""
        }
        return decodedString
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
    public var isValidCarid: Bool {
        base.verification(pattern: "^[京津沪渝冀豫云辽黑湘皖鲁新苏浙赣鄂桂甘晋蒙陕吉闽贵粤青藏川宁琼使领A-Z]{1}[A-Z]{1}[A-Z0-9]{4,5}[A-Z0-9挂学警港澳]{1}$")
    }
    
    /// 检查字符串是否包含特殊字符
    /// - 返回值: 如果包含特殊字符返回true，否则返回false
    public var isContainSpecialChar: Bool {
        base.verification(pattern: "[\\$\\(\\)\\*\\+\\[\\]\\?\\^\\{\\|]")
    }
    
    /// 验证是否为合法的电子邮件地址
    /// - 返回值: 如果是合法邮箱返回true，否则返回false
    public var isValidEmail: Bool {
        base.verification(pattern: "^(\\w)+(\\.\\w+)*@(\\w)+((\\.\\w{1,}){1,3})$")
    }
    
    /// 验证是否为合法的HTTP/HTTPS URL
    /// - 返回值: 如果是合法URL返回true，否则返回false
    public var isValidUrl: Bool {
        base.verification(pattern: "^http(s)?://")
    }
    
    /// 验证是否为合法的手机号码 (中国)
    /// - 返回值: 如果是合法手机号返回true，否则返回false
    public var isValidPhoneNumber: Bool {
        base.verification(pattern: "^1\\d{10}$")
    }
    
    /// 验证是否为合法的身份证号码 (中国)
    /// - 返回值: 如果是合法身份证号返回true，否则返回false
    public var isValidIDCard: Bool {
        base.verification(pattern: "(^[1-9]\\d{5}(18|19|([23]\\d))\\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\\d{3}[0-9Xx]$)|(^[1-9]\\d{5}\\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\\d{2}$)")
    }
    
    /// 验证是否为合法的IP地址
    /// - 返回值: 如果是合法IP返回true，否则返回false
    public var isValidIP: Bool {
        base.verification(pattern: "^((2[0-4]\\d|25[0-5]|[01]?\\d\\d?).){3}(2[0-4]\\d|25[0-5]|[01]?\\d\\d?)$")
    }
    
    /// 验证字符串是否全部为中文字符
    /// - 返回值: 如果全部为中文返回true，否则返回false
    public var isChinese: Bool {
        base.verification(pattern: "^[\\u0391-\\uFFE5]+$")
    }
    
    /// 验证字符串是否为纯数字 (可包含小数点)
    /// - 返回值: 如果是纯数字返回true，否则返回false
    public var isNumber: Bool {
        base.verification(pattern: "^[0-9]+(.[0-9]+)?$")
    }
    
    /// 验证字符串是否为正整数
    /// - 返回值: 如果是正整数返回true，否则返回false
    public var isInteger: Bool {
        base.verification(pattern: "^[0-9]+$")
    }
    
    /// 验证是否为标准小数 (保留两位小数)
    /// - 返回值: 如果是标准小数返回true，否则返回false
    public var isStandardDecimal: Bool {
        base.verification(pattern: "^[0-9]+(\\.[0-9]{2})$")
    }
    
    /// 验证是否为合法密码 (6-18位字母数字组合)
    /// - 返回值: 如果是合法密码返回true，否则返回false
    public var isValidPasswd: Bool {
        base.verification(pattern: "^[a-zA-Z0-9]{6,18}$")
    }
    
    /// 检查字符串是否包含空格或空行
    /// - 返回值: 如果包含空格或空行返回true，否则返回false
    public var isContainBlank: Bool {
        base.verification(pattern: "[\\s]")
    }
    
    /// 获取字符串中所有数字的范围
    /// - 返回值: 数字范围的数组，如果没有数字返回空数组
    public var numberRanges: [NSRange] {
        if let results = base.lx.matching(pattern: "[0-9]+(.[0-9]+)?") {
            return results.map { $0.range }
        }
        return []
    }

}

/// 内部使用的扩展方法
extension String {
    
    /// 通过整数范围截取字符串的子串（左闭右开区间）
    /// - 注意：索引越界会触发运行时错误！调用者需确保范围在有效区间内 [0, count]
    fileprivate subscript (_ r: Range<Int>) -> String {
        get {
            // 计算起始索引：从字符串头部偏移 r.lowerBound 个字符位置
            // ⚠️ 如果 r.lowerBound 超过字符串长度，会导致崩溃
            let startIndex = index(self.startIndex, offsetBy: r.lowerBound)
            
            // 计算结束索引：从字符串头部偏移 r.upperBound 个字符位置
            // ⚠️ 如果 r.upperBound 超过字符串长度，会导致崩溃
            let endIndex = index(self.startIndex, offsetBy: r.upperBound)
            
            // 截取子字符串（遵循Swift标准左闭右开规则）
            // 示例：str[2..<5] 实际截取第2、3、4三个字符
            return String(self[startIndex..<endIndex])
        }
    }
    
    /// 内部方法: 验证字符串是否匹配正则表达式
    fileprivate func verification(pattern: String) -> Bool {
        (self.lx.matching(pattern: pattern)?.count ?? 0) > 0
    }
}
