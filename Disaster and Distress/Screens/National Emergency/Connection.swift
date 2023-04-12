//
//  Connection.swift
//  reachability-playground
//
//  Created by Neo Ighodaro on 27/10/2017.
//  Copyright © 2017 CreativityKills Co. All rights reserved.
//

import Foundation


extension Notification.Name {
    public static let reachabilityChanged = Notification.Name("reachabilityChanged")
}
class NetworkManager: NSObject {

    var reachability: Reachability!
    
    static let sharedInstance: NetworkManager = { return NetworkManager() }()
    
    
    override init() {
        super.init()

        reachability = Reachability()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(networkStatusChanged(_:)),
            name: .reachabilityChanged,
            object: reachability
        )
        
//        do {
//            try reachability.startNotifier()
//        } catch {
//            print("Unable to start notifier")
//        }
    }
    
    @objc func networkStatusChanged(_ notification: Notification) {
        // Do something globally here!
    }
    
    static func stopNotifier() -> Void {
//        do {
//            try (NetworkManager.sharedInstance.reachability).startNotifier()
//        } catch {
//            print("Error stopping notifier")
//        }
    }

    static func isReachable(completed: @escaping (NetworkManager) -> Void) {
        if Reachability.isConnectedToNetwork() == true { 
            completed(NetworkManager.sharedInstance)
        }
    }
    
    static func isUnreachable(completed: @escaping (NetworkManager) -> Void) {
        if Reachability.isConnectedToNetwork() != true {
            completed(NetworkManager.sharedInstance)
        }
    }
   
}
