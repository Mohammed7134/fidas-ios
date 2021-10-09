//
//  MedicationView.swift
//  Cinical Pharmacist
//
//  Created by Mohammed Almutawa on 10/23/20.
//  Copyright © 2020 Mohammed Almutawa. All rights reserved.
//
import SwiftUI

struct MedicationsView: View {
    @EnvironmentObject var patientViewModel: PatientViewModel
    var type: String = "Current"
    var body: some View {
        let admission = patientViewModel.patient.mostRecentAdmission
        return Form {
            if !admission.medicines.isEmpty {
                ForEach(0 ..< admission.medicines.count, id: \.self) { index in
                    if !admission.medicines[index].stopped && admission.medicines[index].listType == type {
                        NavigationLink(destination: MedicationDetails(index: index, type: type).environmentObject(patientViewModel)) {
                            MedicineRow(admission: admission, index: index)
                        }.customedListRowBackground()
                    } else if patientViewModel.showStopped && admission.medicines[index].stopped && admission.medicines[index].listType == type {
                        NavigationLink(destination: MedicationDetails(index: index, type: type).environmentObject(patientViewModel)) {
                            MedicineRow(admission: admission, index: index)
                        }.listRowBackground(Color.white.overlay(Color.pink.opacity(0.4)))
                    }
                }
                
                if !admission.medicines.filter{$0.stopped == true && $0.listType == type}.isEmpty {
                    Button(patientViewModel.showStopped ? "Hide Stopped Medicines" : "Show Stopped Medicines") {
                        patientViewModel.showStopped.toggle()
                    }.customedListRowBackground()
                }
            }
            
            Button("Add Medicine") {patientViewModel.showMedicineSheet = true}
                .disabled(patientViewModel.patient.mostRecentAdmission.discharged)
                .customedListRowBackground()
                .sheet(isPresented: $patientViewModel.showMedicineSheet) {
                    if #available(iOS 14.0, *) {
                        MedicationAdding14(patientViewModel: patientViewModel, type: type)
                    } else {
                        MedicationAdding13(patientViewModel: patientViewModel, type: type)
                    }
                }
        }.navigationBarTitle(Text("Medicines"), displayMode: .inline)
    }
}


struct MedicationDetails: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var patientViewModel: PatientViewModel
    let index: Int
    var type: String
    @State var thingToMonitor = ""
    @State var showDatePicker = false
    @State var stopDate = Date()
    @State var showAlert = false
    var body: some View {
        let admission = patientViewModel.patient.mostRecentAdmission
        let medicine = admission.medicines[index]
        return GeometryReader { geometry in
            Form {
                Group {
                    Text(medicine.name)
                    Text("\(medicine.dose, specifier: "%.2f") \(medicine.unit) \(medicine.route) \(medicine.frequency)")
                    Text("Indication: \(medicine.indication)")
                    Text("Start date: \(medicine.startDateString)")
                }.customedListRowBackground()
                
                Section(header: Text("Things To Monitor").foregroundColor(.white)) {
                    if !medicine.stopped {
                        TextField("Things to monitor", text: $thingToMonitor, onCommit: addThingToMonitor)
                    }
                    ForEach(medicine.thingsToMonitor, id: \.self) { thing in Text(thing)}
                        .onDelete(perform: removeRows)
                }
                .customedListRowBackground()
                Section {
                    if !medicine.stopped {
                        Button("Stop") {showDatePicker = true}
                    } else {
                        Text("Stopped on \(medicine.stopDateString)")
                    }
                    if showDatePicker {
                        DatePicker(selection: $stopDate, displayedComponents: .date, label: {Text("Stop Date")})
                        Button("Submit") {stopMedicine()}
                    }
                }
                .customedListRowBackground()
                Section {
                    HStack {
                        Spacer()
                        Button("Delete") {showAlert = true}
                            .foregroundColor(.red)
                            .alert(isPresented: $showAlert) {
                                Alert(title: Text("Confirm"), message: Text("Are you sure you want to delete this medicine"), primaryButton: .destructive(Text("Yes")) {deleteMedicine()}, secondaryButton: .cancel())}
                        Spacer()
                    }
                }
                .customedListRowBackground()
            }
            .customedBackground()
            .navigationBarTitle(Text(medicine.name), displayMode: .inline)
        }
    }
    func removeRows(at offsets: IndexSet) {
        let admission = patientViewModel.patient.mostRecentAdmission
        let medicine = admission.medicines[index]
        if !medicine.stopped {
            patientViewModel.patient.mostRecentAdmission.medicines[index].thingsToMonitor.remove(atOffsets: offsets)
        }
    }
    func stopMedicine() {
        let admission = patientViewModel.patient.mostRecentAdmission
        let medicine = admission.medicines[index]
        if let medicineIndex = patientViewModel.patient.mostRecentAdmission.medicines.firstIndex(where: {$0.medicineId == medicine.medicineId}) {
            patientViewModel.patient.mostRecentAdmission.medicines[medicineIndex].stopDate = stopDate.timeIntervalSince1970
            presentationMode.wrappedValue.dismiss()
        }
    }
    func deleteMedicine() {
        presentationMode.wrappedValue.dismiss()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            patientViewModel.patient.mostRecentAdmission.medicines.remove(at: index)
        }
    }
    func addThingToMonitor() {
        let admission = patientViewModel.patient.mostRecentAdmission
        let medicine = admission.medicines[index]
        if let medicineIndex = patientViewModel.patient.mostRecentAdmission.medicines.firstIndex(where: {$0.medicineId == medicine.medicineId}) {
            patientViewModel.patient.mostRecentAdmission.medicines[medicineIndex].thingsToMonitor.append(thingToMonitor)
            thingToMonitor = ""
        }
    }
}


//                if !admission.medicines.filter{$0.stopped == false && $0.listType == type}.isEmpty {


//                }
//                if patientViewModel.showStopped && !admission.medicines.filter{$0.stopped == true && $0.listType == type}.isEmpty {
//                    ForEach(0 ..< admission.medicines.count, id: \.self) { index in
//                        if admission.medicines[index].stopped && admission.medicines[index].listType == type {
//                            NavigationLink(destination: MedicationDetails(index: index, type: type).environmentObject(patientViewModel)) {
//                                MedicineRow(admission: admission, index: index)
//                            }.listRowBackground(Color.white.overlay(Color.pink.opacity(0.4)))
//                        }
//                    }
//                }
