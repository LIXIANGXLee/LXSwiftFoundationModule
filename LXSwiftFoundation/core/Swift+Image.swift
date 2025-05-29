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
        // 加载亮/暗模式图片
        let light = UIImage(named: lightStr)
        let dark = UIImage(named: darkStr)
        
        // 确保两种模式图片都存在
        if let light = light, let dark = dark {
            return image(light: light, dark: dark)
        } else {
            // 任一模式图片不存在时返回可用图片或空图
            return light ?? dark ?? UIImage()
        }
    }
    
    /// 创建支持亮暗模式的动态图像
    /// - Parameters:
    ///   - light: 亮模式下的图片
    ///   - dark: 暗模式下的图片
    /// - Returns: 根据当前界面风格自动适配的图片
    public static func image(light: UIImage, dark: UIImage) -> UIImage {
        // 1. 系统版本兼容性检查
        guard #available(iOS 13.0, *) else {
            // iOS 13以下系统不支持暗黑模式，直接返回亮色图片
            return light
        }
        
        // 2. 准备基础配置
        // 使用原始图片的配置，若不存在则返回
        guard let baseConfig = light.configuration else {
            return light
        }
        
        // 3. 创建动态图片资源
        let dynamicImage: UIImage
        
        if let existingAsset = light.imageAsset {
            // 3.1 复用原图片资源
            dynamicImage = existingAsset.image(with: .current)
            // 注册暗色模式图片（覆盖重复注册）
            existingAsset.register(dark, with: baseConfig.withTraitCollection(.init(userInterfaceStyle: .dark)))
        } else {
            // 3.2 创建新图片资源
            let newAsset = UIImageAsset()
            
            // 注册亮色模式图片
            let lightConfig = baseConfig.withTraitCollection(.init(userInterfaceStyle: .light))
            newAsset.register(light, with: lightConfig)
            
            // 注册暗色模式图片
            let darkConfig = baseConfig.withTraitCollection(.init(userInterfaceStyle: .dark))
            newAsset.register(dark, with: darkConfig)
            
            // 获取当前模式对应的图片
            dynamicImage = newAsset.image(with: .current)
        }
        
        // 4. 安全返回
        // 理论上不会为空，保持防御式编程
        return dynamicImage
    }
}

// MARK: - 图片裁剪与处理扩展
extension SwiftBasics where Base: UIImage {
    
