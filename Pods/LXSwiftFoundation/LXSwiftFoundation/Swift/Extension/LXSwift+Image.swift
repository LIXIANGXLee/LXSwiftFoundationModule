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
    
    /// 暗黑模式 和 亮模式
    public static func image(lightStr: String, darkStr: String) -> UIImage {
        let light = UIImage(named: lightStr)
        let dark = UIImage(named: lightStr)
        if light != nil && dark != nil {
            return image(light: light!, dark: dark!)
        }else {
            return light ?? dark ?? UIImage()
        }
    }
    
    /// 暗黑模式 和 亮模式
    public static func image(light: UIImage, dark: UIImage) -> UIImage {
        if #available(iOS 13.0, *) {
            guard let config = light.configuration else { return light }
            let lightImage = light.withConfiguration(
                config.withTraitCollection(
                    UITraitCollection.init(userInterfaceStyle: UIUserInterfaceStyle.light)))
            lightImage.imageAsset?.register(dark, with: config.withTraitCollection( .init(userInterfaceStyle:.dark)))
            return lightImage.imageAsset?.image(with: UITraitCollection.current) ?? light
        } else {
            return light
        }
    }
}

//MARK: -  Extending methods and properties for UIImage cut
extension LXSwiftBasics where Base: UIImage {
    
    /// uiimage转换base64数据
    public var base64EncodingImage: Data? {
        let base64Data = base.pngData()
        return  base64Data?.base64EncodedData(options: .lineLength64Characters)
    }
    
     /// uiimage转换base64数据
     public var base64EncodingImageString: String? {
         let base64Data = base.pngData()
         return  base64Data?.base64EncodedString(options: .lineLength64Characters)
     }
    
    /// 圆形图像
    public var imageWithCircle: UIImage? {
        return imageByRound(with: min(base.size.width, base.size.height))
    }
    
    /// 返回图像是否包含alpha分量
    public var isContainsAlphaComponent: Bool {
        guard let alphaInfo = base.cgImage?.alphaInfo else { return false }
        return ( alphaInfo == .first ||
                 alphaInfo == .last ||
                 alphaInfo == .premultipliedFirst ||
                 alphaInfo == .premultipliedLast )
    }

    /// Returns whether the image is opaque.
    public var isOpaque: Bool { return !isContainsAlphaComponent }
    
    /// 用图像截取圆角
    public func imageByRound(with radius: CGFloat) -> UIImage? {
        return imageByRound(with: radius, corners: UIRectCorner.allCorners)
    }
    
    /// 绘图方法将图片剪切成圆角并添加边框
    public func imageByRound(with radius: CGFloat, corners: UIRectCorner, borderWidth: CGFloat = 0, borderColor: UIColor = UIColor.white, borderLineJoin: CGLineJoin = .round) -> UIImage? {

        UIGraphicsBeginImageContextWithOptions(base.size, false, base.scale)
        guard let context = UIGraphicsGetCurrentContext(),
              let cgImage = base.cgImage else { return nil }
        let rect = CGRect(x: 0,
                          y: 0,
                          width: base.size.width,
                          height: base.size.height)
        context.scaleBy(x: 1, y: -1);
        context.translateBy(x: 0, y: -rect.size.height);
        let minSize = min(base.size.width, base.size.height)
        
        var path: UIBezierPath? = nil
        if borderWidth < minSize / 2 {
            path = UIBezierPath(roundedRect: rect.insetBy(dx: borderWidth, dy: borderWidth), byRoundingCorners: corners, cornerRadii: CGSize(width: radius,height: borderWidth))
        }
        path?.close()
        context.saveGState()
        path?.addClip()
        context.draw(cgImage, in: rect)
        context.restoreGState()
        
        if  borderWidth < minSize, borderWidth > 0 {
            let strokeInset = floor(borderWidth * base.scale  + 0.5) / base.scale
            let strokeRect = rect.insetBy(dx: strokeInset, dy: strokeInset)
            let strokeRadius = radius > base.scale / 2 ? radius - base.scale / 2 : 0;
            let strokePath = UIBezierPath(roundedRect: strokeRect, byRoundingCorners: corners, cornerRadii: CGSize(width: strokeRadius, height: strokeRadius))
            strokePath.close()
            strokePath.lineWidth = borderWidth
            strokePath.lineJoinStyle = borderLineJoin
            borderColor.setStroke()
            strokePath.stroke()
        }
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        return image
    }
    
