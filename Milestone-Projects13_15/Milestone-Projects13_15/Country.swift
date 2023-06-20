//
//  Country.swift
//  CountryViewer
//
//  Created by Ozan Mudul on 22.01.2023.
//

import Foundation

struct Country: Codable {
	var id: Int
	var name: String
	var capitalCity: String
	var size: String
	var population: String
	var currency: String
}
