//
//  Swift+Font.swift
//  LXSwiftFoundation
//
//  Created by XL on 2020/9/24.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

// MARK: - UIFont 扩展
extension SwiftBasics where Base: UIFont {
    
    /// 创建带有倾斜效果的字体
    /// - Parameters:
    ///   - size: 字体大小
    ///   - name: 字体名称
    ///   - italics: 倾斜角度（默认为10度）
    /// - Returns: 倾斜后的字体
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
    
    // MARK: - 字体特性检查
    
    /// 检查字体是否为粗体
    public var isBold: Bool {
        base.fontDescriptor.symbolicTraits == .traitBold
    }
    
    /// 检查字体是否为斜体
    public var isItalic: Bool {
        base.fontDescriptor.symbolicTraits == .traitItalic
    }
    
    /// 检查字体是否为等宽字体
    public var isMonoSpace: Bool {
        base.fontDescriptor.symbolicTraits == .traitMonoSpace
    }
    
    // MARK: - 字体样式转换
    
    /// 转换为粗体字体（如果可能）
    public var withBold: UIFont {
        guard let desc = base.fontDescriptor.withSymbolicTraits(.traitBold) else {
            return base
        }
        return UIFont(descriptor: desc, size: base.pointSize)
    }
    
    /// 转换为斜体字体（如果可能）
    public var withItalic: UIFont {
        guard let desc = base.fontDescriptor.withSymbolicTraits(.traitItalic) else {
            return base
        }
        return UIFont(descriptor: desc, size: base.pointSize)
    }
    
    /// 转换为粗斜体字体（如果可能）
    public var withBoldItalic: UIFont {
        guard let desc = base.fontDescriptor.withSymbolicTraits([.traitBold, .traitItalic]) else {
            return base
        }
        return UIFont(descriptor: desc, size: base.pointSize)
    }
    
    /// 转换为常规字体（如果可能）
    public var withNormal: UIFont {
        guard let desc = base.fontDescriptor.withSymbolicTraits([]) else {
            return base
        }
        return UIFont(descriptor: desc, size: base.pointSize)
    }
    
    // MARK: - 系统字体快捷方法
    
    /// 中等粗细的系统字体
    public static func font(withMedium size: CGFloat) -> UIFont {
        UIFont.systemFont(ofSize: size, weight: .medium)
    }
    
    /// 常规粗细的系统字体
    public static func font(withRegular size: CGFloat) -> UIFont {
        UIFont.systemFont(ofSize: size, weight: .regular)
    }
    
    /// 粗体系统字体
    public static func font(withBold size: CGFloat) -> UIFont {
        UIFont.systemFont(ofSize: size, weight: .bold)
    }
    
    /// 半粗体系统字体
    public static func font(withSemibold size: CGFloat) -> UIFont {
        UIFont.systemFont(ofSize: size, weight: .semibold)
    }
    
    /// 超粗体系统字体
    public static func font(withHeavy size: CGFloat) -> UIFont {
        UIFont.systemFont(ofSize: size, weight: .heavy)
    }
    
    /// 细体系统字体
    public static func font(withLight size: CGFloat) -> UIFont {
        UIFont.systemFont(ofSize: size, weight: .light)
    }
    
    /// 最粗体系统字体
    public static func font(withBlack size: CGFloat) -> UIFont {
        UIFont.systemFont(ofSize: size, weight: .black)
    }
    
    /// 斜体系统字体（只对数字和字母有效，中文无效）
    public static func font(withItalic size: CGFloat) -> UIFont {
        UIFont.italicSystemFont(ofSize: size)
    }
    
    // MARK: - 特定字体获取方法
    
    /// 获取苹方常规字体（PingFangSC-Regular）
    public static func regular(size: CGFloat) -> UIFont {
        if #available(iOS 9.0, OSX 10.11, *),
           let outFont = UIFont(name: "PingFangSC-Regular", size: size) {
            return outFont
        }
        return UIFont.lx.font(withRegular: size)
    }
    
    /// 获取苹方半粗体字体（PingFangSC-Semibold）
    public static func semibold(size: CGFloat) -> UIFont {
        if #available(iOS 9.0, OSX 10.11, *),
           let outFount = UIFont(name: "PingFangSC-Semibold", size: size) {
            return outFount
        }
        return UIFont.lx.font(withRegular: size)
    }
    
    /// 获取苹方细体字体（PingFangSC-Light）
    public static func light(size: CGFloat) -> UIFont {
        if #available(iOS 9.0, OSX 10.11, *),
           let outFont = UIFont(name: "PingFangSC-Light", size: size) {
            return outFont
        }
        return UIFont.lx.font(withRegular: size)
    }
    
    /// 获取苹方中等粗细字体（PingFangSC-Medium）
    public static func medium(size: CGFloat) -> UIFont {
        if #available(iOS 9.0, OSX 10.11, *),
           let outFount = UIFont(name: "PingFangSC-Medium", size: size) {
            return outFount
        }
        return UIFont.lx.font(withRegular: size)
    }
    
    /// 获取Harmattan常规字体（Harmattan-Regular）
    public static func harmattan(size: CGFloat) -> UIFont {
        if let font = UIFont(name: "Harmattan-Regular", size: size) {
            return font
        }
        return UIFont.lx.font(withRegular: size)
    }
    
    /// 获取WorkSans常规字体（WorkSans-Regular）
    public static func workSans(size: CGFloat) -> UIFont {
        if let font = UIFont(name: "WorkSans-Regular", size: size) {
            return font
        }
        return UIFont.lx.font(withRegular: size)
    }
    
    /// 获取DIN Alternate粗体字体（DINAlternate-Bold）
    public static func dinAlternateBold(size: CGFloat) -> UIFont {
        if let font = UIFont(name: "DINAlternate-Bold", size: size) {
            return font
        }
        return UIFont.lx.font(withRegular: size)
    }
    
    /// 获取系统细体字体（适配不同iOS版本）
    public static func lightSystemFont(size: CGFloat) -> UIFont {
        let version = Double(UIDevice.lx.systemVersion) ?? 0
        let name = version >= 9.0 ? ".SFUIText-Light" : "HelveticaNeue-Light"
        if let outFount = UIFont(name: name, size: size) {
            return outFount
        }
        return UIFont.lx.font(withRegular: size)
    }
}
