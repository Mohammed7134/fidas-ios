//
//  AnnouncementViewModel.swift
//  Fidas
//
//  Created by Mohammed Almutawa on 6/3/21.
//

import Foundation
import Combine

class AnnouncementViewModel: ObservableObject, Identifiable {
    @Published var announcement = Announcement()
    @Published var showAlert = false
    var alertMessage = ""
    var alertTitle = ""
    var id: Int = 0
    private var announcementsSubscriber: AnyCancellable?
    private var cancellables = Set<AnyCancellable>()
    init(announcement: Announcement) {
        self.announcement = announcement
        $announcement
            .dropFirst()
            .debounce(for: 0.1, scheduler: RunLoop.main)
            .sink {if $0.id != nil {self.updateAnnouncement()}}
            .store(in: &cancellables)
        
        $announcement
            .compactMap { $0.id }
            .assign(to: \.id, on: self)
            .store(in: &cancellables)
    }
    
    func updateAnnouncement() {
        //Preparing the data to be sent
        guard let dict = try? announcement.toDictionary() else {return}
        guard let data = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted) else {return}
        let url = URL(string: Ref().UPDATE_ANNOUNCEMENT_FILE)!
        
        //Sending the data
        self.announcementsSubscriber = Api.postData(data: data, url: url)
            .catch{ _ in Just(ResponseWithErrorAndMessage(error: true, message: "Networking error"))}
            .sink{
                if $0.error == false {
                    self.alertTitle = SUCCESS_TITLE
                    self.alertMessage = $0.message
                    self.showAlert = true
                }
            }
    }
}
