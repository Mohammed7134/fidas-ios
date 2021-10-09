//
//  SignupView.swift
//  Cinical Pharmacist
//
//  Created by Mohammed Almutawa on 10/15/20.
//  Copyright © 2020 Mohammed Almutawa. All rights reserved.
//

import SwiftUI


@available(iOS 14.0, *)
struct SignupView14: View {
    @StateObject var signupViewModel = SignupViewModel()
    var body: some View {
        SignupView(signupViewModel: signupViewModel)
    }
}
struct SignupView13: View {
    @ObservedObject var signupViewModel = SignupViewModel()
    var body: some View {
        SignupView(signupViewModel: signupViewModel)
    }
}
struct SignupView: View {
    @ObservedObject var signupViewModel: SignupViewModel
    
    func signUp() {
        signupViewModel.signup()
    }
    var body: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: false) {
                Image(IMAGE_LOGO)
                    .resizable()
                    .frame(width: 200, height: 200)
                    .aspectRatio(contentMode: .fit)
                Group {
                    HStack{Text(FILL_DETAILS).padding(.leading); Spacer()}
                    UsernameTextField(username: $signupViewModel.username)
                    
                    EmailTextField(email: $signupViewModel.email)
                    
                    VStack(alignment: .leading) {
                        
                        PasswordTextField(password: $signupViewModel.password)
                        
                        PasswordTextField(password: $signupViewModel.repeatPassword, placeholder: TEXT_PASSWORD_REPEAT)
                        
                        Text(TEXT_SIGN_UP_PASSWORD_REQUIRED)
                            .font(.footnote)
                            .foregroundColor(.gray)
                            .padding(.leading)
                    }
                }
                HospitalPicker(hospital: $signupViewModel.hospital)
                UnitPicker(unit: $signupViewModel.unit, hospital: $signupViewModel.hospital)
                Group {
                    HStack{
                        Image(systemName: signupViewModel.tickedPP ? "checkmark.square" : "square")
                            .font(.body)
                            .padding(5)
                            .onTapGesture{signupViewModel.tickedPP.toggle()}
                        Text("Accept Privacy Policy")
                            .onTapGesture{signupViewModel.showPP = true}
                        Spacer()
                    }
                }
                .font(.footnote)
                .foregroundColor(.gray)
                .padding(.leading)
                .sheet(isPresented: $signupViewModel.showSheet) {
                    NavigationView {
                        ScrollView(.vertical) {
                            Text(signupViewModel.sheetContent)
                                .padding()
                        }
                        .navigationBarTitle(Text(signupViewModel.sheetTitle), displayMode: .inline)
                    }
                }
                SigninButton(action: signUp, wait: self.$signupViewModel.wait, label: TEXT_SIGN_UP, altLabel: PLEASE_WAIT)
                    .alert(isPresented: $signupViewModel.showAlert) {
                        Alert(title: Text(ERROR_TITLE), message: Text(self.signupViewModel.alertString), dismissButton: .default(Text(OK)))
                }.disabled(signupViewModel.wait)
                
                Divider()
                
                Text(TEXT_SIGNUP_NOTE)
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .padding()
                    .lineLimit(nil)
                
            }
            .alert(isPresented: $signupViewModel.showAlert) {
                Alert(title: Text(self.signupViewModel.alertTitle), message: Text(self.signupViewModel.alertString), dismissButton: .default(Text(OK)))
            }
            
        }.navigationBarTitle("Register", displayMode: .inline)
        .navigationBarColor()
    }
}

