//
//  String+RegEx.swift
//  Morse
//
//  Created by J.R.Hoem on 28.09.15.
//  Copyright © 2015 JRH. All rights reserved.
//

import Foundation


extension String {
    
    
    public func regexReplace(pattern: String, withString: String) -> String {
        
        let str = self
        
        let regex = try! NSRegularExpression(pattern: pattern, options: [.CaseInsensitive])
        
        let modString = regex.stringByReplacingMatchesInString(str, options: [], range: NSMakeRange(0, str.characters.count), withTemplate: withString)
        
        return modString
    }
    
    
    public func capitalizeSentences() -> String {
        
        let str = self
        var result = ""
        
        str.uppercaseString.enumerateSubstringsInRange(str.startIndex..<str.endIndex, options: .BySentences) { (_, range, _, _) in
            var substring = str[range] // retrieve substring from original string
            
            let first = substring.removeAtIndex(substring.startIndex)
            result += String(first).uppercaseString + substring
        }
        
        return result
    }

}
