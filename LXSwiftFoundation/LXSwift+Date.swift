//
//  LXSwift+Date.swift
//  LXSwiftFoundation
//
//  Created by XL on 2020/9/24.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

extension Date: LXCompatible { }

//MARK: -  Extending methods for Date
extension LXSwiftBasics where Base == Date {
    
    /// date transform string
    public func dateTranformString(with ymd: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let fmt = DateFormatter()
        fmt.dateFormat = ymd
        let selfStr = fmt.string(from: base)
        return selfStr
    }
    
    /// date and date Compare
    public func dateCompare(with date: Date, unit: Set<Calendar.Component> = [.year,.month,.day]) -> (DateComponents,DateComponents) {
        let calendar = Calendar.current
        let dateComps = calendar.dateComponents(unit, from: date)
        let selfCmps = calendar.dateComponents(unit, from: base)
        return (selfCmps,dateComps)
    }
    
    /// is year
      public func isThisYear() -> Bool {
        let unit: Set<Calendar.Component> = [.year]
        let (selfCmps,nowComps) = base.lx.dateCompare(with: Date(), unit: unit)
        let result = nowComps.year == selfCmps.year
        return result
    }
    
    ///isYesterday
    public func isYesterday() -> Bool {
         let unit: Set<Calendar.Component> = [.day,.month,.year]
         let (selfCmps,nowComps) = base.lx.dateCompare(with: Date(), unit: unit)
         let count = nowComps.day! - selfCmps.day!
         return (selfCmps.year == nowComps.year) &&
             (selfCmps.month == nowComps.month) &&
             (count == 1)
     }
    
    
    /// is today
    public func isToday() -> Bool{
        let unit: Set<Calendar.Component> = [.day,.month,.year]
        let (selfCmps,nowComps) = base.lx.dateCompare(with: Date(), unit: unit)
        return (selfCmps.year == nowComps.year) &&
            (selfCmps.month == nowComps.month) &&
            (selfCmps.day == nowComps.day)
    }
    
    /// An hour ago
    public func isAnHourAgo() -> Bool{
          let unit: Set<Calendar.Component> = [.hour,.day,.month,.year]
          let (selfCmps,nowComps) = base.lx.dateCompare(with: Date(), unit: unit)
          return (selfCmps.year == nowComps.year) &&
              (selfCmps.month == nowComps.month) &&
              (selfCmps.day == nowComps.day) &&
              (selfCmps.hour == nowComps.hour)
      }
    
    /// An minute ago
    public func isJust() -> Bool{
         let unit: Set<Calendar.Component> = [.minute,.hour,.day,.month,.year]
         let (selfCmps,nowComps) = base.lx.dateCompare(with: Date(), unit: unit)
         return (selfCmps.year == nowComps.year) &&
             (selfCmps.month == nowComps.month) &&
             (selfCmps.day == nowComps.day) &&
             (selfCmps.hour == nowComps.hour) &&
             (selfCmps.minute == nowComps.minute)
     }
    
    ///get stamp with Interval
    public func timeInterval() -> TimeInterval {
        return Date().timeIntervalSince1970 * 1000
    }
    
}
