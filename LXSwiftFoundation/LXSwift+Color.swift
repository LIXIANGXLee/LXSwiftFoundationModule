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
    
     ///Suitable for dark mode and light mode , not layer
     ///
     /// - Parameters:
     ///   - lightHex:Color of light mode (hexadecimal)
     ///   - darkHex:  Color of dark mode (hexadecimal)
     ///   - alpha: alpha
     public  static func color(lightHex: String,
                         darkHex: String,
                         alpha: CGFloat = 1.0)
           -> UIColor {
           let light = UIColor(lightHex, alpha) ?? UIColor.black
           let dark =  UIColor(darkHex, alpha) ?? UIColor.white
               
           return color(lightColor: light, darkColor: dark)
       }

     ///Suitable for dark mode and light mode , not layer
     ///
     /// - Parameters:
     ///   - lightHex:Color of light mode (hexadecimal)
     ///   - darkHex:  Color of dark mode (hexadecimal)
     public  static func color(lightColor: UIColor,
                        darkColor: UIColor)
          -> UIColor {
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
     ///hex  color (hexadecimal)
     ///alpha
    public static func color(hex: String , _ alpha : CGFloat = 1.0) -> UIColor?{
        return UIColor(hex, alpha)
    }
    
    ///Constructor r g b a
    public static func color(r : CGFloat, g : CGFloat, b : CGFloat,  alpha : CGFloat = 1.0)  -> UIColor?{
        return  UIColor(r: r, g: g, b:  b, alpha: alpha)
    }
    
    
     ///random Color
    public static func randomColor() -> UIColor {
        
        return UIColor(r: CGFloat(Int.lx.randomInt(lower: 0, upper: 256)), g: CGFloat(Int.lx.randomInt(lower: 0, upper: 256)), b: CGFloat(Int.lx.randomInt(lower: 0, upper: 256)))
    }
    
     /// color difference
     /// firstColor
     /// seccondColor
    public static func getRGBDelta(_ firstColor : UIColor, _ seccondColor : UIColor) -> (CGFloat, CGFloat,  CGFloat) {
        let firstRGB = firstColor.lx.getRGB()
        let secondRGB = seccondColor.lx.getRGB()
        return (firstRGB.0 - secondRGB.0, firstRGB.1 - secondRGB.1, firstRGB.2 - secondRGB.2)
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
    
   ///Constructor r g b a
   internal convenience init(r : CGFloat, g : CGFloat, b : CGFloat,   alpha : CGFloat = 1.0) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: alpha)
    }
    
    
    ///Constructor (hexadecimal)
    ///hex  color (hexadecimal)
    ///alpha
    internal convenience init?(_ hex : String, _ alpha : CGFloat = 1.0) {
         var cHex = hex.trimmingCharacters(in: CharacterSet.whitespaces).uppercased()
         guard cHex.count >= 6 else { return nil }
         if cHex.hasPrefix("0X") {
            cHex = cHex.lx.substring(to: 2)
         }
         if cHex.hasPrefix("#") {
            cHex = cHex.lx.substring(to: 1)
         }

         var r : UInt64 = 0
         var g : UInt64  = 0
         var b : UInt64  = 0

         let rHex = cHex.lx.subString(with: 0..<2)
         let gHex = cHex.lx.subString(with: 2..<4)
         let bHex = cHex.lx.subString(with: 4..<6)

         Scanner(string: String(rHex)).scanHexInt64(&r)
         Scanner(string: String(gHex)).scanHexInt64(&g)
         Scanner(string: String(bHex)).scanHexInt64(&b)
        
         self.init(r:CGFloat(r) , g: CGFloat(g), b: CGFloat(b) , alpha: alpha)
     }
}
