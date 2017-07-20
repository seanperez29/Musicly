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
        var request = URLRequest(url: spotifyURLFromParameters(parameters))
        request.httpMethod = "GET"
        request.addValue("Bearer BQDoeHR_uzcZaM0eL7nzswjdoSuNgaQbLms8B2ePxU4npYyaI0TBNMxoeZJpXcpMk2tTUIpt0PCKIjsbpUz5G6GBb6a00fMRW_rn7Pgvo7rFUjs7765Jxob0VEa_NQ85cOtCzWiJnQWnb3mNobKaHkt4gIOjGdk", forHTTPHeaderField: "Authorization")
        
        let task = session.dataTask(with: request) { (data, response, error) in
            func displayError(_ error: String) {
                print(error)
            }
            guard let internetError = (response as? HTTPURLResponse)?.statusCode, internetError != -1009 else {
                completionHandler(nil, "The internet access appears to be offline.")
                return
            }
            guard (error == nil) else {
                displayError("There was an error with your request: \(error!)")
                return
            }
            
            print("STATUS CODE: \(internetError)")
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                displayError("Your request returned a status code other than 2xx!")
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
            
            guard let tracks = parsedResult[Constants.SpotifyJSONKeys.Tracks] as? [String:AnyObject] else {
                displayError("Cannot find key '\(Constants.SpotifyJSONKeys.Tracks)' in \(parsedResult)")
                return
            }
            guard let items = tracks[Constants.SpotifyJSONKeys.Items] else {
                displayError("Cannot find key '\(Constants.SpotifyJSONKeys.Items)' in \(tracks)")
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
            let songName = item[Constants.SpotifyJSONKeys.Name]
            let previewURL = item[Constants.SpotifyJSONKeys.PreviewURL]
            let id = item[Constants.SpotifyJSONKeys.ID]
            dict[Constants.AudioTrack.SongName] = songName
            dict[Constants.AudioTrack.MediaURL] = previewURL
            dict[Constants.AudioTrack.ID] = id
   
            guard let artists = item[Constants.SpotifyJSONKeys.Artists] else {
                print("Cannot find key '\(Constants.SpotifyJSONKeys.Artists)' in \(item)")
                return
            }
            let artistArray = artists[0] as! [String:AnyObject]
            let artist = artistArray[Constants.SpotifyJSONKeys.Name]
            dict[Constants.AudioTrack.ArtistName] = artist

            guard let albumArray = item[Constants.SpotifyJSONKeys.Album] as? [String:AnyObject] else {
                print("Cannot find key '\(Constants.SpotifyJSONKeys.Album)' in \(item)")
                return
            }
            guard let images = albumArray[Constants.SpotifyJSONKeys.Images] else {
                print("Cannot find key '\(Constants.SpotifyJSONKeys.Images)' in \(albumArray)")
                return
            }
            let imageDict = images[1] as! [String:AnyObject]
            let albumURL = imageDict[Constants.SpotifyJSONKeys.URL]
            dict[Constants.AudioTrack.AlbumURL] = albumURL
            let newTrack = AudioTrack(dictionary: dict as [String:AnyObject])
            AudioTrackResults.sharedInstance.audioTracks.append(newTrack)
        }
    }
    
}
