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
    func performReachability(completionHandler: @escaping (_ hasConnection: Bool) -> Void) {
        guard let reachability = Reachability() else {
            completionHandler(false)
            return
        }
        reachability.whenReachable = { reachability in
            DispatchQueue.main.async {
                if reachability.isReachable {
                    reachability.stopNotifier()
                    completionHandler(true)
                }
            }
        }
        reachability.whenUnreachable = { reachability in
            reachability.stopNotifier()
            completionHandler(false)
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    
}

