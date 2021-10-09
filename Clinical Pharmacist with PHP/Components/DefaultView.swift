//
//  DefaultView.swift
//  Clinical Pharmacist with PHP
//
//  Created by Mohammed Almutawa on 4/15/21.
//

import SwiftUI

struct DefaultView: View {
    var choose = false
    var body: some View {
        VStack {
            Image(IMAGE_LOGO).resizable().aspectRatio(contentMode: .fill).frame(width: 300, height: 300)
            if !choose {
                Text("Welcome to Patient Follow-up app.").font(.title)
                Text("Please Choose a patient from the list in the left side").font(.subheadline)
            } else {
                Text("Choose another patient from the list.").font(.title)
            }
        }
    }
}
