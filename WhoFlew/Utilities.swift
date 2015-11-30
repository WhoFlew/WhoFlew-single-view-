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
        
        
        for chara in input.characters {
            if chara == " " {
                spaceCount++
            }
            if invalidCharacters.contains(chara) {
                return true
            }
        }
        
        
        if Double(spaceCount / input.characters.count) >= 0.34 {
            return true
        }
        else {
            return false
        }
        
    }

    
    
    
    func durationToString(endingDate: NSDate) -> String {

        let interval = endingDate.timeIntervalSinceNow
        let intervalMinutes: Double = (interval % 3600.0)/60.0
        let intervalHours: Double = interval / 3600.0
        let intervalDays: Double = intervalHours / 24
        let intervalWeeks: Double = interval / self.weekSeconds
        let intervalMonth: Double = interval / self.weekSeconds * (31 / 7)
        print(intervalMinutes)
        
        if interval <= 0   {
            return "expired"
        }
        else if intervalWeeks >= 8 {
            return "∞"
        }
        else if intervalMonth == 1 {
            return "1 month"
        }
        else if (intervalWeeks >= 1) && (intervalWeeks < 3) {
            let weeks = (Int(floor(intervalWeeks)))
            let days = (Int(floor(intervalDays % 7)))
            return "w: \(weeks) d: \(days)"
        }
            
        else if (intervalHours >= 24) && (intervalHours < 168){
            let days = (Int(floor(intervalDays)))
            let hours = (Int(floor(intervalHours % 24)))
            return "d: \(days) h: \(hours)"
        }
            
        else if (intervalHours < 24) && (intervalHours > 1) {
            return "h: \(Int(floor(intervalHours))) m: \(Int(round(intervalMinutes)))"
        }
            
        else if (intervalMinutes <= 60) && (intervalMinutes > 0){
            return "\(Int(round(intervalMinutes))) minutes"
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