//
//  PharmacyPicker.swift
//  Fidas
//
//  Created by Mohammed Almutawa on 5/16/21.
//

import SwiftUI
struct PharmacyPicker: View {
    @Binding var hospital: Hospital
    @Binding var pharmacy: String
    @State private var toggle = false
    var body: some View {
        let customPharmacyBinding = Binding<String>(get: {
            self.pharmacy
        }, set: { val in
            self.pharmacy = val
            self.toggle.toggle()
        })
        return VStack {
            HStack {
                Image(systemName: "waveform.path.ecg").foregroundColor(Color(red: 0, green: 0, blue: 0, opacity: 0.3))
                Text("Choose Pharmacy")
                Spacer()
                Text(customPharmacyBinding.wrappedValue)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation{self.toggle.toggle()}
            }
            .modifier(TextFieldModifier())
            
            if toggle {
                Picker(selection: customPharmacyBinding, label: Text(TEXT_PHARMACY), content: {
                    ForEach(hospital.pharNames(), id: \.self) {
                        pharm in
                        Text(pharm)
                    }
                })
                .pickerStyle(WheelPickerStyle())
                .labelsHidden()
            }
        }
    }
}
