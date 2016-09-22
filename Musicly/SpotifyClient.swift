//
//  SpotifyClient.swift
//  Musicly
//
//  Created by Sean Perez on 9/21/16.
//  Copyright © 2016 SeanPerez. All rights reserved.
//

import Foundation

class SpotifyClient: NSObject {
    static var sharedInstance = SpotifyClient()
    
    func loadTracks(_ artist: String, completionHandler: @escaping (_ results: AnyObject?, _ errorString: String?) -> Void) {
        let methodParameters = ["q": artist, "type": "track"]
        
        taskForGetMethod(methodParameters as [String : AnyObject]) { (result, errorString) in
            guard (errorString == nil) else {
                print("There was an error: \(errorString)")
                completionHandler(nil, errorString)
                return
            }
        }
        
    }
    
    func spotifyURLFromParameters(_ parameters: [String:AnyObject]) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.spotify.com"
        components.path = "/v1/search"
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        return components.url!
    }
    
}
