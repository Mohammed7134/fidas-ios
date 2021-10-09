//
//  MenuView.swift
//  Cinical Pharmacist
//
//  Created by Mohammed Almutawa on 10/17/20.
//  Copyright © 2020 Mohammed Almutawa. All rights reserved.
//

import SwiftUI
import MessageUI

struct MenuView: View {
    @EnvironmentObject var session: SessionStore
    @State var showSheet = false
    let count: Int
    var showCount = false
    private let mailComposeDelegate = MailDelegate()
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "person")
                    .foregroundColor(.white)
                    .imageScale(.large)
                Text(session.userSession!.username)
                    .foregroundColor(.white)
                    .font(.headline)
            }.padding(.top, 40)
            HStack {
                Image(systemName: "house")
                    .foregroundColor(.white)
                    .imageScale(.large)
                Text("\(session.userSession!.hospital): \(session.userSession!.unit)")
                    .foregroundColor(.white)
                    .font(.headline)
            }
            .padding(.top, 30)
            if showCount {
                HStack {
                    Image(systemName: "person.3")
                        .foregroundColor(.white)
                        .imageScale(.large)
                    Text("\(count) admissions")
                        .foregroundColor(.white)
                        .font(.headline)
                }
                .padding(.top, 30)
            }
            Spacer()
            HStack {
                Image(systemName: "envelope")
                    .foregroundColor(.white)
                    .imageScale(.large)
                Text("Contact us")
                    .foregroundColor(.white)
                    .font(.headline)
                    .onTapGesture {self.presentMailCompose()}
            }
            HStack {
                Image(systemName: "exclamationmark.circle")
                    .foregroundColor(.white)
                    .imageScale(.large)
                Text("About us")
                    .foregroundColor(.white)
                    .font(.headline)
                    .onTapGesture {showSheet = true}
            }
            .padding(.top, 20)
            HStack {
                Image(systemName: "arrow.down.left.circle")
                    .foregroundColor(.white)
                    .imageScale(.large)
                Text("log out")
                    .foregroundColor(.white)
                    .font(.headline)
                    .onTapGesture {session.logout()}
                Spacer()
                if session.userSession!.admin {
                    Text("Admin")
                        .foregroundColor(.black)
                        .font(.subheadline)
                        .onTapGesture {session.isLoggedIn = .admin}
                        .padding()
                        .background(Color.white)
                        .clipShape(Circle())
                }
            }
            .padding(.top, 20)
            .padding(.bottom, 30)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .trailing)
        .background(Color.init(UIColor(hex: "#41729FFF")!))
        .edgesIgnoringSafeArea(.bottom)
        .sheet(isPresented: $showSheet) {
            NavigationView {
                VStack {
                    Image(IMAGE_LOGO).resizable().frame(width: 200, height: 200)
                    Group {
                        Text("Fidas Application is a way for healthcare professionals to follow-up their in-patients who are admitted in different hospitals across Kuwait. It aims at consuming technology to keep everything documented and easily retrieved in order to improve care for our patients.")
                        Text("We are happy to provide any hospital in Kuwait with the server files in case they want the database to be stored in their local hospital server.")
                    }
                        .padding()
                        .font(.system(.body, design: .serif))
                        .frame(alignment: .leading)
                    Spacer()
                }
                .navigationBarTitle(Text("About \(TEXT_SIGNIN_HEADLINE)"), displayMode: .inline)
            }
        }
    }
}

// MARK: The mail part
extension MenuView {
    /// Delegate for view controller as `MFMailComposeViewControllerDelegate`
    private class MailDelegate: NSObject, MFMailComposeViewControllerDelegate {
        func mailComposeController(_ controller: MFMailComposeViewController,
                                   didFinishWith result: MFMailComposeResult,
                                   error: Error?) {
            // Customize here
            controller.dismiss(animated: true)
        }
    }
    /// Present an mail compose view controller modally in UIKit environment
    private func presentMailCompose() {
        guard MFMailComposeViewController.canSendMail() else {return}
        let vc = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = mailComposeDelegate
        // Customize here
        composeVC.setToRecipients([EMAIL])
        vc?.present(composeVC, animated: true)
    }
}
