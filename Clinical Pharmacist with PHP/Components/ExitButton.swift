//
//  ExitButton.swift
//  Fidas
//
//  Created by Mohammed Almutawa on 6/5/21.
//

import SwiftUI
struct ExitButton: View {
    @EnvironmentObject var session: SessionStore
    var body: some View {
        Button(action: {session.isLoggedIn = .signedIn}, label: {Image(systemName: "square.and.arrow.up").rotationEffect(.degrees(90)).imageScale(.large).foregroundColor(.white).padding([.vertical, .leading])})
    }
}
