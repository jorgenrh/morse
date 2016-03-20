//
//  TorchGenerator.swift
//  Morse
//
//  Created by J.R.Hoem on 29.09.15.
//  Copyright © 2015 JRH. All rights reserved.
//

import Foundation
import AVFoundation

let kMDMorseTorchQueueFinished = "com.tidybits.morseTorchQueueFinished"

public class TorchGenerator: NSObject {

    
    // Torch available
    public var hasTorch: Bool = false
    
    // Capture device
    private var device: AVCaptureDevice? = nil
    
    // Thread queue
    private let torchQueue = NSOperationQueue()

    
    // Singleton
    class var sharedInstance: TorchGenerator {
        struct Static {
            static let instance: TorchGenerator! = TorchGenerator()
        }
        return Static.instance
    }
    
    
    // Initialize, check if torch exists and set queuemode to serial
    override private init() {
        super.init()
        
        if let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo) {
            self.device = device
            hasTorch = true
        }
        
        torchQueue.maxConcurrentOperationCount = 1
        torchQueue.addObserver(self, forKeyPath: "operationCount", options: .New, context: nil)
    }

    
    
    // Set torch to level with duration
    public func setTorch(level: Double, duration: Int, endLevel: Double = 0) {
        
        if device == nil {
            return
        }
        
        let dur: UInt32 = UInt32(duration * 1000)
        
        torchQueue.addOperationWithBlock({
            
            self.setTorchLevel(level)
            usleep(dur)
            self.setTorchLevel(endLevel)
        
        })
        
    }
    
    
    // Cancel sequence
    func stop() {
        torchQueue.cancelAllOperations()
    }

    
    // Pause sequence
    func pause() -> Bool {
        let status: Bool = !torchQueue.suspended
        torchQueue.suspended = status
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
        if (obj == self.torchQueue && keyPath! == "operationCount") {
            if obj?.operationCount == 0 {
                print("*** Torch queue finished")
                NSNotificationCenter.defaultCenter().postNotificationName(kMDMorseTorchQueueFinished, object: self)
            }
        }
    }

    
}
