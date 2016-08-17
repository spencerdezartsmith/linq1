//
//  ViewController.swift
//  BeaconSpot
//
//  Created by Gabriel Theodoropoulos on 10/3/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

import UIKit
import QuartzCore
import CoreLocation


class LinqDownViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var btnSwitchSpotting: UIButton!
    
    @IBOutlet weak var lblBeaconReport: UILabel!
    
    @IBOutlet weak var lblBeaconDetails: UILabel!
    
    var setMajor:NSNumber?
    
    
    var beaconRegion: CLBeaconRegion!
    
    var locationManager: CLLocationManager!
    
    var isSearchingForBeacons = false
    
    var lastFoundBeacon: CLBeacon! = CLBeacon()
    
    var lastProximity: CLProximity! = CLProximity.Unknown
    
    var major:Int = 32;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        lblBeaconDetails.hidden = true
        btnSwitchSpotting.layer.cornerRadius = 30.0
        
        self.view.backgroundColor = UIColor(red:0.14, green:0.66, blue:0.88, alpha:1.0)
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        let uuid = NSUUID(UUIDString: "8492E75F-4FD6-469D-B132-043FE94921D8")
        beaconRegion = CLBeaconRegion(proximityUUID: uuid!, identifier: "com.appcoda.beacondemo")
        //        print(beaconRegion.major)
        
        beaconRegion.notifyOnEntry = true
        beaconRegion.notifyOnExit = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: IBAction method implementation
    
    @IBAction func switchSpotting(sender: AnyObject) {
        if !isSearchingForBeacons {
            locationManager.requestAlwaysAuthorization()
            locationManager.startMonitoringForRegion(beaconRegion)
            locationManager.startUpdatingLocation()
            
            btnSwitchSpotting.setTitle("Stop Spotting", forState: UIControlState.Normal)
            lblBeaconReport.text = "Linqing..."
        }
        else {
            locationManager.stopMonitoringForRegion(beaconRegion)
            locationManager.stopRangingBeaconsInRegion(beaconRegion)
            locationManager.stopUpdatingLocation()
            
            btnSwitchSpotting.setTitle("Start Spotting", forState: UIControlState.Normal)
            lblBeaconReport.text = "Touch to Linq"
            lblBeaconDetails.hidden = true
        }
        
        isSearchingForBeacons = !isSearchingForBeacons
    }
    
    
    func locationManager(manager: CLLocationManager, didStartMonitoringForRegion region: CLRegion) {
        locationManager.requestStateForRegion(region)
    }
    
    
    func locationManager(manager: CLLocationManager, didDetermineState state: CLRegionState, forRegion region: CLRegion) {
        if state == CLRegionState.Inside {
            locationManager.startRangingBeaconsInRegion(beaconRegion)
        }
        else {
            locationManager.stopRangingBeaconsInRegion(beaconRegion)
        }
    }
    
    
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        lblBeaconReport.text = "Linq in range"
        lblBeaconDetails.hidden = false
    }
    
    
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        lblBeaconReport.text = "No linqs in range"
        lblBeaconDetails.hidden = true
    }
    
    
    func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {
        var shouldHideBeaconDetails = true
        
        let foundBeacons = beacons
        if foundBeacons.count > 0 {
            if let closestBeacon = foundBeacons[0] as? CLBeacon {
                if closestBeacon != lastFoundBeacon || lastProximity != closestBeacon.proximity  {
                    lastFoundBeacon = closestBeacon
                    lastProximity = closestBeacon.proximity
                    
                    var proximityMessage: String!
                    switch lastFoundBeacon.proximity {
                    case CLProximity.Immediate:
                        proximityMessage = "Great"
                        
                    case CLProximity.Near:
                        proximityMessage = "Good"
                        
                    case CLProximity.Far:
                        proximityMessage = "Get closer"
                        
                    default:
                        proximityMessage = "Where's the beacon?"
                    }
                    
                    shouldHideBeaconDetails = false
                    // here is the major variable that needs to be sent back to
                    // react or rails
                    self.setMajor = closestBeacon.major
                    lblBeaconDetails.text = "\nDistance: " + proximityMessage
                    
                    // this is the output of that variable
                    print(self.setMajor)
                    
                }
            }
        }
        
        
        lblBeaconDetails.hidden = shouldHideBeaconDetails
    }
    
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error)
    }
    
    
    func locationManager(manager: CLLocationManager, monitoringDidFailForRegion region: CLRegion?, withError error: NSError) {
        print(error)
    }
    
    
    func locationManager(manager: CLLocationManager, rangingBeaconsDidFailForRegion region: CLBeaconRegion, withError error: NSError) {
        print(error)
    }
}

