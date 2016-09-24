//
//  Track.swift
//  Musicly
//
//  Created by Sean Perez on 9/21/16.
//  Copyright © 2016 SeanPerez. All rights reserved.
//

import Foundation
import UIKit

class Track {
    
    var artistName: String!
    var songName: String!
    var mediaURL: String!
    var albumURL: String!
    var id: String!
    var hasFavorited = false
    
    init(dictionary: [String:AnyObject]) {
        artistName = dictionary["artistName"] as! String
        songName = dictionary["songName"] as! String
        mediaURL = dictionary["mediaURL"] as! String
        albumURL = dictionary["albumURL"] as! String
        id = dictionary["id"] as! String
    }
    
    func toggleFavorited() {
        hasFavorited = !hasFavorited
    }
    
}
