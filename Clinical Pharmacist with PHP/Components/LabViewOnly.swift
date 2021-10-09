//
//  LabViewOnly.swift
//  Clinical Pharmacist with PHP
//
//  Created by Mohammed Almutawa on 4/13/21.
//

import SwiftUI

struct LabViewOnlyMode: View {
    let refVals: [(String, Double, Double, String, String)]
    let results: [String: [OptionalFlexDouble]]
    let type: String
    @State var selected = "Na"
    @State var showSheet = false
    @EnvironmentObject var patientViewModel: PatientViewModel
    var body: some View {
        VStack {
            LineChart(values: results[selected])
            Picker("", selection: $selected) {
                ForEach(refVals, id: \.self.0) { refVal in
                    Text(refVal.0)
                }
            }.pickerStyle(SegmentedPickerStyle())
            
        }
        .padding(.horizontal)
        .padding(.bottom)
    }
}
