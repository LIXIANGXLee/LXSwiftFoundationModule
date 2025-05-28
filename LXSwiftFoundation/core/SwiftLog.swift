//
//  SwiftLog.swift
//  LXSwiftFoundationModule
//
//  Created by xrj on 2025/5/27.
//  Copyright © 2025 李响. All rights reserved.
//

// MARK: - Debug SwiftLog
/// 调试日志工具
public struct SwiftLog {
    /// 调试模式日志输出
    /// - Parameters:
    ///   - message: 日志信息
    ///   - file: 调用文件路径（自动捕获）
    ///   - function: 调用方法（自动捕获）
    ///   - line: 调用行号（自动捕获）
    public static func log(
        _ message: Any,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        #if DEBUG
        let fileName = (file as NSString).lastPathComponent
        print("""
            ******
            [DEBUG] \(fileName) > \(function) line \(line):
            \(message)
            ******
            """)
        #endif
    }
}
