//
//  SwiftUITextField.swift
//  Clinical Pharmacist with PHP
//
//  Created by Mohammed Almutawa on 3/17/21.
//

import SwiftUI
struct CustomTextField: View {
    let placeholder: String
    let rules: NSPredicate?
    @Binding var enteredTextValue: String
    @Binding var error: Bool
    let keyType: UIKeyboardType
    let limitCharacters: Int
    var showToolBar: Bool
    let optional: Bool
    let order: (() -> Void)
    
   
    
    init(_ placeholder: String, rules: NSPredicate? = nil, text: Binding<String>, error: Binding<Bool>, keyType: UIKeyboardType, limitCharacters: Int = 40, showToolBar: Bool = false, optional: Bool = false, order: @escaping (() -> Void) = {}) {
        self.placeholder = placeholder
        self.rules = rules
        self._enteredTextValue = text
        self._error = error
        self.keyType = keyType
        self.limitCharacters = limitCharacters
        self.showToolBar = showToolBar
        self.optional = optional
        self.order = order
    }
    func checkIfTextsMatch() {
        DispatchQueue.main.async {
            if rules != nil {
                self.error = !rules!.evaluate(with: enteredTextValue)
            }
        }
    }
    var body: some View {
        let textValueBinding = Binding<String>(get: {
            self.enteredTextValue
        }, set: { val in
            DispatchQueue.main.async {
                self.enteredTextValue = val
                if !optional {
                    self.checkIfTextsMatch()
                } else {
                    self.checkIfTextsMatch()
                }
            }
        })
        
        return
            TextFieldWithFocus(text: textValueBinding,
                               placeholder: NSLocalizedString(placeholder, comment: ""), isFirstResponder: .constant(false), keyboardType: keyType, limitCharacters: limitCharacters, showToolBar: showToolBar, onCommit: {
                                hideKeyboard()
                                order()
                               })
            .padding(.horizontal, 5)
            .border(error ? Color.red : Color.clear, width: 1)

    }
}
