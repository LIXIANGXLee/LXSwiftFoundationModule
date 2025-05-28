//
//  Swift+Image.swift
//  LXSwiftFoundation
//
//  Created by XL on 2020/9/23.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit
import AVFoundation

// MARK: - 暗黑模式扩展
extension SwiftBasics where Base: UIImage {
    
    /// 根据亮暗模式创建图像
    /// - Parameters:
    ///   - lightStr: 亮模式图片名称
    ///   - darkStr: 暗模式图片名称
    /// - Returns: 适配当前模式的图片
    public static func image(lightStr: String, darkStr: String) -> UIImage {
        let light = UIImage(named: lightStr)
        let dark = UIImage(named: darkStr) // 修复了之前使用lightStr的bug
        if light != nil && dark != nil {
            return image(light: light!, dark: dark!)
        } else {
            return light ?? dark ?? UIImage()
        }
    }
    
    /// 根据亮暗模式创建图像
    /// - Parameters:
    ///   - light: 亮模式图片
    ///   - dark: 暗模式图片
    /// - Returns: 适配当前模式的图片
    public static func image(light: UIImage, dark: UIImage) -> UIImage {
        if #available(iOS 13.0, *) {
            guard let config = light.configuration else {
                return light
            }
            let lightImage = light.withConfiguration(
                config.withTraitCollection(
                    UITraitCollection(userInterfaceStyle: .light)))
            lightImage.imageAsset?.register(dark, with: config.withTraitCollection(.init(userInterfaceStyle: .dark)))
            return lightImage.imageAsset?.image(with: UITraitCollection.current) ?? light
        }
        return light
    }
}

// MARK: - 图片裁剪扩展
extension SwiftBasics where Base: UIImage {
    
    /// 将图片转换为Base64编码的Data
    public var base64EncodingImage: Data? {
        base.pngData()?.base64EncodedData(options: .lineLength64Characters)
    }
    
    /// 将图片转换为Base64编码的字符串
    public var base64EncodingImageString: String? {
        base.pngData()?.base64EncodedString(options: .lineLength64Characters)
    }
    
    /// 将图片裁剪为圆形
    public var imageWithCircle: UIImage? {
        imageByRound(with: min(base.size.width, base.size.height))
    }
    
    /// 判断图片是否包含alpha通道
    public var isContainsAlphaComponent: Bool {
        guard let alphaInfo = base.cgImage?.alphaInfo else {
            return false
        }
        return (alphaInfo == .first ||
                alphaInfo == .last ||
                alphaInfo == .premultipliedFirst ||
                alphaInfo == .premultipliedLast)
    }

    /// 判断图片是否不透明
    public var isOpaque: Bool {
        !isContainsAlphaComponent
    }
    
    /// 将图片裁剪为圆角
    /// - Parameter radius: 圆角半径
    /// - Returns: 圆角图片
    public func imageByRound(with radius: CGFloat) -> UIImage? {
        imageByRound(with: radius, corners: .allCorners)
    }
    
    /// 将图片裁剪为指定圆角并添加边框
    /// - Parameters:
    ///   - radius: 圆角半径
    ///   - corners: 需要设置圆角的角落
    ///   - borderWidth: 边框宽度
    ///   - borderColor: 边框颜色
    ///   - borderLineJoin: 边框连接样式
    /// - Returns: 处理后的图片
    public func imageByRound(with radius: CGFloat,
                           corners: UIRectCorner,
                           borderWidth: CGFloat = 0,
                           borderColor: UIColor = .white,
                           borderLineJoin: CGLineJoin = .round) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(base.size, false, base.scale)
        guard let context = UIGraphicsGetCurrentContext(),
              let cgImage = base.cgImage else {
            return nil
        }
        
        let rect = CGRect(origin: .zero, size: base.size)
        context.scaleBy(x: 1, y: -1)
        context.translateBy(x: 0, y: -rect.size.height)
        
        let minSize = min(base.size.width, base.size.height)
        var path: UIBezierPath?
        
