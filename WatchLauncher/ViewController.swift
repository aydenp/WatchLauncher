//
//  ViewController.swift
//  WatchLauncher
//
//  Created by AppleBetas on 2016-07-09.
//  Copyright © 2016 AppleBetas. All rights reserved.
//

import UIKit
import WatchConnectivity

class ViewController: UIViewController, WCSessionDelegate {
    @IBOutlet weak var awLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let watchSupported = WCSession.isSupported()
        if watchSupported {
            let session = WCSession.default()
            session.delegate = self
            session.activate()
        }
        awLabel.isHidden = !watchSupported
    }

    @IBAction func crashPressed(_ sender: AnyObject) {
        self.sendMessage(withTitle: "Crash started", message: "The app has started attempting to crash the SpringBoard.") {
            self.crashSpringboard()
        }
    }
    
    func crashSpringboard() {
        let crasher = Crasher()
        crasher.crashSpringboard()
    }
    
    
    func sendMessage(withTitle title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: completion)
    }
    
    // MARK: - WatchConnectivity
    
    func session(_ session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void) {
        if let action = message["action"] as? String, action == "crash" {
            print("Told to crash by Watch")
            replyHandler(["response": "started"])
            DispatchQueue.main.async() {
                self.crashSpringboard()
            }
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState:
        WCSessionActivationState, error: NSError?) {
        if let error = error {
            print("session activation failed with error: \(error.localizedDescription)")
            return
        }
        print("Activated session with state \(activationState.rawValue)")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        WCSession.default().activate()
        print("Deactivated, activated new one")
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("Inactive")
    }

}

