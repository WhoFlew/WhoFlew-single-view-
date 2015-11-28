//
//  Utilities.swift
//  WhoFlew
//
//  Created by Austin Matese on 11/19/15.
//  Copyright (c) 2015 atomm. All rights reserved.
//

import Foundation

class Utilities {
    //used to turn duration to string value
    let weekSeconds: Double = 604800.0
    
    //codes must be paired within 4 days
    let fourDaysInSeconds = 4 * 24.0 * 60 * 60 * 60
    
    //true: contains any of the following punctuation [",",":",";","\\",">","%"]
    //true: more than 1/3 of codeName are spaces
    //false: code name has valid use of punctuation
    func invalidPunc(input: String) -> Bool {
        
        let invalidCharacters: [(Character)] = [",",":",";","\\",">","%"]
        
        var spaceCount: Int = 0
        
        
        for chara in input {
            if chara == " " {
                spaceCount++
            }
            if contains(invalidCharacters, chara) {
                return true
            }
        }
        
        
        if Double(spaceCount / count(input)) >= 0.34 {
            return true
        }
        else {
            return false
        }
        
    }

    
    
    
    func durationToString(endingDate: NSDate) -> String {
        var currentDateUtc = NSDate()
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")
        
        var dateString = dateFormatter.stringFromDate(NSDate())
        
        if let dateValue = dateFormatter.dateFromString(dateString) {
            currentDateUtc = dateValue
            
        }
        
        var interval = endingDate.timeIntervalSinceNow
        var intervalMinutes: Double = (interval % 3600.0)/60.0
        var intervalHours: Double = interval / 3600.0
        var intervalWeeks: Double = interval / self.weekSeconds
        
        
        
        if interval <= 0   {
            return "expired"
        }
        else if intervalWeeks >= 8 {
            return "∞"
        }
        else if (intervalWeeks >= 1) && (intervalWeeks < 3) {
            var weeks = (Int(floor(intervalWeeks)))
            var days = (Int(floor(intervalWeeks%7)))
            return "w: \(weeks) d: \(days)"
        }
            
        else if (intervalHours >= 24) && (intervalHours < 168){
            var days = (Int(floor(intervalHours/24)))
            var hours = (Int(floor(intervalHours%24)))
            return "d: \(days) h: \(hours)"
        }
            
        else if (intervalHours < 24) && (intervalHours > 1) {
            return "h: \(Int(floor(intervalHours))) m: \(Int(floor(intervalMinutes)))"
        }
            
        else if (intervalMinutes <= 60) && (intervalMinutes > 0){
            return "minutes: \(Int(floor(intervalMinutes)))"
        }
            
        else {
            return "???"
        }
        
        
    }
    
    
    
    
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }



//checkHere
//number of colons following a codeName indicates who can see message in group
}