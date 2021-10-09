//
//  PatientAdmission.swift
//  Clinical Pharmacist with PHP
//
//  Created by Mohammed Almutawa on 3/4/21.
//

import Foundation

struct PatientAdmission: Codable, Comparable {
    var admissionId: Int?
    var patientId: Int?
    var pharmacistId: Int
    var ward: String
    
    var height: Double
    var admissionDate: Double
    var dischargeDate: Double?
    
    var pastMedicalHistory: [String]
    var presentingComplaints: [String]
    var balances: [FlexDouble]
    var beds: [FlexString]
    var weights: [FlexDouble]
    var labs: [Lab]
    var medicines: [Medicine]
    var rfts: [String: [OptionalFlexDouble]] {
        var dic = [String: [OptionalFlexDouble]]()
        for lab in labs {
            if lab.type == "RFT" {
                for pair in lab.values {
                    if dic[pair.key] == nil {
                        if pair.value != nil {
                            dic[pair.key] = [OptionalFlexDouble(date: lab.date, value: pair.value!)]
                        }
                    } else {
                        if pair.value != nil {
                            dic[pair.key]?.append(OptionalFlexDouble(date: lab.date, value: pair.value!))
                        }
                    }
                }
            }
        }
        return dic
    }
    var lfts: [String: [OptionalFlexDouble]] {
        var dic = [String: [OptionalFlexDouble]]()
        for lab in labs {
            if lab.type == "LFT" {
                for pair in lab.values {
                    if dic[pair.key] == nil {
                        if pair.value != nil {
                            dic[pair.key] = [OptionalFlexDouble(date: lab.date, value: pair.value!)]
                        }
                    } else {
                        if pair.value != nil {
                            dic[pair.key]?.append(OptionalFlexDouble(date: lab.date, value: pair.value!))
                        }
                    }
                }
            }
        }
        return dic
    }
    
    var discharged: Bool {
        if dischargeDate != nil {
            if dischargeDate! > 994929132 {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    var admissionDateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        let date = Date(timeIntervalSince1970: admissionDate)
        return formatter.string(from: date)
    }
    var dischargeDateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        if dischargeDate != nil {
            if dischargeDate! > 994929132 {
                let date = Date(timeIntervalSince1970: dischargeDate!)
                return formatter.string(from: date)
                
            } else {
                return "Not Discharged"
            }
        } else {
            return "Not Discharged"
        }
    }
    
    var daysSinceAdmission: String {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: Date(timeIntervalSince1970: admissionDate), to: Date())
        guard let days = components.day, let months = components.month else {return "unknown period"}
        return "\(months) months, \(days) days"
    }
    var timesAgoSinceAdmission: String {
        //        let components = Calendar.current.dateComponents([.year, .month, .day], from: Date(timeIntervalSince1970: admissionDate), to: Date())
        //        guard let days = components.day, let months = components.month else {return "unknown period"}
        //        return "\(months) months, \(days) days"
        return String(timeAgoSinceDate(Date(timeIntervalSince1970: admissionDate), currentDate: Date(), numericDates: true))
    }
    
    static func < (lhs: PatientAdmission, rhs: PatientAdmission) -> Bool {
        lhs.admissionDate < rhs.admissionDate
    }
}
