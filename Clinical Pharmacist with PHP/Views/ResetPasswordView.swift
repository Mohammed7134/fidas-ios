//
//  ResetPasswordView.swift
//  Clinical Pharmacist with PHP
//
//  Created by Mohammed Almutawa on 5/7/21.
//

import SwiftUI

@available(iOS 14.0, *)
struct ResetPassword14: View {
    @StateObject var resetPasswordViewModel = ResetPasswordViewModel()
    var body: some View {
        ResetPassword(resetPasswordViewModel: resetPasswordViewModel)
    }
}
struct ResetPassword13: View {
    @ObservedObject var resetPasswordViewModel = ResetPasswordViewModel()
    var body: some View {
        ResetPassword(resetPasswordViewModel: resetPasswordViewModel)
    }
}
struct ResetPassword: View {
    @ObservedObject var resetPasswordViewModel = ResetPasswordViewModel()
    @State var offset = false
    var body: some View {
        VStack {
            HStack{Text(WRITE_EMAIL).padding(.leading); Spacer()}
            EmailTextField(email: $resetPasswordViewModel.email) //{submitResetRequest()}
            SigninButton(action: submitResetRequest, wait: $resetPasswordViewModel.wait, label: SUBMIT, altLabel: PLEASE_WAIT)
                .alert(isPresented: $resetPasswordViewModel.showAlert) {
                    Alert(title: Text(resetPasswordViewModel.alertTitle), message: Text(resetPasswordViewModel.alertMessage), dismissButton: .default(Text(OK)))
                }.disabled(resetPasswordViewModel.wait)
        }.offset(y: offset ? -100 : 0)
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.keyboardWillShowNotification)) { _ in withAnimation {offset = true}}
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.keyboardWillHideNotification)) { _ in withAnimation {offset = false}}
        .navigationBarTitle("Forget password", displayMode: .inline)
        .navigationBarColor()
    }
    func submitResetRequest() {
        resetPasswordViewModel.submitResetRequest()
    }
}
