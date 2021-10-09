
//
//  MedicationViewModel.swift
//  Cinical Pharmacist
//
//  Created by Mohammed Almutawa on 10/20/20.
//  Copyright © 2020 Mohammed Almutawa. All rights reserved.
//

import Foundation
import Combine

class SearchMedicineViewModel: ObservableObject {
    @Published var isLoading = true
    @Published var pickerSelection = 0
    @Published var searchText = ""
    @Published var medicines: [String] = []
    private var searchTextSubscriber: AnyCancellable?
    private var responseSubscriber: AnyCancellable?
    init() {
        self.searchTextSubscriber = $searchText
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .sink {if !$0.trimmingCharacters(in: .whitespaces).isEmpty {self.searchMedicine($0)}}
    }
    func searchMedicine(_ med: String) {
        isLoading = true
        if !searchText.isEmpty {
            responseSubscriber = Api.Medicine.getMedicines(text: med)
                .catch { _ in Just(LoadMedicinesResponse(error: true, message: "Networking error", medicines: []))}
                .map { $0.error ? [] : $0.medicines!}
                .assign(to: \.medicines, on: self)
            isLoading = false
        } else {
            isLoading = false
            medicines = []
        }
    }
}
