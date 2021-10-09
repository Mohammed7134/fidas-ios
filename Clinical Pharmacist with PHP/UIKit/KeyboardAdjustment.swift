//
//  KeyboardAdjustment.swift
//  Cinical Pharmacist
//
//  Created by Mohammed Almutawa on 10/18/20.
//  Copyright © 2020 Mohammed Almutawa. All rights reserved.
//

import Combine
import SwiftUI
import UIKit

extension Publishers {
    // 1.
     static var keyboardHeight: AnyPublisher<CGFloat, Never> {
        // 2.
        let willShow = NotificationCenter.default.publisher(for: UIApplication.keyboardWillShowNotification)
            .map { $0.keyboardHeight }
        
        let willHide = NotificationCenter.default.publisher(for: UIApplication.keyboardWillHideNotification)
            .map { _ in CGFloat(0) }
        
        // 3.
        return MergeMany(willShow, willHide)
            .eraseToAnyPublisher()
    }
}

// adding a property to the type notification to store the height which is extracted from its sister property of type dictionary(only if the height value exists, otherwise it is zero)
extension Notification {
    var keyboardHeight: CGFloat {
        if #available(iOS 14.0, *) {
            return 0
        } else {
            return (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0
        }
    }
}
//setting viewModifier to add the padding whenever our keybiardHeight publisher emmits a value after it received it from a keyboard notification (using the method onReceive)
struct KeyboardAdaptive: ViewModifier {
    @State var keyboardHeight: CGFloat = 0
    var bottomInset: CGFloat
    func body(content: Content) -> some View {
        content
            .padding(.bottom, keyboardHeight > 0 ? (keyboardHeight - bottomInset) : 0)
            .onReceive(Publishers.keyboardHeight) { val in withAnimation(.easeIn(duration: 0.1)) {self.keyboardHeight = val}}
    }
}
//so you can use the viewModifier directly on the view
extension View {
    func keyboardAdaptive(bottomInset: CGFloat = 39) -> some View {
        self.modifier(KeyboardAdaptive(bottomInset: bottomInset))
    }
}
//struct KeyboardAdaptive1: ViewModifier {
//    @State var keyboardHeight: CGFloat = 0
//    func body(content: Content) -> some View {
//        content
//            .padding(.bottom, keyboardHeight > 0 ? (keyboardHeight - 8) : 0)
//            .onReceive(Publishers.keyboardHeight) { val in withAnimation(.easeIn(duration: 0.1)) {self.keyboardHeight = val}}
//    }
//}
////so you can use the viewModifier directly on the view
//extension View {
//    func keyboardAdaptive1() -> some View {
//        self.modifier(KeyboardAdaptive1())
//    }
//}



