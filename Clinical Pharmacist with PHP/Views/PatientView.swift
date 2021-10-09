//
//  PatientView.swift
//  Cinical Pharmacist
//
//  Created by Mohammed Almutawa on 10/17/20.
//  Copyright © 2020 Mohammed Almutawa. All rights reserved.
//

import SwiftUI
struct PatientView: View {
    @ObservedObject var patientListViewModel: PatientListViewModel
    @ObservedObject var patientViewModel: PatientViewModel
    var body: some View {
        if #available(iOS 14, *) {
            PatientViewDetials(patientListViewModel: patientListViewModel, patientViewModel: patientViewModel)
        } else {
            if UIDevice.current.userInterfaceIdiom == .pad {
                NavigationView {
                    PatientViewDetials(patientListViewModel: patientListViewModel, patientViewModel: patientViewModel)
                }.navigationViewStyle(StackNavigationViewStyle())
            } else {
                PatientViewDetials(patientListViewModel: patientListViewModel, patientViewModel: patientViewModel)
            }
        }
    }
}
struct PatientViewDetials: View {
    @EnvironmentObject var session: SessionStore
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var patientListViewModel: PatientListViewModel
    @ObservedObject var patientViewModel: PatientViewModel
    var body: some View {
        ZStack {
            GeometryReader {geometry in
                    Form {
                        Section(header: Text("Patient Details").foregroundColor(.white)){
                            Text("Patient Initials: \(patientViewModel.patient.patientInitials)")
                            Text("Sex: \(patientViewModel.patient.sex)")
                            Text("Age: \(patientViewModel.patient.age)")
                            if patientViewModel.patient.patientAdmissions.last != nil {
                                if patientViewModel.patient.patientAdmissions.last!.height != 0 {
                                    Text("Height: \(patientViewModel.patient.mostRecentAdmission.height, specifier: "%.2f")")
                                }
                            }
                            Text("Date of Admission: \(patientViewModel.patient.mostRecentAdmission.admissionDateString )")
                            Text("Length of Stay: \(patientViewModel.patient.mostRecentAdmission.daysSinceAdmission)")
                        }
                        .customedListRowBackground()
                        Section {
                            PatientStringDetails(array: $patientViewModel.patient.mostRecentAdmission.pastMedicalHistory, discharged: patientViewModel.patient.mostRecentAdmission.discharged)
                            PatientStringDetails(title: "Presenting Complaints", placeholder: "complaint", array: $patientViewModel.patient.mostRecentAdmission.presentingComplaints, discharged: patientViewModel.patient.mostRecentAdmission.discharged)
                            PatientBedDetails(title: "Beds", placeholder: "bed", showLast: true, array: $patientViewModel.patient.mostRecentAdmission.beds, discharged: patientViewModel.patient.mostRecentAdmission.discharged)
                            PatientDoubleDetails(title: "Fluid chart", placeholder: "balance", unit: "ml", fluidChart: true, admissionDate: Date(timeIntervalSince1970: patientViewModel.patient.mostRecentAdmission.admissionDate), array: $patientViewModel.patient.mostRecentAdmission.balances, discharged: patientViewModel.patient.mostRecentAdmission.discharged)
                            PatientDoubleDetails(title: "Weights", placeholder: "weight", unit: "Kg", fluidChart: false, admissionDate: Date(timeIntervalSince1970: patientViewModel.patient.mostRecentAdmission.admissionDate), array: $patientViewModel.patient.mostRecentAdmission.weights, discharged: patientViewModel.patient.mostRecentAdmission.discharged)
                        }
                        .customedListRowBackground()
                        .customedLeadingPadding()
                        Section {
                            NavigationLink(destination: LabsView().environmentObject(patientViewModel)) {
                                Text("Lab Results")
                            }
                        }
                        .customedListRowBackground()
                        .customedLeadingPadding()

                        Section {
                            NavigationLink(destination: Medicines().environmentObject(patientViewModel)) {
                                Text("Medicines")
                            }
                        }
                        .customedListRowBackground()
                        .customedLeadingPadding()
                        if patientViewModel.patient.patientAdmissions.count > 1 {
                            Section {
                                if #available(iOS 14, *) {
                                    NavigationLink(destination: PastAdmissionView14(patient: patientViewModel.patient).environmentObject(patientListViewModel)) {Text("Past Admissions")}
                                } else {
                                    NavigationLink(destination: PastAdmissionView13(patient: patientViewModel.patient).environmentObject(patientListViewModel)) {Text("Past Admissions")}
                                }
                            }
                            .customedListRowBackground()
                            .customedLeadingPadding()
                        }
                        Button(action: {
                            patientViewModel.showDeletionAlert = true
                        }, label: {
                            HStack {
                                Spacer()
                                Text("Delete Admission").foregroundColor(.red)
                                Spacer()
                            }
                        })
                        .customedListRowBackground()
                        .disabled(patientViewModel.patient.mostRecentAdmission.discharged)
                        .alert(isPresented: $patientViewModel.showDeletionAlert) {
                            Alert(title: Text("Confirm"), message: Text("Are you sure you want to delete?"), primaryButton: .cancel(), secondaryButton: .destructive(Text("Yes")){deleteAdmission()})
                        }
                    }
                    .edgesIgnoringSafeArea(.horizontal)
                    
                    if patientViewModel.showChooseView {Color.white.overlay(DefaultView(choose: true))}
                    
                    if patientViewModel.showPicker {
                        Spacer()
                        VStack(spacing: 0) {
                            Spacer()
                            HStack {
                                Button("Cancel") {patientViewModel.showPicker = false}
                                    .padding()
                                Spacer()
                                Button("Done", action: dischargePatient)
                                    .padding()
                                    .disabled(patientViewModel.patient.mostRecentAdmission.discharged)
                            }
                            .frame(height: 40)
                            .background(Color.init(UIColor.init(hex: "#bbbbbbFF")!))
                            Divider()
                            DatePicker("", selection: $patientViewModel.dischargeDate, in: Date(timeIntervalSince1970: patientViewModel.patient.mostRecentAdmission.admissionDate)...Date(), displayedComponents: .date)
                                .labelsHidden()
                                .datePickerStyle(WheelDatePickerStyle())
                                .frame(maxWidth: .infinity)
                                .background(Color(UIColor.systemGroupedBackground).edgesIgnoringSafeArea(.bottom))
                        }
                    }
            }
        }
//        .navigationBarColor()
        .customedBackground()
        .navigationBarTitle(Text(patientViewModel.lastAdmissionDischarged ? "" : patientViewModel.patient.patientFileNumber), displayMode: .inline)
        .navigationBarItems(trailing: Button(patientViewModel.lastAdmissionDischarged ? "" : patientViewModel.dischargeString) {
            patientViewModel.showPicker.toggle()
        })
        .alert(isPresented: $patientViewModel.showAlert) { //this is new
            Alert(title: Text("Error"), message: Text(patientViewModel.alertMessage))
        }
    }
    
    func dischargePatient() {
        patientViewModel.discharge()
        if UIDevice.current.userInterfaceIdiom == .pad {
            patientViewModel.showPicker = false
            deleteOrDischargeAdmissionIpad()
        }
        else {presentationMode.wrappedValue.dismiss()}
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            patientListViewModel.loadPatients()
        }
    }
    func deleteAdmission() {
        var index: Int {patientViewModel.patient.patientAdmissions.count - 1}
        patientViewModel.deleteAdmission {
                if UIDevice.current.userInterfaceIdiom == .pad {deleteOrDischargeAdmissionIpad()}
                else {presentationMode.wrappedValue.dismiss()}
            if patientViewModel.patient.patientAdmissions.count > 1 {
                patientViewModel.patient.patientAdmissions.remove(at: index)
            } else {
                patientListViewModel.patients.removeAll(where: {$0.patient.patientFileNumber == patientViewModel.patient.patientFileNumber})
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                patientListViewModel.loadPatients()
            }
        }
    }
    func deleteOrDischargeAdmissionIpad() {
        patientViewModel.showChooseView = true
        patientListViewModel.selected = nil
        patientViewModel.lastAdmissionDischarged = true
    }
}

