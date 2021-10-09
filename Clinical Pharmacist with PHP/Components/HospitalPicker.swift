//
//  HospitalTextField.swift
//  Cinical Pharmacist
//
//  Created by Mohammed Almutawa on 10/17/20.
//  Copyright © 2020 Mohammed Almutawa. All rights reserved.
//

import SwiftUI

struct HospitalPicker: View {
    @Binding var hospital: Hospital
    @State private var toggle = false
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "house").foregroundColor(Color(red: 0, green: 0, blue: 0, opacity: 0.3))
                Text("Choose hospital")
                Spacer()
                Text(hospital.hpName())
            }
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation{self.toggle.toggle()}
            }
            .modifier(TextFieldModifier())
            
            if toggle {
                Picker(selection: self.$hospital, label: Text(TEXT_HOSPITAL), content: {
                    ForEach(HOSPITALS_LIST, id: \.self) {
                        hosp in
                        Text(hosp.hpName())
                    }
                })
                .pickerStyle(WheelPickerStyle())
                .labelsHidden()
            }
        }
    }
}
