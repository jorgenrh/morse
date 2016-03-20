//
//  ToneGenerator.swift
//  Morse
//
//  Created by J.R.Hoem on 29.09.15.
//  Copyright © 2015 JRH. All rights reserved.
//
import Foundation
import AVFoundation


// The maximum number of audio buffers in flight. Setting to two allows one
// buffer to be played while the next is being written.
private let kInFlightAudioBuffers: Int = 2


public class MorseToneGen {
    
    // Singleton
    class var sharedInstance: MorseToneGen {
        struct Static {
            static let instance: MorseToneGen! = MorseToneGen()
        }
        return Static.instance
    }
    
    
    // The audio engine manages the sound system.
    private let engine: AVAudioEngine = AVAudioEngine()
    
    // The player node schedules the playback of the audio buffers.
    private let playerNode: AVAudioPlayerNode = AVAudioPlayerNode()
    
    // Use standard non-interleaved PCM audio.
    let audioFormat = AVAudioFormat(standardFormatWithSampleRate: 44100.0, channels: 2)
    
    private init() {

        // Attach and connect the player node.
        engine.attachNode(playerNode)
        engine.connect(playerNode, to: engine.mainMixerNode, format: audioFormat)
        
        do {
            try engine.start()
        } catch let err as NSError {
            print("Error starting audio engine: \(err)")
        }
    }
    
    public func play(frequency: Double, duration: Double) {
        
        let unitVelocity = Double(2.0 * M_PI / audioFormat.sampleRate)
        
        let samplesPerBuffer: AVAudioFrameCount = UInt32(duration * Double(audioFormat.sampleRate))

        
        var sampleTime: Double = 0
        
        // Fill the buffer with new samples.
        
        let audioBuffer = AVAudioPCMBuffer(PCMFormat: audioFormat, frameCapacity: samplesPerBuffer)
        
        let leftChannel = audioBuffer.floatChannelData[0]
        
        let rightChannel = audioBuffer.floatChannelData[1]
            
        for var sampleIndex = 0; sampleIndex < Int(samplesPerBuffer); sampleIndex++ {
        
            let sample = sin(unitVelocity * frequency * sampleTime)
            
            leftChannel[sampleIndex] = Float32(sample)
            rightChannel[sampleIndex] = Float32(sample)
            
            sampleTime++
        }
            
        audioBuffer.frameLength = samplesPerBuffer
        
        playerNode.scheduleBuffer(audioBuffer, completionHandler: nil)
        //playerNode.scheduleBuffer(audioBuffer,
            
        playerNode.pan = 0.8
        playerNode.volume = 0.8
        engine.mainMixerNode.volume = 0.8
        playerNode.play()
    }
    
    public func pause() {
        playerNode.pause()
    }
    
    public func stop() {
        playerNode.stop()
        
        //engine.reset()
    }
    
}
