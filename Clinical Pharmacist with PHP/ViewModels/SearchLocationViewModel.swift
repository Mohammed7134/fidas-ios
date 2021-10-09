//
//  SearchLocationViewModel.swift
//  Fidas
//
//  Created by Mohammed Almutawa on 5/16/21.
//

import Foundation
import Combine

class SearchViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var medicines: [MedicineLocations] = []
    @Published var hospital: Hospital = .Empty 
    @Published var pharmacy: String = ""
    @Published var choosePlace = true
    @Published var showAlert = false
    @Published var alertTitle = ""
    @Published var alertMessage = ""
    var reports: [Report] = []
    private var locationSubscriber: AnyCancellable?
    private var reportSubscriber: AnyCancellable?
    private var searchTextSubscriber: AnyCancellable?
    
    init(hospital: Hospital) {
        self.hospital = hospital
        self.searchTextSubscriber = $searchText
            .debounce(for: 0.6, scheduler: RunLoop.main)
            .sink {if !$0.trimmingCharacters(in: .whitespaces).isEmpty {self.getLocation(medicine: $0)}}
    }
    func getLocation(medicine: String) {
        if hospital == .Farwaniya {
            //Preparing data to be sent
            let url =  URL(string: Ref().SEARCH_MEDICINE_LOCATION_FILE)!
            let postStringData = "hospital=\(hospital.tbName())&pharmacy=\(pharmacy)&searchText=\(medicine)".data(using: String.Encoding.utf8)!
            
            //Sending data
            self.locationSubscriber = Api.postData(data: postStringData, url: url)
                .catch{ _ in Just(LoadMedicinesLocationsResponse(error: true, message: "Networking error", medicines: []))}
                .map { $0.error ? self.onError($0.message!) : $0.medicines!}
                .assign(to: \.medicines, on: self)
        } else {
            alertTitle = ERROR_TITLE
            alertMessage = "This Database still not existing"
            showAlert = true
        }
    }
    func reportLocation(medicine: MedicineLocations) {
        let report = Report(id: nil, medicine: medicine, time: Date().timeIntervalSince1970, reviewed: false, hospital: hospital.tbName())
        if !reports.contains(report) {
            reports.append(report)
            
            //Prepare data to be sent
            guard let dict = try? report.toDictionary() else {return}
            guard let data = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted) else {return}
            let url = URL(string: Ref().REPORT_LOCATION_FILE)!
            
            //Sending data 
            self.reportSubscriber = Api.postJSON(data: data, url: url)
                .catch{ _ in Just(ResponseWithErrorAndMessage(error: true, message: "Networking Error"))}
                .sink { _ in}
        }
    }
    func onError(_ error: String) -> [MedicineLocations] {
        self.alertTitle = ERROR_TITLE
        self.alertMessage = error
        self.showAlert = true
        return []
    }
}
