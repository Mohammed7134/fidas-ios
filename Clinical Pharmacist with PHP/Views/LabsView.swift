//
//  LabsView.swift
//  Clinical Pharmacist with PHP
//
//  Created by Mohammed Almutawa on 3/15/21.
//

import SwiftUI
struct LabsView: View {
    @EnvironmentObject var patientViewModel: PatientViewModel
    @State var selection: String = "RFT"
    var body: some View {
        VStack{
            Picker("", selection: $selection) {
                ForEach(["RFT", "LFT"], id:\.self) {Text($0)}
            }.pickerStyle(SegmentedPickerStyle())
            if selection == "RFT" {
                LabView(refVals: RefVals.RFT, results: patientViewModel.patient.mostRecentAdmission.rfts, type: "RFT")
            } else if selection == "LFT" {
                LabView(refVals: RefVals.LFT, results: patientViewModel.patient.mostRecentAdmission.lfts, type: "LFT")
            }
        }
        .customedBackground()
        .highPriorityGesture(
            DragGesture()
                .onEnded({ (value) in
                    if value.translation.width > 50{// minimum drag...
                        self.changeView(left: false)
                    }
                    if -value.translation.width > 50{
                        self.changeView(left: true)
                    }
                }))
    }
    func changeView(left : Bool){
        if left{
            if selection == "RFT" {
                selection = "LFT"
            }
        }
        else{
            if selection == "LFT" {
                selection = "RFT"
            }
        }
    }
}

