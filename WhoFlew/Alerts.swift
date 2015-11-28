//
//  Alerts.swift
//  WhoFlew
//
//  Created by Austin Matese on 11/27/15.
//  Copyright (c) 2015 atomm. All rights reserved.
//
import UIKit
import Foundation


class Alerts {
    
    
    
    func theseCodesPartedWays(codesThatParted: [(String)]) -> UIAlertController {

        var title: String = ""
        var message: String = ""
        var actionTitle: String = "part ways"
        
        if codesThatParted.count == 0 {
            title = "✌️"
            actionTitle = "✌️"
        }
            
        else if codesThatParted.count == 1 {
            title = codesThatParted.first!
            message = "this connection has been disconnected"
        }
            
            
            
        else if codesThatParted.count < 5 {
            
            for code in codesThatParted {
                title = "\(title)\n\(code)\n"
            }
            message = "these connection has been disconnected"
        }
            
            
            
        else {
            
            
            title = codesThatParted.first!
            for code in codesThatParted {
                if codesThatParted.first! == code {
                }
                else {
                    title = "\(code) | \(title)"
                }
            }
            message = "connections disconnected"

        }
        
        
        var alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        var partWays = UIAlertAction(title: actionTitle, style: UIAlertActionStyle.Destructive, handler: nil)
        alertController.addAction(partWays)
        
        return alertController
        
        
    }
    
    
    
    
    func alertsByType(alertType: String) -> UIAlertController {
        
        let dismiss = UIAlertAction(title: "✌️", style: UIAlertActionStyle.Cancel, handler: nil)
        
        
        //code must be at least 4 charas
        if alertType == "short" {
            var alert = UIAlertController(title: "☝️too short", message: "4 character minimum", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(dismiss)
            
            return alert
        }
            
            
            
            //code cannot be longer than 17 charas
        else if alertType == "long" {
            var alert = UIAlertController(title: "☝️too long", message: "17 character maximum", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(dismiss)
            
            return alert
        }
            
            
            //when pairing, textfield must have text
        else if alertType == "enterCodeToPair" {
            var alert = UIAlertController(title: "☝️enter code", message: "codeNames are used to connect users", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(dismiss)
            
            return alert
        }
            
            
            //invalid punctuation used
        else if alertType == "punc" {
            var alert = UIAlertController(title: "☝️invalid punctuation", message: "try emoticons", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(dismiss)
            
            return alert
        }
            
            
            //no internet
        else if alertType == "network" {
            var alert = UIAlertController(title: "☝️weak signal", message: "connect to a stronger network signal", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(dismiss)
            
            return alert
        }
            
            
        else if alertType == "pairSucess" {
            var alert = UIAlertController(title: "Users Paired", message: "", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(dismiss)
            
            return alert
        }
            
            
            
        else if alertType == "inboxLimit" {
            var alert = UIAlertController(title: "☝️", message: "Sorry, your inbox is at capacity.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(dismiss)
            
            return alert
        }
            
            
            
        else {
            var alert = UIAlertController(title: "PiGone", message: "meet our mascot, PiGone the carrier pigeon", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(dismiss)
            
            return alert
        }
    }
}