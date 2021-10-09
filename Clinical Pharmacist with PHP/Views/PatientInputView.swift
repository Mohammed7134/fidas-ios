//
//  PatientInputView.swift
//  Cinical Pharmacist
//
//  Created by Mohammed Almutawa on 10/18/20.
//  Copyright © 2020 Mohammed Almutawa. All rights reserved.
//

import SwiftUI


@available(iOS 14.0, *)
struct PatientInputView14: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var patientListViewModel: PatientListViewModel
    @StateObject var patientInputViewModel = PatientInputViewModel()
    var body: some View {
        PatientInputViewComponent(patientInputViewModel: patientInputViewModel)
    }
}

struct PatientInputView13: View {
    var body: some View {
        if UIDevice.current.userInterfaceIdiom == .pad {
            NavigationView {
                PatientInputView()
            }.navigationViewStyle(StackNavigationViewStyle())
        } else {
            PatientInputView()
        }
    }
}
struct PatientInputView: View {
    @EnvironmentObject var patientListViewModel: PatientListViewModel
    @ObservedObject var patientInputViewModel = PatientInputViewModel()
    var body: some View {
            PatientInputViewComponent(patientInputViewModel: patientInputViewModel)
    }
}



struct PatientInputViewComponent: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var patientListViewModel: PatientListViewModel
    @ObservedObject var patientInputViewModel: PatientInputViewModel
    @State var showDefaultView = false
    var body: some View {
        ZStack {
            Form {
                Group {
                    CustomTextField("File number (required)", rules: Rules.bedAndWardAndFn, text: $patientInputViewModel.fn, error: $patientInputViewModel.errorFn, keyType: .alphabet)
                    CustomTextField("Patient Initials (required)", rules: Rules.patientInitials, text: $patientInputViewModel.patientInitials, error: $patientInputViewModel.errorInitials, keyType: .alphabet, limitCharacters: 2)
                    AddingTextFieldsView(viewModel: patientInputViewModel)
                    Picker(selection: $patientInputViewModel.sex, label: Text("Sex")) {
                        ForEach(SEX_ARRAY, id: \.self) { sex in
                            Text(sex)
                        }
                    }.pickerStyle(SegmentedPickerStyle()).labelsHidden()
                }.customedListRowBackground()
                Group {
                    DatePicker("Choose Date of Birth", selection: $patientInputViewModel.dob, in: ...Date(), displayedComponents: .date)
                    DatePicker("Choose Date of Admission", selection: $patientInputViewModel.admissionDate, in: patientInputViewModel.dob...Date(), displayedComponents: .date)
                }.customedListRowBackground()
                
                PatientStringDetails(title: "Past Medical History", placeholder: "condition", array: $patientInputViewModel.pastMedicalHistory)
                PatientStringDetails(title: "Presenting Complaints", placeholder: "complaint", showRequired: true, array: $patientInputViewModel.presentingComplaints)
            }
            .customedBackground()
            .navigationBarTitle("Adding Patient")
            .navigationBarItems(trailing: Button(action: onDone) {DoneButtonView(wait: $patientInputViewModel.wait)})
            .alert(isPresented: $patientInputViewModel.showAlert) {
                Alert(title: Text("Error"), message: Text(patientInputViewModel.alertMessage), dismissButton: .default(Text("Ok")))
            }
            if showDefaultView {
                Color.black.opacity(0.2)
                RoundedRectangle(cornerRadius: 20)
                    .frame(width: 300, height: 300)
                    .foregroundColor(.white)
                    .overlay(Text("Patient Added Successfully"))
            }
        }
    }
    func onDone() {
        patientInputViewModel.uploadPatient { (patient) in
            patientListViewModel.patients.append(PatientViewModel(patient: patient))
            if #available(iOS 14, *) {
                presentationMode.wrappedValue.dismiss()
            } else {
                if UIDevice.current.userInterfaceIdiom == .phone {
                    presentationMode.wrappedValue.dismiss()
                } else {
                    showDefaultView = true
                }
            }
        }
    }
}
