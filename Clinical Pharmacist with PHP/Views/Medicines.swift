//
//  Medicines.swift
//  Clinical Pharmacist with PHP
//
//  Created by Mohammed Almutawa on 3/15/21.
//

import SwiftUI

struct Medicines: View {
    @EnvironmentObject var patientViewModel: PatientViewModel
    var body: some View {
        VStack {
            Picker("", selection: $patientViewModel.selection) {ForEach(LIST_TYPES, id:\.self) {Text($0)}}
            .pickerStyle(SegmentedPickerStyle())
            .padding(.top)
            if patientViewModel.selection == "Home" {
                MedicationsView(type: "Home")
            } else if patientViewModel.selection == "Current" {
                MedicationsView(type: "Current")
            } else if patientViewModel.selection == "Discharge" {
                MedicationsView(type: "Discharge")
            }
        }
        .customedBackground()
        .simultaneousGesture(
            DragGesture()
                .onEnded({ (value) in
                    if value.translation.width > 50{// minimum drag...
                        self.changeView(left: false)
                    }
                    if -value.translation.width > 50{
                        self.changeView(left: true)
                    }
                }))
    }
    func changeView(left : Bool){
        if left{
            if patientViewModel.selection == "Home"{
                patientViewModel.selection = "Current"
            } else if patientViewModel.selection == "Current" {
                patientViewModel.selection = "Discharge"
            }
        }
        else{
            if patientViewModel.selection == "Discharge"{
                patientViewModel.selection = "Current"
            } else if patientViewModel.selection == "Current" {
                patientViewModel.selection = "Home"
            }
        }
    }
}

//struct Medicines_Previews: PreviewProvider {
//    static var previews: some View {
//        Medicines()
//    }
//}
