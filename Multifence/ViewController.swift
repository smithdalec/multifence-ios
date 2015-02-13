//
//  ViewController.swift
//  Multifence
//
//  Created by Dale Smith on 1/23/15.
//  Copyright (c) 2015 Dale Smith. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    
    var locationManager = CLLocationManager()
    var lastEnter = NSDate()
    var lastExit = NSDate()
    @IBOutlet var statusText: UILabel?
    @IBOutlet var derp: String?

    
    //------------------------------------------------------------------------------------------------------------------
    // UIViewController delegate methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var loc = CLLocationCoordinate2D(latitude: CLLocationDegrees(27.8465666), longitude: CLLocationDegrees(-82.635896))
        var region = CLCircularRegion(center: loc, radius: CLLocationDistance(50), identifier: "home")
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.activityType = CLActivityType.AutomotiveNavigation
        locationManager.startMonitoringForRegion(region)
        
        statusText?.text = "Geofence is active!"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //------------------------------------------------------------------------------------------------------------------
    // CLLocationManagerDelegate methods
    
    // Handle location errors
    internal func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        alert("Are you lost? Your location can't be found")
    }
    
    // Handle the user entering a region
    func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!) {
        if locationNeedsUpdating(lastEnter) {
            lastEnter = NSDate()
            notification("You entered the geofence")
        }
    }
    
    // Handle the user exiting a region
    func locationManager(manager: CLLocationManager!, didExitRegion region: CLRegion!) {
        if locationNeedsUpdating(lastExit) {
            lastExit = NSDate()
            notification("You left the geofence")
        }
    }
    
    //------------------------------------------------------------------------------------------------------------------
    // Internal methods
    
    
    // Whether or not a location needs to be updated. In our case, we don't let duplicate location updates
    // run within ten seconds. This is because the locationManagerDidEnterRegion and locationManagerDidExitRegion
    // methods are called multiple times at once
    func locationNeedsUpdating(lastDate: NSDate) -> Bool {
        var currentTime = NSDate()
        if (currentTime.timeIntervalSince1970 - lastDate.timeIntervalSince1970) > 10 {
            return true
        }
        return false
    }
    
    
    // Send an alert to the user
    func alert(message: String) {
        var alertController = UIAlertController(title: "Update", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    // Send an iOS notification to the user
    func notification(message: String) {
        var localNotification:UILocalNotification = UILocalNotification()
        localNotification.alertAction = "Geofence"
        localNotification.alertBody = message
        localNotification.fireDate = NSDate(timeIntervalSinceNow: 0)
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
        
        NSLog(message)
    }
}
