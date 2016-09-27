//
//  Category.swift
//  Musicly
//
//  Created by Sean Perez on 9/26/16.
//  Copyright © 2016 SeanPerez. All rights reserved.
//

import Foundation

class Category {
    var name: String!
    var songs: [ArtistTrack]!
    
    init(name: String, songs: [ArtistTrack]) {
        self.name = name
        self.songs = songs
    }
}
