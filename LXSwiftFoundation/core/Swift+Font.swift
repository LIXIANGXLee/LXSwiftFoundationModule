//
//  Swift+Font.swift
//  LXSwiftFoundation
//
//  Created by XL on 2020/9/24.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

//MARK: -  Extending properties for UIFont
extension SwiftBasics where Base: UIFont {
   
    /// 获取字体斜体
    ///
    /// - Parameters:
    /// - size: 字体大小
    /// - name: 字体类型
    /// - italics: 斜体成都大小 默认是10
    public static func font(withMatrix size: CGFloat, name: String, italics: CGFloat = 10) -> UIFont {
        let matrix = CGAffineTransform(a: 1,
                                       b: 0,
                                       c: CGFloat(tanf(Float(italics) * Float(Double.pi) / 180)),
                                       d: 1,
                                       tx: 0,
                                       ty: 0)
        let desc = UIFontDescriptor(name: name, matrix: matrix)
        return UIFont(descriptor: desc, size: size)
    }

    /// isBold
    public var isBold: Bool {
        base.fontDescriptor.symbolicTraits == .traitBold
    }
    
    /// isItalic
    public var isItalic: Bool {
        base.fontDescriptor.symbolicTraits == .traitItalic
    }
    
    /// isMonoSpace
    public var isMonoSpace: Bool {
        base.fontDescriptor.symbolicTraits == .traitMonoSpace
    }
    
    /// withBold
    public var withBold: UIFont {
        guard let desc = base.fontDescriptor.withSymbolicTraits(.traitBold) else {
            return base
        }
        return UIFont(descriptor: desc, size: base.pointSize)
    }
    
    /// withItalic
    public var withItalic: UIFont {
        guard let desc = base.fontDescriptor.withSymbolicTraits(.traitItalic) else {
            return base
        }
        return UIFont(descriptor: desc, size: base.pointSize)
    }
    
    /// withBoldItalic
    public var withBoldItalic: UIFont {
        guard let desc = base.fontDescriptor.withSymbolicTraits(
                [.traitBold,.traitItalic]) else {
            return base
        }
        return UIFont(descriptor: desc, size: base.pointSize)
    }
    
    /// withNormal
    public var withNormal: UIFont {
        guard let desc = base.fontDescriptor.withSymbolicTraits([]) else {
            return base
        }
        return UIFont(descriptor: desc, size: base.pointSize)
    }
    
    public static func font(withMedium size: CGFloat) -> UIFont { UIFont.systemFont(ofSize: size, weight: .medium) }
    public static func font(withRegular size: CGFloat) -> UIFont { UIFont.systemFont(ofSize: size, weight: .regular) }
    public static func font(withBold size: CGFloat) -> UIFont { UIFont.systemFont(ofSize: size, weight: .bold) }
    public static func font(withSemibold size: CGFloat) -> UIFont { UIFont.systemFont(ofSize: size, weight: .semibold) }
    public static func font(withHeavy size: CGFloat) -> UIFont { UIFont.systemFont(ofSize: size, weight: .heavy) }
    public static func font(withLight size: CGFloat) -> UIFont { UIFont.systemFont(ofSize: size, weight: .light) }
    public static func font(withBlack size: CGFloat) -> UIFont { UIFont.systemFont(ofSize: size, weight: .black) }
    
    // 斜体只对数字和字母有效，中文无效
    public static func font(withItalic size: CGFloat) -> UIFont {
        UIFont.italicSystemFont(ofSize: size)
    }
    
    public static func regular(size: CGFloat) -> UIFont {
        if #available(iOS 9.0, OSX 10.11, *),
            let outFont = UIFont(name: "PingFangSC-Regular", size: size) {
            return outFont
        }
        return UIFont.lx.font(withRegular: size)
    }
    
    public static func semibold(size: CGFloat) -> UIFont {
        if #available(iOS 9.0, OSX 10.11, *),
            let outFount = UIFont(name: "PingFangSC-Semibold", size: size) {
            return outFount
        }
        return UIFont.lx.font(withRegular: size)
    }
    
    public static func light(size: CGFloat) -> UIFont {
        if #available(iOS 9.0, OSX 10.11, *),
            let outFont = UIFont(name: "PingFangSC-Light", size: size) {
            return outFont
        }
        return UIFont.lx.font(withRegular: size)
    }
    
    public static func medium(size: CGFloat) -> UIFont {
        if #available(iOS 9.0, OSX 10.11, *),
            let outFount = UIFont(name: "PingFangSC-Medium", size: size) {
            return outFount
        }
        return UIFont.lx.font(withRegular: size)
    }
    
    public static func harmattan(size: CGFloat) -> UIFont {
        if let font = UIFont(name: "Harmattan-Regular", size: size) {
            return font
        }
        return UIFont.lx.font(withRegular: size)
    }
    
    public static func workSans(size: CGFloat) -> UIFont {
        if let font = UIFont(name: "WorkSans-Regular", size: size) {
            return font
        }
        return UIFont.lx.font(withRegular: size)
    }
    
    public static func dinAlternateBold(size: CGFloat) -> UIFont {
        if let font = UIFont(name: "DINAlternate-Bold", size: size) {
            return font
        }
        return UIFont.lx.font(withRegular: size)
    }

    /**
     *  返回系统字体的细体
     *
     * @param fontSize 字体大小
     * @return 变细的系统字体的UIFont对象
     */
    public static func lightSystemFont(size: CGFloat) -> UIFont {
        let version = Double(UIDevice.lx.currentSystemVersion) ?? 0
        let name = version >= 9.0 ? ".SFUIText-Light" : "HelveticaNeue-Light"
        if let outFount = UIFont(name: name, size: size) {
            return outFount
        }
        return UIFont.lx.font(withRegular: size)
    }
}

