//
//  LXConvenienceBundle.swift
//  LXSwiftFoundation
//
//  Created by Mac on 2020/4/23.
//  Copyright © 2020 李响. All rights reserved.
//


import UIKit

/*
 从bundle中加载图片 文件 资源
 for example:
 fileprivate class LXSwiftConvenienceBundlePath {}
 extension UIImage {
 static let convenienceBundle = LXSwiftConvenienceBundle(bundlePath: Bundle(for: LXSwiftConvenienceBundlePath.self).bundlePath, bundleName: "Login.bundle", path: nil)
 
 static func named(_ imageNamed: String?) -> UIImage? {
 guard let imageNamed = imageNamed else { return nil }
 return convenienceBundle.imageNamed(imageNamed)
 }
 }
 */


//MARK: - bundle @1x @2x @3x image
public struct LXSwiftConvenienceBundle {
    private let path: String?           //bundle name
    private let bundlePath: String     //bundle  path
    private let bundleName: String
    
    public init(bundlePath: String, bundleName: String, path: String? = nil) {
        self.bundlePath = bundlePath
        self.path = path
        self.bundleName = bundleName
    }
    
    /// Load resources according to resource name and resource path
    ///
    /// - imageNamed: The name or path of the image
    /// - path: bundle If specified, the default path is not used
    public func imageNamed(_ imageName: String, path: String? = nil) -> UIImage? {
        var imagePath = "\(bundlePath)/\(bundleName)/"
        if let path = path {
            imagePath = imagePath + "\(path)/"
        } else if let path = self.path, path.count > 0 {
            imagePath = imagePath + "\(path)/"
        }
        imagePath = imagePath + imageName
        return LXSwiftImageBuilder.loadImage(imagePath)
    }
}

fileprivate struct LXSwiftImageBuilder {
    static var x1ImageBuilder: LXSwiftImageAdaptNode = LXSwiftX1ImageBuilder(successor: LXSwiftX2ImageBuilder(successor: LXSwiftX3ImageBuilder()))
    static var x2ImageBuilder: LXSwiftImageAdaptNode = LXSwiftX2ImageBuilder(successor: LXSwiftX3ImageBuilder(successor: LXSwiftX1ImageBuilder()))
    static var x3ImageBuilder: LXSwiftImageAdaptNode = LXSwiftX3ImageBuilder(successor: LXSwiftX2ImageBuilder(successor: LXSwiftX1ImageBuilder()))
    static func loadImage(_ imagePath: String) -> UIImage? {
        let scale = UIScreen.main.scale
        if abs(scale - 3) <= 0.01 {
            return x3ImageBuilder.loadImage(imagePath)
        }else if abs(scale - 2) <= 0.01 {
            return x2ImageBuilder.loadImage(imagePath)
        }else {
            return x1ImageBuilder.loadImage(imagePath)
        }
    }
}

///Declaration of responsibility chain node (responsibility chain design pattern)
fileprivate protocol LXSwiftImageAdaptNode {
    init(successor: LXSwiftImageAdaptNode?)
    func loadImage(_ imagePath: String) -> UIImage?
}

///  x2 image builder
fileprivate struct LXSwiftX2ImageBuilder: LXSwiftImageAdaptNode {
    private var successor: LXSwiftImageAdaptNode?
    init(successor: LXSwiftImageAdaptNode? = nil) {
        self.successor = successor
    }
    
    func loadImage(_ imagePath: String) -> UIImage? {
        
        if let image = UIImage(contentsOfFile: "\(imagePath)@2x.png") {
            return image
        }else{
            return successor?.loadImage(imagePath)
        }
    }
}

/// x3 image builder
fileprivate struct LXSwiftX3ImageBuilder: LXSwiftImageAdaptNode {
    private var successor: LXSwiftImageAdaptNode?
    init(successor: LXSwiftImageAdaptNode? = nil) {
        self.successor = successor
    }
    
    func loadImage(_ imagePath: String) -> UIImage? {
        if let image = UIImage(contentsOfFile: "\(imagePath)@3x.png") {
            return image
        }else{
            return successor?.loadImage(imagePath)
        }
    }
}

/// x1 image builder
fileprivate struct LXSwiftX1ImageBuilder: LXSwiftImageAdaptNode {
    private var successor: LXSwiftImageAdaptNode?
    init(successor: LXSwiftImageAdaptNode? = nil) {
        self.successor = successor
    }
    
    func loadImage(_ imagePath: String) -> UIImage? {
        if let image = UIImage(contentsOfFile: "\(imagePath).png") {
            return image
        }else{
            return successor?.loadImage(imagePath)
        }
    }
}

