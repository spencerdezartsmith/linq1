//
//  ViewController.swift
//  BeaconPop
//
//  Created by Gabriel Theodoropoulos on 10/3/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

import UIKit
import QuartzCore
import CoreLocation
import CoreBluetooth


class FirstViewController: UIViewController, CBPeripheralManagerDelegate {
    
    @IBOutlet weak var btnAction: UIButton!
    
    @IBOutlet weak var lblStatus: UILabel!
    
    @IBOutlet weak var lblBTStatus: UILabel!
    
    @IBOutlet weak var txtMajor: UILabel!
    
    @IBOutlet weak var txtMinor: UILabel!
    
    // Here were would reference the user.major field
    
    let uuid = NSUUID(UUIDString: "8492E75F-4FD6-469D-B132-043FE94921D8")
    
    var beaconRegion: CLBeaconRegion!
    
    var bluetoothPeripheralManager: CBPeripheralManager!
    
    var isBroadcasting = false
    
    var dataDictionary = NSDictionary()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.txtMajor.text = "14"
        print(self.txtMajor.text)
        //        btnAction.layer.cornerRadius = btnAction.frame.size.width
        
        self.view.backgroundColor = UIColor(red:0.14, green:0.66, blue:0.88, alpha:1.0)
        
        let swipeDownGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(FirstViewController.handleSwipeGestureRecognizer(_:)))
        swipeDownGestureRecognizer.direction = UISwipeGestureRecognizerDirection.Down
        view.addGestureRecognizer(swipeDownGestureRecognizer)
        
        
        bluetoothPeripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: Custom method implementation
    
    func handleSwipeGestureRecognizer(gestureRecognizer: UISwipeGestureRecognizer) {
        txtMajor.resignFirstResponder()
        txtMinor.resignFirstResponder()
    }
    
    
    // MARK: IBAction method implementation
    
    @IBAction func switchBroadcastingState(sender: AnyObject) {
        if txtMajor.text == "" || txtMinor.text == "" {
            return
        }
        
        if txtMajor.isFirstResponder() || txtMinor.isFirstResponder() {
            return
        }
        
        
        if !isBroadcasting {
            if bluetoothPeripheralManager.state == CBPeripheralManagerState.PoweredOn {
                let major: CLBeaconMajorValue = UInt16(Int(txtMajor.text!)!)
                print(major)
                let minor: CLBeaconMinorValue = UInt16(Int(txtMinor.text!)!)
                beaconRegion = CLBeaconRegion(proximityUUID: uuid!, major: major, minor: minor, identifier: "com.appcoda.beacondemo")
                
                dataDictionary = beaconRegion.peripheralDataWithMeasuredPower(nil)
                bluetoothPeripheralManager.startAdvertising(dataDictionary as? [String : AnyObject])
                
                btnAction.setTitle("", forState: UIControlState.Normal)
                lblStatus.text = "    Linqing....."
                txtMajor.enabled = false
                txtMinor.enabled = false
                
                isBroadcasting = true
            }
        }
        else {
            bluetoothPeripheralManager.stopAdvertising()
            
            btnAction.setTitle("", forState: UIControlState.Normal)
            lblStatus.text = "Touch to Linq"
            
            txtMajor.enabled = true
            txtMinor.enabled = true
            
            isBroadcasting = false
        }
    }
    
    
    // MARK: CBPeripheralManagerDelegate method implementation
    
    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager) {
        var statusMessage = ""
        
        switch peripheral.state {
        case CBPeripheralManagerState.PoweredOn:
            statusMessage = "Bluetooth Status: Turned On"
            
        case CBPeripheralManagerState.PoweredOff:
            if isBroadcasting {
                switchBroadcastingState(self)
            }
            statusMessage = "Bluetooth Status: Turned Off"
            
        case CBPeripheralManagerState.Resetting:
            statusMessage = "Bluetooth Status: Resetting"
            
        case CBPeripheralManagerState.Unauthorized:
            statusMessage = "Bluetooth Status: Not Authorized"
            
        case CBPeripheralManagerState.Unsupported:
            statusMessage = "Bluetooth Status: Not Supported"
            
        default:
            statusMessage = "Bluetooth Status: Unknown"
        }
        
        lblBTStatus.text = statusMessage
    }
    
}

