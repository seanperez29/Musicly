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
            self.getTracksFromResults(items)
            completionHandler(parsedResult as AnyObject?, nil)
        }
        task.resume()
    }
    
    func getTracksFromResults(_ items: AnyObject) {
        for i in 0..<items.count {
            var dict = [String:AnyObject]()
            let item = items[i] as! [String:AnyObject]
            let songName = item["name"]
            let previewURL = item["preview_url"]
            let id = item["id"]
            dict["songName"] = songName
            dict["mediaURL"] = previewURL
            dict["id"] = id
   
            guard let artists = item["artists"] else {
                print("Cannot find key 'artists' in \(item)")
                return
            }
            let artistArray = artists[0] as! [String:AnyObject]
            let artist = artistArray["name"]
            dict["artistName"] = artist

            guard let albumArray = item["album"] as? [String:AnyObject] else {
                print("Cannot find key 'album' in \(item)")
                return
            }
            guard let images = albumArray["images"] else {
                print("Cannot find key 'images' in \(albumArray)")
                return
            }
            let imageDict = images[1] as! [String:AnyObject]
            let albumURL = imageDict["url"]
            dict["albumURL"] = albumURL
            let newTrack = Track(dictionary: dict as [String:AnyObject])
            TrackResults.sharedInstance.tracks.append(newTrack)
        }
    }
    
}
