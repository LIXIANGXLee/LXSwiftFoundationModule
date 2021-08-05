//
//  LXSwift+FileManager.swift
//  LXSwiftFoundation
//
//  Created by XL on 2020/9/24.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

extension FileManager: LXSwiftCompatible { }

//MARK: -  Extending properties for Date
extension LXSwiftBasics where Base: FileManager {
    
    /// Caches
    public static var cachesURL: URL? {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).last
    }
    public static var cachesPath: String? {
        return NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first
    }
    
    /// Documents
    public static var documentURL: URL? {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
    }
    public static var documentPath: String? {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
    }
    
    /// Library
    public static var libraryURL: URL? {
        return FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).last
    }
    public static var libraryPath: String? {
        return NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first
    }
    
    /// 计算单个文件的大小
    public static func fileSize(path: String) -> Double {
        var fileSize: Double = 0
        guard let attr = try? FileManager.default.attributesOfItem(atPath: path) else { return fileSize }
        fileSize = Double(attr[FileAttributeKey.size] as? UInt64 ?? 0)
        return fileSize
    }

    /// 遍历所有子目录， 并计算文件大小
    public static func folderSizeAtPath(folderPath: String) -> Double {
        var fileSize: Double = 0
        if !FileManager.default.fileExists(atPath: folderPath) { return fileSize }
        guard let childFilePaths = FileManager.default.subpaths(atPath: folderPath) else { return fileSize }
        for path in childFilePaths {
            let tPath = folderPath+"/"+path
            fileSize += self.fileSize(path: tPath)
        }
        return fileSize
    }
    
}