        if borderWidth < minSize / 2 {
            path = UIBezierPath(roundedRect: rect.insetBy(dx: borderWidth, dy: borderWidth),
                              byRoundingCorners: corners,
                              cornerRadii: CGSize(width: radius, height: borderWidth))
        }
        
        path?.close()
        context.saveGState()
        path?.addClip()
        context.draw(cgImage, in: rect)
        context.restoreGState()
        
        if borderWidth < minSize, borderWidth > 0 {
            let strokeInset = floor(borderWidth * base.scale + 0.5) / base.scale
            let strokeRect = rect.insetBy(dx: strokeInset, dy: strokeInset)
            let strokeRadius = radius > base.scale / 2 ? radius - base.scale / 2 : 0
            let strokePath = UIBezierPath(roundedRect: strokeRect,
                                        byRoundingCorners: corners,
                                        cornerRadii: CGSize(width: strokeRadius, height: strokeRadius))
            strokePath.close()
            strokePath.lineWidth = borderWidth
            strokePath.lineJoinStyle = borderLineJoin
            borderColor.setStroke()
            strokePath.stroke()
        }
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    /// 截取图片的指定区域
    /// - Parameter frame: 要截取的区域
    /// - Returns: 截取后的图片
    public func imageShot(by frame: CGRect?) -> UIImage? {
        guard let rect = frame else { return nil }
        UIGraphicsBeginImageContextWithOptions(base.size, false, 0.0)
        let path = UIBezierPath(rect: rect)
        path.addClip()
        base.draw(at: .zero)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /// 将图片分割为多个小图
    /// - Parameters:
    ///   - row: 行数
    ///   - col: 列数
    /// - Returns: 分割后的小图数组
    public func imageCut(with row: Int, col: Int) -> [UIImage]? {
        guard let imageRef = base.cgImage else { return nil }
        var images = [UIImage]()
        
        for i in 0..<row {
            for j in 0..<col {
                let rect = CGRect(x: CGFloat(j * imageRef.width / col),
                                 y: CGFloat(i * imageRef.height / row),
                                 width: CGFloat(imageRef.width / col),
                                 height: CGFloat(imageRef.height / row))
                guard let subImageRef = imageRef.cropping(to: rect) else {
                    return nil
                }
                images.append(UIImage(cgImage: subImageRef))
            }
        }
        return images
    }
}

// MARK: - 图片初始化扩展
extension SwiftBasics where Base: UIImage {
    
    /// 用颜色创建图片
    /// - Parameters:
    ///   - color: 图片颜色
    ///   - size: 图片大小
    /// - Returns: 生成的图片
    public static func image(with color: UIColor, size: CGSize = CGSize(width: 10, height: 10)) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(CGRect(origin: .zero, size: size))
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
    
    /// 应用滤镜处理图片
    /// - Parameter filterName: 滤镜名称
    /// - Returns: 处理后的图片
    public func imageFilter(with filterName: String) -> UIImage? {
        guard let inputImage = CIImage(image: base),
              let filter = CIFilter(name: filterName) else {
            return nil
        }
        
        filter.setValue(inputImage, forKey: kCIInputImageKey)
        guard let outputImage = filter.outputImage else { return nil }
        
        let context = CIContext(options: nil)
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else {
            return nil
        }
        return UIImage(cgImage: cgImage)
    }
    
    /// 清除视图的指定区域并生成图片
    /// - Parameters:
    ///   - view: 要处理的视图
    ///   - rect: 要清除的区域
    /// - Returns: 处理后的图片
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
    /// - Parameters:
    ///   - images: 要合成的图片数组
    ///   - imageRect: 每张图片的位置和大小数组
    /// - Returns: 合成后的图片
    public func imageCompose(with images: [UIImage], imageRect: [CGRect]) -> UIImage? {
        guard let imageRef = base.cgImage else { return nil }
        
        let w = CGFloat(imageRef.width)
        let h = CGFloat(imageRef.height)
        
        UIGraphicsBeginImageContext(CGSize(width: w, height: h))
        base.draw(in: CGRect(x: 0, y: 0, width: w, height: h))
        
        for i in 0..<images.count {
            images[i].draw(in: imageRect[i])
        }
        
        let resultImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resultImg
    }
    
