//
//  LabsView.swift
//  Cinical Pharmacist
//
//  Created by Mohammed Almutawa on 11/12/20.
//  Copyright © 2020 Mohammed Almutawa. All rights reserved.
//
import Charts
import SwiftUI

struct LabView: View {
    let refVals: [(String, Double, Double, String, String)]
    let results: [String: [OptionalFlexDouble]]
    let type: String
    @State var selected = "Na"
    @State var showSheet = false
    @EnvironmentObject var patientViewModel: PatientViewModel
    var body: some View {
        return VStack {
            LineChart(values: results[selected]).background(Color.white)
            Form {
                Section(header: Text(type)) {
                    ForEach(refVals, id: \.self.0) { refVal in
                        HStack {
                            Text("\(refVal.0) (\(refVal.1, specifier: "%.2f") - \(refVal.2, specifier: "%.2f")) \(refVal.3)")
                            Spacer()
                            Text("\(results[refVal.0]?.sorted().last?.value ?? 0.0, specifier: "%.2f")")
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {self.selected = refVal.0
                            print(results)
                        }
                        .listRowBackground(self.selected == refVal.0 ? Color.blue.opacity(0.3) : Color(UIColor.systemBackground))
                    }
                    Button("Add") {self.showSheet = true}
                        .disabled(patientViewModel.patient.mostRecentAdmission.discharged)
                        .customedListRowBackground()
                }
                Section {
                    ForEach(0..<patientViewModel.patient.mostRecentAdmission.labs.count, id:\.self) { num in
                        NavigationLink(destination: EditLabView(labs: $patientViewModel.patient.mostRecentAdmission.labs, index: num)) {
                            Text(patientViewModel.patient.mostRecentAdmission.labs[num].dateString)
                        }
                        .disabled(patientViewModel.patient.mostRecentAdmission.discharged)
                    }
                }.customedListRowBackground()
            }
            .sheet(isPresented: self.$showSheet) {
                if #available(iOS 14.0, *) {
                    LabAddingView14(patientViewModel: patientViewModel, type: type, refValues: refVals)
                } else {
                    LabAddingView13(patientViewModel: patientViewModel, type: type, refValues: refVals)
                }
            }
            .customedBackground()
//            .navigationBarColor()
            .navigationBarTitle(Text(self.selected), displayMode: .inline)
        }
    }
    
}

struct EditLabView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var labs: [Lab]
    let index: Int
    var body: some View {
        let keys = labs[index].values.map{$0.key}
        let values = labs[index].values.map{$0.value}
        return Form{
            List {
                ForEach(keys.indices) {index in
                    if values[index] != nil {
                        HStack{
                            Text("\(keys[index])")
                            Spacer()
                            Text("\(values[index]!, specifier: "%.2f")")
                        }.customedListRowBackground()
                    }
                }
                Section {
                    HStack {
                        Spacer()
                        Button("Delete") {
                            presentationMode.wrappedValue.dismiss()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                                labs.remove(at: index)
                            }
                        }.foregroundColor(.red)
                        Spacer()
                    }
                }.customedListRowBackground()
            }
        }
//        .navigationBarColor()
        .customedBackground()
    }
}
