//
//  LXSwift+Date.swift
//  LXSwiftFoundation
//
//  Created by XL on 2020/9/24.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

extension Date: LXSwiftCompatible { }

private let LXCalendar = Calendar.current
//MARK: -  Extending methods for Date
extension LXSwiftBasics where Base == Date {
    
    /// 日期转换字符串 yyyy-MM-dd HH:mm:ss
    public func dateTranformString(with ymd: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let fmt = DateFormatter()
        fmt.dateFormat = ymd
        return fmt.string(from: base)
    }
    
    /// 日期和日期比较
    public func dateCompare(with date: Date, unit: Set<Calendar.Component> = [.year,.month,.day]) -> (DateComponents,DateComponents) { (LXCalendar.dateComponents(unit, from: base), LXCalendar.dateComponents(unit, from: date)) }
    
    /// 获取两个日期之间的数据
    public func componentCompare(from date: Date, unit: Set<Calendar.Component> = [.year,.month,.day]) -> DateComponents { LXCalendar.dateComponents(unit, from: date, to: base) }
    
    /// 获取两个日期之间的天数
    public func numberOfDays(from date: Date) -> Int? { componentCompare(from: date, unit: [.day]).day }
    
    /// 获取两个日期之间的小时
    public func numberOfHours(from date: Date) -> Int? { componentCompare(from: date, unit: [.hour]).hour }
    
    /// 获取两个日期之间的分钟
    public func numberOfMinutes(from date: Date) -> Int? { componentCompare(from: date, unit: [.minute]).minute }
    
    /// 获取两个日期之间的秒数
    public func numberOfSeconds(from date: Date) -> Int? { componentCompare(from: date, unit: [.second]).second }
}

//MARK: -  Extending properties  for NSData
extension LXSwiftBasics where Base == Date {
    
    /// 获取时间戳
    public var timeInterval: TimeInterval { base.timeIntervalSince1970 }
    public var year: Int { LXCalendar.component(.year, from: base) }
    public var month: Int { LXCalendar.component(.month, from: base) }
    public var day: Int { LXCalendar.component(.day, from: base) }
    public var hour: Int { LXCalendar.component(.hour, from: base) }
    public var minute: Int { LXCalendar.component(.minute, from: base) }
    public var second: Int { LXCalendar.component(.second, from: base) }
    public var nanosecond: Int { LXCalendar.component(.nanosecond, from: base) }
    public var weekday: Int { LXCalendar.component(.weekday, from: base) }
    public var weekOfMonth: Int { LXCalendar.component(.weekOfMonth, from: base) }
    public var weekOfYear: Int { LXCalendar.component(.weekOfYear, from: base) }
    public var quarter: Int { LXCalendar.component(.quarter, from: base) }
 
    /// 是否是今年
    public var isThisYear: Bool {
        let unit: Set<Calendar.Component> = [.year]
        let (selfCmps, nowComps) = base.lx.dateCompare(with: Date(), unit: unit)
        return nowComps.year == selfCmps.year
    }
    
    /// 是否是昨天
    public var isYesterday: Bool {
        let unit: Set<Calendar.Component> = [.day,.month,.year]
        let (selfCmps, nowComps) = base.lx.dateCompare(with: Date(), unit: unit)
        guard let nDay = nowComps.day, let cDay = selfCmps.day else { return false }
        return (selfCmps.year == nowComps.year) &&
            (selfCmps.month == nowComps.month) &&
            ((nDay - cDay) == 1)
    }
    
    /// 是否是今天
    public var isToday: Bool{
        let unit: Set<Calendar.Component> = [.day,.month,.year]
        let (selfCmps, nowComps) = base.lx.dateCompare(with: Date(), unit: unit)
        return (selfCmps.year == nowComps.year) &&
            (selfCmps.month == nowComps.month) &&
            (selfCmps.day == nowComps.day)
    }
    
    /// 是否是一小时前
    public var isAnHourAgo: Bool{
        let unit: Set<Calendar.Component> = [.hour,.day,.month,.year]
        let (selfCmps, nowComps) = base.lx.dateCompare(with: Date(), unit: unit)
        return (selfCmps.year == nowComps.year) &&
            (selfCmps.month == nowComps.month) &&
            (selfCmps.day == nowComps.day) &&
            (selfCmps.hour == nowComps.hour)
    }
    
    /// 是否是一分钟内
    public var isJust: Bool{
        let unit: Set<Calendar.Component> = [.minute,.hour,.day,.month,.year]
        let (selfCmps, nowComps) = base.lx.dateCompare(with: Date(), unit: unit)
        return (selfCmps.year == nowComps.year) &&
            (selfCmps.month == nowComps.month) &&
            (selfCmps.day == nowComps.day) &&
            (selfCmps.hour == nowComps.hour) &&
            (selfCmps.minute == nowComps.minute)
    }

    ///判断是否为瑞年
    public var isLeapYear: Bool {
        let year = base.lx.year
        return ((year % 400 == 0) || ((year % 100 != 0) && (year % 4 == 0)))
    }
    
}
