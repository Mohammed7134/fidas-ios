//
//  SigninView.swift
//  Cinical Pharmacist
//
//  Created by Mohammed Almutawa on 10/15/20.
//  Copyright © 2020 Mohammed Almutawa. All rights reserved.
//

import SwiftUI
import LocalAuthentication
enum AuthType {
    case touchid, faceid, none
}
@available(iOS 14.0, *)
struct SigninView14: View {
    @StateObject var signinViewModel = SigninViewModel()
    var body: some View {
        SigninView(signinViewModel: signinViewModel)
    }
}
struct SigninView13: View {
    @ObservedObject var signinViewModel = SigninViewModel()
    var body: some View {
        SigninView(signinViewModel: signinViewModel)
    }
}
struct SigninView: View {
    @EnvironmentObject var session: SessionStore
    @ObservedObject var signinViewModel: SigninViewModel
    func listening() {
        session.listenAuthenticationState()
    }
    func signIn() {
        signinViewModel.signin(onSuccess: {user in session.switchToMainPage(user: user)})
    }
    var body: some View {
        NavigationView {
            VStack{
                HeaderView()
                UsernameTextField(username: $signinViewModel.username)
                PasswordTextField(password: $signinViewModel.password) {signIn()}
                SigninButton(action: signIn, wait: $signinViewModel.wait, label: TEXT_SIGN_IN, altLabel: PLEASE_WAIT).alert(isPresented: $signinViewModel.showAlert) {
                    Alert(title: Text(ERROR_TITLE), message: Text(self.signinViewModel.alertMessage), dismissButton: .default(Text(OK)))
                }.disabled(signinViewModel.wait)
                Divider()
                if #available(iOS 14, *) {
                    NavigationLink(destination: SignupView14()){
                        SignupText()
                    }.padding(.bottom)
                } else {
                    NavigationLink(destination: SignupView13()){
                        SignupText()
                    }.padding(.bottom)
                }
                NavigationLink(destination: ResetPassword()) {
                    Text(TEXT_PASSWORD_FORGET)
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                if UserDefaults.standard.data(forKey: KEY_FOR_USER_DATA) != nil {
                    Group {
                        if authType() == .faceid {
                            FaceidView()
                                .onTapGesture{authenticate()}
                        } else if authType() == .touchid {
                            TouchidView()
                                .onTapGesture {authenticate()}
                        }
                    }
                }
            }
            .navigationBarTitle("", displayMode: .inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .accentColor(.black)
        .navigationBarColor(color: UIColor.clear)
        
    }
    func authType() -> AuthType {
        var authType: AuthType = .none
        let context = LAContext()
        let faceId =  context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthentication, error: nil) && context.biometryType == .faceID
        let touchId = context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthentication, error: nil) && context.biometryType == .touchID
        if faceId {
            authType = .faceid
        } else if touchId {
            authType = .touchid
        } else {
            authType = .none
        }
        return authType
    }
    func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        // check whether biometric authentication is possible
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            // it's possible, so go ahead and use it
            let reason = "We need to unlock your data."
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                // authentication has now completed
                DispatchQueue.main.async {
                    if success {
                        self.session.logingIn(true)
                    } else {
                        print("Authentication error")
                    }
                }
            }
        } else {
            print("No Authentication in this device")
        }
    }
}
struct FaceidView: View {
    @State var animate: CGFloat = 1
    var body: some View {
        Image(systemName: "faceid")
            .font(.title)
            .padding()
            .scaleEffect(animate)
            .animation(Animation.easeInOut(duration: 1).repeatForever(), value: animate)
            .onAppear{DispatchQueue.main.async {animate += 0.5}}
    }
}

struct TouchidView: View {
    @State var animate: CGFloat = 1
    var body: some View {
        Image("touchid")
            .padding()
            .scaleEffect(animate)
            .animation(Animation.easeInOut(duration: 1).repeatForever(), value: animate)
            .onAppear{DispatchQueue.main.async {animate += 0.5}}
    }
}
