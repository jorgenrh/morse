//
//  FlashManager.swift
//  Morse
//
//  Created by J.R.Hoem on 29.09.15.
//  Copyright © 2015 JRH. All rights reserved.
//
import Foundation
import AVFoundation

class TorchManager {
    
    var hasTorch: Bool {
        get {
            return TorchGenerator.sharedInstance.hasTorch
        }
    }
    
    var unit: Int {
        get {
            return Morse.unit
        }
    }
    
    var torchLevel: Double = 1.0
    
    
    func run(code: String) {
        
        let unit = Morse.unit
        
        for var i=0; i < code.characters.count; i++ {
            
            let symbol = code[code.startIndex.advancedBy(i)] as Character
            
            switch symbol {
            case ".":
                setTorch(torchLevel, duration: unit*1)
                setTorch(0, duration: unit*1)
            case "-":
                setTorch(torchLevel, duration: unit*3)
                setTorch(0, duration: unit*1)
            case " ":
                let nextSymbol = code[code.startIndex.advancedBy(i+1)] as Character
                if nextSymbol == " " {
                    i++
                    setTorch(0, duration: unit*5)
                } else {
                    setTorch(0, duration: unit*3)
                }
            default:
                print("Uknown morse symbol")
            }
            
            
        }
    }
    
    
    func setTorch(level: Double, duration: Int) {
        TorchGenerator.sharedInstance.setTorch(level, duration: duration)
    }
    
    func stopAll() {
        TorchGenerator.sharedInstance.stop()
    }
    

    
}
