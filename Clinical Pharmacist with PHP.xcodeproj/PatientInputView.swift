//
//  PatientInputView.swift
//  Cinical Pharmacist
//
//  Created by Mohammed Almutawa on 10/18/20.
//  Copyright © 2020 Mohammed Almutawa. All rights reserved.
//

import SwiftUI

struct PatientInputView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var patientInputViewModel = PatientInputViewModel()
    var execute: () -> Void
    var body: some View {
        NavigationView {
            Form {
                Group {
                    TextField("File number", text: self.$patientInputViewModel.fn)
                    TextField("Patient Initials", text: self.$patientInputViewModel.patientInitials)
                    Picker(selection: self.$patientInputViewModel.sex, label: Text("Sex")) {
                        ForEach(["Male", "Female"], id: \.self) { sex in
                            Text(sex)
                        }
                    }.pickerStyle(SegmentedPickerStyle()).labelsHidden()
                    HStack {
                        Text("Bed:")
                        TextField("enter bed number", text: self.$patientInputViewModel.beds[0])
                    }
                    HStack {
                        Text("Ward:")
                        TextField("enter ward number", text: self.$patientInputViewModel.ward)
                    }
                    HStack {
                        Text("Height:")
                        TextField("height", text: self.$patientInputViewModel.height)
                    }
                }
                DatePicker("Choose Date of Birth", selection: self.$patientInputViewModel.dob, in: ...Date(), displayedComponents: .date)
                DatePicker("Choose Date of Admission", selection: self.$patientInputViewModel.admissionDate, in: ...Date(), displayedComponents: .date)
                PatientDoubleDetails(title: "Fluid Chart", placeholder: "balance", unit: "mL", fluidChart: true, admissionDate: self.patientInputViewModel.admissionDate, array: self.$patientInputViewModel.balances)
                PatientDoubleDetails(title: "Weights", placeholder: "weight", unit: "Kg", fluidChart: false, admissionDate: self.patientInputViewModel.admissionDate, array: self.$patientInputViewModel.weights)
                PatientStringDetails(title: "Past Medical History", placeholder: "condition", array: self.$patientInputViewModel.pastMedicalHistory) {}
                PatientStringDetails(title: "Presenting Complaints", placeholder: "complaint", array: self.$patientInputViewModel.presentingComplaints) {}
            }
            .navigationBarTitle("Adding Patient", displayMode: .inline)
            .navigationBarItems(leading: Button("Cancel") {self.presentationMode.wrappedValue.dismiss()}, trailing: Button("Done"){
                    self.patientInputViewModel.uploadPatient { (patient) in
                        self.execute()
                        self.presentationMode.wrappedValue.dismiss()
                    }
                })
                .alert(isPresented: self.$patientInputViewModel.showAlert) {
                    Alert(title: Text("Error"), message: Text(self.patientInputViewModel.errorString), dismissButton: .default(Text("Ok")))
            }
        }
    }
}
