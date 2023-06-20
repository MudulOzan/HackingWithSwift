//
//  ViewController.swift
//  Project22
//
//  Created by Ozan Mudul on 25.02.2023.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
	@IBOutlet var distanceReading: UILabel!
	var locationManager: CLLocationManager?
	var isShown: Bool = false
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		locationManager = CLLocationManager()
		locationManager?.delegate = self
		locationManager?.requestAlwaysAuthorization()
		
		view.backgroundColor = .gray
	}
	
	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//		if status == .authorizedAlways {
			if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
				if CLLocationManager.isRangingAvailable() {
					startScanning()
				} else {
					let ac = UIAlertController(title: "Ranging not avail", message: nil, preferredStyle: .alert)
					ac.addAction(UIAlertAction(title: "OK", style: .default))
					present(ac, animated: true)				}
			} else {
				let ac = UIAlertController(title: "Monitoring not avail", message: nil, preferredStyle: .alert)
				ac.addAction(UIAlertAction(title: "OK", style: .default))
				present(ac, animated: true)			}
//		} else {
//			print("status not ok")
//		}
	}
	
	func startScanning() {
		let uuid = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!
		let beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: 123, minor: 456, identifier: "MyBeacon")
		
		locationManager?.startMonitoring(for: beaconRegion)
		locationManager?.startRangingBeacons(in: beaconRegion)
	}
	
	func update(distance: CLProximity) {
		UIView.animate(withDuration: 1) {
			switch distance {
				
			case .far:
				self.view.backgroundColor = UIColor.blue
				self.distanceReading.text = "FAR"
				
			case .near:
				self.view.backgroundColor = UIColor.orange
				self.distanceReading.text = "NEAR"
				
			case .immediate:
				self.view.backgroundColor = UIColor.red
				self.distanceReading.text = "RIGHT HERE"
			default:
				self.view.backgroundColor = UIColor.gray
				self.distanceReading.text = "UNKNOWN"
			}
		}
	}
	
	func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
		if let beacon = beacons.first {
			if(!isShown) {
				isShown = true
				let ac = UIAlertController(title: "Beacon detected", message: nil, preferredStyle: .alert)
				ac.addAction(UIAlertAction(title: "OK", style: .default))
				present(ac, animated: true)
			}
			update(distance: beacon.proximity)
		} else {
			update(distance: .unknown)
		}
	}
}

