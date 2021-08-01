//
//  LXSwift+Date.swift
//  LXSwiftFoundation
//
//  Created by XL on 2020/9/24.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

extension Date: LXSwiftCompatible { }

//MARK: -  Extending methods for Date
extension LXSwiftBasics where Base == Date {
    
    /// 日期转换字符串 yyyy-MM-dd HH:mm:ss
    public func dateTranformString(with ymd: String = "yyyy-MM-dd HH:mm:ss")
    -> String {
        let fmt = DateFormatter()
        fmt.dateFormat = ymd
        let selfStr = fmt.string(from: base)
        return selfStr
    }
    
    /// 日期和日期比较
    public func dateCompare(with date: Date,
                            unit: Set<Calendar.Component> = [.year,.month,.day])
    -> (DateComponents,DateComponents) {
        let calendar = Calendar.current
        let dateComps = calendar.dateComponents(unit, from: date)
        let selfCmps = calendar.dateComponents(unit, from: base)
        return (selfCmps,dateComps)
    }
    
    /// 获取两个日期之间的数据
    public func omponentCompare(from date: Date,
                              unit: Set<Calendar.Component> = [.year,.month,.day])
    -> DateComponents {
        let calendar = Calendar.current
        let comp = calendar.dateComponents(unit, from: date, to: base)
        return comp
    }
    
    /// 获取两个日期之间的天数
    public func numberOfDays(from date: Date) -> Int? {
       return omponentCompare(from: date, unit: [.day]).day
    }
    
    /// 获取两个日期之间的小时
    public func numberOfHours(from date: Date) -> Int? {
       return omponentCompare(from: date, unit: [.hour]).hour
    }
    
    /// 获取两个日期之间的分钟
    public func numberOfMinutes(from date: Date) -> Int? {
       return omponentCompare(from: date, unit: [.minute]).minute
    }
    
    /// 获取两个日期之间的秒数
    public func numberOfSeconds(from date: Date) -> Int? {
       return omponentCompare(from: date, unit: [.second]).second
    }
}

//MARK: -  Extending properties  for NSData
extension LXSwiftBasics where Base == Date {
    
    /// 是否是今年
    public var isThisYear: Bool {
        let unit: Set<Calendar.Component> = [.year]
        let (selfCmps,nowComps) = base.lx.dateCompare(with: Date(), unit: unit)
        let result = nowComps.year == selfCmps.year
        return result
    }
    
    /// 是否是昨天
    public var isYesterday: Bool {
        let unit: Set<Calendar.Component> = [.day,.month,.year]
        let (selfCmps,nowComps) = base.lx.dateCompare(with: Date(), unit: unit)

        guard let nDay = nowComps.day,
              let cDay = selfCmps.day else { return false }
        return (selfCmps.year == nowComps.year) &&
            (selfCmps.month == nowComps.month) &&
            ((nDay - cDay) == 1)
    }
    
    /// 是否是今天
    public var isToday: Bool{
        let unit: Set<Calendar.Component> = [.day,.month,.year]
        let (selfCmps,nowComps) = base.lx.dateCompare(with: Date(), unit: unit)
        return (selfCmps.year == nowComps.year) &&
            (selfCmps.month == nowComps.month) &&
            (selfCmps.day == nowComps.day)
    }
    
    /// 是否是一小时前
    public var isAnHourAgo: Bool{
        let unit: Set<Calendar.Component> = [.hour,.day,.month,.year]
        let (selfCmps,nowComps) = base.lx.dateCompare(with: Date(), unit: unit)
        return (selfCmps.year == nowComps.year) &&
            (selfCmps.month == nowComps.month) &&
            (selfCmps.day == nowComps.day) &&
            (selfCmps.hour == nowComps.hour)
    }
    
    /// 是否是一分钟内
    public var isJust: Bool{
        let unit: Set<Calendar.Component> = [.minute,.hour,.day,.month,.year]
        let (selfCmps,nowComps) = base.lx.dateCompare(with: Date(), unit: unit)
        return (selfCmps.year == nowComps.year) &&
            (selfCmps.month == nowComps.month) &&
            (selfCmps.day == nowComps.day) &&
            (selfCmps.hour == nowComps.hour) &&
            (selfCmps.minute == nowComps.minute)
    }

    public var year: Int {
        return NSCalendar.current.component(.year, from: base)
    }
    public var month: Int {
        return NSCalendar.current.component(.month, from: base)
    }
    public var day: Int {
        return NSCalendar.current.component(.day, from: base)
    }
    public var hour: Int {
        return NSCalendar.current.component(.hour, from: base)
    }
    public var minute: Int {
        return NSCalendar.current.component(.minute, from: base)
    }
    public var second: Int {
        return NSCalendar.current.component(.second, from: base)
    }
    public var nanosecond: Int {
        return NSCalendar.current.component(.nanosecond, from: base)
    }
    public var weekday: Int {
        return NSCalendar.current.component(.weekday, from: base)
    }
    public var weekOfMonth: Int {
        return NSCalendar.current.component(.weekOfMonth, from: base)
    }
    public var weekOfYear: Int {
        return NSCalendar.current.component(.weekOfYear, from: base)
    }
    public var quarter: Int {
        return NSCalendar.current.component(.quarter, from: base)
    }
    
    public var isLeapYear: Bool {
        let year = base.lx.year
        return ((year % 400 == 0) || ((year % 100 != 0) && (year % 4 == 0)))
    }
    
    ///get stamp with Interval
    public var timeInterval: TimeInterval {
        return base.timeIntervalSince1970
    }
    
    public var noHourDate: Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: "\(base.lx.year)-\(base.lx.month)-\(base.lx.day)") ?? base
    }
    
    public var bsDescription: String {
        /**
         60秒内：刚刚
         1-60分钟 ：5分钟前
         60以上 - 今天0点之后：几小时以前，
         昨天：昨天22：00
         前1-7日前，在今年内：X天前
         7日前-今年1.1：XX-XX
         去年及以前：20XX-XX-XX
         */
        let now = Date()
        let secDiff = now.timeIntervalSince1970 - base.timeIntervalSince1970
        let dayDiffSec = now.lx.noHourDate.timeIntervalSince1970 -
            base.lx.noHourDate.timeIntervalSince1970
        let dayDiff = Int(dayDiffSec / (24.0 * 60 * 60))
        if secDiff < 60 {
            return "刚刚"
        } else if secDiff < 60 * 60 {
            return "\(Int(secDiff / 60))分钟前"
        } else if base.timeIntervalSince1970 - now.lx.noHourDate.timeIntervalSince1970 > 0 {
            let min = Int(secDiff / 60)
            let hour = min / 60
            return "\(hour)小时前"
        } else if dayDiff <= 1 {
            let hour = NSString(format: "%02d", base.lx.hour)
            let minute = NSString(format: "%02d", base.lx.minute)
            return "昨天\(hour):\(minute)"
        } else if now.lx.year != base.lx.year {
            let year = NSString(format: "%02d", base.lx.year)
            let month = NSString(format: "%02d", base.lx.month)
            let day = NSString(format: "%02d", base.lx.day)
            return "\(year)-\(month)-\(day)"
        } else if dayDiff <= 7 {
            return "\(dayDiff)天前"
        } else {
            let month = NSString(format: "%02d", base.lx.month)
            let day = NSString(format: "%02d", base.lx.day)
            return "\(month)-\(day)"
        }
    }
}
