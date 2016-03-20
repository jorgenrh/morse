//
//  MorseCode.swift
//  Morse
//
//  Created by J.R.Hoem on 28.09.15.
//  Copyright © 2015 JRH. All rights reserved.
//

import Foundation


class MorseTranslater {

    let textManager = TextManager()
    let torchManager = TorchManager()
    let toneManager = ToneManager()
    
    private let dispQueue: dispatch_queue_t = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)
    
    
    func encodeText(text: String) -> String {
        return textManager.encode(text)
    }

    func decodeText(text: String) -> String {
        return textManager.decode(text)
    }

    func runTorch(code: String, torchLevel: Double = 1.0) {
        torchManager.torchLevel = torchLevel
        torchManager.run(code)
    }
    
    func stopTorch() {
        torchManager.stopAll()
    }

    
    func playTone(code: String) {
        toneManager.run(code)
    }
    
    func stopTone() {
        toneManager.stopAll()
    }
    
    func runToneTorch(code: String) {
        dispatch_async(dispQueue) {
            self.playTone(code)
        }
        dispatch_async(dispQueue) {
            self.runTorch(code)
        }
    }
    
    func stopToneTorch() {
        stopTone()
        stopTorch()
    }
    
    
    func runAV(code: String) {
        
        AudioVisualGenerator.sharedInstance.mode = .ToneAndTorch
        AudioVisualGenerator.sharedInstance.toneFrequency = Morse.frequency
        AudioVisualGenerator.sharedInstance.torchLevel = 1.0
        
        let unit: Int = Morse.unit
        
        for var i=0; i < code.characters.count; i++ {
            
            let symbol = code[code.startIndex.advancedBy(i)] as Character
            
            switch symbol {
            case ".":
                setAVPulse(1, duration: unit*1)
                setAVPulse(0, duration: unit*1)
            case "-":
                setAVPulse(1, duration: unit*3)
                setAVPulse(0, duration: unit*1)
            case " ":
                let nextSymbol = code[code.startIndex.advancedBy(i+1)] as Character
                if nextSymbol == " " {
                    i++
                    setAVPulse(0, duration: unit*5)
                } else {
                    setAVPulse(0, duration: unit*3)
                }
            default:
                print("Uknown morse symbol")
            }
        }
    }
    
    func stopAV() {
        AudioVisualGenerator.sharedInstance.stop()
    }
    
    func setAVPulse(pulse: Int, duration: Int) {
        AudioVisualGenerator.sharedInstance.setPulse(pulse, duration: duration)
    }


}























