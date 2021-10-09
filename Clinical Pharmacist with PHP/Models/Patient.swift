//
//  Patient.swift
//  Clinical Pharmacist with PHP
//
//  Created by Mohammed Almutawa on 2/27/21.
//

import Foundation

struct Patient: Codable, Comparable {
    var patientId: Int?
    var patientFileNumber: String = ""
    var patientInitials: String = ""
    var sex: String = ""
    var dob: Double = 0
    
    
    var patientAdmissions: [PatientAdmission] = []
    var mostRecentAdmission: PatientAdmission {
        get {
            return patientAdmissions.sorted().last!
        }
        set {
            let index = patientAdmissions.firstIndex(of: patientAdmissions.sorted().last!)!
            patientAdmissions[index] = newValue
        }
    }
    var age: String {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: Date(timeIntervalSince1970: dob), to: Date())
        guard let days = components.day, let months = components.month, let years = components.year else {return "unknown period"}
        return "\(years) years, \(months) months, \(days) days"
    }
    static func < (lhs: Patient, rhs: Patient) -> Bool {
        rhs.patientAdmissions.first!.admissionDate < lhs.patientAdmissions.first!.admissionDate
    }

}
