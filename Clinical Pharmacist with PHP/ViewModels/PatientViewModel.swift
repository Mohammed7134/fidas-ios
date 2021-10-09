//
//  PatientViewModel.swift
//  Cinical Pharmacist
//
//  Created by Mohammed Almutawa on 10/19/20.
//  Copyright © 2020 Mohammed Almutawa. All rights reserved.
//

import Foundation
import Combine

class PatientViewModel: ObservableObject, Identifiable {
    @Published var patient = Patient()
    @Published var isLoading = true 
    @Published var showDischargeSheet = false
    @Published var dischargeDate = Date()
    @Published var showDeletionAlert = false
    @Published var lastAdmissionDischarged = false
    @Published var dischargeString = "Discharge"
    @Published var showPicker = false
    @Published var showChooseView = false
    @Published var showMedicineSheet = false
    @Published var showStopped = true
    @Published var selection = "Current"
    @Published var alertMessage = ""
    @Published var showAlert = false
    var id: String = ""
    private var cancellables = Set<AnyCancellable>()
    init(patient: Patient) {
        self.patient = patient
        $patient
            .dropFirst()
            .debounce(for: 0.1, scheduler: RunLoop.main)
            .sink {if $0.patientId != nil {self.updatePatient()}}
            .store(in: &cancellables)
        
        $patient
            .compactMap { $0.patientFileNumber }
            .assign(to: \.id, on: self)
            .store(in: &cancellables)
    }
    
    func updatePatient() {
        Api.Patient.updatePatient(patient: patient, onSuccess: {print($0)}) {
            self.alertMessage = ("\($0): changes are not saved")
            self.showAlert = true
        }
    }
    
    
    func deleteAdmission(onSuccess: @escaping () -> Void) {
        if patient.mostRecentAdmission.admissionId != nil {
            Api.Patient.removeAdmission(patient.mostRecentAdmission.admissionId!, onSuccess: {
                print($0)
                onSuccess()
            }, onError: {
                self.alertMessage = ("\($0): Admission Not Deleted")
                self.showAlert = true
            })
        } else {
            self.alertMessage = ("Admission Not Deleted: Unknown error occured")
            self.showAlert = true
        }
    }
    func discharge() {
        patient.mostRecentAdmission.dischargeDate = dischargeDate.timeIntervalSince1970
    }
}

