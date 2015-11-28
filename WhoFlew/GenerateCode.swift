//
//  Dialogue.swift
//  sleiGh
//
//  Created by Austin Matese on 7/27/15.
//  Copyright (c) 2015 atomm. All rights reserved.
//

import UIKit
import CoreData
import Parse
import Bolts
import Foundation

class GenerateCode {
    
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    
    let adjectives = ["purple","purple","purple","purple","purple","purple","pink","sweet","honey","orange","silver","blue","red","blue","red","secret","secret", "cool", "popping", "dark", "light", "dank", "green", "teal", "black", "free", "buzz", "pure", "white", "jumbo", "floating", "baked", "high", "orange","silver","blue","low", "proud", "fair", "calm", "bold", "wild", "deep", "grand", "sleek","blue","red", "hot", "cold", "sweet", "sweet", "raw", "liberty", "frosty", "clean", "gold", "giant", "fast", "slow", "crisp", "hazy", "clear", "bright", "shinning", "rebel", "rebel","rebel","classic", "potent", "alaskan", "power", "passion", "loving", "tender", "bald", "short", "angry", "happy", "sharp", "dumb", "loud", "silent", "good","lazy", "loud","loud","loud","loud","funny","funny","funny","smart","smart","hairy","hairy"]
    
    let nouns = ["monkey", "oak","oak","oak", "sleigh", "rider","monkey", "rebel", "rider","monkey", "rebel", "rider","box","hawk", "code", "cobra", "lion", "den", "basement", "trip", "seal", "man", "night", "knight", "eagle", "camp", "sand", "bee", "grass", "clouds", "cloud","smoke", "bush", "moon", "moons", "kite", "kites", "fire", "ice", "mountain", "design", "snake", "eye", "home", "lake", "joke", "key", "keys", "lock", "door", "star", "stars", "sun", "burn", "book", "books", "bag", "bags", "flamingo", "lady", "matrix", "pandas", "panda", "snow", "hammer", "ball", "hammers", "river", "rivers", "grape", "grapes", "apple", "apples", "peach", "pear", "kiwi", "zebra", "ghost", "king", "queen", "bishop", "president", "computer", "phone", "fish", "mario", "robot", "gator", "warrior", "bullet", "spring", "sky", "haze", "titan", "captain", "goo", "beast", "dragon", "flower", "valley", "band", "spark", "fruit", "kiss", "robot", "robot"]
    
    
    let emoticons = ["👌","☝️","👍","👎","✌️","🍁","🌴","🍄","⚡️","👅","🔥","🇺🇸","🇬🇧","🇯🇵","💯","🙈","💜","😎","💨","💤","💙","💚","❄️","🍒"]
    
    let alphabet = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","A","B","D","E","F","G","H","J","M","P", "Q", "R", "T"]
    
    
    let about30Years: Double = 946707000
    let weekSeconds: Double = 604800.0
    
    var allCodes = [(String)]()

    
    
    
    var currentDateUtc = NSDate()
    

    
    //generate code for 'note', if already in use add numbers till unique code made
    func createCode(suffix: String, infiniteConnection: Bool) -> [(String)] {
        
        var newCodeOptions = [(String)]()
        var newCode: String = ""
        
        //random digits to be created if code exists
        var randomDigit: Int
        var randomDigit2: Int
        var randomDigit3: Int
        
        //initial random digits added to suffix
        var firstRandom = Int(arc4random_uniform(10))
        var secondRandom = Int(arc4random_uniform(10))
        var thirdRandom = Int(arc4random_uniform(10))
        
        
        var randomAlpha = Int(arc4random_uniform(UInt32(self.alphabet.count)))
        
        var randomEmoji = Int(arc4random_uniform(UInt32(self.emoticons.count)))
        var randomEmoji2 = Int(arc4random_uniform(UInt32(self.emoticons.count)))
        
        
        newCodeOptions.append(self.newCodeOptions("\(suffix)\(firstRandom)\(secondRandom)", suffix: suffix))
        newCodeOptions.append(self.newCodeOptions("\(suffix)\(thirdRandom)\(self.alphabet[randomAlpha])", suffix: suffix))
        newCodeOptions.append(self.newCodeOptions("\(suffix)\(self.emoticons[randomEmoji])\(self.emoticons[randomEmoji2])", suffix: suffix))
        
        
        return newCodeOptions
        
    }
    
    
    
