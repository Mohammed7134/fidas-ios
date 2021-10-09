//
//  EmailTextField.swift
//  Cinical Pharmacist
//
//  Created by Mohammed Almutawa on 10/15/20.
//  Copyright © 2020 Mohammed Almutawa. All rights reserved.
//

import SwiftUI

struct EmailTextField: View {
    
    @Binding var email: String
    var onCommit: () -> Void = {}
    var body: some View {
        HStack {
            Image(systemName: "envelope.fill").foregroundColor(Color(red: 0, green: 0, blue: 0, opacity: 0.3))
            TextField(TEXT_EMAIL, text: $email, onCommit: onCommit).textContentType(.emailAddress).keyboardType(.emailAddress)
        }.modifier(TextFieldModifier())
    }
}
