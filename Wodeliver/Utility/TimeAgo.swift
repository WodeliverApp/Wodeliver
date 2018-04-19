//
//  TimeAgo.swift
//  Wodeliver
//
//  Created by Anuj Singh on 16/03/18.
//  Copyright © 2018 Anuj Singh. All rights reserved.
//

import Foundation

extension Date {
    
    public var timeAgoSinceNow: String {
        return self.timeAgoSince()
    }
    
    public var mediumTimeAgoSinceNow: String {
        return self.mediumTimeAgoSince()
    }
    
    public var thinTimeAgoSinceNow: String {
        return self.thinTimeAgoSince()
    }
    
    public var numericTimeAgo: String {
        return self.numericTimeAgoSinceNow(true)
    }
    
    public var numericDateAgo: String {
        return self.numericTimeAgoSinceNow(false)
    }
    
    public func timeAgoSince() -> String {
        let calendar = Calendar.current
        let now = Date()
        let unitFlags = Set<Calendar.Component>([.second,.minute,.hour,.day,.weekOfYear,.month,.year])
        let components = calendar.dateComponents(unitFlags, from: self, to: now)
        
        //        if let year = components.year, year >= 2 {
        //            return String.localizedStringWithFormat("%d_years_ago".localized, year)
        //        }
        //
        //        if let year = components.year, year >= 1 {
        //            return "last_year".localized
        //        }
        //
        //        if let month = components.month, month >= 2 {
        //            return String.localizedStringWithFormat("%d_months_ago".localized, month)
        //        }
        //        if let month = components.month, month >= 1 {
        //            return "last_month".localized
        //        }
        //
        //        if let week = components.weekOfYear, week >= 2 {
        //            return String.localizedStringWithFormat("%d_weeks_ago".localized, week)
        //        }
        //
        //        if let week = components.weekOfYear, week >= 1 {
        //            return "last_week".localized
        //        }
        if let year = components.year, let month = components.month, let week = components.weekOfYear, year == 0, month == 0, week == 0 {
            if let day = components.day, day >= 2 {
                return String.localizedStringWithFormat("%d_days_ago".localized, day)
            }
            
            if let day = components.day, day >= 1 {
                return "a_day_ago".localized
            }
            
            if let hour = components.hour, hour >= 2 {
                return String.localizedStringWithFormat("%d_hours_ago".localized, hour)
            }
            
            if let hour = components.hour, hour >= 1 {
                return "an_hour_ago".localized
            }
            
            if let minute = components.minute, minute >= 2 {
                return String.localizedStringWithFormat("%d_minutes_ago".localized, minute)
            }
            
            if let minute = components.minute, minute >= 1 {
                return "a_minute_ago".localized
            }
            
            if let second = components.second, second >= 30 {
                return String.localizedStringWithFormat("%d_seconds_ago".localized, second)
            }
            return "just_now".localized
        }
        let updatedString = DateFormatter.standardDateFormatter.string(from: self)
        return updatedString
    }
    public func mediumTimeAgoSince() -> String {
        
        let calendar = Calendar.current
        let now = Date()
        let unitFlags = Set<Calendar.Component>([.second,.minute,.hour,.day,.weekOfYear,.month,.year])
        let components = calendar.dateComponents(unitFlags, from: self, to: now)
        
        if let year = components.year, year >= 2 {
            return String.localizedStringWithFormat("%d years".localized, year)
        }
        
        if let year = components.year, year >= 1 {
            return "last_year".localized
        }
        
        if let month = components.month, month >= 2 {
            return String.localizedStringWithFormat("%d months".localized, month)
        }
        
        if let month = components.month, month >= 1 {
            return "last_month".localized
        }
        
        if let week = components.weekOfYear, week >= 2 {
            return String.localizedStringWithFormat("%d weeks".localized, week)
        }
        
        if let week = components.weekOfYear, week >= 1 {
            return "last_week".localized
        }
        
        if let day = components.day, day >= 2 {
            return String.localizedStringWithFormat("%d days".localized, day)
        }
        
        if let day = components.day, day >= 1 {
            return "yesterday".localized
        }
        
        if let hour = components.hour, hour >= 2 {
            return String.localizedStringWithFormat("%d hours".localized, hour)
        }
        
        if let hour = components.hour, hour >= 1 {
            return "1 hour".localized
        }
        
        if let minute = components.minute, minute >= 2 {
            return String.localizedStringWithFormat("%d mins".localized, minute)
        }
        
        if let minute = components.minute, minute >= 1 {
            return "1 min".localized
        }
        
        if let second = components.second, second >= 30 {
            return String.localizedStringWithFormat("%d sec".localized, second)
        }
        
        return "just_now".localized
        
    }
    public func thinTimeAgoSince() -> String {
        
        let calendar = Calendar.current
        let now = Date()
        let unitFlags = Set<Calendar.Component>([.second,.minute,.hour,.day,.weekOfYear,.month,.year])
        let components = calendar.dateComponents(unitFlags, from: self, to: now)
        
        if let year = components.year, year >= 2 {
            return String.localizedStringWithFormat("%d_thin_years_ago".localized, year)
        }
        
        if let year = components.year, year >= 1 {
            return "thin_last_year".localized
        }
        
        if let month = components.month, month >= 2 {
            return String.localizedStringWithFormat("%d_thin_months_ago".localized, month)
        }
        
        if let month = components.month, month >= 1 {
            return "thin_last_month".localized
        }
        
        if let week = components.weekOfYear, week >= 2 {
            return String.localizedStringWithFormat("%d_thin_weeks_ago".localized, week)
        }
        
        if let week = components.weekOfYear, week >= 1 {
            return String.localizedStringWithFormat("%d_thin_last_week".localized, week)
        }
        
        if let day = components.day, day >= 1 {
            return String.localizedStringWithFormat("%d_thin_days_ago".localized, day)
        }
        
        if let hour = components.hour, hour >= 2 {
            return String.localizedStringWithFormat("%d_thin_hours_ago".localized, hour)
        }
        
        if let hour = components.hour, hour >= 1 {
            return "an_thin_hour_ago".localized
        }
        
        if let minute = components.minute, minute >= 2 {
            return String.localizedStringWithFormat("%d_thin_minutes_ago".localized, minute)
        }
        
        if let minute = components.minute, minute >= 1 {
            return "a_thin_minute_ago".localized
        }
        
        if let second = components.second, second >= 3 {
            return String.localizedStringWithFormat("%d_thin_seconds_ago".localized, second)
        }
        
        return "thin_just_now".localized
    }
    
