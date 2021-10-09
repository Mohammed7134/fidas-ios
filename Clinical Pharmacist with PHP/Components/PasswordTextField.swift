//
//  PasswordTextField.swift
//  Cinical Pharmacist
//
//  Created by Mohammed Almutawa on 10/15/20.
//  Copyright © 2020 Mohammed Almutawa. All rights reserved.
//

import SwiftUI

struct PasswordTextField: View {
    
    @Binding var password: String
    var placeholder = TEXT_PASSWORD
    var action: () -> Void = {}

    var body: some View {
        HStack {
            Image(systemName: "lock.fill").foregroundColor(Color(red: 0, green: 0, blue: 0, opacity: 0.3))
            SecureField(placeholder, text: $password, onCommit: action).textContentType(.password).keyboardType(.alphabet)
        }.modifier(TextFieldModifier())
    }
}
