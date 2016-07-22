//
//  InterfaceController.swift
//  WatchLauncher Watch Extension
//
//  Created by AppleBetas on 2016-07-09.
//  Copyright © 2016 AppleBetas. All rights reserved.
//

import WatchKit
import WatchConnectivity

class InterfaceController: WKInterfaceController, WCSessionDelegate {
    var session: WCSession!

    @IBOutlet var crashSpringboardButton: WKInterfaceButton!
    override func awake(withContext context: AnyObject?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        self.session = WCSession.default()
        self.session.delegate = self
        self.session.activate()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState:
        WCSessionActivationState, error: NSError?) {
        if let error = error {
            print("session activation failed with error: \(error.localizedDescription)")
            return
        }
        print("Activated session with state \(activationState.rawValue)")
        self.crashSpringboardButton.setEnabled(session.isReachable)
    }
    
    func sessionReachabilityDidChange(_ session: WCSession) {
        self.crashSpringboardButton.setEnabled(session.isReachable)
    }

    @IBAction func crashSpringboardPressed() {
        self.crashSpringboardButton.setEnabled(false)
        self.crashSpringboardButton.setTitle("Sending...")
        session.sendMessage(["action": "crash"], replyHandler: { [weak self] response in
            self?.resetSpringboardButton()
            if let responseStr = response["response"] as? String, responseStr == "started" {
                self?.sendMessage(withTitle: "Command sent", message: "Sent a message to the iPhone app telling it to crash SpringBoard.\nIf the app was in the background, this may take a bit longer to take effect.")
            } else {
                self?.sendMessage(withTitle: "Error", message: "An error occurred with the iPhone app while to crash SpringBoard.")
            }
        }, errorHandler: { [weak self] _ in
            self?.resetSpringboardButton()
            self?.sendMessage(withTitle: "Error", message: "An error occurred while attempting to tell the iPhone app to crash SpringBoard.")
        })
    }
    
    func resetSpringboardButton() {
        self.crashSpringboardButton.setEnabled(session.isReachable)
        self.crashSpringboardButton.setTitle("iPhone SpringBoard")
    }
    
    func sendMessage(withTitle title: String, message: String) {
        let action = WKAlertAction(title: "Dismiss", style: .cancel) {}
        self.presentAlert(withTitle: title, message: message, preferredStyle: .alert, actions: [action])
    }
    
}
