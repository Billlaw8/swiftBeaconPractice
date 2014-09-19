//
//  BeaconQuotes.swift
//  BeaconQuotes
//
//  Created by Naomi Himley on 9/19/14.
//  Copyright (c) 2014 Naomi Himley. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Beacon: NSManagedObject {

    @NSManaged var uuidString: String
    @NSManaged var name: String
    @NSManaged var displayString: String

    class func newBeacon(#uuid: String, name: String, displayString: String) -> Beacon
    {
        let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
        let entityDescripition = NSEntityDescription.entityForName("Beacon", inManagedObjectContext: managedObjectContext!)
        let beacon = Beacon(entity: entityDescripition!, insertIntoManagedObjectContext: managedObjectContext)
        beacon.uuidString = uuid
        beacon.name = name
        beacon.displayString = displayString
        managedObjectContext?.save(nil)
        return beacon
    }

}
