//
//  Petition.swift
//  WhitehousePetitions
//
//  Created by Ozan Mudul on 13.12.2022.
//

import Foundation

struct Petition: Codable {
    var title: String
    var body: String
    var signatureCount: Int
}
