//
//  MedicineLocations.swift
//  Fidas
//
//  Created by Mohammed Almutawa on 5/16/21.
//

import Foundation
struct MedicineLocations: Codable, Identifiable, Equatable {
    let id: Int
    let name: String
    let pharmacy: String
    var locations: [String : String]
}
