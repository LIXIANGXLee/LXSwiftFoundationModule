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
@objc(LXObjcConvenienceBundle)
@objcMembers public final class SwiftConvenienceBundle: NSObject {
    private let path: String?
    private let bundlePath: String     // bundle  path
    private let bundleName: String     // bundle name
    
    public init(bundlePath: String, bundleName: String, path: String? = nil) {
        self.bundlePath = bundlePath
        self.path = path
        self.bundleName = bundleName
    }
    
    /// 根据资源名称和资源路径加载资源
    ///
    /// -ImageName：图像的名称或路径
    /// -path:bundle如果指定，则不使用默认路径
    public func imageNamed(_ imageName: String, path: String? = nil) -> UIImage? {
        var imagePath = "\(bundlePath)/\(bundleName)/"
        if let path = path {
            imagePath = imagePath + "\(path)/"
        } else if let path = self.path, path.count > 0 {
            imagePath = imagePath + "\(path)/"
        }
        imagePath = imagePath + imageName
        return SwiftImageBuilder.loadImage(imagePath)
    }
}

fileprivate class SwiftImageBuilder: NSObject {
    static var x1ImageBuilder: SwiftImageAdaptNode = SwiftX1ImageBuilder(successor:
                                SwiftX2ImageBuilder(successor: SwiftX3ImageBuilder()))
    static var x2ImageBuilder: SwiftImageAdaptNode = SwiftX2ImageBuilder(successor:
                                SwiftX3ImageBuilder(successor: SwiftX1ImageBuilder()))
    static var x3ImageBuilder: SwiftImageAdaptNode = SwiftX3ImageBuilder(successor:
                               SwiftX2ImageBuilder(successor: SwiftX1ImageBuilder()))
    static func loadImage(_ imagePath: String) -> UIImage? {
        let scale = UIScreen.main.scale
        if abs(scale - 3) <= 0.01 {
            return x3ImageBuilder.loadImage(imagePath)
        } else if abs(scale - 2) <= 0.01 {
            return x2ImageBuilder.loadImage(imagePath)
        } else {
            return x1ImageBuilder.loadImage(imagePath)
        }
    }
}

/// 责任链节点声明（责任链设计模式）
fileprivate protocol SwiftImageAdaptNode {
    init(successor: SwiftImageAdaptNode?)
    func loadImage(_ imagePath: String) -> UIImage?
}

///  x2 image builder
fileprivate struct SwiftX2ImageBuilder: SwiftImageAdaptNode {
    private var successor: SwiftImageAdaptNode?
    init(successor: SwiftImageAdaptNode? = nil) {
        self.successor = successor
    }
    
    func loadImage(_ imagePath: String) -> UIImage? {
        if let image = UIImage(contentsOfFile: "\(imagePath)@2x.png") {
            return image
        }
        return successor?.loadImage(imagePath)
    }
}

/// x3 image builder
fileprivate struct SwiftX3ImageBuilder: SwiftImageAdaptNode {
    private var successor: SwiftImageAdaptNode?
    init(successor: SwiftImageAdaptNode? = nil) {
        self.successor = successor
    }
    
    func loadImage(_ imagePath: String) -> UIImage? {
        if let image = UIImage(contentsOfFile: "\(imagePath)@3x.png") {
            return image
        }
        return successor?.loadImage(imagePath)
    }
}

/// x1 image builder
fileprivate struct SwiftX1ImageBuilder: SwiftImageAdaptNode {
    private var successor: SwiftImageAdaptNode?
    init(successor: SwiftImageAdaptNode? = nil) {
        self.successor = successor
    }
    
    func loadImage(_ imagePath: String) -> UIImage? {
        if let image = UIImage(contentsOfFile: "\(imagePath).png") {
            return image
        }
        return successor?.loadImage(imagePath)
    }
}

