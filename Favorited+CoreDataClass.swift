//
//  Favorited+CoreDataClass.swift
//  Musicly
//
//  Created by Sean Perez on 9/24/16.
//  Copyright © 2016 SeanPerez. All rights reserved.
//

import Foundation
import CoreData

public class Favorited: NSManagedObject {
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    init(context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: "Favorited", in: context)!
        super.init(entity: entity, insertInto: context)
    }

}
