//
//  WatchManager.swift
//  RxTestApp
//
//  Created by Mert Tuzer on 8.05.2021.
//

import Foundation
import WatchConnectivity

class WatchManager: NSObject {
    static let shared = WatchManager()
    fileprivate var watchSession: WCSession?
    
    override init() {
        super.init()
        if !WCSession.isSupported() {
            watchSession = nil
            return
        }
        watchSession = WCSession.default
        watchSession?.delegate = self
        watchSession?.activate()
    }
    
    func sendParametersToWatch(params: [String: Any]) {
        do {
            var parameters = params
            parameters["time"] = Date().timeIntervalSince1970
            print("---", parameters)
            try watchSession?.updateApplicationContext(parameters)
        } catch  {
            print("---Error while sending data to watch with: \(error)")
        }
    }
    
    func isWatchPaired() -> Bool {
        watchSession?.isPaired ?? false
    }
}

extension WatchManager: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("---Activation Complete")
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("---Activation Inactive")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print("---DeActivated")
    }
    
    func sessionReachabilityDidChange(_ session: WCSession) {
        print("---Reachability changed to: \(session.isReachable)")
    }
    
    func sessionWatchStateDidChange(_ session: WCSession) {
        var state = ""
        
        switch session.activationState {
        case .notActivated:
            state = "notActivated"
        case .inactive:
            state = "inactive"
        case .activated:
            state = "activated"
        @unknown default:
            state = "unknown"
        }
        print("---Watch state changed to: \(state)")
    }
}
