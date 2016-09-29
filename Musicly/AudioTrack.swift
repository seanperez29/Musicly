//
//  AudioTrack.swift
//  Musicly
//
//  Created by Sean Perez on 9/21/16.
//  Copyright © 2016 SeanPerez. All rights reserved.
//

import Foundation
import UIKit

class AudioTrack {
    
    var artistName: String!
    var songName: String!
    var mediaURL: String!
    var albumURL: String!
    var id: String!
    var hasFavorited = false
    
    init(dictionary: [String:AnyObject]) {
        artistName = dictionary[Constants.AudioTrack.ArtistName] as! String
        songName = dictionary[Constants.AudioTrack.SongName] as! String
        mediaURL = dictionary[Constants.AudioTrack.MediaURL] as! String
        albumURL = dictionary[Constants.AudioTrack.AlbumURL] as! String
        id = dictionary[Constants.AudioTrack.ID] as! String
    }
    
    func toggleFavorited() {
        hasFavorited = !hasFavorited
    }
    
}
