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
    
    /// light or dark is changed
    ///
    /// - Parameters:
    /// - light: light image
    /// - dark:  dark image
    public static func image(light: UIImage, dark: UIImage) -> UIImage {
        if #available(iOS 13.0, *) {
            guard let config = light.configuration else {
                return light
            }
            let lightImage = light.withConfiguration(
                config.withTraitCollection(
                    UITraitCollection.init(userInterfaceStyle: UIUserInterfaceStyle.light)))
            lightImage.imageAsset?.register(dark,
                                            with: config.withTraitCollection(
                                                UITraitCollection.init(userInterfaceStyle:
                                                                    UIUserInterfaceStyle.dark)))
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
    
    ///返回图像是否包含alpha分量
    public var isContainsAlphaComponent: Bool {
        let alphaInfo = base.cgImage?.alphaInfo
        return (
                alphaInfo == .first ||
                alphaInfo == .last ||
                alphaInfo == .premultipliedFirst ||
                alphaInfo == .premultipliedLast
        )
    }

    /// Returns whether the image is opaque.
    public var isOpaque: Bool { return !isContainsAlphaComponent }

    
    /// 用图像截取圆角
    ///
    /// - Parameters:
    /// - roundCorners: left right top bottom
    /// - cornerRadi: size
    public func imageByRound(with radius: CGFloat) -> UIImage? {
        return imageByRound(with: radius, corners: UIRectCorner.allCorners)
    }
    
    /// 绘图方法将图片剪切成圆角并添加边框
    ///
    /// - Parameters:
    /// - radius  border radius size
    /// - corners  topleft topright bottomleft bottomright
    /// - borderWidth -- border color
    /// - borderColor -- border color
    /// - borderLineJoin type
    public func imageByRound(with radius: CGFloat,
                                 corners: UIRectCorner,
                                 borderWidth: CGFloat = 0,
                                 borderColor: UIColor = UIColor.white,
                                 borderLineJoin: CGLineJoin = .round) -> UIImage? {

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
            path = UIBezierPath(roundedRect: rect.insetBy(dx: borderWidth,
                                                          dy: borderWidth),
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius,
                                                    height: borderWidth))
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
            let strokePath = UIBezierPath(roundedRect: strokeRect,
                                          byRoundingCorners: corners,
                                          cornerRadii: CGSize(width: strokeRadius,
                                                              height: strokeRadius))
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
    /// - ImageView
    /// - BGView -- screenshot background
    /// - Parameter completed: asynchronous completion callback (main thread callback)
    public func imageShot(byFrame frame: CGRect?) -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(base.size, false, 0.0)
        let path = UIBezierPath(rect: frame!)
        path.addClip()
        base.draw(at: CGPoint.zero)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /// 分割更多图像
    ///
    /// - Parameters:
    /// - row:  row count
    /// - col: col count
    public func imageCut(withRow row:Int, col:Int) -> [UIImage] {
        
        guard let imageRef = base.cgImage else {return [UIImage()]}
        var images: [UIImage] = [UIImage]()
        for i in 0..<row {
            for j in 0..<col {
                guard let subImageRef = imageRef.cropping(to:
                                CGRect(x: CGFloat(j * imageRef.width / col),
                                         y: CGFloat(i * imageRef.height / row),
                                         width: CGFloat(imageRef.width / col),
                                         height: CGFloat(imageRef.height / row))) else {
                    return [UIImage()]
                }
                images.append(UIImage(cgImage: subImageRef))
            }
        }
        return images
    }
}

//MARK: -  Extending methods and properties for UIImage init
extension LXSwiftBasics where Base: UIImage {
    
    /// 创建图像返回newImage
    ///
    /// - Parameters:
    /// - color: color
    /// - size: size
    public static func image(WithColor color: UIColor,
                             size: CGSize = CGSize(width: 10, height: 10)) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(CGRect(origin: CGPoint.zero, size: size))
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
    
    /// 图像滤波处理
    /// - Image -- transfer picture
    /// - filter -- input filter
    public func imageFilter(withFilterName filterName: String) -> UIImage? {
        let inputImage = CIImage(image: base)
        let filter = CIFilter(name: filterName)
        filter?.setValue(inputImage, forKey: kCIInputImageKey)
        let outputImage = filter?.outputImage!
        let context: CIContext = CIContext(options: nil)
        let cgImage = context.createCGImage(outputImage!,
                                            from: (outputImage?.extent)!)
        let newImage = UIImage(cgImage: cgImage!)
        return newImage
    }
    
