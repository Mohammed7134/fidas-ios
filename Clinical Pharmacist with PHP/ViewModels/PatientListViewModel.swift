//
//  PatientListViewModel.swift
//  Cinical Pharmacist
//
//  Created by Mohammed Almutawa on 10/19/20.
//  Copyright © 2020 Mohammed Almutawa. All rights reserved.
//

import SwiftUI
import Combine
enum isLoading {
    case loading, loaded, empty
}
class PatientListViewModel: ObservableObject {
    @Published var patients: [PatientViewModel] = []
    @Published var isLoading: isLoading = .loading
    @Published var searchText = "F" {didSet{searchTextDidChange()}}
    @Published var selected: Int?
    @Published var selectedFromSearch: Int?
    @Published var count = 0
    @Published var isShowing = false
    @Published var showMenu = false
    @Published var isActive = false
    @Published var isFirstResponder = false
    var message = ""

    func searchTextDidChange() {
        if !searchText.isEmpty {
            Api.Patient.searchPatients(text: searchText, onSuccess: {
                if !$0.isEmpty {
                    self.patients = $0
                    self.isLoading = .loaded
                } else {
                    self.isLoading = .empty
                    self.message = "Empty List"
                }
            })
        } else {
            isLoading = .empty
            message = "Empty List"
        }
    }
    func loadPatients() {
        self.isLoading = .loading
        self.message = "Loading..."
        Api.Patient.loadPatients(onSuccess: {
            self.isLoading = .loaded
            self.patients = $0
        }) {
                self.isLoading = .empty
                self.message = $0
        }
    }
    func admissionCount() {
        Api.Patient.countPatientsForCurrentUser {self.count = $0}
    }
}
