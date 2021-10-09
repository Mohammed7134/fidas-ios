//
//  MedicationAdding.swift
//  Cinical Pharmacist
//
//  Created by Mohammed Almutawa on 10/18/20.
//  Copyright © 2020 Mohammed Almutawa. All rights reserved.
//

import SwiftUI
import Combine
@available (iOS 14, *)
struct MedicationAdding14: View {
    @StateObject var searchMedicnieViewModel = SearchMedicineViewModel()
    @StateObject var medicineAddingViewModel = MedicineAddingViewModel()
    @ObservedObject var patientViewModel: PatientViewModel
    let type: String
    var body: some View {
        MedicationAdding(searchMedicnieViewModel: searchMedicnieViewModel, medicineAddingViewModel: medicineAddingViewModel, patientViewModel: patientViewModel, type: type)
    }
}

struct MedicationAdding13: View {
    @ObservedObject var searchMedicnieViewModel = SearchMedicineViewModel()
    @ObservedObject var medicineAddingViewModel = MedicineAddingViewModel()
    @ObservedObject var patientViewModel: PatientViewModel
    let type: String
    var body: some View {
        MedicationAdding(searchMedicnieViewModel: searchMedicnieViewModel, medicineAddingViewModel: medicineAddingViewModel, patientViewModel: patientViewModel, type: type)
    }
}


struct MedicationAdding: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var searchMedicnieViewModel: SearchMedicineViewModel
    @ObservedObject var medicineAddingViewModel: MedicineAddingViewModel
    @ObservedObject var patientViewModel: PatientViewModel
    let type: String
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Choose medicine").foregroundColor(.white)) {
                    NavigationLink(destination: SearchMedicineView(searchMedicnieViewModel: searchMedicnieViewModel)) {
                        Text(searchMedicnieViewModel.searchText.isEmpty ? "Find a medicine" : searchMedicnieViewModel.searchText)
                    }
                    CustomTextField("indication", rules: Rules.condition, text: $medicineAddingViewModel.indication, error: $medicineAddingViewModel.indicationError, keyType: .alphabet)
                    HStack {
                        CustomTextField("dose", rules: Rules.weightAndHeightAndBalance, text: $medicineAddingViewModel.dose, error: $medicineAddingViewModel.doseError, keyType: .decimalPad, limitCharacters: 6)
                        Divider()
                        CustomTextField("unit", rules: Rules.condition, text: $medicineAddingViewModel.unit, error: $medicineAddingViewModel.unitError, keyType: .alphabet, limitCharacters: 6)
                        Divider()
                        CustomTextField("route", rules: Rules.condition, text: $medicineAddingViewModel.route, error: $medicineAddingViewModel.routeError, keyType: .alphabet, limitCharacters: 10)
                        Divider()
                        CustomTextField("frequency", rules: Rules.frequency, text: $medicineAddingViewModel.frequency, error: $medicineAddingViewModel.frequencyError, keyType: .alphabet, limitCharacters: 10)
                    }
                }
                .customedListRowBackground()
                
                Section {
                    TextField("Thing to monitor", text: $medicineAddingViewModel.newThing, onCommit:  addThing)
                        .customedListRowBackground()
                    ForEach(medicineAddingViewModel.thingsToMonitor, id: \.self) { thing in
                        Text(thing)
                            .customedListRowBackground()
                    }
                }
                Section {
                    DatePicker(selection: $medicineAddingViewModel.startDate, in: ...Date(), displayedComponents: .date) {Text("Start Date")}
                        .customedListRowBackground()
                    Toggle(isOn: $medicineAddingViewModel.stopped, label: {Text("Stopped")})
                        .customedListRowBackground()
                    if medicineAddingViewModel.stopped {
                        DatePicker(selection: $medicineAddingViewModel.stopDate, in: medicineAddingViewModel.startDate...Date(), displayedComponents: .date) {Text("Stop Date")}
                            .customedListRowBackground()
                    }
                }
            }
            .customedBackground()
            .navigationBarTitle("Adding Medicine", displayMode: .inline)
            .navigationBarItems(leading: Button("Cancel") {presentationMode.wrappedValue.dismiss()},
                                trailing: Button(action: onDone) {Text("Done")})
            .alert(isPresented: $medicineAddingViewModel.showAlert) {
                Alert(title: Text("Error"), message: Text(medicineAddingViewModel.alertMessage), dismissButton: .default(Text("Ok")))
            }
        }
        .introspectViewController{$0.isModalInPresentation = true}
        .navigationViewStyle(StackNavigationViewStyle())
    }
    func onDone() {
        let admission = patientViewModel.patient.mostRecentAdmission
        medicineAddingViewModel.addMedicine(admissionId: admission.admissionId, type: type, pickedMedicine: searchMedicnieViewModel.searchText) { (medicine) in
            patientViewModel.patient.mostRecentAdmission.medicines.append(medicine)
            presentationMode.wrappedValue.dismiss()
        }
    }
    func addThing() {
        medicineAddingViewModel.addThing()
    }
}

struct SearchMedicineView: View {
    @Environment(\.presentationMode) var presentaionMode
    @ObservedObject var searchMedicnieViewModel: SearchMedicineViewModel
    var body: some View {
        VStack(spacing: 0){
            SearchBar(text: $searchMedicnieViewModel.searchText, isFirstResponder: true)
            List{
                if !searchMedicnieViewModel.isLoading {
                    ForEach(0..<searchMedicnieViewModel.medicines.count, id: \.self) { index in
                        HStack{
                            Text(searchMedicnieViewModel.medicines[index]).foregroundColor(.white)
                            Spacer()
                        }
                        .contentShape(Rectangle())
                        .listRowBackground(Color.clear)
                        .onTapGesture {
                            searchMedicnieViewModel.searchText = searchMedicnieViewModel.medicines[index]
                            presentaionMode.wrappedValue.dismiss()
                        }
                    }
                } else {
                    Text("Loading...")
                        .listRowBackground(Color.clear)

                }
            }
            Spacer()
        }
        .customedBackground()
        .navigationBarTitle("Search Medicines")
        .onAppear{searchMedicnieViewModel.searchText = ""}
    }
}
