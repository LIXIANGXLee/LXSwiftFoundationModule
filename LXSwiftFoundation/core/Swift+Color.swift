//
//  Swift+Color.swift
//  LXSwiftFoundation
//
//  Created by Mac on 2020/9/25.
//  Copyright © 2020 李响. All rights reserved.
//

// MARK: - UIColor 扩展 (命名空间)
extension SwiftBasics where Base: UIColor {
    
    // MARK: 暗黑模式适配
    
    /// 创建支持暗黑模式的颜色 (十六进制字符串)
    /// - Parameters:
    ///   - lightHex: 浅色模式下的十六进制颜色值 (支持格式: "#RGB", "#RRGGBB", "0xRRGGBB")
    ///   - darkHex: 深色模式下的十六进制颜色值 (格式同上)
    ///   - alpha: 透明度 (默认1.0)
    /// - Returns: 适配当前外观模式的颜色
    /// - Note: iOS13以下系统仅返回浅色模式颜色
    public static func color(lightHex: String, darkHex: String, alpha: CGFloat = 1.0) -> UIColor {
        let light = UIColor(hex: lightHex, alpha: alpha)
        let dark = UIColor(hex: darkHex, alpha: alpha)
        return color(lightColor: light, darkColor: dark)
    }
    
    /// 创建支持暗黑模式的颜色 (UIColor对象)
    /// - Parameters:
    ///   - lightColor: 浅色模式下的颜色
    ///   - darkColor: 深色模式下的颜色
    /// - Returns: 适配当前外观模式的颜色
    /// - Note: iOS13以下系统仅返回浅色模式颜色
    public static func color(lightColor: UIColor, darkColor: UIColor) -> UIColor {
        // 利用iOS13+的UITraitCollection特性适配暗黑模式
        if #available(iOS 13.0, *) {
            return UIColor { traitCollection in
                traitCollection.userInterfaceStyle == .dark ? darkColor : lightColor
            }
        }
        // 旧版本系统回退到浅色模式
        return lightColor
    }
    
    // MARK: 基础颜色构造
    
    /// 通过十六进制字符串创建颜色
    /// - Parameters:
    ///   - hex: 十六进制字符串 (支持格式: "#RGB", "#RRGGBB", "0xRRGGBB")
    ///   - alpha: 透明度 (默认1.0)
    /// - Returns: 对应的UIColor对象
    /// - Warning: 无效格式会返回透明红色作为错误提示
    public static func color(hex: String, alpha: CGFloat = 1.0) -> UIColor {
        UIColor(hex: hex, alpha: alpha)
    }
    
    /// 通过十六进制数值创建颜色
    /// - Parameters:
    ///   - hex: 十六进制数值 (格式: 0xRRGGBB)
    ///   - alpha: 透明度 (默认1.0)
    /// - Returns: 对应的UIColor对象
    public static func color(hex: Int, alpha: CGFloat = 1.0) -> UIColor {
        UIColor(hex: hex, alpha: alpha)
    }
    
    /// 通过RGB分量创建颜色
    /// - Parameters:
    ///   - r: 红色分量 (0-255范围)
    ///   - g: 绿色分量 (0-255范围)
    ///   - b: 蓝色分量 (0-255范围)
    ///   - alpha: 透明度 (默认1.0)
    /// - Returns: 对应的UIColor对象
    public static func color(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat = 1.0) -> UIColor {
        UIColor(r: r, g: g, b: b, alpha: alpha)
    }
    
    // MARK: 实用功能
    
    /// 生成随机颜色
    /// - Returns: RGB分量随机的颜色
    public static func randomColor() -> UIColor {
        UIColor(
            r: CGFloat.random(in: 0...255),
            g: CGFloat.random(in: 0...255),
            b: CGFloat.random(in: 0...255)
        )
    }
    
    /// 计算两个颜色的RGB差值
    /// - Parameters:
    ///   - first: 第一个颜色
    ///   - second: 第二个颜色
    /// - Returns: RGB分量的差值元组 (redDelta, greenDelta, blueDelta)
    /// - Note: 仅支持RGB色彩空间，其他色彩空间返回nil
    public static func getRGBDelta(first: UIColor, second: UIColor) -> (CGFloat, CGFloat, CGFloat)? {
        guard let firstRGB = first.lx.getRGB,
              let secondRGB = second.lx.getRGB else {
            return nil
        }
        return (
            firstRGB.0 - secondRGB.0,
            firstRGB.1 - secondRGB.1,
            firstRGB.2 - secondRGB.2
        )
    }
    
    // MARK: 颜色信息
    
    /// 获取颜色的RGB分量值 (0-255范围)
    /// - Returns: 包含RGB分量的元组 (红, 绿, 蓝)
    /// - Note: 仅支持RGB色彩空间，其他色彩空间返回nil
    public var getRGB: (CGFloat, CGFloat, CGFloat)? {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        
        // 确保颜色在RGB色彩空间且成功获取分量
        guard base.getRed(&red, green: &green, blue: &blue, alpha: nil) else {
            return nil
        }
        
        // 转换到0-255范围
        return (red * 255, green * 255, blue * 255)
    }
}

// MARK: - UIColor 构造方法扩展
extension UIColor {
    
    /// RGB分量初始化 (0-255范围)
    /// - Parameters:
    ///   - r: 红色分量 (0-255)
    ///   - g: 绿色分量 (0-255)
    ///   - b: 蓝色分量 (0-255)
    ///   - alpha: 透明度 (默认1.0)
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat = 1.0) {
        self.init(
            red: r / 255.0,
            green: g / 255.0,
            blue: b / 255.0,
            alpha: alpha
        )
    }
    
    /// 十六进制数值初始化
    /// - Parameters:
    ///   - hex: 十六进制数值 (格式: 0xRRGGBB)
    ///   - alpha: 透明度 (默认1.0)
    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255
        let green = CGFloat((hex & 0x00FF00) >> 8) / 255
        let blue = CGFloat(hex & 0x0000FF) / 255
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    /// 十六进制字符串初始化
    /// - Parameters:
    ///   - hex: 十六进制字符串 (支持格式: "#RGB", "#RRGGBB", "0xRRGGBB")
    ///   - alpha: 透明度 (默认1.0)
    /// - Note: 无效格式会返回透明红色(alpha=0.5)便于调试
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var processedHex = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        // 去除前缀标识
        ["0X", "#", "0x"].forEach { prefix in
            if processedHex.hasPrefix(prefix) {
                processedHex = String(processedHex.dropFirst(prefix.count))
            }
        }
        
        // 验证有效性
        let isValidHex = processedHex.allSatisfy { $0.isHexDigit }
        guard !processedHex.isEmpty, isValidHex else {
            self.init(red: 1, green: 0, blue: 0, alpha: 0.5) // 错误提示色
            return
        }
        
        // 处理短格式 (如"FFF")
        if processedHex.count == 3 {
            processedHex = processedHex.map {
                String(repeating: $0, count: 2)
            }.joined()
        }
        
        // 验证标准长度
        guard processedHex.count == 6 else {
            self.init(red: 1, green: 0, blue: 0, alpha: 0.5) // 错误提示色
            return
        }
        
        // 解析颜色分量
        var rgbValue: UInt64 = 0
        Scanner(string: processedHex).scanHexInt64(&rgbValue)
        
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255,
            blue: CGFloat(rgbValue & 0x0000FF) / 255,
            alpha: alpha
        )
    }
}
