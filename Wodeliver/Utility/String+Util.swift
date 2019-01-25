//
//  String+Util.swift
//  SPCE
//
//  Created by Arvind Kumar Gupta on 06/07/17..
//  Copyright © 2017 Arvind Kumar Gupta. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    /**
     * Function to use for Validate email address
     * @param
     **/
    func isValidateEmail() -> Bool
    {
        do {
            let regex = try NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}", options: .caseInsensitive)
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count)) != nil
        } catch {
            return false
        }
    }
    func trim() -> String {
        let trimmedString = self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        return trimmedString
    }
    /**
     * Function to use for check string is empety or not.
     * @param
     **/
    func isEmpty() -> Bool {
        let trimmedString = self.trim()
        if trimmedString.count > 0 {
            return false
        }
        return true
    }
    /**
     * Function to use for convert string into date
     * @param inputDateFormat:- Formate of date
     **/
    func convertDateStringIntoDateWithFormate(inputDateFormat:String) -> Date?
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = inputDateFormat //this your string date format
        dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            return nil
        }
    }
    /**
     * Function to use for convert string into date string into required formate
     * @param inputDateFormat:- Formate of date
     **/
//    func convertStringIntoDateStringWithFormate(inputDateFormat:String) -> String?
//    {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = inputDateFormat //this your string date format
//        dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
//        if let date = dateFormatter.date(from: self) {
//            return date.getDateStringWithDateformeter(dateFormatter: DateFormatter.dateFormatter_yyyy_MM_DD())
//        } else {
//            return nil
//        }
//    }
}
