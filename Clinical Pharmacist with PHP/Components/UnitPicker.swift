//
//  UnitTextField.swift
//  Cinical Pharmacist
//
//  Created by Mohammed Almutawa on 10/17/20.
//  Copyright © 2020 Mohammed Almutawa. All rights reserved.
//

import SwiftUI

struct UnitPicker: View {
    @Binding var unit: String
    @Binding var hospital: Hospital
    @State private var toggle = false
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "waveform.path.ecg").foregroundColor(Color(red: 0, green: 0, blue: 0, opacity: 0.3))
                Text("Choose Unit")
                Spacer()
                Text(unit)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation{self.toggle.toggle()}
            }
            .modifier(TextFieldModifier())
            
            if toggle {
                Picker(selection: self.$unit, label: Text(TEXT_UNIT), content: {
                    ForEach(hospital.units(), id: \.self) {
                        un in
                        Text(un)
                    }
                })
                .pickerStyle(WheelPickerStyle())
                .labelsHidden()
            }
        }
    }
}
