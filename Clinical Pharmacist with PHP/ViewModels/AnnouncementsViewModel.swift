//
//  AnnouncementsViewModel.swift
//  Fidas
//
//  Created by Mohammed Almutawa on 5/26/21.
//

import Foundation
import Combine

class AnnouncementsViewModel: ObservableObject {
    @Published var selectedAnnouncement: Int? = nil
    @Published var announcements: [AnnouncementViewModel] = []
    @Published var hospital: Hospital = .Farwaniya 
    @Published var choosePlace = true
    @Published var showAlert = false
    @Published var alertTitle = ""
    @Published var alertMessage = ""
    @Published var isLoading: isLoading = .loading
    @Published var isShowing = false
    private var announcementsSubscriber: AnyCancellable?
    private var announcementRemoveSubscriber: AnyCancellable?
    init(hospital: Hospital = .Farwaniya){
        self.hospital = hospital
        if self.announcements.isEmpty {
            loadAnnouncements()
        }
    }
    func loadAnnouncements() {
        isLoading = .loading
        if hospital == .Farwaniya {
            
            //Preparing data to be sent
            let postStringData = "hospital=\(hospital.hpName())".data(using: String.Encoding.utf8)!
            let url = URL(string: Ref().LOAD_ANNOUNCEMENTS_FILE)!
            
            //Sending the data
            self.announcementsSubscriber = Api.postData(data: postStringData, url: url)
                .catch{ _ in Just(LoadAnnouncementsResponse(error: true, message: "Networking error", announcements: []))}
                .map { $0.error ? self.onLoadError($0.message!) : self.onLoadSuccess($0.annVMs)}
                .assign(to: \.announcements, on: self)
            
        } else {
            alertTitle = ERROR_TITLE
            alertMessage = "This Database still not existing"
            showAlert = true
            isLoading = .loaded
        }
    }
    func onLoadError(_ error: String) -> [AnnouncementViewModel] {
        self.alertTitle = ERROR_TITLE
        self.alertMessage = error
        self.showAlert = true
        isLoading = .empty
        return []
    }
    func onLoadSuccess(_ announcements: [AnnouncementViewModel]) -> [AnnouncementViewModel] {
        isLoading = .loaded
        return announcements
    }
    func removeAnnouncement(at index: Int, id: Int, images: [String]) {
        announcements.remove(at: index)
        
        //Preparing the data to be sent
        let url = URL(string: Ref().REMOVE_ANNOUNCEMENTS_FILE)!
        print(images)
        let dicti: [String : Any] = ["id" : id, "images" : images]
        guard let data = try? JSONSerialization.data(withJSONObject: dicti, options: .prettyPrinted) else {return}

        //Sending the data
        self.announcementRemoveSubscriber = Api.postJSON(data: data, url: url)
            .catch{_ in Just(ResponseWithErrorAndMessage(error: true, message: "Networking error"))}
            .sink{_ in}
    }
}
