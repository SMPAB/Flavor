//
//  TimeStamp.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-13.
//

import Foundation
import Firebase

extension Timestamp{
    func timestampString() -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekday]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: self.dateValue(), to: Date()) ?? ""
    }
    
    func timestampHourlyString() -> String {
            let date = self.dateValue()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm a"
            dateFormatter.amSymbol = "AM"
            dateFormatter.pmSymbol = "PM"
            return dateFormatter.string(from: date)
        }
}

extension Date {
    func toFormattedString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM" // Adjust the format as needed
        //formatter.locale = Locale(identifier: "en_US_POSIX") // Use a fixed locale to ensure consistency
        return formatter.string(from: self)
    }
}

extension Calendar {
    func startOfToday() -> Date {
        return startOfDay(for: Date())
    }

    func startOfYesterday() -> Date? {
        return date(byAdding: .day, value: -1, to: startOfToday())
    }
}
