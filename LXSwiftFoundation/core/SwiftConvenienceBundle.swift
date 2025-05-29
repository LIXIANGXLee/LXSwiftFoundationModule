//
//  SwiftConvenienceBundle.swift
//  LXSwiftFoundation
//
//  Created by Mac on 2017/4/23.
//  Copyright © 2017 李响. All rights reserved.
//


import UIKit

/******************oc写法********************/
/*
 
 从bundle中加载图片 文件 资源
 for example:
 @interface LXBundleImage : NSObject
 + (LXBundleImage *)shared;
 - (LXObjcConvenienceBundle *)bundle;
 @end

 @implementation LXBundleImage
 static LXBundleImage *instance;
 + (LXBundleImage *)shared {
 static dispatch_once_t oneToken;
     dispatch_once(&oneToken, ^{
         instance = [[self alloc]init];
     });
     return instance;
 }
 - (LXObjcConvenienceBundle *)bundle {
     NSString *bundlePath = [NSBundle bundleForClass:self.class].bundlePath;
     return [[LXObjcConvenienceBundle alloc] initWithBundlePath:bundlePath bundleName:@"" path:nil];
 }
 @end
 @implementation UIImage (add)
 + (nullable UIImage *)imageName:(NSString *)imageName {
     return [[LXBundleImage shared].bundle imageNamed:imageName path:@""];
 }
 
 /******************swift写法********************/
 
 从bundle中加载图片 文件 资源
 for example:
     fileprivate class SwiftConvenienceBundlePath {}
     extension UIImage {
         static let convenienceBundle = SwiftConvenienceBundle(bundlePath: Bundle(for: LXSwiftConvenienceBundlePath.self).bundlePath, bundleName: "Login.bundle", path: nil)
         
         static func named(_ imageNamed: String?) -> UIImage? {
         guard let imageNamed = imageNamed else { return nil }
         return convenienceBundle.imageNamed(imageNamed)
         }
     }
 */

//MARK: - bundle @1x @2x @3x image
import UIKit

/// 面向Objective-C的便捷Bundle资源加载器
/// - 提供基于路径的图片资源加载能力
/// - 支持多分辨率自动适配（@1x/@2x/@3x）
@objc(LXObjcConvenienceBundle)
@objcMembers public final class SwiftConvenienceBundle: NSObject {
    // MARK: - 属性
    private let defaultSubPath: String?  // 默认子路径（可选）
    private let bundlePath: String       // Bundle根目录路径
    private let bundleName: String       // Bundle名称
    
    // MARK: - 初始化方法
    /// 初始化资源加载器
    /// - Parameters:
    ///   - bundlePath: Bundle所在目录的绝对路径
    ///   - bundleName: Bundle文件名称（不含扩展名）
    ///   - path: 资源默认子路径（可选）
    public init(bundlePath: String, bundleName: String, path: String? = nil) {
        self.bundlePath = bundlePath
        self.bundleName = bundleName
        self.defaultSubPath = path
    }
    
    // MARK: - 图片加载接口
    /// 加载指定名称的图片资源
    /// - Parameters:
    ///   - imageName: 图片基础名称（不含分辨率后缀和扩展名）
    ///   - path: 自定义子路径（可选），覆盖初始化时的默认路径
    /// - Returns: 加载成功的UIImage对象，失败返回nil
    public func imageNamed(_ imageName: String, path: String? = nil) -> UIImage? {
        // 1. 构建基础路径：bundlePath/bundleName/
        var imagePath = "\(bundlePath)/\(bundleName)/"
        
        // 2. 添加子路径（优先使用参数路径，其次使用初始化路径）
        if let customPath = path {
            imagePath.append("\(customPath)/")
        } else if let defaultPath = defaultSubPath, !defaultPath.isEmpty {
            imagePath.append("\(defaultPath)/")
        }
        
        // 3. 拼接图片基础名称
        imagePath.append(imageName)
        
        // 4. 通过图片加载器获取适配当前屏幕的图片
        return SwiftImageBuilder.loadImage(imagePath)
    }
}

// MARK: - 图片加载器（责任链模式实现）
fileprivate class SwiftImageBuilder {
    /// 责任链节点（静态初始化）
    /// 注意：责任链设置为线性结构避免循环引用（3x -> 2x -> 1x）
    private static let imageLoaderChain: SwiftImageAdaptNode = {
        // 创建链式关系：x3处理器 -> x2处理器 -> x1处理器
        let x1Loader = SwiftX1ImageBuilder(successor: nil)
        let x2Loader = SwiftX2ImageBuilder(successor: x1Loader)
        return SwiftX3ImageBuilder(successor: x2Loader)
    }()
    
    /// 根据当前屏幕分辨率选择合适的图片加载链
    static func loadImage(_ baseImagePath: String) -> UIImage? {
        // 根据屏幕分辨率选择加载策略（责任链自动处理多分辨率适配）
        // 注意：实际加载逻辑由责任链统一处理，此处直接调用责任链入口
        return imageLoaderChain.loadImage(baseImagePath)
    }
}

// MARK: - 责任链节点协议
fileprivate protocol SwiftImageAdaptNode {
    /// 初始化方法
    /// - Parameter successor: 责任链中的下一个处理器
    init(successor: SwiftImageAdaptNode?)
    
    /// 图片加载核心方法
    /// - Parameter imagePath: 图片基础路径（不含分辨率后缀和扩展名）
    func loadImage(_ imagePath: String) -> UIImage?
}

// MARK: - @3x图片处理器
fileprivate struct SwiftX3ImageBuilder: SwiftImageAdaptNode {
    private let successor: SwiftImageAdaptNode?
    
    init(successor: SwiftImageAdaptNode? = nil) {
        self.successor = successor
    }
    
    func loadImage(_ imagePath: String) -> UIImage? {
        // 尝试加载@3x分辨率图片
        if let image = UIImage(contentsOfFile: "\(imagePath)@3x.png") {
            return image
        }
        
        // 加载失败则转交下一个处理器
        return successor?.loadImage(imagePath)
    }
}

// MARK: - @2x图片处理器
fileprivate struct SwiftX2ImageBuilder: SwiftImageAdaptNode {
    private let successor: SwiftImageAdaptNode?
    
    init(successor: SwiftImageAdaptNode? = nil) {
        self.successor = successor
    }
    
    func loadImage(_ imagePath: String) -> UIImage? {
        // 尝试加载@2x分辨率图片
        if let image = UIImage(contentsOfFile: "\(imagePath)@2x.png") {
            return image
        }
        
        // 加载失败则转交下一个处理器
        return successor?.loadImage(imagePath)
    }
}

// MARK: - @1x图片处理器（基础分辨率）
fileprivate struct SwiftX1ImageBuilder: SwiftImageAdaptNode {
    private let successor: SwiftImageAdaptNode?
    
    init(successor: SwiftImageAdaptNode? = nil) {
        self.successor = successor
    }
    
    func loadImage(_ imagePath: String) -> UIImage? {
        // 尝试加载基础分辨率图片（无后缀）
        if let image = UIImage(contentsOfFile: "\(imagePath).png") {
            return image
        }
        
        // 作为责任链末端不再向后传递
        return nil
    }
}