    func newCodeOptions(possibleCode: String, suffix: String) -> String {
        var newCode: String = possibleCode
        var attempts: Int = 0
        
        
        while contains(self.allCodes, newCode) {
            
            var newCodeArray = Array(newCode)
            while newCodeArray != Array(suffix) {
                newCodeArray.removeLast()
                newCode = String(newCodeArray)
                
                if !contains(self.allCodes, newCode) && count(newCode) >= 4 {

                }
            }
            
            
            var randomDigit = Int(arc4random_uniform(10))
            var randomDigit2 = Int(arc4random_uniform(10))
            var randomDigit3 = Int(arc4random_uniform(10))
            
            var randomEmoji = Int(arc4random_uniform(UInt32(self.emoticons.count)))
            var randomEmoji2 = Int(arc4random_uniform(UInt32(self.emoticons.count)))
            
            if attempts > 1300 {
                newCode = "\(newCode)\(randomDigit)\(self.emoticons[randomEmoji2])\(randomDigit3)\(self.emoticons[randomEmoji])"
            }
            else if randomDigit == 0 {
                newCode = "\(newCode)\(randomDigit2)"
                
            }
            else if (self.allCodes.count % 4 == 0 && attempts < 8) || attempts < 9 {
                newCode = "\(newCode)\(randomDigit)"
                
            }
            else if attempts < 130 {
                
                newCode = "\(newCode)\(randomDigit)\(randomDigit2)"
                
            }
            else if attempts < 1000 {
                newCode = "\(newCode)\(randomDigit)\(randomDigit2)\(randomDigit3)"

            }
            else {
                newCode = "\(newCode)\(randomDigit)\(self.emoticons[randomEmoji2])\(randomDigit3)\(self.emoticons[randomEmoji])"
            }
            
            attempts++
            
        }
        
    
        
        return newCode
    }
    
    
    
    
    
    func generateCodeName() -> [(String)] {
        
        var randomCodeOptions = [(String)]()
        
        var randomDigitA = Int(arc4random_uniform(UInt32(self.adjectives.count)))
        var randomDigitN = Int(arc4random_uniform(UInt32(self.nouns.count)))
        
        var randomDigitA2 = Int(arc4random_uniform(UInt32(self.adjectives.count)))
        var randomDigitN2 = Int(arc4random_uniform(UInt32(self.nouns.count)))
        
        var randomDigitA3 = Int(arc4random_uniform(UInt32(self.adjectives.count)))
        var randomDigitAA3 = Int(arc4random_uniform(UInt32(self.adjectives.count)))
        var randomDigitN3 = Int(arc4random_uniform(UInt32(self.nouns.count)))
        
        var newCodeName: String = "\(self.adjectives[randomDigitA]) \(self.nouns[randomDigitN])"

        randomCodeOptions.append(self.randomCodeOptions("\(self.adjectives[randomDigitA]) \(self.nouns[randomDigitN])"))
        randomCodeOptions.append(self.randomCodeOptions("\(self.adjectives[randomDigitA2]) \(self.nouns[randomDigitN2])"))
        randomCodeOptions.append(self.randomCodeOptions("\(self.adjectives[randomDigitA3]) \(self.adjectives[randomDigitAA3]) \(self.nouns[randomDigitN3])"))
        
        return randomCodeOptions
        
    }
    
    
    func randomCodeOptions(newCodeName: String) -> String {
        
        var newCode: String = newCodeName
        var attempts: Int = 0
        
        while contains(self.allCodes, newCodeName) {
            var randomDigitA = Int(arc4random_uniform(UInt32(self.adjectives.count)))
            var randomDigitN = Int(arc4random_uniform(UInt32(self.nouns.count)))
            
            newCode = "\(self.adjectives[randomDigitA]) \(self.nouns[randomDigitN])"
            
            if attempts > 5000 {
                return "try to create a code"
            }
            attempts++
        }
        return newCodeName
    }
    

    

    
}