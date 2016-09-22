//
//  Track.swift
//  Musicly
//
//  Created by Sean Perez on 9/21/16.
//  Copyright © 2016 SeanPerez. All rights reserved.
//

import Foundation

struct Track {
    
    var artistName: String!
    var songName: String!
    var mediaURL: String!
    var albumURL: String!
    
    init(dictionary: [String:AnyObject]) {
        artistName = dictionary["artistName"] as! String
        songName = dictionary["songName"] as! String
        mediaURL = dictionary["mediaURL"] as! String
        albumURL = dictionary["albumURL"] as! String
    }
}
