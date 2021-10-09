//
//  LabAddingViewModel.swift
//  Clinical Pharmacist with PHP
//
//  Created by Mohammed Almutawa on 3/21/21.
//

import Foundation

class LabAddingViewModel: ObservableObject {
    var refValuesRFT = RefVals.RFT
    var refValuesLFT = RefVals.LFT
    @Published var showLabAlert = false
    @Published var values: [String : [FlexDouble]] = [:]
    @Published var resultsDate = Date()
    var errorLabString = ""
    
    func AddLab(patient: Patient, type: String, onSuccess: @escaping (_ values: [String : Double?]) -> Void) {
        //add regex here also
        if allFieldFilled(type: type) {
            var index: Int {patient.patientAdmissions.count - 1}
            var values = [String : Double?]()
            if type == "RFT" {
                let Na = Double(refValuesRFT[0].4)
                let K = Double(refValuesRFT[1].4)
                let Ca = Double(refValuesRFT[2].4)
                let CorrectedCa = Double(refValuesRFT[3].4)
                let Urea = Double(refValuesRFT[4].4)
                let Gluc = Double(refValuesRFT[5].4)
                let Creat = Double(refValuesRFT[6].4)
                values = ["Na": Na, "K":K, "Ca":Ca, "CorrectedCa":CorrectedCa, "Urea":Urea, "Gluc":Gluc, "Creat":Creat]
            } else if type == "LFT"  {
                let ALT = Double(refValuesLFT[0].4)
                let Bili = Double(refValuesLFT[1].4)
                let AlkPhos = Double(refValuesLFT[2].4)
                let GGT = Double(refValuesLFT[3].4)
                let Alb = Double(refValuesLFT[4].4)
                let Prot = Double(refValuesLFT[5].4)
                let AST = Double(refValuesLFT[6].4)
                values = ["ALT": ALT, "Bili":Bili, "AlkPhos":AlkPhos, "GGT":GGT, "Alb":Alb, "Prot":Prot, "AST":AST]
            }
            onSuccess(values)
        } else {
            showLabAlert = true
            errorLabString = "Fill in at least one field"
        }
    }
    func allFieldFilled(type: String) -> Bool {
        var bools = [Bool]()
        if type == "RFT" {
            for field in refValuesRFT {
                bools.append(field.4.isEmpty || Double(field.4) == nil)
            }
        } else if type == "LFT" {
            for field in refValuesLFT {
                bools.append(field.4.isEmpty || Double(field.4) == nil)
            }
        }
        if bools.contains(false) {
            return true
        } else {
            return false
        }
    }
    
}
