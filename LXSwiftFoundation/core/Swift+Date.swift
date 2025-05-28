//
//  Swift+Date.swift
//  LXSwiftFoundation
//
//  Created by XL on 2020/9/24.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

extension SwiftBasics where Base == Date {
    
    /// 将日期格式化为指定格式的字符串
    /// - Parameter format: 日期格式字符串，默认为 "yyyy-MM-dd HH:mm:ss"
    /// - Returns: 格式化后的日期字符串
    ///
    /// 示例:
    /// ```
    /// let date = Date()
    /// date.lx.dateTranformString()                     // "2023-08-15 14:30:00"
    /// date.lx.dateTranformString(with: "yyyy/MM/dd")   // "2023/08/15"
    /// date.lx.dateTranformString(with: "HH:mm")        // "14:30"
    /// ```
    public func dateTranformString(with format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current  // 使用当前地区设置
        formatter.timeZone = TimeZone.current  // 使用当前时区
        formatter.dateFormat = format
        return formatter.string(from: base)
    }
    
    // MARK: - 辅助方法 (Helper Methods)
    
    /// 比较两个日期的指定组件
    /// - Parameters:
    ///   - date: 要比较的日期
    ///   - unit: 要比较的日历组件
    /// - Returns: 包含两个日期组件的元组
    public func dateCompare(with date: Date, unit: Set<Calendar.Component>) -> (DateComponents, DateComponents) {
        let selfCmps = Calendar.current.dateComponents(unit, from: base)
        let otherCmps = Calendar.current.dateComponents(unit, from: date)
        return (selfCmps, otherCmps)
    }
 
}

// MARK: - 日期扩展 (Date Extension)
extension SwiftBasics where Base == Date {
    
    // MARK: - 时间组件 (Time Components)
    
    /// 获取时间戳（Unix时间戳，1970年至今的秒数）
    public var timeInterval: TimeInterval { base.timeIntervalSince1970 }
    
    /// 年份（如：2023）
    public var year: Int { Calendar.current.component(.year, from: base) }
    
    /// 月份（1-12）
    public var month: Int { Calendar.current.component(.month, from: base) }
    
    /// 日（1-31）
    public var day: Int { Calendar.current.component(.day, from: base) }
    
    /// 小时（0-23）
    public var hour: Int { Calendar.current.component(.hour, from: base) }
    
    /// 分钟（0-59）
    public var minute: Int { Calendar.current.component(.minute, from: base) }
    
    /// 秒（0-59）
    public var second: Int { Calendar.current.component(.second, from: base) }
    
    /// 纳秒
    public var nanosecond: Int { Calendar.current.component(.nanosecond, from: base) }
    
    /// 星期几（1-7，系统相关，通常1=星期日）
    public var weekday: Int { Calendar.current.component(.weekday, from: base) }
    
    /// 月中的第几周（1-5）
    public var weekOfMonth: Int { Calendar.current.component(.weekOfMonth, from: base) }
    
    /// 年中的第几周（1-52）
    public var weekOfYear: Int { Calendar.current.component(.weekOfYear, from: base) }
    
    /// 季度（1-4）
    public var quarter: Int { Calendar.current.component(.quarter, from: base) }
    
    // MARK: - 日期判断 (Date Checks)
    
    /// 判断是否是今年
    public var isThisYear: Bool {
        return Calendar.current.isDate(base, equalTo: Date(), toGranularity: .year)
    }
    
    /// 判断是否是昨天
    public var isYesterday: Bool {
        return Calendar.current.isDateInYesterday(base)
    }
    
    /// 判断是否是今天
    public var isToday: Bool {
        return Calendar.current.isDateInToday(base)
    }
    
    /// 判断是否是一小时内（当前小时）
    public var isAnHourAgo: Bool {
        return Calendar.current.isDate(base, equalTo: Date(), toGranularity: .hour)
    }
    
    /// 判断是否是一分钟内（当前分钟）
    public var isJust: Bool {
        return Calendar.current.isDate(base, equalTo: Date(), toGranularity: .minute)
    }
    
    /// 判断是否是闰年
    public var isLeapYear: Bool {
        let year = base.lx.year
        return (year % 400 == 0) || (year % 100 != 0 && year % 4 == 0)
    }

}
