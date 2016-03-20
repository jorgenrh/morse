//
//  ToneGenerator.swift
//  Morse
//
//  Created by J.R.Hoem on 29.09.15.
//  Copyright © 2015 JRH. All rights reserved.
//

import Foundation
import AVFoundation

let kMDMorseAudioVisualQueueFinished = "com.tidybits.morseAudioVisualQueueFinished"

public class AudioVisualGenerator: NSObject {
    
    
    // Audio engine
    private let audioEngine: AVAudioEngine = AVAudioEngine()
    
    // Audioplayer node
    private let playerNode: AVAudioPlayerNode = AVAudioPlayerNode()
    
    // Standard non-interleaved PCM audio.
    private let audioFormat = AVAudioFormat(standardFormatWithSampleRate: 44100.0, channels: 2)
    
    
    // Torch available
    public var hasTorch: Bool = false
    
    // Capture device
    private var device: AVCaptureDevice? = nil
    
    // Thread queue
    private let avQueue = NSOperationQueue()
    
    
    public var toneFrequency: Double = 440.0
    
    public var torchLevel: Double = 1.0

    
    public enum AVMode {
        case ToneOnly
        case TorchOnly
        case ToneAndTorch
    }
    
    public enum AVPulse {
        case High
        case Low
    }
    
    public var mode: AVMode = .ToneOnly
    
    
    public var useTorch: Bool {
        get {
            if (mode == .TorchOnly || mode == .ToneAndTorch) {
                return true
            }
            return false
        }
    }
    
    public var useTone: Bool {
        get {
            if (mode == .ToneOnly || mode == .ToneAndTorch) {
                return true
            }
            return false
        }
    }
    
    
    // Singleton
    class var sharedInstance: AudioVisualGenerator {
        struct Static {
            static let instance: AudioVisualGenerator! = AudioVisualGenerator()
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
        
        if let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo) {
            self.device = device
            hasTorch = true
        }
        
        avQueue.maxConcurrentOperationCount = 1
        avQueue.addObserver(self, forKeyPath: "operationCount", options: .New, context: nil)
    }
    
    
    // Play tone / add to queue
    public func setPulse(pulse: Int, duration: Int) {
        
        var frequency = toneFrequency
        var level = torchLevel
        
        if pulse == 0 {
            frequency = 0
            level = 0
        }
        
        let sineBase = Double(2.0 * M_PI / audioFormat.sampleRate)
        
        let samplesPerBuffer: AVAudioFrameCount = UInt32(Double(duration)/1000 * Double(audioFormat.sampleRate))
        
        avQueue.addOperationWithBlock({
            
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
            self.avQueue.suspended = true

            if (self.useTorch) {
                self.setTorchLevel(level)
            }

            self.playerNode.scheduleBuffer(audioBuffer) {
                self.avQueue.suspended = false
                if (self.useTorch) {
                    self.setTorchLevel(0)
                }
                return
            }

            if (self.useTone) {
                self.playerNode.volume = 1.0
            } else {
                self.playerNode.volume = 0.0
            }

            self.playerNode.play()
            
        })
        
    }
    
    
    // Cancel sequence
    public func stop() {
        avQueue.cancelAllOperations()
        playerNode.stop()
        setTorchLevel(0)
    }
    
    
    // Pause sequence
    public func pause() -> Bool {
        let status: Bool = !avQueue.suspended
        avQueue.suspended = status
        return status
    }
    
    // Set torch level
    private func setTorchLevel(level: Double) {
        
        var torchLevel: Float = Float(level)
        
        if torchLevel > AVCaptureMaxAvailableTorchLevel {
            torchLevel = AVCaptureMaxAvailableTorchLevel
        }
        
        do {
            
            try self.device!.lockForConfiguration()
            
            if torchLevel > 0 {
                try self.device!.setTorchModeOnWithLevel(torchLevel)
            } else {
                self.device!.torchMode = .Off
            }
            
            self.device!.unlockForConfiguration()
            
        } catch let err as NSError {
            print("Error setting torch level:", err.debugDescription)
        }
    }
    
    // Observe when queue is finished
    override public func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        let obj = (object as? NSOperationQueue)
        if (obj == self.avQueue && keyPath! == "operationCount") {
            if obj?.operationCount == 0 {
                print("*** Audio/Visual queue finished")
                NSNotificationCenter.defaultCenter().postNotificationName(kMDMorseAudioVisualQueueFinished, object: self)
            }
        }
    }
    
}
