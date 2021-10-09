//
//  SigninButton.swift
//  Cinical Pharmacist
//
//  Created by Mohammed Almutawa on 10/15/20.
//  Copyright © 2020 Mohammed Almutawa. All rights reserved.
//


import SwiftUI

struct SigninButton: View {
    var action: () -> Void
    @Binding var wait: Bool
    var label: String
    var altLabel: String
    var color = Color.blue
    var body: some View {
        Button(action: action) {
            HStack {
                Spacer()
                if !self.wait {
                    Text(label).fontWeight(.bold).foregroundColor(Color.white)
                } else {
                    Text(altLabel).fontWeight(.bold).foregroundColor(Color.white)
                }
                Spacer()
            }
            
        }.modifier(SigninButtonModifier(color: color))
    }
}
