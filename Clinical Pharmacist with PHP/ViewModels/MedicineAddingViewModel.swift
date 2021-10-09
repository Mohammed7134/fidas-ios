//
//  MedicineAddingViewModel.swift
//  Clinical Pharmacist with PHP
//
//  Created by Mohammed Almutawa on 3/17/21.
//

import Foundation

class MedicineAddingViewModel: ObservableObject {
    @Published var unit = ""
    @Published var route = ""
    @Published var frequency = ""
    @Published var indication = ""
    @Published var doseError = false
    @Published var frequencyError = false
    @Published var routeError = false
    @Published var unitError = false
    @Published var indicationError = false
    @Published var dose = ""
    @Published var showAlert = false
    @Published var thingsToMonitor = [String]()
    @Published var startDate = Date()
    @Published var stopped = false
    @Published var stopDate = Date()
    var newThing = ""
    var alertMessage = ""
    
    func addMedicine(admissionId: Int?, type: String, pickedMedicine: String, onSuccess: @escaping (_ medicine: Medicine) -> Void) {
        let doubleStartDate = startDate.timeIntervalSince1970
        let doubleStopDate = stopped ? stopDate.timeIntervalSince1970 : nil
        
        if !doseError && !indicationError && !routeError && !unitError && !frequencyError {
            if !anyEmpty(type: type, pickedMedicine: pickedMedicine) {
                let medicine = Medicine(admissionId: admissionId, listType: type, indication: indication, name: pickedMedicine, form: "", dose: Double(dose)!, unit: unit, route: route, frequency: frequency, startDate: doubleStartDate, thingsToMonitor: thingsToMonitor, stopDate: doubleStopDate)
                onSuccess(medicine)
            } else {
                alertMessage = "One of the required fields is empty"
                showAlert = true
            }
        } else {
            alertMessage = "Check red labelled field"
            showAlert = true
        }
    }
    func anyEmpty(type: String, pickedMedicine: String) -> Bool {
        var anyEmpty = false
        [pickedMedicine, type, frequency, route, unit, indication].forEach({if $0.isEmpty {anyEmpty = true}})
        if Double(dose) == nil {anyEmpty = true}
        return anyEmpty
    }
    func addThing() {
        if !newThing.isEmpty {
            thingsToMonitor.append(newThing)
            newThing = ""
        }
    }
}
