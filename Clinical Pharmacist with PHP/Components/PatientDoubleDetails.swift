//
//  PatientDoubleDetails.swift
//  Cinical Pharmacist
//
//  Created by Mohammed Almutawa on 10/18/20.
//  Copyright © 2020 Mohammed Almutawa. All rights reserved.
//

import SwiftUI

struct PatientDoubleDetails: View {
    var title: String = "Weights"
    var placeholder: String = "weight"
    var unit: String = "mg"
    var fluidChart = false
    var admissionDate = Date()
    @Binding var array: [FlexDouble]
    var discharged = false
    var body: some View {
        
        NavigationLink(destination: ExtractedDoubleView(title: title, placeholder: placeholder, unit: unit, fluidChart: fluidChart, admissionDate: admissionDate, array: $array, discharged: discharged)
        ) {
            HStack{
                Text("last \(placeholder): \(fluidChart ? array.last?.sign ?? "" : "") \(array.last?.value ?? 000, specifier: "%.2f") \(unit)")
                Spacer()
                Text(array.last != nil ? array.last!.dateString : "unknown")
            }
        }
    }
}



struct ExtractedDoubleView: View {
    var title: String = "Weights"
    var placeholder: String = "weight"
    var unit: String = "mg"
    var fluidChart = false
    var admissionDate = Date()
    @Binding var array: [FlexDouble]
    var discharged = false
    @State private var selectedSign = "+"
    @State private var showTextField = false
    @State private var date = Date()
    @State private var text = ""
    @State private var updatePage: Bool = true
    @State var error: Bool = false
    var body: some View {
        GeometryReader { geometry in
            Form{
                if !discharged {
                    CustomTextField(placeholder, rules: Rules.weightAndHeightAndBalance, text: $text, error: $error, keyType: .decimalPad, limitCharacters: 6, showToolBar: !fluidChart, order: doneTabbed)
                        .customedListRowBackground()
                    if self.fluidChart {
                        Picker(selection: self.$selectedSign, label: Text("Select sign")) {
                            ForEach(["+", "-"], id: \.self) {sign in Text(sign)}
                        }
                        .pickerStyle(SegmentedPickerStyle()).labelsHidden()
                        .customedListRowBackground()
                        DatePicker("", selection: self.$date, in: self.admissionDate...Date(), displayedComponents: .date)
                            .labelsHidden()
                            .customedListRowBackground()
                        Button("Submit this value") {self.submitTabbed()}
                            .disabled(discharged)
                            .customedListRowBackground()
                    }
                }
                
                    Section{
                        List{
                            ForEach(array, id: \.self) { 
                                each in
                                HStack {
                                    Text((self.fluidChart && each.sign != nil) ? each.sign! : "")
                                    Text("\(each.value, specifier: "%.2f") \(self.unit)")
                                    Spacer()
                                    Text(each.dateString)
                                }.customedListRowBackground()
                            }.onDelete(perform: removeRows)
                        }
                    }
                }
            .navigationBarTitle(title)
            .customedBackground()
        }
    }
    func removeRows(at offsets: IndexSet) {
        if !discharged {
            array.remove(atOffsets: offsets)
            updatePage.toggle()
        }
    }
    
    func doneTabbed() {
        text = text.trimmingCharacters(in: .whitespacesAndNewlines)
        if !self.fluidChart {
            if !error {
                array.append(FlexDouble(date: Date().timeIntervalSince1970, value: Double(text) ?? 0, sign: nil))
                text = ""
                showTextField.toggle()
            }
        }
    }
    func submitTabbed() {
        if !self.text.isEmpty {
            if !error {
                array.append(FlexDouble(date: date.timeIntervalSince1970, value: Double(text) ?? 0, sign: fluidChart ? selectedSign : nil))
                text = ""
                showTextField.toggle()
            }
        }
    }
}
