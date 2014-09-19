//
//  ViewController.swift
//  BeaconQuotes
//
//  Created by Naomi Himley on 9/18/14.
//  Copyright (c) 2014 Naomi Himley. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class BQEnterUUIDViewController: UIViewController {
    @IBOutlet weak var uuidTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var displayQuoteTextView: UITextView!

    @IBOutlet weak var messageTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        let notyCenter:NSNotificationCenter = NSNotificationCenter.defaultCenter()
        let mainQueue = NSOperationQueue.mainQueue()

        notyCenter.addObserver(self, selector: "enteredRegion:", name: "EnteredRegionNotification:", object: nil)
    }


    @IBAction func onSaveButtonTapped(sender: AnyObject)
    {
        self.view.endEditing(true)
        //create and save a beacon model
        let beacon = Beacon.newBeacon(uuid: uuidTextField.text, name: nameTextField.text, displayString: messageTextField.text)
        //tell the manager to start monitoring for region
        let locManag:CLLocationManager! = CLLocationManager()
        locManag.requestAlwaysAuthorization()
        let beaconManag: BeaconManager = BeaconManager(locationManager: locManag)
        beaconManag.createCLRegion(beacon)
        self.displayQuoteTextView.text = "Your beacon has been saved.\n Your message will display when you next enter your beacon's boundaries."
    }

    //MARK: Notification Center Method
    func enteredRegion(notification:NSNotification)
    {
        let userInfo:Dictionary<String, String!> = notification.userInfo as Dictionary<String, String!>
        let messageString: String = userInfo["message"]!
        var alertski = UIAlertController(title: "You have entered a beacon region", message: messageString, preferredStyle: UIAlertControllerStyle.Alert)
        self.presentViewController(alertski, animated: true, completion: nil)
    }
}

