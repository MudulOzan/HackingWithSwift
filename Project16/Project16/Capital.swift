//
//  Capital.swift
//  Project16
//
//  Created by Ozan Mudul on 30.01.2023.
//

import UIKit
import MapKit

class Capital: NSObject, MKAnnotation {
	var title: String?
	var coordinate: CLLocationCoordinate2D
	var info: String
	
	init(title: String? = nil, coordinate: CLLocationCoordinate2D, info: String) {
		self.title = title
		self.coordinate = coordinate
		self.info = info
	}
}