    public func numericTimeAgoSinceNow(_ showTodayTime: Bool) -> String {
        let calendar = Calendar.current
        let formatter = DateFormatter()
        if calendar.isDateInToday(self) {
            if showTodayTime {
                formatter.dateFormat = "hh:mm a"
                return formatter.string(from: self)
            }
            return "today".localized
        }
        if calendar .isDateInYesterday(self) {
            return "yesterday".localized
        }
        formatter.dateFormat = "dd/MM/yy"
        return formatter.string(from: self)
    }
    
    func getElapsedInterval() -> String {
        
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: Bundle.main.preferredLocalizations[0])
        
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.maximumUnitCount = 1
        formatter.calendar = calendar
        
        var dateString: String?
        
        let interval = calendar.dateComponents([.year, .month, .weekOfYear, .day], from: self, to: Date())
        
        if let year = interval.year, year > 0 {
            formatter.allowedUnits = [.year] //2 years
        } else if let month = interval.month, month > 0 {
            formatter.allowedUnits = [.month] //1 month
        } else if let week = interval.weekOfYear, week > 0 {
            formatter.allowedUnits = [.weekOfMonth] //3 weeks
        } else if let day = interval.day, day > 0 {
            formatter.allowedUnits = [.day] // 6 days
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: Bundle.main.preferredLocalizations[0])
            dateFormatter.dateStyle = .medium
            dateFormatter.doesRelativeDateFormatting = true
            
            dateString = dateFormatter.string(from: self) // IS GOING TO SHOW 'TODAY'
        }
        
        if dateString == nil {
            dateString = formatter.string(from: self, to: Date())
        }
        
        return dateString!
    }
}
