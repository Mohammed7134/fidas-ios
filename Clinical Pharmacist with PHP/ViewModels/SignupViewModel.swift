//
//  SignupViewModel.swift
//  Clinical Pharmacist with PHP
//
//  Created by Mohammed Almutawa on 2/26/21.
//

import SwiftUI
import Combine

class SignupViewModel: ObservableObject {
    @Published var username = ""
    @Published var password = ""
    @Published var repeatPassword = ""
    @Published var email = ""
    var hospital: Hospital = .Empty
    var unit = ""
    var alertTitle = ""
    var alertString = ""
    @Published var wait = false
    @Published var showAlert = false
    @Published var showImagePicker = false
    @Published var tickedPP = false
    @Published var showPP = false {didSet{showSheet = true; sheetTitle = "Privacy Policy"; sheetContent = PrivacyPolicy}}
    @Published var showSheet = false
    @Published var sheetTitle = ""
    @Published var sheetContent = ""
    static var deviceToken = ""
    private var cancellable: AnyCancellable?

    func signup() {
        wait = true
        let filteredEmail = email.trimmingCharacters(in: .whitespaces)
        let filteredUsername = username.trimmingCharacters(in: .whitespaces)
        let filteredPassword = password.trimmingCharacters(in: .whitespaces)
        if !self.username.isEmpty && !self.password.isEmpty && !self.email.isEmpty && self.hospital != .Empty && !self.unit.isEmpty {
            if Rules.email.evaluate(with: email) {
                if Rules.password.evaluate(with: password) && repeatPassword == password {
                    if tickedPP {
                        
                        //Storing the password in the KeyChain
                        let kcw = KeychainWrapper()
                        do {
                            try kcw.storeGenericPasswordFor(
                                account: username,
                                service: "unlockPassword",
                                password: password)
                        } catch let error as KeychainWrapperError {
                            print("Exception setting password: \(error.message ?? "no message")")
                        } catch {
                            print("An error occurred setting the password.")
                        }
                        
                        //Preparing data to send
                        let postStringData = "username=\(filteredUsername)&password=\(filteredPassword)&email=\(filteredEmail)&hospital=\(hospital.hpName())&unit=\(unit)&deviceToken=\(Self.deviceToken)&devicePlatform=IOS".data(using: String.Encoding.utf8)!
                        let url = URL(string: Ref().REGISTER_FILE)!
                        
                        //Sending data
                        self.cancellable = AuthServices.postData(data: postStringData, url: url)
                            .catch{_ in Just(ResponseWithErrorAndMessage(error: true, message: "Networking error"))}
                            .sink{$0.error ? self.onError($0.message) : self.onSuccess($0.message)}
                        
                    } else {
                        onError("Accept Privacy Policy before continuing")
                    }
                } else {
                    onError("Password must be in English, 8 characters or more and contains at least one small and one capital letter")
                }
            } else {
                onError("Email format is incorrect")
            }
        } else {
            onError("Please fill in all fields")
        }
    }
    
    func onError(_ error: String) {
        wait = false
        alertTitle = ERROR_TITLE
        alertString = error
        showAlert = true
    }
    func onSuccess(_ success: String) {
        wait = false
        alertTitle = SUCCESS_TITLE
        alertString = success
        showAlert = true
        clean()
    }
    func clean() {
        password = ""
        username = ""
        email = ""
        unit = ""
        hospital = .Empty
    }
}
