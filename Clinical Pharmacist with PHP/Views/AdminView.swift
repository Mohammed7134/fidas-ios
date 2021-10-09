//
//  AdminView.swift
//  Clinical Pharmacist with PHP
//
//  Created by Mohammed Almutawa on 5/1/21.
//

import SwiftUI

struct AdminViews: View {
    @EnvironmentObject var session: SessionStore
    var body: some View {
        Group {
            if #available(iOS 14.0, *) {
                AdminView14(hospital: session.userSession!.hospEnum)
            } else {
                AdminView13(hospital: session.userSession!.hospEnum)
            }
        }
    }
}
@available(iOS 14.0, *)
struct AdminView14: View {
    @StateObject var adminViewModel: AdminViewModel
    init(hospital: Hospital) {
        _adminViewModel = StateObject(wrappedValue: AdminViewModel(hospital: hospital))
    }
    var admin: Bool = false
    var body: some View {
        AdminView(adminViewModel: adminViewModel)
    }
}
struct AdminView13: View {
    @ObservedObject var adminViewModel: AdminViewModel
    init(hospital: Hospital) {
        _adminViewModel = ObservedObject(wrappedValue: AdminViewModel(hospital: hospital))
    }
    var body: some View {
        AdminView(adminViewModel: adminViewModel)
    }
}
struct AdminView: View {
    @EnvironmentObject var session: SessionStore
    @ObservedObject var adminViewModel: AdminViewModel
    var body: some View {
        TabView {
//            PendingUsers(adminViewModel: adminViewModel)
//                .tabItem {
//                    Text("Users")
//                    Image(systemName: "person")
//                }
            
            MedicinesReports(adminViewModel: adminViewModel)
                .tabItem {
                    Text("Medicines")
                    Image(systemName: "doc.append")
                }
//            AddAnnounceView(adminViewModel: adminViewModel)
//                .tabItem {
//                    Text("Announce")
//                    Image(systemName: "square.and.pencil")
//                }
            
        }
        
    }
    
    
    
}



