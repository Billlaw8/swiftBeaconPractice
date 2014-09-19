//
//  BeaconManager.swift
//  BeaconQuotes
//
//  Created by Naomi Himley on 9/18/14.
//  Copyright (c) 2014 Naomi Himley. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import CoreData

class BeaconManager:NSObject, CLLocationManagerDelegate, NSFetchedResultsControllerDelegate {

    let moc = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
    let locationManager : CLLocationManager
    let fetchedResultsController:NSFetchedResultsController = NSFetchedResultsController()

    init(locationManager: CLLocationManager) {
        self.locationManager = locationManager
    }

    func createCLRegion(beacon: Beacon) -> CLRegion {
        let uuidString: String = beacon.uuidString
        let beaconIdentifier: String = beacon.name
        let beaconUUID: NSUUID = NSUUID(UUIDString: uuidString)
        let beaconRegion:CLBeaconRegion = CLBeaconRegion(proximityUUID: beaconUUID,
            identifier: beaconIdentifier)
        beginMonitoring(region: beaconRegion)
        return beaconRegion
    }

    func beginMonitoring(#region: CLRegion) {
        self.locationManager.delegate = self
        self.locationManager.startMonitoringForRegion(region)
    }

    // MARK: CLLocationManagerDelegate Methods

    func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!) {
        let regionIdentifier:String = region.identifier
        let request = requestForString(regionIdentifier)
        let fetchedResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: moc!, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultController.delegate = self
        fetchedResultController.performFetch(nil)
        var results:Array = fetchedResultsController.fetchedObjects!
        if !results.isEmpty {
            let beacon: Beacon = results[0] as Beacon
            let notyCenter = NSNotificationCenter.defaultCenter()
            notyCenter.postNotificationName("EnteredRegionNotification",
                object: nil,
                userInfo: ["message" : beacon.displayString])
        }
    }

    func requestForString(name: String) -> NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: "Beacon")
        let sortDescriptor = NSSortDescriptor(key: "uuidString", ascending: true)
        let predicate = NSPredicate(format: "name = \(name)")
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [sortDescriptor]
        return fetchRequest
    }
}



