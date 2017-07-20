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
        let methodParameters = [Constants.SpotifyParameterKeys.Q: artist, Constants.SpotifyParameterKeys.SearchType: Constants.SpotifyParameterValues.SearchTracks, Constants.SpotifyParameterKeys.Limit: Constants.SpotifyParameterValues.SearchLimit]
        
        taskForGetMethod(methodParameters as [String : AnyObject]) { (result, errorString) in
            guard (errorString == nil) else {
                print("There was an error: \(errorString!)")
                completionHandler(nil, errorString)
                return
            }
            completionHandler(result, nil)
        }
        
    }
    
    func spotifyURLFromParameters(_ parameters: [String:AnyObject]) -> URL {
        var components = URLComponents()
        components.scheme = Constants.SpotifyURL.Scheme
        components.host = Constants.SpotifyURL.Host
        components.path = Constants.SpotifyURL.Path
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        return components.url!
    }
    
    func getImage(_ imageUrl: String, completionHandler: @escaping (_ imageData: Data?, _ errorString: String?) -> Void) -> URLSessionDataTask {
        let url = URL(string: imageUrl)
        let request = URLRequest(url: url!)
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: {data, response, error in
            if let error = error {
                completionHandler(nil, error.localizedDescription)
            } else {
                completionHandler(data, nil)
            }
        })
        task.resume()
        return task
    }
    
}
