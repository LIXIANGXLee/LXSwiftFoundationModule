//
//  Swift+FileManager.swift
//  LXSwiftFoundation
//
//  Created by XL on 2020/9/24.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

extension FileManager {
    /// 文件类型枚举
    public enum FileType {
        case file      // 文件类型
        case directory // 目录类型
    }
    
    /// 文件操作类型枚举
    public enum MoveFileType {
        case move      // 移动操作
        case copy     // 复制操作
    }
}

// MARK: - FileManager 扩展功能
extension SwiftBasics where Base: FileManager {
    // MARK: - 系统目录路径获取
    
    /// 获取缓存目录的URL
    public static var cachesURL: URL? {
        FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).last
    }
    
    /// 获取缓存目录的路径字符串
    public static var cachesPath: String? {
        NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first
    }
    
    /// 获取文档目录的URL
    public static var documentURL: URL? {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
    }
    
    /// 获取文档目录的路径字符串
    public static var documentPath: String? {
        NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
    }
    
    /// 获取Library目录的URL
    public static var libraryURL: URL? {
        FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).last
    }
    
    /// 获取Library目录的路径字符串
    public static var libraryPath: String? {
        NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first
    }
    
    // MARK: - 文件/目录操作
    
    /// 创建目录
    /// - Parameters:
    ///   - path: 目录路径
    ///   - block: 完成回调，返回是否成功
    /// - Returns: 是否创建成功
    @discardableResult
    public static func createFolder(atPath path: String, completionHandler: ((_ isSuccess: Bool) -> Void)? = nil) -> Bool {
        guard !isFileExists(atPath: path) else {
            // 目录已存在，直接返回成功
            completionHandler?(true)
            return true
        }
        
        do {
            // 创建目录，withIntermediateDirectories为true表示自动创建中间目录
            try FileManager.default.createDirectory(
                atPath: path,
                withIntermediateDirectories: true,
                attributes: nil
            )
            completionHandler?(true)
            return true
        } catch {
            SwiftLog.log("创建目录失败: \(error.localizedDescription)")
            completionHandler?(false)
            return false
        }
    }
    
    /// 创建文件
    /// - Parameters:
    ///   - path: 文件路径
    ///   - block: 完成回调，返回是否成功
    /// - Returns: 是否创建成功
    @discardableResult
    public static func createFile(atPath path: String, completionHandler: ((_ isSuccess: Bool) -> Void)? = nil) -> Bool {
        guard !isFileExists(atPath: path) else {
            // 文件已存在，直接返回成功
            completionHandler?(true)
            return true
        }
        
        // 创建空文件
        let isSuccess = FileManager.default.createFile(
            atPath: path,
            contents: nil,
            attributes: nil
        )
        completionHandler?(isSuccess)
        return isSuccess
    }
    
    /// 从Plist文件路径读取字典数据
    /// - Parameter path: plist文件绝对路径
    /// - Returns: 解析后的字典 (失败返回nil)
    ///
    /// 注意: 文件需为有效的Property List格式
    public static func readDictionary(from path: String) -> [String: Any]? {
        // 1. 验证文件存在性
        guard !isFileExists(atPath: path) else {
            // 文件已存在，直接返回成功
           
            return nil
        }
        
        do {
            // 2. 读取文件数据
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            
            // 3. 反序列化Property List
            return try PropertyListSerialization.propertyList(
                from: data,
                options: [],
                format: nil
            ) as? [String: Any]
        } catch {
            // 4. 错误处理
            SwiftLog.log("Plist文件读取失败: \(error.localizedDescription)")
            return nil
        }
    }
    
    /// 删除目录
    /// - Parameters:
    ///   - path: 目录路径
    ///   - block: 完成回调，返回是否成功
    /// - Returns: 是否删除成功
    @discardableResult
    public static func removefolder(atPath path: String, completionHandler: ((_ isSuccess: Bool) -> Void)? = nil) -> Bool {
        guard isFileExists(atPath: path) else {
            // 目录不存在，直接返回成功
            completionHandler?(true)
            return true
        }
        
        do {
            try FileManager.default.removeItem(atPath: path)
            completionHandler?(true)
            return true
        } catch {
            SwiftLog.log("删除目录失败: \(error.localizedDescription)")
            completionHandler?(false)
            return false
        }
    }
    
    /// 删除文件
    /// - Parameters:
    ///   - path: 文件路径
    ///   - block: 完成回调，返回是否成功
    /// - Returns: 是否删除成功
    @discardableResult
    public static func removefile(atPath path: String, completionHandler: ((_ isSuccess: Bool) -> Void)? = nil) -> Bool {
        guard isFileExists(atPath: path) else {
            // 文件不存在，直接返回成功
            completionHandler?(true)
            return true
        }
        
        do {
            try FileManager.default.removeItem(atPath: path)
            completionHandler?(true)
            return true
        } catch {
            SwiftLog.log("删除文件失败: \(error.localizedDescription)")
            completionHandler?(false)
            return false
        }
    }
    
    /// 移动/复制文件或目录
    /// - Parameters:
    ///   - fromFilePath: 源路径
    ///   - toFilePath: 目标路径
    ///   - fileType: 文件类型（文件/目录）
    ///   - moveType: 操作类型（移动/复制）
    ///   - isOverwrite: 是否覆盖已存在的文件
    ///   - block: 完成回调，返回是否成功
    public static func moveFile(
        fromFilePath: String,
        toFilePath: String,
        fileType: FileManager.FileType = .file,
        moveType: FileManager.MoveFileType = .move,
        isOverwrite: Bool = true,
        completionHandler: ((_ isSuccess: Bool) -> Void)? = nil
    ) {
        // 检查源路径是否存在
        guard isFileExists(atPath: fromFilePath) else {
            completionHandler?(false)
            return
        }
        
        // 准备目标路径
        let toFileFolderPath = directory(atPath: toFilePath)
        
        // 创建目标目录（如果需要）
        if !isFileExists(atPath: toFilePath) {
            let createSuccess = fileType == .file ?
                createFile(atPath: toFilePath) :
                createFolder(atPath: toFileFolderPath)
            
            guard createSuccess else {
                completionHandler?(false)
                return
            }
        }
        
        // 处理目标路径已存在的情况
        if isOverwrite && isFileExists(atPath: toFilePath) {
            do {
                try FileManager.default.removeItem(atPath: toFilePath)
            } catch {
                SwiftLog.log("删除已存在文件失败: \(error.localizedDescription)")
                completionHandler?(false)
                return
            }
        }
        
        // 执行移动或复制操作
        do {
            switch moveType {
            case .move:
                try FileManager.default.moveItem(atPath: fromFilePath, toPath: toFilePath)
            case .copy:
                try FileManager.default.copyItem(atPath: fromFilePath, toPath: toFilePath)
            }
            completionHandler?(true)
        } catch {
            SwiftLog.log("文件操作失败: \(error.localizedDescription)")
            completionHandler?(false)
        }
    }
    
    // MARK: - 文件信息查询
    
    /// 检查文件或目录是否存在
    /// - Parameter path: 路径
    /// - Returns: 是否存在
    public static func isFileExists(atPath path: String) -> Bool {
        FileManager.default.fileExists(atPath: path)
    }
    
    /// 获取路径的父目录
    /// - Parameter path: 路径
    /// - Returns: 父目录路径
    public static func directory(atPath path: String) -> String {
        (path as NSString).deletingLastPathComponent
    }
    
    /// 获取文件扩展名
    /// - Parameter path: 文件路径
    /// - Returns: 文件扩展名
    public static func fileSuffix(atPath path: String) -> String {
        (path as NSString).pathExtension
    }
    
    /// 获取目录下所有文件和子目录（递归）
    /// - Parameter folderPath: 目录路径
    /// - Returns: 所有文件和子目录的枚举器内容
    public static func getAllFiles(atPath folderPath: String) -> [Any]? {
        guard isFileExists(atPath: folderPath) else {
            return nil
        }
        return FileManager.default.enumerator(atPath: folderPath)?.allObjects
    }
    
    /// 获取目录下所有文件和子目录的名称（非递归）
    /// - Parameter folderPath: 目录路径
    /// - Returns: 所有文件和子目录的名称
    public static func getAllFileNames(atPath folderPath: String) -> [String]? {
        guard isFileExists(atPath: folderPath) else {
            return nil
        }
        return FileManager.default.subpaths(atPath: folderPath)
    }
    
    /// 获取目录下所有文件和子目录的完整路径（递归）
    /// - Parameter folderPath: 目录路径
    /// - Returns: 所有文件和子目录的完整路径
    public static func getAllTotalFiles(atPath folderPath: String) -> [String]? {
        guard let files = getAllFiles(atPath: folderPath) else {
            return nil
        }
        return files.map { folderPath + "/" + "\($0)" }
    }
    
    // MARK: - 文件大小相关
    
    /// 获取单个文件的大小（字节）
    /// - Parameter path: 文件路径
    /// - Returns: 文件大小（字节）
    public static func fileSize(atPath path: String) -> Double {
        guard let attr = try? FileManager.default.attributesOfItem(atPath: path) else {
            return 0
        }
        return Double(attr[FileAttributeKey.size] as? UInt64 ?? 0)
    }
    
    /// 计算目录的总大小（递归所有子目录）
    /// - Parameter folderPath: 目录路径
    /// - Returns: 总大小（字节）
    public static func fileFolderSize(atPath folderPath: String) -> Double {
        guard let files = getAllTotalFiles(atPath: folderPath) else {
            return 0
        }
        return files.reduce(0) { $0 + fileSize(atPath: $1) }
    }
    
    /// 获取文件大小并格式化为易读字符串（如 1.2MB）
    /// - Parameter path: 文件路径
    /// - Returns: 格式化后的文件大小字符串
    public static func fileSizeToString(atPath path: String) -> String {
        fileSize(atPath: path).lx.sizeFileToString
    }
    
    /// 获取目录大小并格式化为易读字符串（如 1.2MB）
    /// - Parameter path: 目录路径
    /// - Returns: 格式化后的目录大小字符串
    public static func fileFolderSizeToString(atPath path: String) -> String {
        fileFolderSize(atPath: path).lx.sizeFileToString
    }
    
    // MARK: - 废弃方法（保持兼容性）
    
    @available(*, deprecated, renamed: "fileSizeToString", message: "请使用 fileSizeToString 方法")
    public static func fileSizeToStr(atPath path: String) -> String {
        fileSizeToString(atPath: path)
    }
    
    @available(*, deprecated, renamed: "fileFolderSizeToString", message: "请使用 fileFolderSizeToString 方法")
    public static func fileFolderSizeToStr(atPath path: String) -> String {
        fileFolderSizeToString(atPath: path)
    }
}
