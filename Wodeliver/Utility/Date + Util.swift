//
//  Date + Util.swift
//  SPCE
//
//  Created by Arvind Kumar Gupta on 03/08/17.
//  Copyright © 2017 Arvind Kumar Gupta. All rights reserved.
//

import Foundation


extension Date {

    func getDateStringWithDateformeter(dateFormatter : DateFormatter) -> String {
             return dateFormatter.string(from: self)
        
        }
    /**
     * Function to use for Getting day, month, years, hours, minutes and seconds from date
     * @param
     * @Return Tuple of year, month, day, hours, minute and second
     **/
    func getdateComponents() -> (Int?,Int?,Int?,Int?,Int?,Int?) {
        let calendar = Calendar.current
        let comp = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
        let year = comp.year
        let month = comp.month
        let day = comp.day
        let hour = comp.hour
        let minute = comp.minute
        let second = comp.second
        return ( year, month, day, hour, minute, second)
    }
    
}
