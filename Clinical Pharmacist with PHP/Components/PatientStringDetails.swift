//
//  PatientStringDetails.swift
//  Cinical Pharmacist
//
//  Created by Mohammed Almutawa on 10/18/20.
//  Copyright © 2020 Mohammed Almutawa. All rights reserved.
//

import SwiftUI

struct PatientStringDetails: View {
    var title = "Past Medical History"
    var placeholder = "condition"
    var showLast = false
    var showRequired = false
    @Binding var array: [String]
    var discharged: Bool = false
    @State private var showTextField = false
    @State private var text: String = ""
    @State private var updatePage: Bool = true
    @State var error = false
    var body: some View {
        NavigationLink(destination: ExtractedStringView(title: title, placeholder: placeholder, array: $array, discharged: discharged, error: error)) {
            HStack {
                Text(title)
                if showRequired && array.isEmpty {Text("(required)").opacity(0.3)}
                Spacer()
                if showLast {Text("\(array.last ?? "")")}
            }
        }.customedListRowBackground()
    }
}

struct ExtractedStringView: View {
    var title = "Past Medical History"
    var placeholder = "condition"
    @Binding var array: [String]
    var discharged: Bool = false
    @State private var text: String = ""
    @State var error = false
    var body: some View {
        GeometryReader { geometry in
            Form {
                if !discharged {
                    CustomTextField(placeholder, rules: Rules.condition, text: $text, error: $error, keyType: .alphabet, order: onCommitAction)
                        .customedListRowBackground()
                }
                Section {
                    List {
                        ForEach(array, id: \.self) {item in Text(item)}
                            .onDelete(perform: removeRows)
                            .customedListRowBackground()
                    }
                }
//                Spacer()
            }
            .customedBackground()
            .navigationBarTitle(title)
        }
    }
    fileprivate func onCommitAction() {
        text = text.trimmingCharacters(in: .whitespacesAndNewlines)
        if array.first(where: {$0 == text}) == nil {
            if !error && !text.isEmpty {
                array.append(text)
                text = ""
            }
        } else {
            error = true
        }
    }
    func removeRows(at offsets: IndexSet) {
        if !discharged {
            array.remove(atOffsets: offsets)
        }
    }
}
