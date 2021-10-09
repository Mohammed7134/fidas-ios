//
//  Medicine.swift
//  Clinical Pharmacist with PHP
//
//  Created by Mohammed Almutawa on 3/15/21.
//

import Foundation
struct Medicine: Codable, Comparable, Hashable {
    var admissionId: Int? = nil
    var medicineId: String = UUID().uuidString
    var listType: String = ""
    var indication: String = ""
    var name: String = ""
    var form: String = ""
    var dose: Double = 0.0
    var unit: String = ""
    var route: String = ""
    var frequency: String = ""
    var startDate: Double = 0.0
    var thingsToMonitor: [String] = []
    var stopDate: Double?
    var startDateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        let date = Date(timeIntervalSince1970: startDate)
        return formatter.string(from: date)
    }
    var stopDateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        let date = Date(timeIntervalSince1970: stopDate ?? 946684800)
        return formatter.string(from: date)
    }
    var stopped: Bool {
        if stopDate != nil {
            if stopDate != 946684800 {
                return true
            }  else {
                return false
            }
        } else {
            return false
        }
    }
    static func < (lhs: Medicine, rhs: Medicine) -> Bool {
        rhs.startDate < lhs.startDate
    }
    
}
