//
//  SpotifyConvenience.swift
//  Musicly
//
//  Created by Sean Perez on 9/21/16.
//  Copyright © 2016 SeanPerez. All rights reserved.
//

import Foundation

extension SpotifyClient {
    func taskForGetMethod(_ parameters: [String:AnyObject], completionHandler: @escaping (_ result: AnyObject?, _ errorString: String?) -> Void) -> Void {
        let session = URLSession.shared
        let request = URLRequest(url: spotifyURLFromParameters(parameters))
        
        let task = session.dataTask(with: request) { (data, response, error) in
            func displayError(_ error: String) {
                print(error)
            }
            guard (error == nil) else {
                displayError("There was an error with your request: \(error)")
                return
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                displayError("Your request returned a status code other thatn 2xx!")
                return
            }
            guard let data = data else {
                displayError("No data was returned by the request")
                return
            }
            
            var parsedResult: AnyObject!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
            } catch {
                completionHandler(nil, "Could not parse the data as JSON: \(data)")
                return
            }
            
            guard let tracks = parsedResult["tracks"] as? [String:AnyObject] else {
                displayError("Cannot find key 'tracks' in \(parsedResult)")
                return
            }
            guard let items = tracks["items"] else {
                displayError("Cannot find key 'items' in \(tracks)")
                return
            }
            for i in 0..<items.count {
                var newTrack = Track()
                let item = items[i] as! [String:AnyObject]
                let name = item["name"] as! String
                newTrack.songName = name
                
                let previewURL = item["preview_url"] as! String
                newTrack.mediaURL = previewURL
                
                guard let artists = item["artists"] else {
                    displayError("Cannot find key 'artists' in \(item)")
                    return
                }
                let artistArray = artists[0] as! [String:AnyObject]
                let artist = artistArray["name"] as! String
                newTrack.artistName = artist
                
                guard let albumArray = item["album"] as? [String:AnyObject] else {
                    displayError("Cannot find key 'album' in \(item)")
                    return
                }
                guard let images = albumArray["images"] else {
                    displayError("Cannot find key 'images' in \(albumArray)")
                    return
                }
                let imageDict = images[1] as! [String:AnyObject]
                let albumURL = imageDict["url"] as! String
                newTrack.albumURL = albumURL
                print(albumURL)
            }
            
            completionHandler(parsedResult as AnyObject?, nil)
        }
        task.resume()
    }
}







