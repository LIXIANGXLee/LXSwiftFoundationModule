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
    
    /// date transform string yyyy-MM-dd HH:mm:ss
    public func dateTranformString(with ymd: String = "yyyy-MM-dd HH:mm:ss")
    -> String {
        let fmt = DateFormatter()
        fmt.dateFormat = ymd
        let selfStr = fmt.string(from: base)
        return selfStr
    }
    
    /// date and date Compare
    public func dateCompare(with date: Date,
                            unit: Set<Calendar.Component> = [.year,.month,.day])
    -> (DateComponents,DateComponents) {
        let calendar = Calendar.current
        let dateComps = calendar.dateComponents(unit, from: date)
        let selfCmps = calendar.dateComponents(unit, from: base)
        return (selfCmps,dateComps)
    }
}

//MARK: -  Extending properties  for NSData
extension LXSwiftBasics where Base == Date {
    
    /// is this year
    public var isThisYear: Bool {
        let unit: Set<Calendar.Component> = [.year]
        let (selfCmps,nowComps) = base.lx.dateCompare(with: Date(), unit: unit)
        let result = nowComps.year == selfCmps.year
        return result
    }
    
    ///isYesterday
    public var isYesterday: Bool {
        let unit: Set<Calendar.Component> = [.day,.month,.year]
        let (selfCmps,nowComps) = base.lx.dateCompare(with: Date(), unit: unit)
        let count = nowComps.day! - selfCmps.day!
        return (selfCmps.year == nowComps.year) &&
            (selfCmps.month == nowComps.month) &&
            (count == 1)
    }
    
    /// is today
    public var isToday: Bool{
        let unit: Set<Calendar.Component> = [.day,.month,.year]
        let (selfCmps,nowComps) = base.lx.dateCompare(with: Date(), unit: unit)
        return (selfCmps.year == nowComps.year) &&
            (selfCmps.month == nowComps.month) &&
            (selfCmps.day == nowComps.day)
    }
    
    /// An hour ago
    public var isAnHourAgo: Bool{
        let unit: Set<Calendar.Component> = [.hour,.day,.month,.year]
        let (selfCmps,nowComps) = base.lx.dateCompare(with: Date(), unit: unit)
        return (selfCmps.year == nowComps.year) &&
            (selfCmps.month == nowComps.month) &&
            (selfCmps.day == nowComps.day) &&
            (selfCmps.hour == nowComps.hour)
    }
    
    /// An minute ago
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
        let year = self.year
        return ((year % 400 == 0) || ((year % 100 != 0) && (year % 4 == 0)))
    }
    
    ///get stamp with Interval
    public var timeInterval: TimeInterval {
        return base.timeIntervalSince1970
    }
}
