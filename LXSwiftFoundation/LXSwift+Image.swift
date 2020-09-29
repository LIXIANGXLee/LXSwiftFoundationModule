//
//  LXSwift+Image.swift
//  LXSwiftFoundation
//
//  Created by XL on 2020/9/23.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit
import AVFoundation

/// String and NSString compliance
extension UIImage: LXSwiftCompatible { }

//MARK: -  Extending methods for UIImage dark
extension LXSwiftBasics where Base: UIImage {
    
    ///  light or dark is changed
    ///
    /// - Parameters:
    ///   - light: light image
    ///   - dark:  dark image
      public static func image(lightStr: String, darkStr: String) -> UIImage {
       
           let light = UIImage(named: lightStr)
           let dark = UIImage(named: lightStr)

       if light != nil && dark != nil {
               return image(light: light!, dark: dark!)
           }else {
               return light ?? dark ?? UIImage()
           }
      }

      ///  light or dark is changed
      ///
      /// - Parameters:
      ///   - light: light image
      ///   - dark:  dark image
      public static func image(light: UIImage, dark: UIImage) -> UIImage {
           if #available(iOS 13.0, *) {
               guard let config = light.configuration else { return light }
               let lightImage = light.withConfiguration(config.withTraitCollection(UITraitCollection.init(userInterfaceStyle: UIUserInterfaceStyle.light)))
               lightImage.imageAsset?.register(dark, with: config.withTraitCollection(UITraitCollection.init(userInterfaceStyle: UIUserInterfaceStyle.dark)))
               return lightImage.imageAsset?.image(with: UITraitCollection.current) ?? light
           } else {
               return light
           }
       }
}


//MARK: -  Extending methods and properties for UIImage cut
extension LXSwiftBasics where Base: UIImage {
    /// interception roundCorners  with image
    ///
    /// - Parameters:
    ///   - roundCorners: left right top bottom
    ///   - cornerRadi: size
    public func roundImage(by roundCorners: UIRectCorner = .allCorners,cornerRadi: CGFloat) -> UIImage? {
        return roundImage(roundCorners: roundCorners, cornerRadii: CGSize(width: cornerRadi, height: cornerRadi))
    }
 
    /// interception roundCorners  with image
    ///
    /// - Parameters:
    ///   - roundCorners: left right top bottom
    ///   - cornerRadi: size
    public func roundImage(roundCorners: UIRectCorner = UIRectCorner.allCorners, cornerRadii: CGSize) -> UIImage? {
        
        let imageRect = CGRect(origin: CGPoint.zero, size: base.size)
        UIGraphicsBeginImageContextWithOptions(base.size, false, base.scale)
        defer { UIGraphicsEndImageContext() }
        let context = UIGraphicsGetCurrentContext()
        guard context != nil else { return nil }
        context?.setShouldAntialias(true)
        let bezierPath = UIBezierPath(roundedRect: imageRect,
                                      byRoundingCorners: roundCorners,
                                      cornerRadii: cornerRadii)
        bezierPath.close()
        bezierPath.addClip()
        base.draw(in: imageRect)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    /// division more image
      ///
      /// - Parameters:
      ///   - row:  row count
      ///   - col: col count
     public func imageCut(with row:Int, col:Int) -> [UIImage] {
          
          guard  let imageRef = base.cgImage else {return [UIImage()]}
          var images : [UIImage] = [UIImage]()
          for i in 0..<row {
              for j in 0..<col {
                  guard let subImageRef = imageRef.cropping(to: CGRect(x: CGFloat(j * imageRef.width / col), y: CGFloat(i * imageRef.height / row), width: CGFloat(imageRef.width / col), height: CGFloat(imageRef.height / row))) else {return [UIImage()]}
                  images.append(UIImage(cgImage: subImageRef))
              }
          }
          return images
      }
    
     /// circle image
      public var imageWithCircle: UIImage {
         UIGraphicsBeginImageContextWithOptions(base.size, false, 0.0)
         let circlePath = UIBezierPath(ovalIn: CGRect(origin: CGPoint.zero, size: base.size))
         circlePath.addClip()
         base.draw(at: CGPoint.zero)
         guard let image = UIGraphicsGetImageFromCurrentImageContext() else {return base}
         UIGraphicsEndImageContext()
         return image
    }
    
}

//MARK: -  Extending methods and properties for UIImage init
extension LXSwiftBasics where Base: UIImage {

      /// create image return newImage
      ///
      /// - Parameters:
      ///   - color: color
      ///   - size: size
    public static func image(of color: UIColor, size: CGSize) -> UIImage? {
          UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
          let context = UIGraphicsGetCurrentContext()
          context?.setFillColor(color.cgColor)
          context?.fill(CGRect(origin: CGPoint.zero, size: size))
          guard let img = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
          UIGraphicsEndImageContext()
          return img
      }
      
        
      
