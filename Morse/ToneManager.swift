//
//  ToneTranslater.swift
//  Morse
//
//  Created by J.R.Hoem on 29.09.15.
//  Copyright © 2015 JRH. All rights reserved.
//
// dot = 1 unit
// dash = 3 units
// space between dots/dashes within a letter = 1 unit
// space between letters = 3 units
// space between words = 5 units

class ToneManager {

    var unit: Int = 150
    var frequency: Double = 1440.0
    
    enum MorseSymbols: Character {
        case Dash = "-"
        case Dot = "."
        case Space = " "
    }
    
    func run(code: String) {
        
        for var i=0; i < code.characters.count; i++ {
            
            let symbol = code[code.startIndex.advancedBy(i)] as Character
            
            switch symbol {
            case ".":
                playTone(frequency, duration: unit*1)
                playTone(0, duration: unit*1)
            case "-":
                playTone(frequency, duration: unit*3)
                playTone(0, duration: unit*1)
            case " ":
                let nextSymbol = code[code.startIndex.advancedBy(i+1)] as Character
                if nextSymbol == " " {
                    i++
                    playTone(0, duration: unit*5)
                } else {
                    playTone(0, duration: unit*3)
                }
            default:
                print("Uknown morse symbol")
            }
            
            
        }
        
    }
    
    func playTone(freq: Double, duration: Int) {
        ToneGenerator.sharedInstance.setTone(freq, duration: duration)
        //AudioVisualGenerator.sharedInstance.setPulse(duration)
    }
    
    func stopAll() {
        ToneGenerator.sharedInstance.stop()
        //AudioVisualGenerator.sharedInstance.stop()
    }
    
    
    
    
}
