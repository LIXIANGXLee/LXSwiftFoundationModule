//
//  LXSwiftMemory.swift
//  LXSwiftFoundation
//
//  Created by 李响 on 2021/9/18.

import UIKit

private let LXSwift_EMPTY_PTR = UnsafeRawPointer(bitPattern: 0x1)!

public enum LXSwiftMemoryAlign: Int {
    case one   = 1
    case two   = 2
    case four  = 4
    case eight = 8
}

public enum LXSwiftMemoryType: UInt8 {
   case text   = 0xd0     // TEXT段（为常量区）
   case tagPtr = 0xe0     // taggerPointer
   case heap   = 0xf0     // 堆空间
   case unknow = 0xff     // 未知
}

public struct LXSwiftMemory<T> {
    
    /// 获得变量所占用的内存大小
    public static func size(ofVal v: inout T) -> Int { MemoryLayout.size(ofValue: v) > 0 ? MemoryLayout.stride(ofValue: v) : 0 }
    
    /// 获得引用所指向内存的大小
    public static func size(ofRef v: T) -> Int { malloc_size(ptr(ofRef: v)) }
   
    /// 获得变量的内存数据（字节数组格式）
    public static func memoryBytes(ofVal v: inout T) -> [UInt8] { _memoryBytes(ptr(ofVal: &v), size(ofVal: &v)) }
    
    /// 获得引用所指向的内存数据（字节数组格式）
    public static func memoryBytes(ofRef v: T) -> [UInt8] { _memoryBytes(ptr(ofRef: v), size(ofRef: v)) }
    
    /// 获得变量的内存数据（字符串格式）
    /// - Parameter alignment: 决定了多少个字节为一组
    public static func memoryStr(ofVal v: inout T, alignment: LXSwiftMemoryAlign? = nil) -> String {
        let p = ptr(ofVal: &v)
        let s = size(ofVal: &v)
        let a = alignment != nil ? alignment!.rawValue : MemoryLayout.alignment(ofValue: v)
        return _memoryStr(p, s, a)
    }
    
    /// 获得引用所指向的内存数据（字符串格式）
    ///
    /// - Parameter alignment: 决定了多少个字节为一组
    public static func memoryStr(ofRef v: T, alignment: LXSwiftMemoryAlign? = nil) -> String {
        let p = ptr(ofRef: v)
        let s = size(ofRef: v)
        let a = alignment != nil ? alignment!.rawValue : MemoryLayout.alignment(ofValue: v)
        return _memoryStr(p, s, a)
    }
    
    /// 获得变量的内存地址
    public static func ptr(ofVal v: inout T) -> UnsafeRawPointer { MemoryLayout.size(ofValue: v) == 0 ? LXSwift_EMPTY_PTR : withUnsafePointer(to: &v) { UnsafeRawPointer($0) } }
    
    /// 获得引用所指向内存的地址
    public static func ptr(ofRef v: T) -> UnsafeRawPointer {
        if v is Array<Any> || Swift.type(of: v) is AnyClass || v is AnyClass {
            return UnsafeRawPointer(bitPattern: unsafeBitCast(v, to: UInt.self))!
        } else if v is String {
            var mstr = v as! String
            if mstr._type() != .heap { return LXSwift_EMPTY_PTR }
            return UnsafeRawPointer(bitPattern: unsafeBitCast(v, to: (UInt, UInt).self).1)!
        } else {
            return LXSwift_EMPTY_PTR
        }
    }
}

extension LXSwiftMemory {
    fileprivate static func _memoryStr(_ ptr: UnsafeRawPointer, _ size: Int, _ aligment: Int) ->String {
        if ptr == LXSwift_EMPTY_PTR { return "" }
        var rawPtr = ptr
        var string = ""
        let fmt = "0x%0\(aligment << 1)lx"
        let count = size / aligment
        for i in 0..<count {
            if i > 0 {
                string.append(" ")
                rawPtr += aligment
            }
            let value: CVarArg
            switch aligment {
            case LXSwiftMemoryAlign.eight.rawValue:
                value = rawPtr.load(as: UInt64.self)
            case LXSwiftMemoryAlign.four.rawValue:
                value = rawPtr.load(as: UInt32.self)
            case LXSwiftMemoryAlign.two.rawValue:
                value = rawPtr.load(as: UInt16.self)
            default: value = rawPtr.load(as: UInt8.self)
            }
            string.append(String(format: fmt, value))
        }
        return string
    }
    
    fileprivate static func _memoryBytes(_ ptr: UnsafeRawPointer, _ size: Int) -> [UInt8] {
        var arr: [UInt8] = []
        if ptr == LXSwift_EMPTY_PTR { return arr }
        for i in 0..<size { arr.append((ptr + i).load(as: UInt8.self)) }
        return arr
    }
}

extension String {
   fileprivate mutating func _type() -> LXSwiftMemoryType {
        let ptr = LXSwiftMemory.ptr(ofVal: &self)
    
        /// 15 是swift的taggerPointer临界值 7是oc的taggerPointer临界值
        return LXSwiftMemoryType(rawValue: (ptr + 15).load(as: UInt8.self) & 0xf0)
            ?? LXSwiftMemoryType(rawValue: (ptr + 7).load(as: UInt8.self) & 0xf0)
            ?? .unknow
    }
}
