//
//  AddAdmissionView.swift
//  Clinical Pharmacist with PHP
//
//  Created by Mohammed Almutawa on 3/11/21.
//

import SwiftUI

@available(iOS 14.0, *)
struct AddAdmission14: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var admissionViewModel = AdmissionViewModel()
    @ObservedObject var patientListViewModel: PatientListViewModel
    let patient: Patient
    var body: some View {
        NavigationView {
            ExtractedView(admissionViewModel: admissionViewModel, patient: patient)
                .navigationBarItems(leading: Button("Cancel"){presentationMode.wrappedValue.dismiss()},
                                    trailing: Button(action: onDone) { DoneButtonView(wait: $admissionViewModel.wait)})
        }
        .introspectViewController{$0.isModalInPresentation = true}
        .navigationViewStyle(StackNavigationViewStyle())
    }
    func onDone() {
        admissionViewModel.appendAdmission(patient: patient, onSuccess: {
            presentationMode.wrappedValue.dismiss()
            if UIDevice.current.userInterfaceIdiom == .phone {patientListViewModel.selectedFromSearch = nil} //this is new
            else if UIDevice.current.userInterfaceIdiom == .pad {patientListViewModel.selectedFromSearch = nil}
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {patientListViewModel.searchTextDidChange()}
        })
    }
}

struct AddAdmission13: View {
    @ObservedObject var patientListViewModel: PatientListViewModel
    let patient: Patient
    var body: some View {
        AddAdmission(patientListViewModel: patientListViewModel, patient: patient)
    }
}
struct AddAdmission: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var admissionViewModel = AdmissionViewModel()
    @ObservedObject var patientListViewModel: PatientListViewModel
    let patient: Patient
    var body: some View {
        NavigationView {
            ExtractedView(admissionViewModel: admissionViewModel, patient: patient)
                .navigationBarItems(leading: Button("Cancel"){presentationMode.wrappedValue.dismiss()},
                                    trailing: Button(action: onDone) { DoneButtonView(wait: $admissionViewModel.wait)})
        }
        .introspectViewController{$0.isModalInPresentation = true}
        .navigationViewStyle(StackNavigationViewStyle())
        
    }
    func onDone() {
        admissionViewModel.appendAdmission(patient: patient, onSuccess: {
            presentationMode.wrappedValue.dismiss()
            if UIDevice.current.userInterfaceIdiom == .phone {patientListViewModel.selectedFromSearch = nil} //this is new
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {patientListViewModel.searchTextDidChange()}
        })
    }
}



struct ExtractedView: View {
    @ObservedObject var admissionViewModel: AdmissionViewModel
    let patient: Patient
    var body: some View {
        GeometryReader {geometry in
            Form {
                Section{
                    if UIDevice.current.userInterfaceIdiom == .phone {
                        Text("File no: \(patient.patientFileNumber)")
                        HStack{
                            Text("Initials: \(patient.patientInitials)")
                            Spacer()
                            Text(patient.sex)
                        }
                        Text("Age: \(patient.age)")
                    } else {
                        HStack {
                            Text("File no: \(patient.patientFileNumber)").frame(width: geometry.size.width * 0.33, alignment: .leading)
                            Spacer()
                            Divider()
                            Text("Initials: \(patient.patientInitials)").frame(width: geometry.size.width * 0.33, alignment: .leading)
                            Spacer()
                            Divider()
                            Text(patient.sex).frame(width: geometry.size.width * 0.33, alignment: .leading)
                        }
                        Text("Age: \(patient.age)")
                    }
                }.customedListRowBackground()
                Group {
                    AddingTextFieldsView(viewModel: admissionViewModel)
                    Text("Last admission \(patient.patientAdmissions.last!.admissionDateString)")
                    DatePicker("Choose Date of Admission", selection: $admissionViewModel.admissionDate, in: Date(timeIntervalSince1970: patient.dob)...Date(), displayedComponents: .date)
                }.customedListRowBackground()
                PatientStringDetails(title: "Past Medical History", placeholder: "condition", array: $admissionViewModel.pastMedicalHistory)
                PatientStringDetails(title: "Presenting Complaints", placeholder: "complaint", showRequired: true, array: $admissionViewModel.presentingComplaints)
                    .alert(isPresented: $admissionViewModel.showAlert) {
                        Alert(title: Text("Error"), message: Text(admissionViewModel.alertMessage), dismissButton: .default(Text("Ok")))
                    }
            }
            .customedBackground()
            .navigationBarTitle(Text("Add Admission"), displayMode: .inline)
        }
    }
}
