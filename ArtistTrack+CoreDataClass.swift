//
//  ArtistTrack+CoreDataClass.swift
//  Musicly
//
//  Created by Sean Perez on 9/24/16.
//  Copyright © 2016 SeanPerez. All rights reserved.
//

import Foundation
import CoreData

public class ArtistTrack: NSManagedObject {

    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    init(audioTrack: AudioTrack, context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: "ArtistTrack", in: context)!
        super.init(entity: entity, insertInto: context)
        self.album = audioTrack.albumURL
        self.media = audioTrack.mediaURL
        self.song = audioTrack.songName
        self.artist = audioTrack.artistName
        self.isFavorite = audioTrack.hasFavorited
        self.trackID = audioTrack.id
        self.creationDate = Date() as NSDate
    }
}
