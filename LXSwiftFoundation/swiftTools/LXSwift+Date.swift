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
    public func dateTranformString(with ymd: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let fmt = DateFormatter()
        fmt.dateFormat = ymd
        let selfStr = fmt.string(from: base)
        return selfStr
    }
    
    /// 日期和日期比较
    public func dateCompare(with date: Date, unit: Set<Calendar.Component> = [.year,.month,.day]) -> (DateComponents,DateComponents) {
        let calendar = Calendar.current
        let dateComps = calendar.dateComponents(unit, from: date)
        let selfCmps = calendar.dateComponents(unit, from: base)
        return (selfCmps,dateComps)
    }
    
    /// 获取两个日期之间的数据
    public func componentCompare(from date: Date, unit: Set<Calendar.Component> = [.year,.month,.day]) -> DateComponents {
        let calendar = Calendar.current
        let comp = calendar.dateComponents(unit, from: date, to: base)
        return comp
    }
    
    /// 获取两个日期之间的天数
    public func numberOfDays(from date: Date) -> Int? {
       return componentCompare(from: date, unit: [.day]).day
    }
    
    /// 获取两个日期之间的小时
    public func numberOfHours(from date: Date) -> Int? {
       return componentCompare(from: date, unit: [.hour]).hour
    }
    
    /// 获取两个日期之间的分钟
    public func numberOfMinutes(from date: Date) -> Int? {
       return componentCompare(from: date, unit: [.minute]).minute
    }
    
    /// 获取两个日期之间的秒数
    public func numberOfSeconds(from date: Date) -> Int? {
       return componentCompare(from: date, unit: [.second]).second
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
    
}