      /// video image
      ///
      /// - Parameters:
      ///   - videoUrl: video Url
     public static func image(with videoUrl: URL?) -> UIImage?{
          guard let videoUrl = videoUrl else { return nil }
          
          let asset = AVURLAsset(url: videoUrl, options: nil)
          let generator = AVAssetImageGenerator(asset: asset)
          generator.appliesPreferredTrackTransform = true
          let time = CMTimeMakeWithSeconds(1, preferredTimescale: 600)
          guard let image = try? generator.copyCGImage(at: time, actualTime: nil) else { return nil }
          let shotImage = UIImage(cgImage: image)
          return shotImage;
      }
      
      
      /// add water for image
      ///
      /// - Parameters:
      ///   - bgImage: bg image
      ///   - waterImage: water image
     public static func image(with bgImage: UIImage?, waterImage: UIImage?) -> UIImage?{
          guard let bgImage = bgImage,let waterImage = waterImage else { return nil }
          UIGraphicsBeginImageContextWithOptions(bgImage.size, false, 0.0)
          bgImage.draw(in: CGRect(origin: CGPoint.zero, size: bgImage.size))
          waterImage.draw(in: CGRect(x: 0, y:  bgImage.size.height-waterImage.size.height, width: waterImage.size.width, height: waterImage.size.height),blendMode: .overlay,alpha: 0.5)
          let resultingImage = UIGraphicsGetImageFromCurrentImageContext()
          UIGraphicsEndImageContext()
          return resultingImage
      }
      
      
      
        /// add border for image
        ///
        /// - Parameters:
        ///   - radius: size
        ///   - borderWidth: size
        ///   - borderColor: size
        /// - Returns: border image
        public func setBorder(radius: CGFloat, borderWidth: CGFloat, borderColor: UIColor) -> UIImage {
            return setRound(radius: radius, corners: .allCorners, borderWidth: borderWidth, borderColor: borderColor)
        }
        
        /// Cut image, cut or add border according to radius, corner, border, etc
        ///
        /// - Parameters:
        ///   - radius: size
        ///   - corners:  left right top bottom
        ///   - borderWidth: size
        ///   - borderColor: size
        /// - Returns: new image
        public func setRound(radius: CGFloat,
                       corners: UIRectCorner = .allCorners,
                       borderWidth: CGFloat = 0,
                       borderColor: UIColor = UIColor.white) -> UIImage {
            let rect = CGRect(origin: CGPoint.zero, size: base.size)
            UIGraphicsBeginImageContextWithOptions(rect.size, false, base.scale)
            let context = UIGraphicsGetCurrentContext()
            context?.scaleBy(x: 1, y: -1)
            context?.translateBy(x: 0, y: -rect.size.height)
            
            let minSize = min(base.size.width, base.size.height)
            if borderWidth < minSize / 2 {
                let rectInsert = rect.insetBy(dx: borderWidth, dy: borderWidth)
                let bezierPath = UIBezierPath(roundedRect: rectInsert, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: borderWidth))
                bezierPath.close()
                context?.saveGState()
                bezierPath.addClip()
                context?.addPath(bezierPath.cgPath)
                context?.draw(base.cgImage!, in: rect)
                context?.restoreGState()
            }
            
