//
//  ToneGenerator.swift
//  Morse
//
//  Created by J.R.Hoem on 29.09.15.
//  Copyright © 2016 JRH. All rights reserved.
//

import Foundation
import AVFoundation

let kMDMorseToneQueueFinished = "com.tidybits.morseToneQueueFinished"

public class ToneGenerator: NSObject {

    
    // Volume
    public var volume: Double = 0.8 {
        didSet {
            audioEngine.mainMixerNode.volume = Float(volume)
        }
    }

    // Volume
    public var pan: Double = 0.8
    
    // Audio engine
    private let audioEngine: AVAudioEngine = AVAudioEngine()
    
    // Audioplayer node
    private let playerNode: AVAudioPlayerNode = AVAudioPlayerNode()
    
    // Standard non-interleaved PCM audio.
    private let audioFormat = AVAudioFormat(standardFormatWithSampleRate: 44100.0, channels: 2)
    
    // Thread queue
    private let toneQueue = NSOperationQueue()

    
    // Singleton
    class var sharedInstance: ToneGenerator {
        struct Static {
            static let instance: ToneGenerator! = ToneGenerator()
        }
        return Static.instance
    }
    
    
    // Initialize engine
    override private init() {
        super.init()

        // Attach and connect the player node.
        audioEngine.attachNode(playerNode)
        audioEngine.connect(playerNode, to: audioEngine.mainMixerNode, format: audioFormat)
        
        do {
            try audioEngine.start()
        } catch let err as NSError {
            print("Error starting audio engine: \(err)")
        }
        
        toneQueue.maxConcurrentOperationCount = 1
        toneQueue.addObserver(self, forKeyPath: "operationCount", options: .New, context: nil)
    }


    // Play tone / add to queue
    public func setTone(frequency: Double, duration: Int) {
        
        let sineBase = Double(2.0 * M_PI / audioFormat.sampleRate)
        
        let samplesPerBuffer: AVAudioFrameCount = UInt32(Double(duration)/1000 * Double(audioFormat.sampleRate))
        
        toneQueue.addOperationWithBlock({

            var sampleTime: Double = 0

            let audioBuffer = AVAudioPCMBuffer(PCMFormat: self.audioFormat, frameCapacity: samplesPerBuffer)
            
            let leftChannel = audioBuffer.floatChannelData[0]
            
            let rightChannel = audioBuffer.floatChannelData[1]
            
            for var sampleIndex = 0; sampleIndex < Int(samplesPerBuffer); sampleIndex++ {
                
                let sample = sin(sineBase * frequency * sampleTime)
                
                leftChannel[sampleIndex] = Float32(sample)
                rightChannel[sampleIndex] = Float32(sample)
                
                sampleTime++
            }
            
            audioBuffer.frameLength = samplesPerBuffer
            
            //self.playerNode.scheduleBuffer(audioBuffer, completionHandler: nil)
            self.toneQueue.suspended = true
            self.playerNode.scheduleBuffer(audioBuffer) {
                self.toneQueue.suspended = false
                return
            }
            
        })
        
        self.playerNode.play()
    }

    
    // Cancel sequence
    func stop() {
        playerNode.stop()
        toneQueue.cancelAllOperations()
    }
    
    
    // Pause sequence
    func pause() -> Bool {
        let status: Bool = !toneQueue.suspended
        toneQueue.suspended = status
        return status
    }
    
    
    // Observe when queue is finished
    override public func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        let obj = (object as? NSOperationQueue)
        if (obj == self.toneQueue && keyPath! == "operationCount") {
            if obj?.operationCount == 0 {
                print("*** Tone queue finished")
                NSNotificationCenter.defaultCenter().postNotificationName(kMDMorseToneQueueFinished, object: self)
            }
        }
    }
    
}
