//
//  ViewController.swift
//  Morse
//
//  Created by J.R.Hoem on 28.09.15.
//  Copyright © 2015 JRH. All rights reserved.
//
/*
https://stackoverflow.com/questions/7298342/generating-morse-code-style-tones-in-objective-c
You need to be able to generate tones of a specific duration, separated by silences of a specific duration. So long as you have these two building blocks you can send morse code:

dot = 1 unit
dash = 3 units
space between dots/dashes within a letter = 1 unit
space between letters = 3 units
space between words = 5 units
The length of unit determines the overall speed of the morse code. Start with e.g. 50 ms.

The tone should just be a pure sine wave at an appropriate frequency, e.g. 400 Hz. The silence can just be an alternate buffer containing all zeroes. That way you can "play" both the tone and the silence using the same API, without worrying about timing/synchronisation, etc.
*/

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var encodedTextView: MDTextView!
    @IBOutlet weak var decodedTextView: MDTextView!
    
    let morse = MorseTranslater()

    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        for _ in 1...10 {
            TorchGenerator.sharedInstance.setTorch(0.1, duration: 1000)
            TorchGenerator.sharedInstance.setTorch(0.0, duration: 1000)
        }
        */
        //self.addDoneButtonOnKeyboard(encodedTextView)
        //self.addDoneButtonOnKeyboard(decodedTextView)
    }
    /*
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRectMake(0, 0, 320, 50))
        doneToolbar.barStyle = UIBarStyle.BlackTranslucent
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        var done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: Selector("doneButtonAction"))
        //let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: view, action: "resignFirstResponder")
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.encodedTextView.inputAccessoryView = doneToolbar
        self.decodedTextView.inputAccessoryView = doneToolbar
        
    }
    
    func doneButtonAction()
    {
        self.encodedTextView.resignFirstResponder()
        self.decodedTextView.resignFirstResponder()
    }
    */
    
    func addDoneButtonOnKeyboard(view: UIView?)
    {
        
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRectMake(0, 0, 320, 50))
        doneToolbar.barStyle = UIBarStyle.BlackTranslucent
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: view, action: "resignFirstResponder")
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items //as? [UIBarButtonItem]
        doneToolbar.sizeToFit()
        if let accessorizedView = view as? UITextView {
            accessorizedView.inputAccessoryView = doneToolbar
            accessorizedView.inputAccessoryView = doneToolbar
        } else if let accessorizedView = view as? UITextField {
            accessorizedView.inputAccessoryView = doneToolbar
            accessorizedView.inputAccessoryView = doneToolbar
        }
        
    }
    

    
    @IBAction func encodeBtnPressed(sender: UIButton) {
        let encode = morse.encodeText(encodedTextView.text)
        decodedTextView.text = encode
    }
    
    
    @IBAction func decodeBtnPressed(sender: UIButton) {
        let decode = morse.decodeText(decodedTextView.text)
        encodedTextView.text = decode
    }

    @IBAction func playBtnPressed(sender: UIButton) {
        if sender.titleLabel?.text == "Tone" {
            sender.setTitle("Stop", forState: .Normal)
            morse.playTone(decodedTextView.text)
        } else {
            sender.setTitle("Tone", forState: .Normal)
            morse.stopTone()
        }
    }

    @IBAction func torchBtnPressed(sender: UIButton) {
        if sender.titleLabel?.text == "Torch" {
            sender.setTitle("Stop", forState: .Normal)
            morse.runTorch(decodedTextView.text)
        } else {
            sender.setTitle("Torch", forState: .Normal)
            morse.stopTorch()
        }
    }
    
    @IBAction func toneTorchBtnPressed(sender: UIButton) {
        if sender.titleLabel?.text == "Tone & Torch" {
            sender.setTitle("Stop", forState: .Normal)
            //morse.runToneTorch(decodedTextView.text)
            morse.runAV(decodedTextView.text)
        } else {
            sender.setTitle("Tone & Torch", forState: .Normal)
            morse.stopAV()
        }
    }
    

    
}

