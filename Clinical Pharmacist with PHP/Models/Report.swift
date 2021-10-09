//
//  Report.swift
//  Fidas
//
//  Created by Mohammed Almutawa on 5/16/21.
//

import Foundation
struct Report: Codable, Identifiable, Equatable {
    static func == (lhs: Report, rhs: Report) -> Bool {
        lhs.medicine == rhs.medicine
    }
    let id: Int?
    let medicine: MedicineLocations
    let time: Double
    let reviewed: Bool
    let hospital: String
    var date: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        let date = Date(timeIntervalSince1970: time)
        return formatter.string(from: date)
    }
}