    /// 框架截图（捕捉图片的任何部分）
    public func imageShot(by frame: CGRect?) -> UIImage? {
        guard let rect = frame else { return nil }
        UIGraphicsBeginImageContextWithOptions(base.size, false, 0.0)
        let path = UIBezierPath(rect: rect)
        path.addClip()
        base.draw(at: CGPoint.zero)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /// 分割更多图像
    public func imageCut(with row:Int, col:Int) -> [UIImage]? {
        guard let imageRef = base.cgImage else { return nil }
        var images = [UIImage]()
        for i in 0..<row {
            for j in 0..<col {
                let rect = CGRect(x: CGFloat(j * imageRef.width / col),
                                   y: CGFloat(i * imageRef.height / row),
                                   width: CGFloat(imageRef.width / col),
                                   height: CGFloat(imageRef.height / row))
                guard let subImageRef = imageRef.cropping(to: rect) else { return nil }
                images.append(UIImage(cgImage: subImageRef))
            }
        }
        return images
    }
}

//MARK: -  Extending methods and properties for UIImage init
extension LXSwiftBasics where Base: UIImage {
    
    /// 创建图像返回newImage
    public static func image(with color: UIColor, size: CGSize = CGSize(width: 10, height: 10)) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(CGRect(origin: CGPoint.zero, size: size))
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
    
    /// 图像滤波处理
    public func imageFilter(with filterName: String) -> UIImage? {
        let inputImage = CIImage(image: base)
        let filter = CIFilter(name: filterName)
        filter?.setValue(inputImage, forKey: kCIInputImageKey)
        guard let outputImage = filter?.outputImage else { return nil }
        let context: CIContext = CIContext(options: nil)
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return nil }
        let newImage = UIImage(cgImage: cgImage)
        return newImage
    }
    
    /// 用手势擦除图片
    public static func clearImage(with view: UIView?, rect: CGRect) -> UIImage? {
        guard let v = view else { return nil }
        UIGraphicsBeginImageContextWithOptions(v.bounds.size, false, 0.0)
        guard let imageCtx = UIGraphicsGetCurrentContext() else { return nil }
        view?.layer.render(in: imageCtx)
        imageCtx.clear(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /// 图片合成
    public func imageCompose(with images:[UIImage], imageRect: [CGRect]) -> UIImage? {
        guard let imageRef = base.cgImage else { return nil }
        let w = CGFloat(imageRef.width)
        let h = CGFloat(imageRef.height)
        UIGraphicsBeginImageContext(CGSize(width: w, height: h))
        base.draw(in: CGRect(x: 0, y: 0, width: w, height: h))
        for i in 0..<images.count {
            images[i].draw(in: CGRect(x: imageRect[i].origin.x,
                                      y: imageRect[i].origin.y,
                                      width: imageRect[i].size.width,
                                      height:imageRect[i].size.height))
        }
        let resultImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resultImg
    }
    
    /// 视频图像
    public static func image(with videoUrl: URL?) -> UIImage? {
        guard let videoUrl = videoUrl else { return nil }
        
        let asset = AVURLAsset(url: videoUrl, options: nil)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        let time = CMTimeMakeWithSeconds(1, preferredTimescale: 600)
        guard let image = try? generator.copyCGImage(at: time, actualTime: nil) else { return nil }
        let shotImage = UIImage(cgImage: image)
        return shotImage;
    }
        
    /// 缩放返回图像 scale: (0~1)
    public func zoomTo(by scale: CGFloat) -> UIImage {
        let targetSize = CGSize(width: base.size.width * scale, height: base.size.height * scale)
        return zoomTo(by: targetSize)
    }
    
    /// 图像缩放大小，压缩
    public func zoomTo(by size: CGSize, mode contentMode: UIView.ContentMode = .scaleAspectFill) -> UIImage {
        let targetRect = CGRect(origin: CGPoint(x: 0, y: 0), size: size)
        UIGraphicsBeginImageContextWithOptions(targetRect.size, true, UIScreen.main.scale)
        let ctx = UIGraphicsGetCurrentContext()
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
    
    /// 图像旋转
    public func rotation(with orientation: UIImage.Orientation) -> UIImage {
        guard let cgimage = base.cgImage else { return base }
        return UIImage(cgImage: cgimage, scale: base.scale, orientation: orientation)
    }
    
    /// 旋转图片（解决90度摄影问题）
    public var fixOrientation: UIImage? {
        
        guard let bgImage = base.cgImage else { return base }
        if base.imageOrientation == .up { return base }
        
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
        guard let space = bgImage.colorSpace else { return nil }
        let ctx = CGContext(data: nil, width: Int(base.size.width),
                            height: Int(base.size.height),
                            bitsPerComponent: bgImage.bitsPerComponent,
                            bytesPerRow: 0, space: space,
                            bitmapInfo: bgImage.bitmapInfo.rawValue)
        ctx?.concatenate(transform)
        switch base.imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx?.draw(bgImage, in: CGRect(x: CGFloat(0),
                                          y: CGFloat(0),
                                          width: CGFloat(base.size.height),
                                          height: CGFloat(base.size.width)))
            break
        default:
            ctx?.draw(bgImage, in: CGRect(x: CGFloat(0),
                                          y: CGFloat(0),
                                          width: CGFloat(base.size.width),
                                          height: CGFloat(base.size.height)))
            break
        }
        guard let cgimg = ctx?.makeImage() else { return nil }
        let img = UIImage(cgImage: cgimg)
        return img
    }
    
    /// 如何将彩色图片转换成黑白图片
    public var grayImage: UIImage? {
        guard let cgImage = base.cgImage else { return nil }
        
        let width = base.size.width
        let height = base.size.height
        let colorSpace = CGColorSpaceCreateDeviceGray()
        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: CGImageAlphaInfo.none.rawValue)
        context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        guard let targetCGImage = context?.makeImage() else { return nil }
        return UIImage(cgImage: targetCGImage)
    }
    
    /// 获取图片内存大小 单位字节bytes
    public var imageCost: Int {
        guard let cgImage = base.cgImage else { return 1 }
        let cost = cgImage.height * cgImage.bytesPerRow
        return max(cost, 1);
    }
}

//MARK: -  Extending methods and properties for UIImage async
extension LXSwiftBasics where Base: UIImage {
    