            //border
            if borderWidth > 0 && borderWidth < minSize / 2 {
                let strokeRect = rect
                let bezierPath = UIBezierPath(roundedRect: strokeRect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: borderWidth))
                bezierPath.close()
                bezierPath.addClip()
                bezierPath.lineWidth = borderWidth
                context?.addPath(bezierPath.cgPath)
                context?.setStrokeColor(borderColor.cgColor)
                context?.strokePath()
            }
            
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            guard let targetImage = image else { return UIImage() }
            return targetImage
        }
        
        
        /// scale return image
        ///
        /// - Parameter scale: (0~1)
        /// - Returns: newimage
        public func zoomTo(scale: CGFloat) -> UIImage {
            let targetSize = CGSize(width: base.size.width * scale, height: base.size.height * scale)
            return zoomTo(size: targetSize)
        }
        
        /// image scale size,  compress
        ///
        /// - Parameter size: curent
        /// - Parameter contentMode: model
        /// - Parameter clipsToBounds:
        /// - Parameter radius: size
        /// - Returns: image
        //    private func zoomTo(size: CGSize, radius: CGFloat = 0.0) -> UIImage {
        public func zoomTo(size: CGSize,
                    mode contentMode: UIView.ContentMode = .scaleAspectFill) -> UIImage {
            let targetRect = CGRect(origin: CGPoint(x: 0, y: 0), size: size)
            UIGraphicsBeginImageContextWithOptions(targetRect.size, true, UIScreen.main.scale)
            let ctx = UIGraphicsGetCurrentContext() //获取上下文
            let bezier = UIBezierPath(roundedRect: targetRect, cornerRadius: 0)
            bezier.addClip()
            ctx?.addPath(bezier.cgPath)
            ctx?.setFillColor(UIColor.white.cgColor)
            ctx?.fillPath()
            base.draw(in: targetRect)
            let currentImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            guard let newImage = currentImage else {
                return base
            }
            return newImage
        }
        
        /// image rotation
        ///
        /// - Parameter orientation: Orientation
        /// - Returns: image
        public func rotation(_ orientation: UIImage.Orientation) -> UIImage {
            guard let cgimage = base.cgImage else {
                return base
            }
            return UIImage(cgImage: cgimage, scale: base.scale, orientation: orientation)
        }
        
        /// Rotate the picture (solve the problem of 90 degree photographing)
        public func fixOrientation() -> UIImage {
            if base.imageOrientation == .up {
                return base
            }
            var transform = CGAffineTransform.identity
            switch base.imageOrientation {
            case .down, .downMirrored:
                transform = transform.translatedBy(x: base.size.width, y: base.size.height)
                transform = transform.rotated(by: .pi)
                break
            case .left, .leftMirrored:
                transform = transform.translatedBy(x: base.size.width, y: 0)
                transform = transform.rotated(by: .pi / 2)
                break
            case .right, .rightMirrored:
                transform = transform.translatedBy(x: 0, y: base.size.height)
                transform = transform.rotated(by: -.pi / 2)
                break
            default:
                break
            }
            switch base.imageOrientation {
            case .upMirrored, .downMirrored:
                transform = transform.translatedBy(x: base.size.width, y: 0)
                transform = transform.scaledBy(x: -1, y: 1)
                break
            case .leftMirrored, .rightMirrored:
                transform = transform.translatedBy(x: base.size.height, y: 0);
                transform = transform.scaledBy(x: -1, y: 1)
                break
            default:
                break
            }
            let ctx = CGContext(data: nil, width: Int(base.size.width), height: Int(base.size.height), bitsPerComponent: base.cgImage!.bitsPerComponent, bytesPerRow: 0, space: base.cgImage!.colorSpace!, bitmapInfo: base.cgImage!.bitmapInfo.rawValue)
            ctx?.concatenate(transform)
            switch base.imageOrientation {
            case .left, .leftMirrored, .right, .rightMirrored:
                ctx?.draw(base.cgImage!, in: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(base.size.height), height: CGFloat(base.size.width)))
                break
            default:
                ctx?.draw(base.cgImage!, in: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(base.size.width), height: CGFloat(base.size.height)))
                break
            }
            let cgimg: CGImage = (ctx?.makeImage())!
            let img = UIImage(cgImage: cgimg)
            return img
        }

        /// How to change color picture into black and white picture
        ///
        /// - Returns: new image
        public func grayImage() -> UIImage? {
            guard let cgImage = base.cgImage else { return nil }
            
            let width = base.size.width
            let height = base.size.height
            let colorSpace = CGColorSpaceCreateDeviceGray()
            let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: CGImageAlphaInfo.none.rawValue)
            context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
            
            guard let targetCGImage = context?.makeImage() else { return nil }
            
            return UIImage(cgImage: targetCGImage)
        }
    
}

//MARK: -  Extending methods and properties for UIImage async
extension LXSwiftBasics where Base: UIImage {
    
    /// async create image return newImage
    ///
    /// - Parameters:
    ///   - color: color
    ///   - size: size
    public static func async_image(of color: UIColor, size: CGSize, complete: @escaping (UIImage?) -> ()) {
            DispatchQueue.global().async{
               let async_image = self.image(of: color, size: size)
               DispatchQueue.main.async(execute: {
                   complete(async_image)
            })
        }
    }
    
     /// async interception roundCorners  with image
     ///
     /// - Parameters:
     ///   - roundCorners: left right top bottom
     ///   - cornerRadi: size
    public func async_roundImage(by roundCorners: UIRectCorner = .allCorners, cornerRadi: CGFloat, complete: @escaping (UIImage?) -> ()) {
          DispatchQueue.global().async{
            let async_image = self.roundImage(roundCorners: roundCorners, cornerRadii: CGSize(width: cornerRadi, height: cornerRadi))
             DispatchQueue.main.async(execute: {
                 complete(async_image)
             })
         }
    }
    
    /// async scale return image
    ///
    /// - Parameter scale: (0~1)
    /// - Returns: newimage
    public func async_zoomTo(by size: CGSize, contentMode: UIView.ContentMode = .scaleAspectFill, complete: @escaping (UIImage?) -> ()) {
          DispatchQueue.global().async{
            let async_image = self.zoomTo(size: size, mode: contentMode)
             DispatchQueue.main.async(execute: {
                 complete(async_image)
             })
         }
    }
    
    /// async circle image
    public func async_imageWithCircle(complete: @escaping (UIImage?) -> ()) {
          DispatchQueue.global().async{
            let async_image = self.imageWithCircle
             DispatchQueue.main.async(execute: {
                 complete(async_image)
             })
         }
    }
    

    /// async video image
    ///
    /// - Parameters:
    ///   - videoUrl: video Url
    public static func async_image(with videoUrl: URL?, complete: @escaping (UIImage?) -> ()) {
          DispatchQueue.global().async{
            let async_image = self.image(with: videoUrl)
             DispatchQueue.main.async(execute: {
                 complete(async_image)
             })
         }
    }

}
