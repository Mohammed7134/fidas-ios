//
//  SignupText.swift
//  Cinical Pharmacist
//
//  Created by Mohammed Almutawa on 10/15/20.
//  Copyright © 2020 Mohammed Almutawa. All rights reserved.
//


import SwiftUI


struct SignupText: View {
    var body: some View {
        HStack {
            Text(TEXT_NEED_AN_ACCOUNT).font(.footnote).foregroundColor(.gray)
            Text(TEXT_SIGN_UP).foregroundColor(.black)
        }
    }
}
