//
//  ArtistTrack+CoreDataProperties.swift
//  Musicly
//
//  Created by Sean Perez on 9/24/16.
//  Copyright © 2016 SeanPerez. All rights reserved.
//

import Foundation
import CoreData

extension ArtistTrack {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ArtistTrack> {
        return NSFetchRequest<ArtistTrack>(entityName: "ArtistTrack");
    }

    @NSManaged public var album: String
    @NSManaged public var artist: String
    @NSManaged public var creationDate: NSDate
    @NSManaged public var imageData: Data?
    @NSManaged public var isFavorite: Bool
    @NSManaged public var media: String
    @NSManaged public var song: String
    @NSManaged public var trackID: String
    @NSManaged public var favorited: Favorited?
    @NSManaged public var recentlyPlayed: RecentlyPlayed?

}
