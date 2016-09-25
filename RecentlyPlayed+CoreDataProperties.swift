//
//  RecentlyPlayed+CoreDataProperties.swift
//  Musicly
//
//  Created by Sean Perez on 9/24/16.
//  Copyright © 2016 SeanPerez. All rights reserved.
//

import Foundation
import CoreData

extension RecentlyPlayed {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecentlyPlayed> {
        return NSFetchRequest<RecentlyPlayed>(entityName: "RecentlyPlayed");
    }

    @NSManaged public var artistTrack: NSSet?

}

// MARK: Generated accessors for artistTrack
extension RecentlyPlayed {

    @objc(addArtistTrackObject:)
    @NSManaged public func addToArtistTrack(_ value: ArtistTrack)

    @objc(removeArtistTrackObject:)
    @NSManaged public func removeFromArtistTrack(_ value: ArtistTrack)

    @objc(addArtistTrack:)
    @NSManaged public func addToArtistTrack(_ values: NSSet)

    @objc(removeArtistTrack:)
    @NSManaged public func removeFromArtistTrack(_ values: NSSet)

}
