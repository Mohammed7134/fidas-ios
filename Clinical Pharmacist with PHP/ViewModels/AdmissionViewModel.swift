//
//  AdmissionViewModel.swift
//  Clinical Pharmacist with PHP
//
//  Created by Mohammed Almutawa on 3/11/21.
//

import Foundation
class AdmissionViewModel: ItemViewModel {
    @Published var admissionDate = Date()
    @Published var presentingComplaints = [String]()
    @Published var pastMedicalHistory = [String]()
    @Published var height = ""
    @Published var weight = ""
    @Published var ward = "" 
    @Published var bed = ""
    @Published var alertMessage = ""
    @Published var showAlert = false
    @Published var errorWeight = false
    @Published var errorHeight = false
    @Published var errorWard = false
    @Published var errorBed = false
    
    @Published var wait = false
    
    func appendAdmission(patient: Patient, onSuccess: @escaping () -> Void) {
        wait = true
        let bedData = FlexString(date: Date().timeIntervalSince1970, name: bed)
        let heightDouble = height.StringToDoubleValue()
        var flexWeight: [FlexDouble] {
            let weightDouble = Double(weight)
            if weightDouble != nil {
                return [FlexDouble(date: Date().timeIntervalSince1970, value: weightDouble!)]
            } else {
                return []
            }
        }
        if !anyEmpty() {
            if patient.patientAdmissions.sorted(by: {$0.admissionDate < $1.admissionDate}).last!.discharged {
                if !presentingComplaints.isEmpty && !ward.isEmpty && !bed.isEmpty {
                    if !errorWeight && !errorBed && !errorHeight && !errorWard {
                        Api.Patient.submitAdmission(patientFileNumber: patient.patientFileNumber, admissionDate: admissionDate.timeIntervalSince1970, presentingComplains: presentingComplaints, pastMedicalHistory: pastMedicalHistory, height: heightDouble, weight: flexWeight, ward: ward, bed: [bedData], onSuccess: {
                                self.wait = false
                                onSuccess()
                                self.clean()
                        }) {
                            self.onError($0)
                        }
                    } else {
                        onError("Error filling red labeled fields")
                    }
                } else {
                    onError("Fill all required fields")
                }
            } else {
                onError("Patient is not discharged yet from the previous admission")
            }
        } else {
            onError("Fill in the empty fields")
        }
    }
    func anyEmpty() -> Bool {
        var anyEmpty = false
        [ward, bed].forEach({if $0.isEmpty {anyEmpty = true}})
        if presentingComplaints.isEmpty {anyEmpty = true}
        return anyEmpty
    }
    func onError(_ error: String) {
        self.wait = false
        alertMessage = "Fill in the empty fields"
        showAlert = true
    }
    func clean() {
        bed = ""
        ward = ""
        weight = ""
        height = ""
        presentingComplaints = []
        pastMedicalHistory = []
        admissionDate = Date()
        errorBed = false
        alertMessage = ""
        errorWard = false
        errorHeight = false
        errorWeight = false
    }
}
