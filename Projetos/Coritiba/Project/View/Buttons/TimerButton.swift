//
//  TimerButton.swift
//  
//
//  Created by Roberto Oliveira on 11/02/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

protocol TimerButtonDelegate:AnyObject {
    func timerButton(sender:TimerButton, didUpdateTimeAt time:TimeInterval)
    func timerButton(didTimeoutWith sender:TimerButton)
}

class TimerButton: CustomButton {
    
    weak var delegate:TimerButtonDelegate?
    // timer
    var timer:Timer?
    let timeInterval:TimeInterval = 0.01
    var totalTime:TimeInterval = 0.0
    var currentTime:TimeInterval = 0.0
    var delayOnTimeOut:TimeInterval = 1.0
    
    
    func startTimer() {
        self.stopTimer()
        self.currentTime = 0.0
        self.timer = Timer.scheduledTimer(timeInterval: self.timeInterval, target: self, selector: #selector(self.increaseTime), userInfo: nil, repeats: true)
        RunLoop.main.add(self.timer!, forMode: RunLoop.Mode.common)
    }
    
    
    @objc func increaseTime() {
        // Check for time out
        if self.currentTime >= self.totalTime {
            self.stopTimer()
            DispatchQueue.main.asyncAfter(deadline: .now()+self.delayOnTimeOut) {
                self.delegate?.timerButton(didTimeoutWith: self)
            }
            return
        }
        DispatchQueue.main.async {
            self.currentTime += self.timeInterval
            self.delegate?.timerButton(sender: self, didUpdateTimeAt: self.currentTime)
        }
    }
    
    private func stopTimer() {
        self.timer?.invalidate()
        self.timer = nil
    }
    
}

