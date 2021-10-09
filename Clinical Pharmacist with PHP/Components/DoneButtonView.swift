//
//  DoneButtonView.swift
//  Clinical Pharmacist with PHP
//
//  Created by Mohammed Almutawa on 4/14/21.
//

import SwiftUI
struct DoneButtonView: View {
    @Binding var wait: Bool
    var body: some View {
        if !wait {
            HStack {
                Spacer()
                Text("Done")
                Spacer()
            }
        } else {
            HStack {
                Spacer()
                ActivityIndicator(isAnimating: .constant(true), style: .large)
                Spacer()
            }
        }
    }
}

