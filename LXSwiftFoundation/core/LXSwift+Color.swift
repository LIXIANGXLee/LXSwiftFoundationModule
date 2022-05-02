//
//  LXSwift+Color.swift
//  LXSwiftFoundation
//
//  Created by Mac on 2020/9/25.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

extension UIColor: LXSwiftCompatible { }

//MARK: -  Extending methods for UIColor
extension LXSwiftBasics where Base: UIColor {
    
    /// 暗黑模式 和 亮模式
    public static func color(lightHex: String, darkHex: String, alpha: CGFloat = 1.0) -> UIColor {
        let light = UIColor(hex: lightHex, alpha: alpha)
        let dark = UIColor(hex: darkHex, alpha: alpha)
        return color(lightColor: light, darkColor: dark)
    }
    
    /// 暗黑模式 和 亮模式
    public static func color(lightColor: UIColor, darkColor: UIColor) -> UIColor {
        if #available(iOS 13.0, *) {
            return UIColor { (traitCollection) -> UIColor in
                if traitCollection.userInterfaceStyle == .dark {
                    return darkColor
                } else { return lightColor }
            }
        } else { return lightColor }
    }
    
    // MARK: - Constructor (hexadecimal)
    /// 根据字符串设置颜色
    public static func color(hex: String, alpha: CGFloat = 1.0) -> UIColor { UIColor(hex: hex, alpha: alpha) }
    
    /// 根据十六进制数设置颜色
    public static func color(hex: Int, alpha: CGFloat = 1.0) -> UIColor { UIColor(hex: hex, alpha: alpha) }
    
    /// 根据R、G、B设置颜色
    public static func color(r : CGFloat, g : CGFloat, b : CGFloat, alpha : CGFloat = 1.0) -> UIColor? { UIColor(r: r, g: g, b:  b, alpha: alpha) }
    
    /// 随机颜色
    public static func randomColor() -> UIColor {
        return UIColor(r: CGFloat(Int.lx.randomInt(lower: 0, upper: 256)),
                       g: CGFloat(Int.lx.randomInt(lower: 0, upper: 256)),
                       b: CGFloat(Int.lx.randomInt(lower: 0, upper: 256)))
    }
    
   /// 获取两个颜色rgb的差值的颜色值
    public static func getRGBDelta(withColor first: UIColor, seccond: UIColor) -> (CGFloat, CGFloat, CGFloat)? {
        guard let firstRGB = first.lx.getRGB, let secondRGB = seccond.lx.getRGB else { return nil }
        return (firstRGB.0 - secondRGB.0, firstRGB.1 - secondRGB.1, firstRGB.2 - secondRGB.2)
    }
    
    /// 获取rgb颜色值 请保证普通颜色是RGB方式传入
    public var getRGB: (CGFloat, CGFloat, CGFloat)? {
        guard let cmps = base.cgColor.components else { return nil }
        return (cmps[0] * 255, cmps[1] * 255, cmps[2] * 255)
    }
}

//MARK: -  Extending Constructor methods for UIColor
extension UIColor {
    
    /// 便利构造函数
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat = 1.0) { self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: alpha) }
    
    convenience init(hex: Int, alpha: CGFloat = 1) {
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255
        let green = CGFloat((hex & 0xFF00) >> 8) / 255
        let blue = CGFloat(hex & 0xFF) / 255
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }

    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var cHex: String = hex.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        switch hex {
        case has_prefix("0X"), has_prefix("0x"):
            cHex = cHex.lx.substring(from: 2)
            fallthrough
        case has_prefix("#"):
            cHex = cHex.lx.substring(from: 1)
        default: break
        }
        if cHex.count > 6 || cHex.isEmpty { self.init(hex: 0xFFFFFF) }
        var color: UInt32 = 0x0
        Scanner.init(string: cHex).scanHexInt32(&color)
        self.init(hex: Int(color), alpha: alpha)
    }
}