    /// 用手势擦除图片
    /// - ImageView
    /// - BGView -- screenshot background
    /// - Parameter completed: asynchronous completion callback (main thread callback)
    public static func clearImage(withView view: UIView?, rect: CGRect) -> UIImage? {
        guard let v = view else { return nil }
        UIGraphicsBeginImageContextWithOptions(v.bounds.size, false, 0.0)
        let imageCtx = UIGraphicsGetCurrentContext()
        view?.layer.render(in: imageCtx!)
        imageCtx!.clear(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /// 为图像添加水
    ///
    /// - Parameters:
    /// - images: bg image
    /// - imageRect: [imageRect]
    public func imageCompose(withImages images:[UIImage], imageRect: [CGRect]) -> UIImage? {
        let imageRef = base.cgImage
        let w: CGFloat = CGFloat((imageRef?.width)!)
        let h: CGFloat = CGFloat((imageRef?.height)!)
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
    ///
    /// - Parameters:
    /// - videoUrl: video Url
    public static func image(withVideoUrl videoUrl: URL?) -> UIImage? {
        guard let videoUrl = videoUrl else { return nil }
        
        let asset = AVURLAsset(url: videoUrl, options: nil)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        let time = CMTimeMakeWithSeconds(1, preferredTimescale: 600)
        guard let image = try? generator.copyCGImage(at: time,
                                                     actualTime: nil) else {
            return nil
        }
        let shotImage = UIImage(cgImage: image)
        return shotImage;
    }
        
    /// 缩放返回图像
    ///
    /// - Parameter scale: (0~1)
    /// - Returns: newimage
    public func zoomTo(scale: CGFloat) -> UIImage {
        let targetSize = CGSize(width: base.size.width * scale,
                                height: base.size.height * scale)
        return zoomTo(size: targetSize)
    }
    
    /// 图像缩放大小，压缩
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
    ///
    /// - Parameter orientation: Orientation
    /// - Returns: image
    public func rotation(_ orientation: UIImage.Orientation) -> UIImage {
        guard let cgimage = base.cgImage else {
            return base
        }
        return UIImage(cgImage: cgimage, scale: base.scale,
                       orientation: orientation)
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
        let ctx = CGContext(data: nil, width: Int(base.size.width),
                            height: Int(base.size.height),
                            bitsPerComponent: base.cgImage!.bitsPerComponent,
                            bytesPerRow: 0, space: base.cgImage!.colorSpace!,
                            bitmapInfo: base.cgImage!.bitmapInfo.rawValue)
        ctx?.concatenate(transform)
        switch base.imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx?.draw(base.cgImage!, in: CGRect(x: CGFloat(0),
                                                y: CGFloat(0),
                                                width: CGFloat(base.size.height),
                                                height: CGFloat(base.size.width)))
            break
        default:
            ctx?.draw(base.cgImage!, in: CGRect(x: CGFloat(0),
                                                y: CGFloat(0),
                                                width: CGFloat(base.size.width),
                                                height: CGFloat(base.size.height)))
            break
        }
        let cgimg: CGImage = (ctx?.makeImage())!
        let img = UIImage(cgImage: cgimg)
        return img
    }
    
    /// 如何将彩色图片转换成黑白图片
    ///
    /// - Returns: new image
    public func grayImage() -> UIImage? {
        guard let cgImage = base.cgImage else { return nil }
        
        let width = base.size.width
        let height = base.size.height
        let colorSpace = CGColorSpaceCreateDeviceGray()
        let context = CGContext(data: nil, width: Int(width),
                                height: Int(height),
                                bitsPerComponent: 8,
                                bytesPerRow: 0,
                                space: colorSpace,
                                bitmapInfo: CGImageAlphaInfo.none.rawValue)
        context?.draw(cgImage, in: CGRect(x: 0,
                                          y: 0,
                                          width: width,
                                          height: height))
        guard let targetCGImage = context?.makeImage() else {
            return nil
        }
        return UIImage(cgImage: targetCGImage)
    }
}

//MARK: -  Extending methods and properties for UIImage async
extension LXSwiftBasics where Base: UIImage {
    
    /// 异步创建映像返回newImage
    ///
    /// - Parameters:
    /// - color: color
    /// - size: size
    public static func async_image(of color: UIColor,
                                   size: CGSize = CGSize(width: 10, height: 10),
                                   complete: @escaping (UIImage?) -> ()) {
        DispatchQueue.global().async{
            let async_image = self.image(WithColor: color, size: size)
            DispatchQueue.main.async(execute: {
                complete(async_image)
            })
        }
    }
        
    ///异步圆图像
    public func async_imageWithCircle(complete: @escaping (UIImage?) -> ()) {
        DispatchQueue.global().async{
            let async_image = self.imageWithCircle
            DispatchQueue.main.async(execute: {
                complete(async_image)
            })
        }
    }
    
    /// 异步绘图方法将图片剪切成圆角并添加边框
    ///
    /// - Parameters:
    /// -radius  border radius size
    /// -corners  topleft topright bottomleft bottomright
    /// -borderWidth -- border color
    /// -borderColor -- border color
    /// -borderLineJoin type
    public func async_imageByRound(with radius: CGFloat,
                                       corners: UIRectCorner,
                                       borderWidth: CGFloat = 0,
                                       borderColor: UIColor = UIColor.white,
                                       borderLineJoin: CGLineJoin = .round,
                                       complete: @escaping (UIImage?) -> ()) {
        DispatchQueue.global().async{
            let async_image = self.imageByRound(with: radius,
                                                    corners: corners,
                                                    borderWidth: borderWidth,
                                                    borderColor: borderColor,
                                                    borderLineJoin: borderLineJoin)
            DispatchQueue.main.async(execute: {
                complete(async_image)
            })
        }
    }
    
    /// 异步视频图像
    ///
    /// - Parameters:
    ///   - videoUrl: video Url
    public static func async_image(with videoUrl: URL?,
                                   complete: @escaping (UIImage?) -> ()) {
        DispatchQueue.global().async{
            let async_image = self.image(withVideoUrl: videoUrl)
            DispatchQueue.main.async(execute: {
                complete(async_image)
            })
        }
    }
    
    /// 图像缩放大小，压缩
    ///
    /// - Parameter size: curent
    /// - Parameter contentMode: model
    /// - Returns: image
    public func async_zoomTo(size: CGSize,
                             contentMode: UIView.ContentMode = .scaleAspectFill,
                             complete: @escaping (UIImage?) -> ()) {
        DispatchQueue.global().async{
            let async_image = self.zoomTo(size: size, mode: contentMode)
            DispatchQueue.main.async(execute: {
                complete(async_image)
            })
        }
    }
    
    ///  异步为图像添加水
    ///
    ///  - Parameters:
    ///  - images: bg image
    ///  - imageRect: [imageRect]
    public func async_imageCompose(with images:[UIImage], imageRect: [CGRect],
                                   complete: @escaping (UIImage?) -> ()) {
        DispatchQueue.global().async{
            let async_image = self.imageCompose(withImages: images, imageRect: imageRect)
            DispatchQueue.main.async(execute: {
                complete(async_image)
            })
        }
    }
    
    /// 分割更多图像
    ///
    /// - Parameters:
    /// - row:  row count
    /// - col: col count
    public func async_imageCut(with row:Int, col:Int,
                               complete: @escaping ([UIImage?]?) -> ()){
        DispatchQueue.global().async{
            let async_images = self.imageCut(withRow: row, col: col)
            DispatchQueue.main.async(execute: {
                complete(async_images)
            })
        }
    }
    
    /// 框架截图（捕捉图片的任何部分）
    /// - Parameters:
    /// - BGView -- screenshot background
    /// - Parameter completed: asynchronous completion callback (main thread callback)
    public func async_imageShot(byFrame frame: CGRect?,
                                complete: @escaping (UIImage?) -> ()){
        DispatchQueue.global().async{
            let async_images = self.imageShot(byFrame: frame)
            DispatchQueue.main.async(execute: {
                complete(async_images)
            })
        }
    }
    
    ///  异步图像滤波处理
    /// - Parameters:
    /// - Image -- transfer picture
    /// - filter -- input filter
    public func async_imageFilter(withFilterName filterName: String,
                                  completed:@escaping (UIImage?) -> ()) -> Void {
        DispatchQueue.global().async{
            let newImage = self.imageFilter(withFilterName: filterName)
            DispatchQueue.main.async(execute: {
                completed(newImage)
            })
        }
    }
    
    /// 用手势异步擦除图片
    /// - Parameters:
    /// -ImageView
    /// -BGView -- screenshot background
    /// -Parameter completed: asynchronous completion callback (main thread callback)
    public static func async_clearImage(withView view: UIView?, rect: CGRect,
                                        complete: @escaping (UIImage?) -> ()) {
        DispatchQueue.global().async{
            let async_image = self.clearImage(withView: view, rect: rect)
            DispatchQueue.main.async(execute: {
                complete(async_image)
            })
        }
    }
}
