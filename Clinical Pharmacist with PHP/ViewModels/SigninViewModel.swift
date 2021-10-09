//
//  SigninViewModel.swift
//  Cinical Pharmacist
//
//  Created by Mohammed Almutawa on 10/15/20.
//  Copyright © 2020 Mohammed Almutawa. All rights reserved.
//

import Foundation
import Combine
class SigninViewModel: ObservableObject {
    @Published var username = ""
    @Published var password = ""
    @Published var showAlert = false
    @Published var wait = false
    @Published var signinByCredentials = false
    var alertMessage = ""
    private var cancellable: AnyCancellable?
    func signin(onSuccess: @escaping (_ user: User) -> Void) {
        wait = true
        let filteredUsername = username.trimmingCharacters(in: .whitespaces)
        let filteredPassword = password.trimmingCharacters(in: .whitespaces)
        if !self.password.isEmpty && !self.username.isEmpty {
            let url = URL(string: Ref().LOGIN_FILE)!
            let postStringData = "username=\(filteredUsername)&password=\(filteredPassword)".data(using: String.Encoding.utf8)!
            self.cancellable = AuthServices.postData(data: postStringData, url: url)
                .catch{_ in Just(ResponseWithErrorAndMessageUser(error: true, message: "Networking Error", user: nil))}
                .sink {
                    if $0.error {
                        self.onError($0.message!)
                    } else {
                        if let data = try? JSONEncoder().encode($0.user!) {
                            
                            //Save user data and login Status in UserDefaults
                            UserDefaults.standard.set(true, forKey: KEY_FOR_LOG_STATUS)
                            UserDefaults.standard.set(data, forKey: KEY_FOR_USER_DATA)
                            UserDefaults.standard.synchronize()
                            onSuccess($0.user!)
                            self.clean()
                        } else {
                            self.onError("Error encoding logged in user")
                        }
                        
                        //Retreiving password from KeyChain
                        let kcw = KeychainWrapper()
                        if let pswd = try? kcw.getGenericPasswordFor(account: filteredUsername, service: "unlockPassword") {
                            if filteredPassword != pswd {
                                kcw.updateStoredPassword(username: filteredUsername, password: filteredPassword)
                            }
                        } else {
                            kcw.storePassword(username: filteredUsername, password: filteredPassword)
                        }
                        
                    }
                }
        }
        else {
            onError("Please fill in all fields")
        }
    }
    func onError(_ error: String) {
        showAlert = true
        alertMessage = error
        clean()
    }
    func clean() {
        password = ""
        username = ""
        wait = false
    }
}