    /// 从视频URL获取缩略图
    /// - Parameter videoUrl: 视频URL
    /// - Returns: 视频缩略图
    public static func image(with videoUrl: URL?) -> UIImage? {
        guard let videoUrl = videoUrl else { return nil }
        
        let asset = AVURLAsset(url: videoUrl, options: nil)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        
        let time = CMTimeMakeWithSeconds(1, preferredTimescale: 600)
        guard let image = try? generator.copyCGImage(at: time, actualTime: nil) else {
            return nil
        }
        return UIImage(cgImage: image)
    }
    
    /// 按比例缩放图片
    /// - Parameter scale: 缩放比例 (0~1)
    /// - Returns: 缩放后的图片
    public func zoomTo(by scale: CGFloat) -> UIImage {
        zoomTo(by: CGSize(width: base.size.width * scale, height: base.size.height * scale))
    }
    
    /// 按指定大小缩放图片
    /// - Parameters:
    ///   - size: 目标大小
    ///   - contentMode: 内容模式
    /// - Returns: 缩放后的图片
    public func zoomTo(by size: CGSize, mode contentMode: UIView.ContentMode = .scaleAspectFill) -> UIImage {
        let targetRect = CGRect(origin: .zero, size: size)
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
        
        return currentImage ?? base
    }
    
    /// 旋转图片方向
    /// - Parameter orientation: 目标方向
    /// - Returns: 旋转后的图片
    public func rotation(with orientation: UIImage.Orientation) -> UIImage {
        guard let cgimage = base.cgImage else { return base }
        return UIImage(cgImage: cgimage, scale: base.scale, orientation: orientation)
    }
    
    /// 修正图片方向（解决拍照后图片旋转问题）
    public var fixOrientation: UIImage? {
        guard let bgImage = base.cgImage else { return base }
        if base.imageOrientation == .up { return base }
        
        var transform = CGAffineTransform.identity
        
        // 根据当前方向计算变换矩阵
        switch base.imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: base.size.width, y: base.size.height)
            transform = transform.rotated(by: .pi)
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: base.size.width, y: 0)
            transform = transform.rotated(by: .pi / 2)
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: base.size.height)
            transform = transform.rotated(by: -.pi / 2)
        default: break
        }
        
        // 处理镜像情况
        switch base.imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: base.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: base.size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        default: break
        }
        
        guard let space = bgImage.colorSpace else { return nil }
        
        // 创建上下文并应用变换
        let ctx = CGContext(data: nil,
                           width: Int(base.size.width),
                           height: Int(base.size.height),
                           bitsPerComponent: bgImage.bitsPerComponent,
                           bytesPerRow: 0,
                           space: space,
                           bitmapInfo: bgImage.bitmapInfo.rawValue)
        ctx?.concatenate(transform)
        
        // 绘制图片
        switch base.imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx?.draw(bgImage, in: CGRect(x: 0, y: 0,
                                     width: base.size.height,
                                     height: base.size.width))
        default:
            ctx?.draw(bgImage, in: CGRect(x: 0, y: 0,
                                     width: base.size.width,
                                     height: base.size.height))
        }
        
        guard let cgimg = ctx?.makeImage() else { return nil }
        return UIImage(cgImage: cgimg)
    }
    
    /// 将图片转换为灰度图
    public var grayImage: UIImage? {
        guard let cgImage = base.cgImage else { return nil }
        
        let width = base.size.width
        let height = base.size.height
        let colorSpace = CGColorSpaceCreateDeviceGray()
        
        let context = CGContext(data: nil,
                              width: Int(width),
                              height: Int(height),
                              bitsPerComponent: 8,
                              bytesPerRow: 0,
                              space: colorSpace,
                              bitmapInfo: CGImageAlphaInfo.none.rawValue)
        context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        guard let targetCGImage = context?.makeImage() else { return nil }
        return UIImage(cgImage: targetCGImage)
    }
    
    /// 获取图片内存占用大小（单位：字节）
    public var imageCost: Int {
        guard let cgImage = base.cgImage else { return 1 }
        return max(cgImage.height * cgImage.bytesPerRow, 1)
    }
}

