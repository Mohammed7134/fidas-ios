//
//  PatientBedDetails.swift
//  Clinical Pharmacist with PHP
//
//  Created by Mohammed Almutawa on 3/21/21.
//

import SwiftUI

struct PatientBedDetails: View {
    var title = ""
    var placeholder = ""
    var showLast = false
    var showRequired = false
    @Binding var array: [FlexString]
    var discharged = false
    var body: some View {
        NavigationLink(destination: ExtractedBedView(title: title, placeholder: placeholder, array: $array, discharged: discharged)
        ) {
            HStack {
                Text(title)
                if showRequired && array.isEmpty {Text("(required)").opacity(0.3)}
                Spacer()
                if showLast {Text("\(array.last?.name ?? "")")}
                
            }
        }
    }
}


struct ExtractedBedView: View {
    var title = ""
    var placeholder = ""
    @Binding var array: [FlexString]
    var discharged = false
    @State private var showTextField = false
    @State private var text: String = ""
    @State private var updatePage: Bool = true
    @State private var error = false
    var body: some View {
        GeometryReader { geometry in
            Form {
                if !discharged {
                    CustomTextField(placeholder, rules: Rules.bedAndWardAndFn, text: $text, error: $error, keyType: .alphabet, order: onCommitAction)
                        .customedListRowBackground()
                }
                Section {
                    List {
                        ForEach(self.array, id: \.self) { item in Text(item.name) }
                            .onDelete(perform: removeRows)
                            .customedListRowBackground()
                    }
                }
            }
            .customedBackground()
            .navigationBarTitle(title)
        }
    }
    fileprivate func onCommitAction() {
        if !error && !text.isEmpty {
            self.array.append(FlexString(date: Date().timeIntervalSince1970, name: self.text))
            self.text = ""
            self.showTextField.toggle()
        }
    }
    func removeRows(at offsets: IndexSet) {
        if !discharged {
            array.remove(atOffsets: offsets)
            updatePage.toggle()
        }
    }
}
