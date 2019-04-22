//
//  GCD.swift
//  GYDO
//
//  Created by Fahad on 28/08/2018.
//  Copyright © 2018 AcclivousByte. All rights reserved.
//

import Foundation

var QueueBundleID = "com.abyte.gcd"

public enum GCGThreadType {
    case Main
    case High
    case Default
    case Low
    case Background
}

class GCD {
    
    
    static func async(_ thread: GCGThreadType, delay: Double = 0.0, execute:@escaping () -> Void) {
        
        let dispatchTime = DispatchTime.now()+delay
        
        if thread == .Main {
            DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: execute)
        }else if thread == .Background {
            let queue = DispatchQueue(label: QueueBundleID, qos: .background)
            queue.asyncAfter(deadline: dispatchTime, execute: execute)
        }else if thread == .Default {
            let queue = DispatchQueue(label: QueueBundleID, qos: .default)
            queue.asyncAfter(deadline: dispatchTime, execute: execute)
        }else if thread == .High {
            let queue = DispatchQueue(label: QueueBundleID, qos: .userInteractive)
            queue.asyncAfter(deadline: dispatchTime, execute: execute)
        }else if thread == .Low{
            let queue = DispatchQueue(label: QueueBundleID, qos: .unspecified)
            queue.asyncAfter(deadline: dispatchTime, execute: execute)
        }
    }
}
