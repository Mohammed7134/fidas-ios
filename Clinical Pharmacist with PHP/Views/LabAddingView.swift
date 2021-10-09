//
//  RFTAddingView.swift
//  Cinical Pharmacist
//
//  Created by Mohammed Almutawa on 11/19/20.
//  Copyright © 2020 Mohammed Almutawa. All rights reserved.
//

import Foundation
import SwiftUI

@available(iOS 14.0, *)
struct LabAddingView14: View {
    @StateObject var labAddingViewModel = LabAddingViewModel()
    @ObservedObject var patientViewModel: PatientViewModel
    let type: String
    var refValues: [(String, Double, Double, String, String)]
    var body: some View {
        LabAddingView(labAddingViewModel: labAddingViewModel, patientViewModel: patientViewModel, type: type, refValues: refValues)
    }
}

struct LabAddingView13: View {
    @ObservedObject var labAddingViewModel = LabAddingViewModel()
    @ObservedObject var patientViewModel: PatientViewModel
    let type: String
    var refValues: [(String, Double, Double, String, String)]
    var body: some View {
        LabAddingView(labAddingViewModel: labAddingViewModel, patientViewModel: patientViewModel, type: type, refValues: refValues)
    }
}
struct LabAddingView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var labAddingViewModel = LabAddingViewModel()
    @ObservedObject var patientViewModel: PatientViewModel
    let type: String
    var refValues: [(String, Double, Double, String, String)]
    var body: some View {
        UIScrollView.appearance().keyboardDismissMode = .interactive
        let refVals = Binding(
            get: { () -> [(String, Double, Double, String, String)] in
                if type == "RFT" {return labAddingViewModel.refValuesRFT}
                else {return labAddingViewModel.refValuesLFT}
            },
            set: {
                if type == "RFT" {labAddingViewModel.refValuesRFT = $0}
                else {labAddingViewModel.refValuesLFT = $0}
            }
        )
        return NavigationView {
            Form {
                ForEach(0..<refVals.wrappedValue.count) {num in
                    HStack{
                        Text("\(refValues[num].0): ")
                        TextField("\(refValues[num].0)", text: refVals[num].4).keyboardType(.decimalPad)
                    }
                    .customedListRowBackground()
                }
                DatePicker(selection: $labAddingViewModel.resultsDate, in: ...Date(), displayedComponents: .date, label: {Text("Results Date")})
                    .customedListRowBackground()
            }
            .modifier(AdaptsToSoftwareKeyboard())
            .customedBackground()
            .navigationBarTitle("Adding \(type) Values", displayMode: .inline)
            .alert(isPresented: $labAddingViewModel.showLabAlert) {
                Alert(title: Text("Error"), message: Text(labAddingViewModel.errorLabString), dismissButton: .default(Text("Ok")))
            }
            .navigationBarItems(leading: Button("Cancel"){presentationMode.wrappedValue.dismiss()},
                                trailing: Button(action: onDone) {Text("Done")})
            .onDisappear{UIScrollView.appearance().keyboardDismissMode = .onDrag}
        }
        .introspectViewController{$0.isModalInPresentation = true}
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    func onDone() {
        labAddingViewModel.AddLab(patient: patientViewModel.patient, type: type) { values in
            patientViewModel.patient.mostRecentAdmission.labs.append(Lab(type: type, values: values, date: labAddingViewModel.resultsDate.timeIntervalSince1970))
            presentationMode.wrappedValue.dismiss()
        }
    }
}
