//
//  PatientInputViewModel.swift
//  Cinical Pharmacist
//
//  Created by Mohammed Almutawa on 10/19/20.
//  Copyright © 2020 Mohammed Almutawa. All rights reserved.
//

import Foundation
protocol ItemViewModel: ObservableObject {
    var height: String {get set}
    var weight: String {get set}
    var ward: String {get set}
    var bed: String {get set}
    var errorBed: Bool {get set}
    var errorWard: Bool {get set}
    var errorHeight: Bool {get set}
    var errorWeight: Bool {get set}
}
class PatientInputViewModel: ItemViewModel {
    var fn: String = ""
    var height = ""
    var bed = ""
    var weight: String = ""
    var alertMessage: String = ""
    var sex = "Male"
    var ward = ""
    var patientInitials = ""
    @Published var pastMedicalHistory: [String] = []
    @Published var presentingComplaints: [String] = []
    @Published var dob: Date = Date()
    @Published var admissionDate: Date = Date()
    @Published var showAlert = false
    @Published var wait = false
    
    @Published var errorInitials = false
    @Published var errorBed = false
    @Published var errorWard = false
    @Published var errorHeight = false
    @Published var errorWeight = false
    @Published var errorFn = false
    
    func uploadPatient(onSuccess: @escaping (_ patient: Patient) -> Void) {
        let bedData = FlexString(date: Date().timeIntervalSince1970, name: bed)
        let doubleHeight = height.StringToDoubleValue()
        let doubleWeight = Double(weight)
        var flexWeight: [FlexDouble] {
            if doubleWeight != nil {
                return [FlexDouble(date: Date().timeIntervalSince1970, value: doubleWeight!)]
            } else {
                return []
            }
        }
        if !anyEmpty() {
            if !errorInitials && !errorWeight && !errorHeight && !errorFn && !errorBed && !errorWard {
                if (admissionDate > dob) {
                    wait = true
                    Api.Patient.uploadNewPatient(admissionDate: admissionDate.timeIntervalSince1970, dob: dob.timeIntervalSince1970, fn: fn, beds: [bedData], patientInitials: patientInitials, sex: sex, height: doubleHeight, ward: ward, weights: flexWeight, pastMedicalHistory: pastMedicalHistory, presentingComplaints: presentingComplaints, onSuccess: { patient in
                        onSuccess(patient)
                        self.clean()
                    }) { (error) in
                        self.wait = false
                        self.showAlert = true
                        self.alertMessage = error
                    }
                } else {
                    onError("Date of birth must be before date of admission")
                }
            } else {
                onError("Error filling labeled fields")
            }
        } else {
            onError("Fill in the Empty Fields")
        }
    }
    func anyEmpty() -> Bool {
        var emptyField = false
        [ward, patientInitials, bed, fn].forEach({if $0.isEmpty {emptyField = true}})
        if presentingComplaints.isEmpty {emptyField = true}
        return emptyField
    }
    func onError(_ error: String) {
        showAlert = true
        alertMessage = error
    }
    func clean() {
        bed = ""
        ward = ""
        weight = ""
        height = ""
        fn = ""
        patientInitials = ""
        presentingComplaints = []
        pastMedicalHistory = []
        dob = Date()
        admissionDate = Date()
        self.wait = false
        
    }
}
