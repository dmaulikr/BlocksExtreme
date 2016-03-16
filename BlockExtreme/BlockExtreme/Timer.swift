//
//  timer.swift
//  BlockExtreme
//
//  Created by Jason Chan MBP on 3/9/16.
//  Copyright © 2016 Jason Chan. All rights reserved.
//

import Foundation
import SpriteKit

class Timer {
    
    var seconds = 0
    var timer:NSTimer?
    
    var swiftris:Swiftris?
    
    func timerOn() {
        
        seconds = 120
        
        if (timer == nil) {
            timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("subtractTime"), userInfo: nil, repeats: true)}
    }
    
    func subtractTime() {
        seconds--
        print(seconds)
        
        if(seconds == 0)  {
            
            timer?.invalidate()
            
            swiftris?.endGame()
        }
        
    }
    
    
}
