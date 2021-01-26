//
//  DateUtil.swift
//  AnalogueClock
//
//  Created by Priyesh on 15/01/21.
//

import Foundation

extension Date {
    
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
         Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
         Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    
    func milliSeconds(from date: Date) -> Int {
        Int(self.timeIntervalSince(date)*1000)
    }
}
