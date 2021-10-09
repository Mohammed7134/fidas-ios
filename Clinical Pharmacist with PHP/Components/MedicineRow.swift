//
//  MedicineRow.swift
//  Clinical Pharmacist with PHP
//
//  Created by Mohammed Almutawa on 4/13/21.
//

import SwiftUI

struct MedicineRow: View {
    let admission: PatientAdmission
    let index: Int
    var body: some View {
        VStack {
            HStack {Text("\(admission.medicines[index].name)"); Spacer()}
            HStack {
                Text("\(admission.medicines[index].dose, specifier: "%.2f") \(admission.medicines[index].unit) \(admission.medicines[index].route) \(admission.medicines[index].frequency)")
                Spacer()
                Text(admission.medicines[index].startDateString)
            }
        }
    }
}
