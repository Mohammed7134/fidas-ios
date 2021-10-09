//
//  UITextField.swift
//  Clinical Pharmacist with PHP
//
//  Created by Mohammed Almutawa on 4/6/21.
//

import Combine
import SwiftUI

struct TextFieldWithFocus: UIViewRepresentable {
    class Coordinator: NSObject, UITextFieldDelegate {
        @Binding var text: String
        @Binding var isFirstResponder: Bool
        var didBecomeFirstResponder = false
        var limitCharacters: Int
        var showToolBar: Bool
        var onCommit: () -> Void
        init(text: Binding<String>, isFirstResponder: Binding<Bool>, limitCharacters: Int, showToolBar: Bool, onCommit: @escaping () -> Void) {
            _text = text
            _isFirstResponder = isFirstResponder
            self.onCommit = onCommit
            self.limitCharacters = limitCharacters
            self.showToolBar = showToolBar
        }
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            // get the current text, or use an empty string if that failed
            let currentText = textField.text ?? ""

            // attempt to read the range they are trying to change, or exit if we can't
            guard let stringRange = Range(range, in: currentText) else { return false }

            // add their new text to the existing text
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

            // make sure the result is under 16 characters
            return updatedText.count <= limitCharacters
        }
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            text = textField.text ?? ""
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            isFirstResponder = false
            didBecomeFirstResponder = false
            onCommit()
            return true
        }
        
        func textFieldDidEndEditing(_ textField: UITextField) {
            isFirstResponder = false
            didBecomeFirstResponder = false
        }
        func textFieldDidBeginEditing(_ textField: UITextField) {
            isFirstResponder = true
        }
        @objc func doneButtonTapped(button:UIBarButtonItem) -> Void {
            isFirstResponder = false
            didBecomeFirstResponder = false
            onCommit()
        }
    }
    @Binding var text: String
    var placeholder: String
    @Binding var isFirstResponder: Bool
    var textAlignment: NSTextAlignment = .left
    var isSecure: Bool = false
    var keyboardType: UIKeyboardType = .default
    var returnKeyType: UIReturnKeyType = .default
    var textContentType: UITextContentType?
    var textFieldBorderStyle: UITextField.BorderStyle = .none
    var enablesReturnKeyAutomatically: Bool = false
    @State var frameRect: CGRect = .zero
    let limitCharacters: Int
    var showToolBar: Bool
    var onCommit: (() -> Void)?
    func setFrameRect(_ rect: CGRect) -> some View {
        self.frameRect = rect
        return self
    }
    func makeUIView(context: UIViewRepresentableContext<TextFieldWithFocus>) -> UITextField {
        let textField = UITextField(frame: self.frameRect)
        textField.delegate = context.coordinator
        textField.placeholder = NSLocalizedString(placeholder, comment: "")
        textField.textAlignment = textAlignment
        textField.adjustsFontSizeToFitWidth = true
        textField.isSecureTextEntry = isSecure
        textField.keyboardType = keyboardType
        textField.returnKeyType = returnKeyType
        textField.textContentType = textContentType
        textField.borderStyle = textFieldBorderStyle
        textField.enablesReturnKeyAutomatically = enablesReturnKeyAutomatically
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton2 = UIBarButtonItem(title: "Done", style: .done, target: context.coordinator, action: #selector(context.coordinator.doneButtonTapped(button:)))

        toolBar.setItems([spacer, doneButton2], animated: true)
        toolBar.barStyle = UIBarStyle.default
        toolBar.sizeToFit()
        if showToolBar {
            textField.inputAccessoryView = toolBar
        }
        return textField
    }
    
    func makeCoordinator() -> TextFieldWithFocus.Coordinator {
        return Coordinator(text: $text, isFirstResponder: $isFirstResponder, limitCharacters: limitCharacters, showToolBar: showToolBar, onCommit: {
            self.onCommit?()
        })
    }
    
    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<TextFieldWithFocus>) {
        uiView.text = text
        if isFirstResponder && !context.coordinator.didBecomeFirstResponder {
            uiView.becomeFirstResponder()
            context.coordinator.didBecomeFirstResponder = true
        }
    }
}
struct TextFieldWithFocus_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldWithFocus(text: .constant(""), placeholder: "placeholder", isFirstResponder: .constant(false), limitCharacters: 10, showToolBar: true)
            .modifier(SearchFieldModifier())
    }
}