// MARK: - 异步操作扩展
extension SwiftBasics where Base: UIImage {
    
    /// 异步创建纯色图片
    public static func async_image(of color: UIColor,
                                  size: CGSize = CGSize(width: 10, height: 10),
                                  complete: @escaping (UIImage?) -> Void) {
        DispatchQueue.global().async {
            let async_image = self.image(with: color, size: size)
            DispatchQueue.main.async {
                complete(async_image)
            }
        }
    }
    
    /// 异步将图片裁剪为圆形
    public func async_imageWithCircle(complete: @escaping (UIImage?) -> Void) {
        DispatchQueue.global().async {
            let async_image = self.imageWithCircle
            DispatchQueue.main.async {
                complete(async_image)
            }
        }
    }
    
    /// 异步将图片裁剪为圆角并添加边框
    public func async_imageByRound(with radius: CGFloat,
                                 corners: UIRectCorner,
                                 borderWidth: CGFloat = 0,
                                 borderColor: UIColor = .white,
                                 borderLineJoin: CGLineJoin = .round,
                                 complete: @escaping (UIImage?) -> Void) {
        DispatchQueue.global().async {
            let async_image = self.imageByRound(with: radius,
                                              corners: corners,
                                              borderWidth: borderWidth,
                                              borderColor: borderColor,
                                              borderLineJoin: borderLineJoin)
            DispatchQueue.main.async {
                complete(async_image)
            }
        }
    }
    
    /// 异步从视频URL获取缩略图
    public static func async_image(with videoUrl: URL?, complete: @escaping (UIImage?) -> Void) {
        DispatchQueue.global().async {
            let async_image = self.image(with: videoUrl)
            DispatchQueue.main.async {
                complete(async_image)
            }
        }
    }
    
    /// 异步缩放图片
    public func async_zoomTo(size: CGSize,
                           contentMode: UIView.ContentMode = .scaleAspectFill,
                           complete: @escaping (UIImage?) -> Void) {
        DispatchQueue.global().async {
            let async_image = self.zoomTo(by: size, mode: contentMode)
            DispatchQueue.main.async {
                complete(async_image)
            }
        }
    }
    
    /// 异步合成图片
    public func async_imageCompose(with images: [UIImage],
                                 imageRect: [CGRect],
                                 complete: @escaping (UIImage?) -> Void) {
        DispatchQueue.global().async {
            let async_image = self.imageCompose(with: images, imageRect: imageRect)
            DispatchQueue.main.async {
                complete(async_image)
            }
        }
    }
    
    /// 异步分割图片
    public func async_imageCut(with row: Int,
                             col: Int,
                             complete: @escaping ([UIImage]?) -> Void) {
        DispatchQueue.global().async {
            let async_images = self.imageCut(with: row, col: col)
            DispatchQueue.main.async {
                complete(async_images)
            }
        }
    }
    
    /// 异步截取图片指定区域
    public func async_imageShot(byFrame frame: CGRect?,
                              complete: @escaping (UIImage?) -> Void) {
        DispatchQueue.global().async {
            let async_images = self.imageShot(by: frame)
            DispatchQueue.main.async {
                complete(async_images)
            }
        }
    }
    
    /// 异步应用滤镜处理图片
    public func async_imageFilter(withFilterName filterName: String,
                                completed: @escaping (UIImage?) -> Void) {
        DispatchQueue.global().async {
            let newImage = self.imageFilter(with: filterName)
            DispatchQueue.main.async {
                completed(newImage)
            }
        }
    }
    
    /// 异步清除视图指定区域并生成图片
    public static func async_clearImage(withView view: UIView?,
                                      rect: CGRect,
                                      complete: @escaping (UIImage?) -> Void) {
        DispatchQueue.global().async {
            let async_image = self.clearImage(with: view, rect: rect)
            DispatchQueue.main.async {
                complete(async_image)
            }
        }
    }
}
