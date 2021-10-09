//
//  AdminViewModel.swift
//  Clinical Pharmacist with PHP
//
//  Created by Mohammed Almutawa on 5/1/21.
//

import Foundation
import Combine 
class AdminViewModel: ObservableObject {
    @Published var users = [User]()
    @Published var reports = [Report]()
    @Published var hospital = Hospital.Empty
    @Published var showAlert = false {didSet {didSetShowAlert()}}
    @Published var isLoading = true
    @Published var selectedLocation = "location1"
    @Published var firstPart = ""
    @Published var secondPart = 0
    @Published var thirdPart = ""
    @Published var showPickers = false
    @Published var category: String = ""
    @Published var title: String = ""
    @Published var content: String = ""
    @Published var date: Date = Date()
    @Published var imagesData: [Data] = []
    @Published var animate3d = false

    var alertTitle = ""
    var alertMessage = ""
    
    private var writeAnnouncementsSubscriber: AnyCancellable?
    private var reportActionSubscriber: AnyCancellable?
    private var loadReportsSubscriber: AnyCancellable?
    private var adminUserActionSubscriber: AnyCancellable?
    private var loadPendingUsersSubscriber: AnyCancellable?
    init(hospital: Hospital) {
        self.hospital = hospital
    }
    
    func didSetShowAlert() {
        if !showAlert {
            self.animate3d.toggle()
        }
    }
    
    func loadPendingUsers() {
        isLoading = true
        //preparing data to send
        let postStringData = "hospital=\(hospital.hpName())".data(using: String.Encoding.utf8)!
        
        //sending data
        self.loadPendingUsersSubscriber = Api.postData(data: postStringData, url: URL(string: Ref().ADMIN_FILE)!)
            .catch{_ in Just(LoadUsersResponse(error: true, message: "Networking error", users: []))}
            .map {
                if $0.error {
                    self.alertTitle = ERROR_TITLE
                    self.alertMessage = $0.message!
                    self.showAlert = true
                    self.isLoading = false
                    return []
                } else {
                    self.isLoading = false
                    return $0.users!
                }
            }
            .assign(to: \.users, on: self)
    }
    func adminUserAction(accept: Bool, user: User) {
        //preparing data to send
        let accepted = (accept ? "true" : "false")
        let dicti: [String : Any] = ["accept" : accepted, "userId" : user.id, "email" : user.email]
        guard let data = try? JSONSerialization.data(withJSONObject: dicti, options: .prettyPrinted) else {return}
        
        //sending data
        self.adminUserActionSubscriber = Api.postJSON(data: data, url: URL(string: Ref().ADMIN_FILE)!)
            .catch{_ in Just(ResponseWithErrorAndMessage(error: true, message: "Networking Error"))}
            .sink {
                if $0.error {
                    self.alertTitle = ERROR_TITLE
                    self.alertMessage = $0.message
                    self.showAlert = true
                } else {
                    self.alertTitle = SUCCESS_TITLE
                    self.alertMessage = $0.message
                    self.showAlert = true
                    self.loadPendingUsers()
                }
            }
    }
    func loadLocationsReports() {
        isLoading = true
        //preparing data to send
        let postStringData = "hospital=\(hospital.tbName())".data(using: String.Encoding.utf8)!
        
        //sending data
        self.loadReportsSubscriber = Api.postData(data: postStringData, url: URL(string: Ref().LOAD_REPORTS_FILE)!)
            .catch{_ in Just(LoadReportsResponse(error: true, message: "Networking error", reports: []))}
            .map {
                if $0.error {
                    self.alertTitle = ERROR_TITLE
                    self.alertMessage = $0.message!
                    self.showAlert = true
                    self.isLoading = false
                    return []
                } else {
                    self.isLoading = false
                    return $0.reports!
                }
            }
            .assign(to: \.reports, on: self)
    }
    func adminReportAction(medicine: MedicineLocations, delete: Bool, report: Report, onSuccess: @escaping () -> Void) {
        isLoading = true
        
        //defining the medicine
        var modifiedMed = report.medicine
        if !delete {
            if firstPart.isEmpty || secondPart == 0 || thirdPart.isEmpty {
                modifiedMed.locations[selectedLocation] = ""
            } else {
                modifiedMed.locations[selectedLocation] = "\(firstPart)\(secondPart < 10 ? "0" : "")\(secondPart)" + thirdPart
            }
        }
        
        //preparing data to send
        let rejected = (delete ? "true" : "false")
        guard let med = try? modifiedMed.toDictionary() else {return}
        let dicti: [String : Any] = ["reject" : rejected, "reportId" : report.id!, "medicineLocations" : med, "place": hospital.tbName()]
        guard let data = try? JSONSerialization.data(withJSONObject: dicti, options: .prettyPrinted) else {return}
        
        //networking
        self.reportActionSubscriber = Api.postJSON(data: data, url: URL(string: Ref().ADMIN_FILE)!)
            .catch{_ in Just(ResponseWithErrorAndMessage(error: true, message: "Networking Error"))}
            .sink {
                if $0.error {
                    self.isLoading = false
                    self.alertTitle = ERROR_TITLE
                    self.alertMessage = $0.message
                    self.showAlert = true
                } else {
                    self.isLoading = false
                    self.alertTitle = SUCCESS_TITLE
                    self.alertMessage = $0.message
                    self.showAlert = true
                    if delete {
                        onSuccess()
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        self.loadLocationsReports()
                    }
                    
                }
            }
    }
    func writeAnnouncement(hospit: String, author: String) {
        isLoading = true
        var imagesString = [String]()
        for imageData in imagesData {
            let stringImg = imageData.base64EncodedString()
            imagesString.append(stringImg)
        }
        if !anyEmpty() {
            let ann = Announcement(author: author, category: category, title: title, content: content, photos: imagesString, hospital: hospit, date: date.timeIntervalSince1970, status: "Active")
            guard let dict = try? ann.toDictionary() else {isLoading = false ;return}
            
            guard let data = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted) else {isLoading = false; return}
            let url = URL(string: Ref().LOAD_ANNOUNCEMENTS_FILE)
            self.writeAnnouncementsSubscriber = Api.Announcement.postData(data: data, to: url!)
                .catch{ _ in Just(ResponseWithErrorAndMessage(error: true, message: "Networking error"))}
                .map {self.onWriteResult($0)}
                .assign(to: \.alertMessage, on: self)
        } else {
            isLoading = false
            alertMessage = "Fill in all the fields"
            alertTitle = ERROR_TITLE
            showAlert = true
        }
    }
    func onWriteResult(_ response: ResponseWithErrorAndMessage) -> String {
        alertTitle = response.error ? ERROR_TITLE : SUCCESS_TITLE
        isLoading = false
        showAlert = true
        if !response.error {
            title = ""
            category = ""
            content = ""
            imagesData = []
        }
        return response.message
    }
    func anyEmpty() -> Bool {
        var emptyField = false
        [title, category, content].forEach({if $0.isEmpty {emptyField = true}})
        return emptyField
    }
    
}
