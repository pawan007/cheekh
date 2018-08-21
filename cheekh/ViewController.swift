//
//  ViewController.swift
//  cheekh
//
//  Created by pawan kumar on 18/08/18.
//  Copyright © 2018 fincop. All rights reserved.
//

import UIKit
import AVFoundation
import PhotosUI

class ViewController: UIViewController {
    
    @IBOutlet weak var progressView: CircularProgressView!
    @IBOutlet weak var timeLabel: UILabel!

    var timer = Timer()
    var timeLeftCounter: Int = 5
    var sosStatus: Int = 0
 
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 0.94, alpha: 1.0)
        progressView.trackColor = UIColor.green
        progressView.progressColor = UIColor.purple
        progressView.backgroundColor = UIColor.blue
        timeLabel.text = "Start"
        progressView.addSubview(timeLabel)
    }
    
    @IBAction func progressViewClick() {
        if sosStatus == 0 {
            sosStatus = 1
            startAnimation()
        }
        else if sosStatus == 1 {
            sosStatus = 0
            stopAnimation()
        }
        else if sosStatus == 2 {
            sosStatus = 0
            stopSOS()
        }
    }
    
    func startAnimation() {
        progressView.setProgressWithAnimation(duration: 0.1, value: 0.0)
        progressView.setProgressWithAnimation(duration: 5.0, value: 1.0)
        timeLeftCounter = 5
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        timeLabel.fadeTransition(0.4)
        timeLabel.text =  "\(timeLeftCounter)"
    }
    
    func stopAnimation() {
        timer.invalidate()
        timeLabel.fadeTransition(0.4)
        timeLabel.text = "Start"
        progressView.setProgressWithAnimation(duration: 0.0, value: 0.0)
    }
    
    
    func startSOS() {
        sosStatus = 2
        timer.invalidate()
        timeLabel.fadeTransition(0.4)
        timeLabel.text = "Stop"
        Sound.play(file: "tickle", fileExtension: "mp3", numberOfLoops: -1)
        //flash(shouldOn: true)
    }
    
     func stopSOS() {
        Sound.stopAll()
        timeLabel.fadeTransition(0.4)
        timeLabel.text = "Start"
        progressView.setProgressWithAnimation(duration: 0.0, value: 0.0)
        //flash(shouldOn: false)
    }
  
    @objc func flash(shouldOn : Bool ) {
        #if TARGET_IPHONE_SIMULATOR
        // Simulator
        #else
        // Device
        let device = AVCaptureDevice.default(for: AVMediaType.video)
        if (device?.hasTorch)! {
            do {
                try device?.lockForConfiguration()
                
                if shouldOn {
                    if (device?.torchMode == AVCaptureDevice.TorchMode.on) {
                        device?.torchMode = AVCaptureDevice.TorchMode.off
                    } else {
                        do {
                            try device?.setTorchModeOn(level: 1.0)
                        } catch {
                            print(error)
                        }
                    }
                }
                else {
                    if (device?.torchMode == AVCaptureDevice.TorchMode.on) {
                        device?.torchMode = AVCaptureDevice.TorchMode.off
                    }
                }
                device?.unlockForConfiguration()
            } catch {
                print(error)
            }
        }
        #endif
        
    }
    
    @objc func updateTime() {
        if timeLeftCounter > 0 {
            timeLeftCounter = timeLeftCounter - 1
            timeLabel.fadeTransition(0.4)
            timeLabel.text =  "\(timeLeftCounter)"
        } else {
            startSOS()
        }
    }
}

// Usage: insert view.fadeTransition right before changing content
extension UIView {
    func fadeTransition(_ duration:CFTimeInterval) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.type = kCATransitionFade
        animation.duration = duration
        layer.add(animation, forKey: kCATransitionFade)
    }
}
