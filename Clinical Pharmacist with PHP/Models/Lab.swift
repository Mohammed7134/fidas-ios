//
//  Lab.swift
//  Clinical Pharmacist with PHP
//
//  Created by Mohammed Almutawa on 3/14/21.
//

import Foundation
struct Lab: Codable, Comparable, Hashable {
    let type: String
    let values: [String : Double?]
    let date: Double
    static func < (lhs: Lab, rhs: Lab) -> Bool {
        rhs.date < lhs.date
    }
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        let actualDate = Date(timeIntervalSince1970: date)
        return formatter.string(from: actualDate)
    }
}
