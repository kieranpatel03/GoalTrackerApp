//
//  DateFunctions.swift
//  HabitTracker
//
//  Created by Kieran on 02/07/2022.
//

import Foundation

func string_to_date(from timeString: String, format: String) -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    dateFormatter.timeZone = TimeZone.current
    dateFormatter.locale = Locale.current
    return dateFormatter.date(from: timeString)!
}

func secondsToDaysHoursMinutesSeconds(_ seconds: Int) -> String {
    let Days: Int
    let Hours: Int
    let Minutes: Int
    let Seconds: Int
    (Days, Hours, Minutes, Seconds) = (seconds / 86400, seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    if (Days >= 1){
        return "\(Days) days"
    } else if (Hours >= 1) {
        return "\(Hours) hours"
    } else if (Minutes >= 1) {
        return "\(Minutes) minutes"
    }   else if (Seconds >= 1) {
        return "\(Seconds) seconds"
    } else {
        return "0 seconds"
    }
}
