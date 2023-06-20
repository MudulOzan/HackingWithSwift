//
//  Person.swift
//  NamesToFaces
//
//  Created by Ozan Mudul on 29.12.2022.
//

import UIKit

class Person: NSObject, Codable {
	var name: String
	var image: String
	
	init(name: String, image: String) {
		self.name = name
		self.image = image
	}
}
