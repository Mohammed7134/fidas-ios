//
//  PendingUsers.swift
//  Fidas
//
//  Created by Mohammed Almutawa on 5/17/21.
//

import SwiftUI

struct PendingUsers: View {
    @EnvironmentObject var session: SessionStore
    @ObservedObject var adminViewModel: AdminViewModel
    var body: some View {
        NavigationView{
            List{
                if !adminViewModel.isLoading {
                    ForEach(adminViewModel.users) { user in
                        UserRow(user: user)
                            .contextMenu {
                                Button(action: {adminUserAction(accept: true, user: user)}) {
                                    HStack {
                                        Text("Activate")
                                        Image(systemName: "checkmark")
                                    }
                                }
                                Button(action: {adminUserAction(accept: false, user: user)}) {
                                    HStack {
                                        Text("Delete").foregroundColor(.red)
                                        Image(systemName: "xmark").foregroundColor(.red)
                                    }
                                }
                            }
                    }
                }
            }
            .navigationBarTitle("Pending Users", displayMode: .inline)
            .onAppear {adminViewModel.loadPendingUsers()}
            .navigationBarItems(trailing: ExitButton())
            .alert(isPresented: $adminViewModel.showAlert) {
                Alert(title: Text(adminViewModel.alertTitle), message: Text(adminViewModel.alertMessage), dismissButton: .default(Text(OK)))
            }
        }
    }
    func adminUserAction(accept: Bool, user: User) {
        adminViewModel.adminUserAction(accept: accept, user: user)
    }
}

struct UserRow: View {
    let user: User
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(user.username).font(.subheadline).bold()
            Text(user.email).font(.subheadline).bold()
            HStack{
                Text(user.unit);Divider()
                Text(user.hospital)
            }
        }
        .padding()
    }
}
