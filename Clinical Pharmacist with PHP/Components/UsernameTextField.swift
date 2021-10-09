//
//  UsernameTextField.swift
//  Cinical Pharmacist
//
//  Created by Mohammed Almutawa on 10/15/20.
//  Copyright © 2020 Mohammed Almutawa. All rights reserved.
//

import SwiftUI

struct UsernameTextField: View {
      @Binding var username: String
     
     var body: some View {
         HStack {
             Image(systemName: "person.fill").foregroundColor(Color(red: 0, green: 0, blue: 0, opacity: 0.3))
            TextField(TEXT_USERNAME, text: $username).textContentType(.username).keyboardType(.alphabet)
         }.modifier(TextFieldModifier())
     }
}