    /// 异步创建映像返回newImage
    public static func async_image(of color: UIColor, size: CGSize = CGSize(width: 10, height: 10), complete: @escaping (UIImage?) -> ()) {
        DispatchQueue.global().async {
            let async_image = self.image(with: color, size: size)
            DispatchQueue.main.async(execute: {
                complete(async_image)
            })
        }
    }
        
    /// 异步圆图像
    public func async_imageWithCircle(complete: @escaping (UIImage?) -> ()) {
        DispatchQueue.global().async {
            let async_image = self.imageWithCircle
            DispatchQueue.main.async(execute: {
                complete(async_image)
            })
        }
    }
    
    /// 异步绘图方法将图片剪切成圆角并添加边框
    public func async_imageByRound(with radius: CGFloat, corners: UIRectCorner, borderWidth: CGFloat = 0, borderColor: UIColor = UIColor.white, borderLineJoin: CGLineJoin = .round, complete: @escaping (UIImage?) -> ()) {
        DispatchQueue.global().async {
            let async_image = self.imageByRound(with: radius, corners: corners, borderWidth: borderWidth, borderColor: borderColor, borderLineJoin: borderLineJoin)
            DispatchQueue.main.async(execute: {
                complete(async_image)
            })
        }
    }
    
    /// 异步视频图像
    public static func async_image(with videoUrl: URL?, complete: @escaping (UIImage?) -> ()) {
        DispatchQueue.global().async {
            let async_image = self.image(with: videoUrl)
            DispatchQueue.main.async(execute: {
                complete(async_image)
            })
        }
    }
    
    /// 图像缩放大小，压缩
    public func async_zoomTo(size: CGSize, contentMode: UIView.ContentMode = .scaleAspectFill, complete: @escaping (UIImage?) -> ()) {
        DispatchQueue.global().async { 
            let async_image = self.zoomTo(by: size, mode: contentMode)
            DispatchQueue.main.async(execute: {
                complete(async_image)
            })
        }
    }
    
    ///  异步合成图片
    public func async_imageCompose(with images:[UIImage], imageRect: [CGRect], complete: @escaping (UIImage?) -> ()) {
        DispatchQueue.global().async {
            let async_image = self.imageCompose(with: images, imageRect: imageRect)
            DispatchQueue.main.async(execute: {
                complete(async_image)
            })
        }
    }
    
    /// 分割更多图像
    public func async_imageCut(with row:Int, col:Int, complete: @escaping ([UIImage?]?) -> ()){
        DispatchQueue.global().async {
            let async_images = self.imageCut(with: row, col: col)
            DispatchQueue.main.async(execute: {
                complete(async_images)
            })
        }
    }
    
    /// 框架截图（捕捉图片的任何部分）
    public func async_imageShot(byFrame frame: CGRect?, complete: @escaping (UIImage?) -> ()){
        DispatchQueue.global().async {
            let async_images = self.imageShot(by: frame)
            DispatchQueue.main.async(execute: {
                complete(async_images)
            })
        }
    }
    
    ///  异步图像滤波处理
    public func async_imageFilter(withFilterName filterName: String, completed:@escaping (UIImage?) -> ()) -> Void {
        DispatchQueue.global().async {
            let newImage = self.imageFilter(with: filterName)
            DispatchQueue.main.async(execute: {
                completed(newImage)
            })
        }
    }
    
    /// 用手势异步擦除图片
    public static func async_clearImage(withView view: UIView?, rect: CGRect, complete: @escaping (UIImage?) -> ()) {
        DispatchQueue.global().async {
            let async_image = self.clearImage(with: view, rect: rect)
            DispatchQueue.main.async(execute: {
                complete(async_image)
            })
        }
    }

}
