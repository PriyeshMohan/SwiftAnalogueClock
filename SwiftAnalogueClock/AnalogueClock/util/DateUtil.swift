//
//  DateUtil.swift
//  AnalogueClock
//
//  Created by Priyesh on 26/01/21.
//

import Foundation

struct DateUtil {
    static func timeComponents(date: Date?) -> (hour: Int, minutes: Int, seconds: Int)  {
        let targetDate = date ?? Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: targetDate)
        let minutes = calendar.component(.minute, from: targetDate)
        let seconds = calendar.component(.second, from: targetDate)
        return (hour, minutes, seconds)
    }
}
