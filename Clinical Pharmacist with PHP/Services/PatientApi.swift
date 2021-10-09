//
//  PatientApi.swift
//  Cinical Pharmacist
//
//  Created by Mohammed Almutawa on 10/19/20.
//  Copyright © 2020 Mohammed Almutawa. All rights reserved.
//

import Foundation


class PatientApi {
    func countPatientsForCurrentUser(onSuccess: @escaping (_ count: Int) -> Void) {
        guard let currentUserData = UserDefaults.standard.data(forKey: "UserData") else {print("No data saved for the current user"); return}
        guard let user = try? JSONDecoder().decode(User.self, from: currentUserData) else {print("Could not decode current user data"); return}
        let pharmacistId = user.id
        let request = NSMutableURLRequest(url: NSURL(string: Ref().RETRIEVECOUNT_FILE)! as URL)
        let postString = "userId=\(pharmacistId)"
        request.httpBody = postString.data(using: String.Encoding.utf8)
        request.httpMethod = "POST"
        request.NetworkingWithCountAdmissionsResponse(onSuccess: onSuccess, onError: {print($0)})
    }
    func searchPatients(text: String, onSuccess: @escaping (_ patients: [PatientViewModel]) -> Void) {
        guard let currentUserData = UserDefaults.standard.data(forKey: "UserData") else {print("No data saved for the current user"); return}
        guard let user = try? JSONDecoder().decode(User.self, from: currentUserData) else {print("Could not decode current user data"); return}
        let hospital = user.hospital
        let request = NSMutableURLRequest(url: NSURL(string: Ref().SEARCH_FILE)! as URL)
        request.httpMethod = "POST"
        let postString = "searchText=\(text)&hospital=\(hospital)"
        request.httpBody = postString.data(using: String.Encoding.utf8)
        request.NetworkingWithLoadPatientsResponse(onSuccess: {onSuccess($0)}, onError: {print($0)})
    }
    func uploadNewPatient(admissionDate: Double, dob: Double, fn: String, beds: [FlexString], patientInitials: String, sex: String, height: Double, ward: String, weights: [FlexDouble], pastMedicalHistory: [String], presentingComplaints: [String], onSuccess: @escaping (_ patient :Patient) -> Void, onError: @escaping (_ errorMessage: String) -> Void) {
        guard let currentUserData = UserDefaults.standard.data(forKey: "UserData") else {onError("No data saved for the current user"); return}
        guard let user = try? JSONDecoder().decode(User.self, from: currentUserData) else {onError("Could not decode current user data"); return}
        let pharmacistId = user.id
        let patientAdmission = PatientAdmission(pharmacistId: pharmacistId, ward: ward, height: height, admissionDate: admissionDate, pastMedicalHistory: pastMedicalHistory, presentingComplaints: presentingComplaints, balances: [], beds: beds, weights: weights, labs: [], medicines: [])
        let patient = Patient(patientFileNumber: fn, patientInitials: patientInitials, sex: sex, dob: dob, patientAdmissions: [patientAdmission])
        guard let dict = try? patient.toDictionary() else {print("dictionary could not be fetched"); return}
        let request = NSMutableURLRequest(url: NSURL(string: Ref().ADDPATIENT_FILE)! as URL)
        request.httpMethod = "POST"
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        guard let data = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted) else {onError("Could not serialize dict of patient"); return}
        request.httpBody =  data
        request.NetworkingWithErrorMessageResponse(onSuccess: {_ in onSuccess(patient)}, onError: onError)
    }
    func loadPatients(onSuccess: @escaping (_ patients: [PatientViewModel]) -> Void, onError: @escaping (_ errorMessage: String) -> Void) {
        guard let currentUserData = UserDefaults.standard.data(forKey: "UserData") else {onError("No data saved for the current user"); return}
        guard let user = try? JSONDecoder().decode(User.self, from: currentUserData) else {onError("Could not decode current user data"); return}
        let pharmacistId = user.id
        let request = NSMutableURLRequest(url: NSURL(string: Ref().LOADPATIENTS_FILE)! as URL)
        let postString = "userId=\(pharmacistId)"
        request.httpBody = postString.data(using: String.Encoding.utf8)
        request.httpMethod = "POST"
        request.NetworkingWithLoadPatientsResponse(onSuccess: {onSuccess($0)}, onError: {onError($0)})
    }
    

    func updatePatient(patient: Patient, onSuccess: @escaping (_ successMsg: String) -> Void, onError: @escaping (_ errorMsg: String) -> Void) {
        guard let dict = try? patient.toDictionary() else {print("dictionary could not be fetched"); return}
        let request = NSMutableURLRequest(url: NSURL(string: Ref().UPDATEADMISSION_FILE)! as URL)
        request.httpMethod = "POST"
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        guard let data = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted) else {onError("Could not conver dict to json in updatePatient function in PatientApi file"); return}
        request.httpBody =  data
        request.NetworkingWithErrorMessageResponse(onSuccess: onSuccess, onError: onError)
    }
    
    func submitAdmission(patientFileNumber: String, admissionDate: Double, presentingComplains: [String], pastMedicalHistory: [String], height: Double, weight: [FlexDouble], ward: String, bed: [FlexString], onSuccess: @escaping () -> Void, onError: @escaping (_ error: String) -> Void) {
        guard let currentUserData = UserDefaults.standard.data(forKey: "UserData") else {onError("No data saved for the current user"); return}
        guard let user = try? JSONDecoder().decode(User.self, from: currentUserData) else {onError("Could not decode current user data"); return}
        let pharmacistId = user.id
        let admission = PatientAdmission(pharmacistId: pharmacistId, ward: ward, height: height, admissionDate: admissionDate, pastMedicalHistory: pastMedicalHistory, presentingComplaints: presentingComplains, balances: [], beds: bed, weights: weight, labs: [], medicines: [])
        guard let dict = try? admission.toDictionary() else {onError("dictionary could not be fetched"); return}
        var dicti = dict
        dicti["patientFileNumber"] = patientFileNumber
        let request = NSMutableURLRequest(url: NSURL(string: Ref().ADDPATIENT_FILE)! as URL)
        request.httpMethod = "POST"
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        guard let data = try? JSONSerialization.data(withJSONObject: dicti, options: .prettyPrinted) else {onError("Could not conver dict to json in updatePatient function in PatientApi file"); return}
        request.httpBody =  data
        request.NetworkingWithErrorMessageResponse(onSuccess: {_ in onSuccess()}, onError: onError)
    }
    
    func removeAdmission(_ admissionId: Int, onSuccess: @escaping (_ success: String) -> Void, onError: @escaping (_ error: String) -> Void) {
        let request = NSMutableURLRequest(url: NSURL(string: Ref().DELETEADMISSON_FILE)! as URL)
        request.httpMethod = "POST"
        let postString = "admissionId=\(admissionId)"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type");
        request.httpBody = postString.data(using: String.Encoding.utf8)
        request.NetworkingWithErrorMessageResponse(onSuccess: onSuccess, onError: onError)
    }
}