    // MARK: 基础属性
    
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
        let diameter = min(base.size.width, base.size.height)
        return imageByRound(with: diameter)
    }
    
    /// 判断图片是否包含alpha通道
    public var isContainsAlphaComponent: Bool {
        guard let alphaInfo = base.cgImage?.alphaInfo else { return false }
        return alphaInfo == .first || alphaInfo == .last ||
               alphaInfo == .premultipliedFirst || alphaInfo == .premultipliedLast
    }

    /// 判断图片是否不透明
    public var isOpaque: Bool {
        !isContainsAlphaComponent
    }
    
    /// 获取图片内存占用的近似大小（单位：字节）
    public var imageCost: Int {
        // 1. 安全获取底层CGImage对象
        // 如果UIImage的cgImage属性为nil（如动态图片/系统符号图片），返回最小单位1字节
        guard let cgImage = base.cgImage else {
            return 1
        }
        
        // 2. 计算内存占用核心公式：
        //   - bytesPerRow: 每行像素占用的字节数（包含可能的内存对齐填充）
        //   - height: 图片垂直像素数量
        //   - 内存总量 = 每行字节数 × 行数
        let cost = cgImage.height * cgImage.bytesPerRow
        
        // 3. 返回结果处理：
        //   - 当计算结果<=0时（理论上不应出现），返回保护值1
        //   - 使用max确保返回值至少为1字节，避免后续计算中出现0或负值导致异常
        return max(cost, 1)
    }
    
    // MARK: 裁剪与变形
    
    /// 将图片裁剪为圆角
    /// - Parameter radius: 圆角半径
    /// - Returns: 圆角图片
    public func imageByRound(with radius: CGFloat) -> UIImage? {
        imageByRound(with: radius, corners: .allCorners)
    }
    
    /// 将图片裁剪为指定圆角并添加边框
    /// - Parameters:
    ///   - radius: 圆角半径（当值超过图片尺寸时自动取半宽/高）
    ///   - corners: 需要设置圆角的角落（可组合使用）
    ///   - borderWidth: 边框宽度（默认0，无边框）
    ///   - borderColor: 边框颜色（默认白色）
    ///   - borderLineJoin: 边框连接样式（默认圆角连接）
    /// - Returns: 处理后的图片（失败返回nil）
    public func imageByRound(with radius: CGFloat,
                           corners: UIRectCorner,
                           borderWidth: CGFloat = 0,
                           borderColor: UIColor = .white,
                           borderLineJoin: CGLineJoin = .round) -> UIImage? {
        // 1. 创建与原始图片相同尺寸的绘图上下文
        UIGraphicsBeginImageContextWithOptions(base.size, false, base.scale)
        defer { UIGraphicsEndImageContext() } // 确保结束时释放上下文
        
        // 2. 安全获取上下文和CGImage
        guard let context = UIGraphicsGetCurrentContext(),
              let cgImage = base.cgImage else {
            return nil
        }
        
        let rect = CGRect(origin: .zero, size: base.size)
        let minSize = min(rect.width, rect.height)
        
        // 3. 坐标系转换：UIKit(左上原点) → CoreGraphics(左下原点)
        context.scaleBy(x: 1, y: -1)
        context.translateBy(x: 0, y: -rect.height)
        
        // 4. 计算有效圆角半径（防止超过图片尺寸）
        let effectiveRadius = min(radius, minSize/2)
        
        // 5. 创建裁剪路径（仅在边框宽度小于图片尺寸时创建）
        var clipPath: UIBezierPath?
        if borderWidth < minSize / 2 {
            // 内缩边框宽度，防止边框被裁剪
            let insetRect = rect.insetBy(dx: borderWidth, dy: borderWidth)
            clipPath = UIBezierPath(
                roundedRect: insetRect,
                byRoundingCorners: corners,
                cornerRadii: CGSize(width: effectiveRadius, height: effectiveRadius)
            )
            clipPath?.close()
        }
        
        // 6. 应用裁剪路径并绘制图片
        context.saveGState()
        clipPath?.addClip() // 设置裁剪区域
        context.draw(cgImage, in: rect) // 绘制原始图片
        context.restoreGState()
        
        // 7. 绘制边框（当边框宽度有效时）
        if borderWidth > 0 && borderWidth < minSize {
            // 计算像素对齐的边框内缩值（避免模糊）
            let strokeInset = (borderWidth * base.scale).rounded() / base.scale
            
            // 计算边框矩形和圆角半径
            let strokeRect = rect.insetBy(dx: strokeInset, dy: strokeInset)
            let strokeRadius = max(effectiveRadius - strokeInset, 0)
            
            // 创建边框路径
            let strokePath = UIBezierPath(
                roundedRect: strokeRect,
                byRoundingCorners: corners,
                cornerRadii: CGSize(width: strokeRadius, height: strokeRadius)
            )
            strokePath.close()
            
            // 配置边框样式
            strokePath.lineWidth = borderWidth
            strokePath.lineJoinStyle = borderLineJoin
            borderColor.setStroke()
            
            // 绘制边框
            strokePath.stroke()
        }
        
        // 8. 从当前上下文中获取处理后的图片
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    /// 截取图片的指定区域（自动处理边界越界情况）
    /// - Parameter frame: 要截取的区域（坐标系与原始图片相同）
    /// - Returns: 截取后的子图（可能比请求区域小），当区域无效时返回nil
    public func imageShot(by frame: CGRect?) -> UIImage? {
        // 1. 参数安全检查
        guard var cropRect = frame else { return nil }
        guard !cropRect.isEmpty else { return nil }
        
        // 2. 获取原始图片尺寸和缩放因子
        let originalSize = base.size
        let imageScale = base.scale  // 保留原始图片的缩放因子
        
        // 3. 将裁剪区域转换到像素坐标系（处理Retina屏）
        cropRect.origin.x *= imageScale
        cropRect.origin.y *= imageScale
        cropRect.size.width *= imageScale
        cropRect.size.height *= imageScale
        
        // 4. 安全边界处理：确保裁剪区域在图片范围内
        let drawingRect = cropRect.intersection(CGRect(origin: .zero, size: CGSize(
            width: originalSize.width * imageScale,
            height: originalSize.height * imageScale
        )))
        
        // 5. 检查有效裁剪区域
        guard !drawingRect.isEmpty else { return nil }
        
        // 6. 创建目标尺寸的图形上下文
        UIGraphicsBeginImageContextWithOptions(drawingRect.size, false, imageScale)
        defer { UIGraphicsEndImageContext() }
        
        // 7. 计算绘制偏移量（考虑部分越界情况）
        let drawPoint = CGPoint(
            x: -drawingRect.origin.x,
            y: -drawingRect.origin.y
        )
        
        // 8. 在上下文中绘制原始图片
        base.draw(at: drawPoint)
        
        // 9. 从上下文中获取裁剪后的图片
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    /// 将原始图片分割为指定行列数的小图矩阵
    /// - Parameters:
    ///   - row: 纵向分割的行数（必须大于0）
    ///   - col: 横向分割的列数（必须大于0）
    /// - Returns: 按行优先顺序排列的小图数组（左上→右上，左下→右下），当参数无效或CGImage转换失败时返回nil
    public func imageCut(with row: Int, col: Int) -> [UIImage]? {
        // 基础校验：确保CGImage存在且行列数有效
        guard let cgImage = base.cgImage, row > 0, col > 0 else {
            return nil
        }
        
        // 计算单张小图的尺寸（使用整数除法，舍弃余数部分）
        let tileWidth = cgImage.width / col
        let tileHeight = cgImage.height / row
        
        // 有效性检查：避免创建0尺寸图片
        guard tileWidth > 0 && tileHeight > 0 else {
            return nil
        }
        
        var images = [UIImage]()
        images.reserveCapacity(row * col) // 预分配数组空间提升性能
        
        // 逐行扫描：从顶部到底部
        for y in 0..<row {
            // 逐列扫描：从左到右
            for x in 0..<col {
                // 计算当前小图的裁剪区域（CoreGraphics坐标系原点在左上角）
                let tileRect = CGRect(
                    x: x * tileWidth,
                    y: y * tileHeight,
                    width: tileWidth,
                    height: tileHeight
                )
                
                // 从原始图像中裁剪指定区域
                if let tileCGImage = cgImage.cropping(to: tileRect) {
                    // 将CGImage转换为UIImage并加入结果数组
                    images.append(UIImage(cgImage: tileCGImage))
                } else {
                    // 裁剪失败时返回nil（通常不会发生，除非内存问题）
                    return nil
                }
            }
        }
        return images
    }
    
    /// 按比例缩放图片
    /// - Parameter scale: 缩放比例 (0~1)
    /// - Returns: 缩放后的图片
    public func zoomTo(by scale: CGFloat) -> UIImage {
        let newSize = CGSize(
            width: base.size.width * scale,
            height: base.size.height * scale
        )
        return zoomTo(by: newSize)
    }
    
    /// 按指定大小和内容模式缩放图片
    /// - Parameters:
    ///   - size: 目标尺寸（以点为单位的CGSize）
    ///   - contentMode: 内容显示模式（默认填充模式）
    /// - Returns: 缩放后的新图片（缩放失败时返回原图）
    public func zoomTo(by size: CGSize, mode contentMode: UIView.ContentMode = .scaleAspectFill) -> UIImage {
        // 安全检查：目标尺寸有效性
        guard size.width > 0, size.height > 0 else {
            return base
        }
        
        // 创建目标矩形（原点为(0,0)，尺寸为指定大小）
        let targetRect = CGRect(origin: .zero, size: size)
        
        // 开启图像上下文（参数说明：目标尺寸 / 不透明 / 当前屏幕缩放因子）
        UIGraphicsBeginImageContextWithOptions(size, true, UIScreen.main.scale)
        // 保证退出时关闭图像上下文
        defer { UIGraphicsEndImageContext() }
        
        // 创建白色背景（确保透明区域有底色）
        UIColor.white.setFill()
        UIRectFill(targetRect)
        
        // 计算内容绘制矩形（根据内容模式调整）
        let drawRect: CGRect = {
            // 获取原图尺寸
            let imageSize = base.size
            
            // 内容模式处理逻辑
            switch contentMode {
            case .scaleAspectFit:
                // 保持宽高比：适应目标框（可能有留白）
                let aspectRatio = imageSize.width / imageSize.height
                let targetAspect = size.width / size.height
                
                if targetAspect > aspectRatio {
                    // 目标框更宽：高度撑满，宽度按比例
                    let width = size.height * aspectRatio
                    return CGRect(x: (size.width - width) * 0.5, y: 0,
                                 width: width, height: size.height)
                } else {
                    // 目标框更高：宽度撑满，高度按比例
                    let height = size.width / aspectRatio
                    return CGRect(x: 0, y: (size.height - height) * 0.5,
                                 width: size.width, height: height)
                }
                
            case .scaleAspectFill:
                // 保持宽高比：填充目标框（可能裁剪）
                let aspectRatio = imageSize.width / imageSize.height
                let targetAspect = size.width / size.height
                
                if targetAspect > aspectRatio {
                    // 目标框更宽：宽度撑满，高度按比例（超出部分裁剪）
                    let height = size.width / aspectRatio
                    return CGRect(x: 0, y: (size.height - height) * 0.5,
                                 width: size.width, height: height)
                } else {
                    // 目标框更高：高度撑满，宽度按比例（超出部分裁剪）
                    let width = size.height * aspectRatio
                    return CGRect(x: (size.width - width) * 0.5, y: 0,
                                 width: width, height: size.height)
                }
                
            case .scaleToFill:
                // 拉伸填充整个区域（忽略宽高比）
                return targetRect
                
            case .center:
                // 居中显示（保持原尺寸）
                return CGRect(x: (size.width - imageSize.width) * 0.5,
                              y: (size.height - imageSize.height) * 0.5,
                              width: imageSize.width, height: imageSize.height)
                
            // 其他对齐模式可根据需求扩展...
            default:
                // 默认回退到填充模式
                return targetRect
            }
        }()
        
        // 在计算出的矩形区域绘制图片
        base.draw(in: drawRect)
        
        // 从当前上下文获取新图片（失败时返回原图）
        return UIGraphicsGetImageFromCurrentImageContext() ?? base
    }
    
    /// 调整图片方向（通过修改图像方向元数据，不改变像素数据）
    /// - Parameter orientation: 目标方向枚举值
    /// - Returns: 新方向的图片对象（若方向相同或处理失败返回原图）
    public func rotation(with orientation: UIImage.Orientation) -> UIImage {
        // 1. 方向匹配检查：目标方向与当前方向一致时直接返回原图
        if base.imageOrientation == orientation {
            return base
        }
        
        // 2. 安全获取CGImage对象
        guard let cgImage = base.cgImage else {
            // CGImage获取失败时返回原始图片
            return base
        }
        
        // 3. 创建并返回新方向图片
        // 注意：此操作仅修改图像方向元数据，不进行像素重采样
        // scale参数继承原图缩放比例，保持显示尺寸一致性
        return UIImage(cgImage: cgImage, scale: base.scale, orientation: orientation)
    }
    
    /// 修正图片方向（解决拍照后图片旋转问题）
    public var fixOrientation: UIImage? {
        // 1. 基础检查
        guard let cgImage = base.cgImage else {
            // 无CGImage时返回原图（可能是系统图片或CIImage）
            return base
        }
        guard base.imageOrientation != .up else {
            // 方向已是正向时直接返回原图
            return base
        }
        
        let width = base.size.width
        let height = base.size.height
        var transform = CGAffineTransform.identity  // 初始化单位矩阵
        
        // 2. 计算基础变换（旋转+平移）
        switch base.imageOrientation {
        case .down, .downMirrored:
            /* 向下旋转180°：
             * 1. 平移到右下角 (width, height)
             * 2. 旋转180° (π弧度)
             */
            transform = transform.translatedBy(x: width, y: height)
            transform = transform.rotated(by: .pi)
        case .left, .leftMirrored:
            /* 逆时针旋转90°：
             * 1. 平移到右侧 (width, 0)
             * 2. 逆时针旋转90° (π/2弧度)
             */
            transform = transform.translatedBy(x: width, y: 0)
            transform = transform.rotated(by: .pi / 2)
        case .right, .rightMirrored:
            /* 顺时针旋转90°：
             * 1. 平移到底部 (0, height)
             * 2. 顺时针旋转90° (-π/2弧度)
             */
            transform = transform.translatedBy(x: 0, y: height)
            transform = transform.rotated(by: -.pi / 2)
        case .up, .upMirrored:
            // 正向无需基础旋转
            break
        @unknown default:
            // 处理未来可能新增的未知方向
            return base
        }
        
        // 3. 处理镜像翻转
        switch base.imageOrientation {
        case .upMirrored, .downMirrored:
            /* 水平镜像：
             * 1. 平移到右侧 (width, 0)
             * 2. 水平翻转 (x轴缩放-1)
             */
            transform = transform.translatedBy(x: width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .leftMirrored, .rightMirrored:
            /* 垂直镜像：
             * 1. 平移到下方 (height, 0)
             * 2. 垂直翻转 (y轴缩放-1)
             * 注意：此时坐标系已旋转，height实际代表宽度
             */
            transform = transform.translatedBy(x: height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        default:
            // 无镜像情况
            break
        }
        
        // 4. 动态计算上下文尺寸
        var contextSize: CGSize
        switch base.imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            // 旋转90°后宽高互换
            contextSize = CGSize(width: height, height: width)
        default:
            // 其他情况保持原尺寸
            contextSize = CGSize(width: width, height: height)
        }
        
        // 5. 创建图形上下文
        guard let colorSpace = cgImage.colorSpace,
              let context = CGContext(
                data: nil,
                width: Int(contextSize.width),      // 使用动态计算的宽度
                height: Int(contextSize.height),    // 使用动态计算的高度
                bitsPerComponent: cgImage.bitsPerComponent,
                bytesPerRow: 0,                    // 自动计算行字节数
                space: colorSpace,
                bitmapInfo: cgImage.bitmapInfo.rawValue
              ) else {
            // 上下文创建失败时返回nil
            return nil
        }
        
        // 6. 应用变换矩阵
        context.concatenate(transform)
        
        // 7. 统一绘制到整个上下文区域
        let drawRect: CGRect
        switch base.imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            /* 旋转90°的图像绘制说明：
             * - 使用原图尺寸 (width, height) 作为绘制尺寸
             * - 变换矩阵已处理旋转，这里只需填充原始尺寸
             * - 实际渲染时会自动适配到交换后的上下文尺寸
             */
            drawRect = CGRect(x: 0, y: 0, width: width, height: height)
        default:
            // 非旋转图像直接填充上下文
            drawRect = CGRect(x: 0, y: 0, width: width, height: height)
        }
        
        // 8. 执行绘制操作
        context.draw(cgImage, in: drawRect)
        
        // 9. 生成并返回修正后的图像
        guard let fixedImage = context.makeImage() else {
            // 图像生成失败时返回nil
            return nil
        }
        return UIImage(cgImage: fixedImage)
    }

    /// 将原始图像转换为灰度图
    public var grayImage: UIImage? {
        // 1. 安全获取CGImage对象
        guard let cgImage = base.cgImage else {
            SwiftLog.log("错误：无法获取CGImage")
            return nil
        }
        
        // 2. 获取图像尺寸
        let width = cgImage.width
        let height = cgImage.height
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        
        // 3. 创建灰度色彩空间（设备相关灰度空间）
        guard let colorSpace = CGColorSpace(name: CGColorSpace.linearGray) else {
            SwiftLog.log("错误：无法创建灰度色彩空间")
            return nil
        }
        
        // 4. 创建位图上下文配置
        let bitmapInfo = CGImageAlphaInfo.none.rawValue  // 不需要透明度
        
        // 5. 创建灰度绘图上下文
        guard let context = CGContext(
            data: nil,                      // 由系统自动管理内存
            width: width,                   // 图像宽度(像素)
            height: height,                 // 图像高度(像素)
            bitsPerComponent: 8,            // 每个颜色分量8位 (0-255)
            bytesPerRow: 0,                 // 自动计算每行字节数
            space: colorSpace,              // 灰度色彩空间
            bitmapInfo: bitmapInfo           // 无Alpha通道
        ) else {
            SwiftLog.log("错误：无法创建图形上下文")
            return nil
        }
        
        // 6. 绘制图像到灰度上下文
        context.draw(cgImage, in: rect)
        
        // 7. 从上下文中生成灰度CGImage
        guard let grayCGImage = context.makeImage() else {
            SwiftLog.log("错误：无法生成灰度CGImage")
            return nil
        }
        
        // 8. 创建并返回UIImage对象
        return UIImage(cgImage: grayCGImage)
    }
}

// MARK: - 图片初始化与生成扩展
extension SwiftBasics where Base: UIImage {
    
    /// 生成纯色图片
    /// - Parameters:
    ///   - color: 图片填充颜色
    ///   - size: 图片尺寸（默认 10x10 像素）
    /// - Returns: 生成的纯色UIImage对象，失败时返回nil
    public static func image(with color: UIColor, size: CGSize = CGSize(width: 10, height: 10)) -> UIImage? {
        // 使用UIGraphicsImageRenderer创建图片渲染器
        // 优点：自动管理上下文生命周期，避免内存泄漏，支持Retina缩放
        let renderer = UIGraphicsImageRenderer(size: size)

        // 执行渲染操作
        let image = renderer.image { context in
            // 获取CoreGraphics上下文
            let cgContext = context.cgContext
            
            // 设置填充颜色（将UIColor转换为CGColor）
            cgContext.setFillColor(color.cgColor)
            
            // 创建填充矩形区域（从(0,0)点开始，覆盖整个尺寸）
            let rect = CGRect(origin: .zero, size: size)
            
            // 绘制实心矩形
            cgContext.fill(rect)
        }
        
        return image
    }
    
    /// 应用Core Image滤镜处理图片
    /// - Parameter filterName: 系统支持的CIFilter名称（如："CISepiaTone"）
    /// - Returns: 处理后的UIImage对象，失败时返回nil
    public func imageFilter(with filterName: String) -> UIImage? {
        // 确保原始图像存在且能转换为CIImage对象
        guard let ciImage = CIImage(image: base) else {
            SwiftLog.log("⚠️ 错误：无法从UIImage创建CIImage对象")
            return nil
        }
        
        // 检查滤镜名称是否有效，并创建对应滤镜实例
        guard let filter = CIFilter(name: filterName) else {
            SwiftLog.log("🚫 错误：不支持的滤镜名称 '\(filterName)'")
            return nil
        }
        
        // 设置输入图像（使用Core Image常量kCIInputImageKey）
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        
        // 验证滤镜是否成功生成输出图像
        guard let outputImage = filter.outputImage else {
            SwiftLog.log("❌ 错误：滤镜处理未生成输出图像（滤镜：\(filterName)）")
            return nil
        }
        
        // 创建Core Image上下文（可考虑上下文复用提升性能）
        let context = CIContext(options: [
            .useSoftwareRenderer: false,  // 优先使用GPU硬件加速
            .priorityRequestLow: true     // 低优先级避免阻塞UI
        ])
        
        // 将CIImage转换为CGImage
        guard let cgImage = context.createCGImage(
            outputImage,
            from: outputImage.extent  // 使用原始尺寸范围
        ) else {
            SwiftLog.log("🖼️ 错误：无法生成CGImage（范围：\(outputImage.extent)）")
            return nil
        }
        
        // 保留原始图像的scale和orientation属性
        return UIImage(
            cgImage: cgImage,
            scale: base.scale,
            orientation: base.imageOrientation
        )
    }
    
    /// 清除视图指定区域并生成处理后的图片
    /// - Parameters:
    ///   - view: 待处理的视图对象（可选类型）
    ///   - rect: 需要清除的矩形区域（基于视图坐标系）
    /// - Returns: 处理后的UIImage对象，失败时返回nil
    public static func clearImage(with view: UIView?, rect: CGRect) -> UIImage? {
        // 1. 参数有效性检查
        guard let view = view else {
            SwiftLog.log("⚠️ 视图对象为nil")
            return nil
        }
        
        // 2. 创建图像绘制上下文
        // 参数说明：
        // - size: 使用视图实际尺寸
        // - opaque: 非透明处理（保留Alpha通道）
        // - scale: 0表示自动适配当前设备屏幕缩放
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0.0)
        
        // 3. 使用defer确保结束上下文（避免内存泄漏）
        defer {
            UIGraphicsEndImageContext()
        }
        
        // 4. 获取图形上下文
        guard let context = UIGraphicsGetCurrentContext() else {
            SwiftLog.log("❌ 获取图形上下文失败")
            return nil
        }
        
        // 5. 将视图内容渲染到图形上下文
        // 注意：此操作会捕获当前视图层的视觉状态
        view.layer.render(in: context)
        
        // 6. 执行关键清除操作
        // 原理：将指定区域的像素RGBA值清零（全透明黑色）
        context.clear(rect)
        
        // 7. 从上下文中生成最终图像
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    /// 将多张图片合成到当前图片上
    /// - Parameters:
    ///   - images: 需要叠加的图片数组（按数组顺序叠加）
    ///   - imageRect: 每张图片对应的位置和尺寸数组（坐标基于当前图片坐标系）
    /// - Returns: 合成后的新图片（失败返回nil）
    public func imageCompose(with images: [UIImage], imageRect: [CGRect]) -> UIImage? {
        // 检查基础图片是否存在
        guard !base.size.equalTo(.zero) else {
            SwiftLog.log("⚠️ 基础图片尺寸为0，合成失败")
            return nil
        }
        
        // 当没有叠加图片时直接返回原图
        guard !images.isEmpty else {
            SwiftLog.log("ℹ️ 无叠加图片，返回原始图片")
            return base
        }
        
        // 验证参数有效性
        guard images.count == imageRect.count else {
            SwiftLog.log("⚠️ 图片数量(\(images.count))与矩形数量(\(imageRect.count))不匹配")
            return nil
        }
        
        // 获取基础图片尺寸和缩放比例
        let size = base.size
        let scale = base.scale
        
        // 创建绘图上下文（透明背景）
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer {
            // 确保结束时释放上下文
            UIGraphicsEndImageContext()
        }
        
        // 绘制基础图片
        base.draw(in: CGRect(origin: .zero, size: size))
        
        // 叠加绘制每张图片
        for (index, image) in images.enumerated() {
            let rect = imageRect[index]
            
            // 检查矩形是否有效
            guard rect.isNull == false else {
                SwiftLog.log("⚠️ 跳过无效矩形区域：index=\(index)")
                continue
            }
            
            // 检查矩形是否在画布范围内
            let canvasRect = CGRect(origin: .zero, size: size)
            guard canvasRect.contains(rect) else {
                SwiftLog.log("⚠️ 图片位置超出画布：index=\(index), rect=\(rect)")
                continue
            }
            
            // 高质量绘制（保持原始宽高比）
            image.draw(in: rect, blendMode: .normal, alpha: 1.0)
        }
        
        // 从上下文获取合成后的图片
        guard let composedImage = UIGraphicsGetImageFromCurrentImageContext() else {
            SwiftLog.log("⚠️ 图片合成失败：无法从上下文获取图片")
            return nil
        }
        
        return composedImage
    }
    
    /// 从视频URL获取首帧缩略图
    /// - 优化说明：
    ///   1. 增加时间点容错机制（优先尝试0秒帧）
    ///   2. 添加缩略图尺寸优化
    ///   3. 强化错误处理逻辑
    ///   4. 增加关键日志标记
    /// - Parameter videoUrl: 视频资源URL（支持本地/网络路径）
    /// - Returns: 视频首帧缩略图（失败返回nil）
    public static func image(with videoUrl: URL?) -> UIImage? {
        // 参数安全检查
        guard let url = videoUrl else {
            SwiftLog.log("⚠️ 视频URL为空")
            return nil
        }
        
        // 初始化资源对象（不验证证书，避免网络资源卡顿）
        let asset = AVURLAsset(url: url)
        
        // 创建图像生成器并配置参数
        let generator = AVAssetImageGenerator(asset: asset)
        
        // 自动应用视频方向变换（确保缩略图方向正确）
        generator.appliesPreferredTrackTransform = true
        
        /* 尺寸优化策略：
            - 按原始尺寸的1/4生成（平衡清晰度与内存）
            - 若原始尺寸未知，默认使用720p尺寸
        */
        if let videoTrack = asset.tracks(withMediaType: .video).first {
            let naturalSize = videoTrack.naturalSize
            let targetSize = CGSize(
                width: naturalSize.width / 4,
                height: naturalSize.height / 4
            )
            generator.maximumSize = targetSize
        } else {
            generator.maximumSize = CGSize(width: 1280, height: 720)
        }
        
        // 时间点选择策略（优先尝试0秒，失败后尝试1秒）
        let timePoints = [
            CMTimeMake(value: 0, timescale: 1),  // 首帧
            CMTimeMake(value: 1, timescale: 1)   // 第一秒帧（备选）
        ]
        
        // 尝试多个时间点获取图像
        for time in timePoints {
            do {
                // 精确抓取关键帧（避免解码延迟）
                generator.requestedTimeToleranceBefore = .zero
                generator.requestedTimeToleranceAfter = .zero
                
                // 执行缩略图生成
                let cgImage = try generator.copyCGImage(at: time, actualTime: nil)
                SwiftLog.log("✅ 成功生成缩略图 [时间点: \(time.seconds)s]")
                return UIImage(cgImage: cgImage)
            } catch {
                SwiftLog.log("⚠️ 帧捕获失败 [时间点: \(time.seconds)s]: \(error.localizedDescription)")
            }
        }
        
        SwiftLog.log("❌ 所有时间点捕获均失败")
        return nil
    }
}

// MARK: - 异步操作扩展
extension SwiftBasics where Base: UIImage {
    
    /// 异步创建纯色图片
    public static func async_image(of color: UIColor,
                                  size: CGSize = CGSize(width: 10, height: 10),
                                  complete: @escaping (UIImage?) -> Void) {
        DispatchQueue.lx.asyncOperation {
            self.image(with: color, size: size)
        } completion: { image in
            complete(image)
        }
    }
    
    /// 异步将图片裁剪为圆形
    public func async_imageWithCircle(complete: @escaping (UIImage?) -> Void) {
       
        DispatchQueue.lx.asyncOperation {
            self.imageWithCircle
        } completion: { image in
            complete(image)
        }
    }
}
