//
//  Utilities.swift
//  WhoFlew
//
//  Created by Austin Matese on 11/19/15.
//  Copyright (c) 2015 atomm. All rights reserved.
//

import Foundation

class Utilities {
    
    
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
}