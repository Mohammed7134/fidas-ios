//
//  MedicineViewOnly.swift
//  Clinical Pharmacist with PHP
//
//  Created by Mohammed Almutawa on 4/13/21.
//

import SwiftUI

struct MedicineViewOnlyMode: View {
    let admission: PatientAdmission
    let type: String
    var body: some View {
        VStack {
            if !admission.medicines.filter({$0.listType == type}).isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(admission.medicines.filter({$0.listType == type}), id: \.medicineId) {med in
                            VStack(spacing: 6) {
                                Text(med.name)
                                Group {
                                    Text("\(med.dose, specifier: "%.2f") \(med.unit) \(med.route) \(med.frequency)")
                                    Text("Started on \(med.startDateString)")
                                    if med.stopped {
                                        Text("Stopped on \(med.stopDateString)")
                                    }
                                }.frame(minWidth: 100).font(.subheadline).padding().background(Color.blue.opacity(0.2)).clipShape(RoundedRectangle(cornerRadius: 20)).padding(.trailing)
                            }
                            Divider()
                        }
                    }.customedListRowBackground()
                }
            } else {
                Spacer()
                Text("There is no medicine in this list").padding().background(Color.pink.opacity(0.4))
            }
            Spacer()
        }
    }
}
