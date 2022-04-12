//
//  LXSwift+FileManager.swift
//  LXSwiftFoundation
//
//  Created by XL on 2020/9/24.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

private let fileManagerDefault = FileManager.default
extension FileManager: LXSwiftCompatible {
    
    /// 文件类型
    public enum FileType {
        case file
        case directory
    }
    
     /// 移动类型
    public enum MoveFileType {
        case move
        case copy
    }
}

//MARK: -  Extending properties for Date
extension LXSwiftBasics where Base: FileManager {
    
    /// Caches
    public static var cachesURL: URL? { fileManagerDefault.urls(for: .cachesDirectory, in: .userDomainMask).last }
    public static var cachesPath: String? { NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first }
    
    /// Documents
    public static var documentURL: URL? { fileManagerDefault.urls(for: .documentDirectory, in: .userDomainMask).last }
    public static var documentPath: String? { NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first }
    
    /// Library
    public static var libraryURL: URL? { fileManagerDefault.urls(for: .libraryDirectory, in: .userDomainMask).last }
    public static var libraryPath: String? { NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first }
    
    /// 创建文件夹(蓝色的，文件夹和文件是不一样的)
    @discardableResult
    public static func createFolder(atPath path: String, block: ((_ isSuccess: Bool) -> Void)? = nil) -> Bool {
        if !isFileExists(atPath: path) { // 不存在的路径才会创建
            do {
                // withIntermediateDirectories为ture表示路径中间如果有不存在的文件夹都会创建
                try fileManagerDefault.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
                block?(true)
                return true
            } catch _ {
                block?(false)
                return false
            }
        } else {
            block?(true)
            return true
        }
    }
    
    /// 创建文件路径
    @discardableResult
    public static func createFile(atPath path: String, block: ((_ isSuccess: Bool) -> Void)? = nil) -> Bool {
        if !isFileExists(atPath: path) { // 不存在的路径才会创建
            let isSuccess = fileManagerDefault.createFile(atPath: path, contents: nil, attributes: nil)
            block?(isSuccess)
            return isSuccess
        } else {
            block?(false)
            return false
        }
    }
    
    /// 移除文件目录
    @discardableResult
    public static func removefolder(atPath path: String, block: ((_ isSuccess: Bool) -> Void)? = nil) -> Bool {
        if isFileExists(atPath: path) {
            do {
                // 开始移除文件目录
                try fileManagerDefault.removeItem(atPath: path)
                block?(true)
                return true
            } catch _ {
                block?(false)
                return false
            }
        } else {
            block?(true)
            return true
        }
    }
    
    /// 移除文件
    @discardableResult
    public static func removefile(atPath path: String, block: ((_ isSuccess: Bool) -> Void)? = nil) -> Bool {
        if isFileExists(atPath: path) {
            do {
                // 开始移除文件
                try fileManagerDefault.removeItem(atPath: path)
                block?(true)
                return true
            } catch _ {
                block?(false)
                return false
            }
        } else {
            block?(true)
            return true
        }
    }
    
    /// 移动文件路径到另一个文件路径
    public static func moveFile(fromFilePath: String, toFilePath: String,
                                fileType: FileManager.FileType = .file,
                                moveType: FileManager.MoveFileType = .move,
                                isOverwrite: Bool = true, block: ((_ isSuccess: Bool) -> Void)? = nil) {
        // 先判断被拷贝路径是否存在
        if !isFileExists(atPath: fromFilePath) {
            block?(false)
        } else {
            // 判断拷贝后的文件路径的前一个文件路径是否存在，如果不存在就进行创建
            let toFileFolderPath = directory(atPath: toFilePath)
            if !isFileExists(atPath: toFilePath) && fileType == .file ?
                !createFile(atPath: toFilePath) :
                !createFolder(atPath: toFileFolderPath)  {
                block?(false)
            } else {
                if isOverwrite && isFileExists(atPath: toFilePath) {
                    // 如果被移动的件夹或者文件，如果已存在，先删除，否则拷贝不了
                    do {
                        try fileManagerDefault.removeItem(atPath: toFilePath)
                        block?(true)
                    } catch _ { block?(false) }
                }
                
                // 移动文件夹或者文件
                do {
                    if moveType == .move {
                        try fileManagerDefault.moveItem(atPath: fromFilePath, toPath: toFilePath)
                    } else {
                        try fileManagerDefault.copyItem(atPath: fromFilePath, toPath: toFilePath)
                    }
                    block?(true)
                } catch _ { block?(false) }
            }
        }
    }
    
    /// 判断文件是否存在
    public static func isFileExists(atPath path: String) -> Bool { fileManagerDefault.fileExists(atPath: path) }

    /// 获取 (文件夹/文件) 的前一个路径
    public static func directory(atPath path: String) -> String { (path as NSString).deletingLastPathComponent }
    
    /// 根据文件路径获取文件扩展类型
    public static func fileSuffix(atPath path: String) -> String { (path as NSString).pathExtension }
    
    /// 获取所有文件路径
    public static func getAllFiles(atPath folderPath: String) -> [Any]? {
         // 查看文件夹是否存在，如果存在就直接读取，不存在就直接反空
         if isFileExists(atPath: folderPath) {
            return fileManagerDefault.enumerator(atPath: folderPath)?.allObjects
         }
         return nil
     }
    
    /// 获取所有文件名（性能要比getAllFiles差一些）
    static func getAllFileNames(atPath folderPath: String) -> [String]? {
        // 查看文件夹是否存在，如果存在就直接读取，不存在就直接反空
        if (isFileExists(atPath: folderPath)) {
            return fileManagerDefault.subpaths(atPath: folderPath)
        }
        return nil
    }
    
    /// 获取目录下所有文件的全路径
    public static func getAllTotalFiles(atPath folderPath: String) -> [String]? {
        guard let files = getAllFiles(atPath: folderPath) else { return nil }
        return files.map { folderPath + "/"+"\($0)" }
     }
    
    /// 计算单个文件的大小
    public static func fileSize(atPath path: String) -> Double {
        guard let attr = try? fileManagerDefault.attributesOfItem(atPath: path) else { return 0 }
        return Double(attr[FileAttributeKey.size] as? UInt64 ?? 0)
    }
    
    /// 遍历所有子目录，并计算所有文件总大小
    public static func fileFolderSize(atPath folderPath: String) -> Double {
        var fileSize: Double = 0
        guard let files = getAllTotalFiles(atPath: folderPath) else { return fileSize }
        files.forEach { (file) in fileSize += self.fileSize(atPath: file) }
        return fileSize
    }
    
    /// 计算单个文件的大小 显示格式GB、MB、KB、B 返回字符串
    @available(*, deprecated, renamed: "fileSizeToString")
    public static func fileSizeToStr(atPath path: String) -> String { fileSizeToString(atPath: path) }
    
    /// 计算单个文件的大小 显示格式GB、MB、KB、B 返回字符串
    public static func fileSizeToString(atPath path: String) -> String { fileSize(atPath: path).lx.sizeFileToString }

    @available(*, deprecated, renamed: "fileFolderSizeToString")
    public static func fileFolderSizeToStr(atPath path: String) -> String { fileFolderSizeToString(atPath: path) }

    /// 计算目录下所有文件的大小 显示格式GB、MB、KB、B 返回字符串
    public static func fileFolderSizeToString(atPath path: String) -> String { fileFolderSize(atPath: path).lx.sizeFileToString }
}
