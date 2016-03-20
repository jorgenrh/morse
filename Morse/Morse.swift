
//
//  Morse.swift
//  Morse
//
//  Created by J.R.Hoem on 29.09.15.
//  Copyright © 2015 JRH. All rights reserved.
//

class Morse {
    
    // Default delay unit [ms]
    static let unit: Int = 50

    // Default frequency [Hz]
    static let frequency: Double = 1440.0

    
    // Morse characters
    // TODO: add internationalization, types etc
    
    static let letters: Dictionary<Character, String> = [
        
        // Letters
        "A": ".-",
        "B": "-...",
        "C": "-.-.",
        "D": "-..",
        "E": ".",
        "F": "..-.",
        "G": "--.",
        "H": "....",
        "I": "..",
        "J": ".---",
        "K": "-.-",
        "L": ".-..",
        "M": "--",
        "N": "-.",
        "O": "---",
        "P": ".--.",
        "Q": "--.-",
        "R": ".-.",
        "S": "...",
        "T": "-",
        "U": "..-",
        "V": "...-",
        "W": ".--",
        "X": "-..-",
        "Y": "-.--",
        "Z": "--..",
    
    ]
    
    static let numbers: Dictionary<Character, String> = [
    
        // Numbers
        "0": "-----",
        "1": ".----",
        "2": "..---",
        "3": "...--",
        "4": "....-",
        "5": ".....",
        "6": "-....",
        "7": "--...",
        "8": "---..",
        "9": "----.",
        
    ]
    
    static let punctuation: Dictionary<Character, String> = [
    
        // Punctuation
        ".": ".-.-.-",
        ",": "--..--",
        "?": "..--..",
        "'": ".----.",
        "!": "-.-.--",
        "/": "-..-.",
        "(": "-.--.",
        ")": "-.--.-",
        "&": ".-...",
        ":": "---...",
        ";": "-.-.-.",
        "=": "-...-",
        "+": ".-.-.",
        "-": "-....-",
        "_": "..--.-",
        "\"": ".-..-.",
        "$": "...-..-",
        "@": ".--.-.",
        
    ]
    
    static let prosigns: Dictionary<Character, String> = [

        // Prosigns
        "\n": ".-.-",
    
    ]

    static var code: Dictionary<Character, String> {
        get {
            var all = Dictionary<Character, String>()
            all.merge(letters)
            all.merge(numbers)
            all.merge(punctuation)
            all.merge(prosigns)
            return all
        }
    }
    
}
