//
//  PastAdmissionViewModel.swift
//  Clinical Pharmacist with PHP
//
//  Created by Mohammed Almutawa on 4/5/21.
//

import Foundation

class PastAdmissionViewModel: ObservableObject {
    @Published var labSelection = "RFT"
    @Published var medSelection = "Current"
    @Published var admissionSelection = 0
    @Published var showPicker = false
    @Published var showSheet = false
}
