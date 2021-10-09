//
//  NetworkingResponseTypes.swift
//  Clinical Pharmacist with PHP
//
//  Created by Mohammed Almutawa on 5/6/21.
//

import Foundation
struct ResponseWithErrorAndMessage: Decodable {
    let error: Bool
    let message: String
}

struct ResponseWithErrorAndMessageUser: Decodable {
    let error: Bool
    let message: String?
    let user: User?
}
struct LoadUsersResponse: Decodable {
    let error: Bool
    let message: String?
    let users: [User]?
}
struct AddPatientResponse: Decodable {
    let error: Bool
    let message: String
}
struct LoadPatientsResponse: Decodable {
    let error: Bool
    let message: String?
    let patients: [Patient]?
}
struct CountAdmissionsResponse: Decodable {
    let error: Bool
    let message: String?
    let count: Int?
}
struct LoadMedicinesResponse: Decodable {
    let error: Bool
    let message: String?
    let medicines: [String]?
}
struct LoadReportsResponse: Decodable {
    let error: Bool
    let message: String?
    let reports: [Report]?
}
struct LoadMedicinesLocationsResponse: Decodable {
    let error: Bool
    let message: String?
    let medicines: [MedicineLocations]?
}
struct LoadAnnouncementsResponse: Decodable {
    let error: Bool
    let message: String?
    let announcements: [Announcement]?
    
    var annVMs: [AnnouncementViewModel] {
        var arr = [AnnouncementViewModel]()
        if announcements != nil {
            for ann in announcements! {
                arr.append(AnnouncementViewModel(announcement: ann))
            }
        }
        return arr
    }
}

