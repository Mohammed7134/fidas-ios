//
//  TextView.swift
//  Fidas
//
//  Created by Mohammed Almutawa on 5/29/21.
//

import UIKit
import Foundation
import SwiftUI

struct TextView: UIViewRepresentable {
    @Binding var text: String
    let textDidChange: (UITextView) -> Void
    @State var placeholderLabel = UILabel()
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> UITextView {
        
        let myTextView = UITextView()

        myTextView.delegate = context.coordinator
        myTextView.font = UIFont(name: "HelveticaNeue", size: 17)
        myTextView.isScrollEnabled = true
        myTextView.isEditable = true
        myTextView.isUserInteractionEnabled = true
        placeholderLabel.text = "Enter content here..."
        placeholderLabel.font = UIFont.italicSystemFont(ofSize: (myTextView.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        myTextView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (myTextView.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !myTextView.text.isEmpty
        return myTextView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
        placeholderLabel.isHidden = !uiView.text.isEmpty
        DispatchQueue.main.async {
            self.textDidChange(uiView)
        }
    }
    
    class Coordinator : NSObject, UITextViewDelegate {
        
        var parent: TextView
        
        init(_ uiTextView: TextView) {
            self.parent = uiTextView
        }
        
        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            return true
        }
        
        func textViewDidChange(_ textView: UITextView) {
            self.parent.text = textView.text
            self.parent.textDidChange(textView)
        }
    }
}
