//
//  RechabilityConvenience.swift
//  Musicly
//
//  Created by Sean Perez on 9/30/16.
//  Copyright © 2016 SeanPerez. All rights reserved.
//

import Foundation
import SystemConfiguration

class ReachabilityConvenience {
    static let sharedInstance = ReachabilityConvenience()
    var reachability: Reachability!

    func setupReachability(hostName: String, useClosures: Bool, completionHander: @escaping (_ hasConnection:Bool) -> Void) {
        let reachability = Reachability(hostname: hostName)
        self.reachability = reachability
        
        if useClosures {
            reachability?.whenReachable = { reachability in
                DispatchQueue.main.async {
                    self.stopNotifier()
                    completionHander(true)
                }
            }
            reachability?.whenUnreachable = { reachability in
                DispatchQueue.main.async {
                    self.stopNotifier()
                    completionHander(false)
                }
            }
        }
    }

    func startNotifier() {
        do {
            try reachability?.startNotifier()
        } catch {
            return
        }
    }
    
    func stopNotifier() {
        reachability?.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: ReachabilityChangedNotification, object: nil)
        reachability = nil
    }
    
}
    
