//
//  File.swift
//  ConsolidationVIII
//
//  Created by Ozan Mudul on 9.02.2023.
//

import Foundation

struct Note: Codable {
	var key: UUID
	var title: String
	var content: String
	
	init(key: UUID = UUID(), title: String, content: String) {
		self.key = key
		self.title = title
		self.content = content
	}
	
}
