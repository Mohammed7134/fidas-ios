//
//  SessionStore.swift
//  Clinical Pharmacist with PHP
//
//  Created by Mohammed Almutawa on 2/27/21.
//

import Foundation
import Combine

enum LoadingStatus {
    case loading, signedIn, signedOut, admin
}
class SessionStore: ObservableObject {
    @Published var isLoggedIn: LoadingStatus = .loading
    @Published var userSession: User?
    @Published var showAnnouncementsView = false
    @Published var showFollowUpView = false
    @Published var showFindMedicineView = false
    @Published var showInfoView = false
    private var autoLogInSubscriber: AnyCancellable?
    static let shared = SessionStore()
    static func goToAnn(){
        if shared.isLoggedIn == .signedIn || shared.isLoggedIn == .loading {
            if shared.showFollowUpView == true || shared.showFindMedicineView == true || shared.showInfoView == true {
                shared.showFollowUpView = false
                shared.showFindMedicineView = false
                shared.showInfoView = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                    shared.showAnnouncementsView = true
                }
            } else {
                shared.showAnnouncementsView = true
            }
        }
    }
    func listenAuthenticationState() {
        AuthServices.checkExpiredSession { msg in
            self.isLoggedIn = .signedOut
        }
    }
    func logingIn(_ biometricAuthentication: Bool = false) {
        isLoggedIn = .loading
        let userLoginStatus = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
        if userLoginStatus || biometricAuthentication {
            self.autoLogInSubscriber = AuthServices.autoLogIn()
                .catch{ _ in Just(ResponseWithErrorAndMessageUser(error: true, message: "Networking error", user: nil))}
                .sink {
                    if $0.error {
                        print("error in authorisation: \($0.message!)")
                        self.isLoggedIn = .signedOut
                    } else {
                        self.switchToMainPage(user: $0.user!)
                    }
                }
        } else {
            print("user not signed in")
            self.isLoggedIn = .signedOut
        }
    }

    func logout() {
        AuthServices.logout()
        UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
        UserDefaults.standard.synchronize()
        isLoggedIn = .signedOut
        print("user logged out successfully")
    }
    
    func switchToMainPage(user: User) {
        self.userSession = user
        self.isLoggedIn = .signedIn
        print("user logged in successfully")
    }
}
