//
//  ViewController.swift
//  DetectBeacon
//
//  Created by Ani Adhikary on 08/01/18.
//  Copyright © 2018 Ani Adhikary. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var distanceReading: UILabel!
    
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        //1-Step 1
        locationManager.requestAlwaysAuthorization()
        
        view.backgroundColor = UIColor.gray
    }

    //3-Step 3
    func startScanning() {
        let uuid = UUID(uuidString: "2f234454-cf6d-4a0f-adf2-f4911ba9ffa6")!
        //let beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: 25, minor: 5, identifier: "MyBeacon")
        
        let beaconRegion = CLBeaconRegion(proximityUUID: uuid, identifier: "MyBeacon")
        locationManager.startMonitoring(for: beaconRegion)
        locationManager.startRangingBeacons(in: beaconRegion)
    }
    
    func update(distance: CLProximity) {
        UIView.animate(withDuration: 0.8) { [unowned self] in
            switch distance {
            case .unknown:
                self.view.backgroundColor = UIColor.gray
                self.distanceReading.text = "UNKNOWN"
                
            case .far:
                self.view.backgroundColor = UIColor.blue
                self.distanceReading.text = "FAR"
                
            case .near:
                self.view.backgroundColor = UIColor.orange
                self.distanceReading.text = "NEAR"
                
            case .immediate:
                self.view.backgroundColor = UIColor.red
                self.distanceReading.text = "RIGHT HERE"
            }
        }
    }
}

extension ViewController: CLLocationManagerDelegate {
    
    //2-Step 2
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                }
            }
        }
    }

    //4-Step 4
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if beacons.count > 0 {
            let beacon = beacons[0]
            update(distance: beacon.proximity)
            //print("Beacon successfully found!!!!!")
            print(beacons.count)
        } else {
            update(distance: .unknown)
        }
    }
}
