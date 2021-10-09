//
//  ResetPasswordViewModel.swift
//  Clinical Pharmacist with PHP
//
//  Created by Mohammed Almutawa on 5/7/21.
//

import Foundation

class ResetPasswordViewModel: ObservableObject {
    @Published var email = ""
    @Published var alertMessage = ""
    @Published var alertTitle = ""
    @Published var wait = false
    @Published var showAlert = false
    func submitResetRequest() {
        wait = true
        AuthServices.resetPasswordRequest(email: email, completed: { success in
            self.alertTitle = "Success"
            self.alertMessage = success
            self.showAlert = true
            self.wait = false
        }, onError: { error in
            self.alertTitle = "Error"
            self.alertMessage = error
            self.showAlert = true
            self.wait = false
        })
    }
}
