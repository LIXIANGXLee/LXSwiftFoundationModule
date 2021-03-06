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
    
    /// Suitable for dark mode and light mode , not layer
    ///
    /// - Parameters:
    /// - lightHex:Color of light mode (hexadecimal)
    /// - darkHex:  Color of dark mode (hexadecimal)
    /// - alpha: alpha
    public static func color(lightHex: String, darkHex: String,
                             alpha: CGFloat = 1.0) -> UIColor {
        let light = UIColor(lightHex, alpha: alpha)
        let dark =  UIColor(darkHex, alpha: alpha)
        return color(lightColor: light, darkColor: dark)
    }
    
    /// Suitable for dark mode and light mode , not layer
    ///
    /// - Parameters:
    /// - lightHex:Color of light mode (hexadecimal)
    /// - darkHex:  Color of dark mode (hexadecimal)
    public static func color(lightColor: UIColor, darkColor: UIColor) -> UIColor {
        if #available(iOS 13.0, *) {
            return UIColor { (traitCollection) -> UIColor in
                if traitCollection.userInterfaceStyle == .dark {
                    return darkColor
                }else {
                    return lightColor
                }
            }
        } else {
            return lightColor
        }
    }
    
    // MARK: - Constructor (hexadecimal)
    /// hex color (hexadecimal)
    /// alpha
    public static func color(hex: String, alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(hex, alpha: alpha)
    }
    
    public static func color(hex: Int, alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(hex, alpha: alpha)
    }
    
    ///Constructor r g b a
    public static func color(r : CGFloat, g : CGFloat, b : CGFloat,
                             alpha : CGFloat = 1.0)  -> UIColor? {
        return  UIColor(r: r, g: g, b:  b, alpha: alpha)
    }
    
    ///random Color
    public static func randomColor() -> UIColor {
        return UIColor(r: CGFloat(Int.lx.randomInt(lower: 0, upper: 256)),
                       g: CGFloat(Int.lx.randomInt(lower: 0, upper: 256)),
                       b: CGFloat(Int.lx.randomInt(lower: 0, upper: 256)))
    }
    
    /// color difference
    /// firstColor
    /// seccondColor
    public static func getRGBDelta(_ firstColor: UIColor, _ seccondColor: UIColor)
    -> (CGFloat, CGFloat, CGFloat) {
        let firstRGB = firstColor.lx.getRGB()
        let secondRGB = seccondColor.lx.getRGB()
        return (firstRGB.0 - secondRGB.0,
                firstRGB.1 - secondRGB.1,
                firstRGB.2 - secondRGB.2)
    }
    
    ///  r g b 
    public func getRGB() -> (CGFloat, CGFloat, CGFloat) {
        guard let cmps = base.cgColor.components else {
            fatalError("保证普通颜色是RGB方式传入")
        }
        return (cmps[0] * 255, cmps[1] * 255, cmps[2] * 255)
    }
}

//MARK: -  Extending Constructor methods for UIColor
extension UIColor {
    
    /// Constructor r g b a
    convenience init(r : CGFloat, g : CGFloat, b : CGFloat,
                     alpha : CGFloat = 1.0) {
        self.init(red: r / 255.0,
                  green: g / 255.0,
                  blue: b / 255.0, alpha: alpha)
    }
    
    convenience init(_ hex: Int, alpha: CGFloat = 1) {
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255
        let green = CGFloat((hex & 0xFF00) >> 8) / 255
        let blue = CGFloat(hex & 0xFF) / 255
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }

    /// Constructor (hexadecimal)
    /// hex  color (hexadecimal)
    /// alpha
    convenience init(_ hex: String, alpha: CGFloat = 1.0) {
        var cHex: String = hex.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        switch hex {
        case has_prefix("0X"), has_prefix("0x"):
            cHex = cHex.lx.substring(from: 2)
            fallthrough
        case has_prefix("#"):
            cHex = cHex.lx.substring(from: 1)
        default:
            break
        }
        if cHex.count > 6 || cHex.isEmpty {
            self.init(0xFFFFFF)
        }
        var color: UInt32 = 0x0
        Scanner.init(string: cHex).scanHexInt32(&color)
        self.init(Int(color), alpha: alpha)
    }
}
