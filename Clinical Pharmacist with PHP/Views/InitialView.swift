//
//  ContentView.swift
//  Clinical Pharmacist with PHP
//
//  Created by Mohammed Almutawa on 2/26/21.
//

import SwiftUI

struct InitialView: View {
    @EnvironmentObject var session: SessionStore
    func logingIn() {
        session.logingIn()
    }
    func logout() {
        session.logout()
    }
    func listening() {
        session.listenAuthenticationState()
    }
    init() {
        //MARK: Disable selection.
        let cellAppearance = UITableViewCell.appearance()
        cellAppearance.selectionStyle = .none
        cellAppearance.backgroundColor = .clear
        UITableView.appearance().backgroundColor = .clear
    }
    var body: some View {
        Group{
            if session.isLoggedIn == .signedIn  {
//                if #available(iOS 14.0, *) {
//                    PatientListView14()
//                } else {
//                    PatientListView13()
//                }
                MainView()
            } else if session.isLoggedIn == .admin {
                AdminViews()
            }
            else {
                ZStack {
                    if #available(iOS 14.0, *) {
                        SigninView14()
                    } else {
                        SigninView13()
                    }
                    if session.isLoggedIn == .loading {
                        LoadingView()
                    }
                }
            }
        }
        .onAppear(perform: logingIn)
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in listening()}
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        InitialView()
    }
}


