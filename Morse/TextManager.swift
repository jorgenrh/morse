//
//  TextManager.swift
//  Morse
//
//  Created by J.R.Hoem on 29.09.15.
//  Copyright © 2015 JRH. All rights reserved.
//

import Foundation


class TextManager {

    
    
    // Encode string
    func encode(text: String) -> String {
        
        var result = [String]()
        
        var input = text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        input = input.regexReplace("[ ]{2,}+", withString: " ")
        
        let words = input.characters.split { $0 == " " }
        
        for word in words {
            for symbol in word {
                result.append(encodeSymbol(symbol))
            }
            result.append(" ")
        }
        result.removeAtIndex(result.count-1)
        
        return result.joinWithSeparator(" ")
    }
    
    
    // Decode string
    func decode(text: String) -> String {
        
        var result = [Character]()
        
        var input = text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        input = input.regexReplace("[ ]{2,}+", withString: "  ")
        
        let words = input.componentsSeparatedByString("  ")
        
        for word in words {
            let codes = word.componentsSeparatedByString(" ")
            for code in codes {
                
                let dec = decodeSymbol(code)
                if dec.characters.count > 1 {
                    for d in dec.characters {
                        result.append(d)
                    }
                } else {
                    result.append(Character(dec))
                }
                
            }
            result.append(" ")
        }
        result.removeAtIndex(result.count-1)
        
        return String(result).lowercaseString.capitalizeSentences()
    }
    
    
    
    // Encode string or character
    private func encodeSymbol(symbol: String) -> String {
        return encodeSymbol(Character(symbol))
    }
    
    private func encodeSymbol(symbol: Character) -> String {
        
        let char = Character(String(symbol).uppercaseString)
        
        if let sym = Morse.code[char] {
            return sym
        }
        
        return String(symbol)
    }

    // Decode string
    private func decodeSymbol(symbol: String) -> String {
        
        for (key, val) in Morse.code {
            if val == symbol {
                return String(key)
            }
        }
        
        return symbol
    }
    

}
