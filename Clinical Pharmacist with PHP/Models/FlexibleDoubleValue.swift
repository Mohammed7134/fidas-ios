//
//  FlexibleDoubleValue.swift
//  Cinical Pharmacist
//
//  Created by Mohammed Almutawa on 10/18/20.
//  Copyright © 2020 Mohammed Almutawa. All rights reserved.
//

import Foundation

struct FlexDouble: Codable, Comparable, Hashable {
    static func < (lhs: FlexDouble, rhs: FlexDouble) -> Bool {
        lhs.date < rhs.date
    }
    
    var date: Double
    var value: Double
    var sign: String?
    
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        let actualDate = Date(timeIntervalSince1970: date)
        return formatter.string(from: actualDate)
    }
}

struct FlexString: Codable, Comparable, Hashable {
    static func < (lhs: FlexString, rhs: FlexString) -> Bool {
        lhs.date < rhs.date
    }
    
    var date: Double
    var name: String
    var sign: String?
    
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        let actualDate = Date(timeIntervalSince1970: date)
        return formatter.string(from: actualDate)
    }
}

struct OptionalFlexDouble: Codable, Comparable, Hashable {
    static func < (lhs: OptionalFlexDouble, rhs: OptionalFlexDouble) -> Bool {
        lhs.date < rhs.date
    }
    
    var date: Double
    var value: Double?
    
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        let actualDate = Date(timeIntervalSince1970: date)
        return formatter.string(from: actualDate)
    }
}
