//
//  Announcement.swift
//  Fidas
//
//  Created by Mohammed Almutawa on 5/26/21.
//

import Foundation
import SwiftUI
struct Announcement: Codable, Identifiable {
    var id: Int?
    var author: String? = ""
    var category: String = ""
    var title: String = ""
    var content: String = ""
    var photos: [String] = []
    var hospital: String = ""
    var date: Double = 0
    var status: String = ""

    var imgStrings: [String] {
        var imgUrls: [String] = []
        for ph in photos {
            if ph.contains("image") {
                let url = Ref().WEBSITE + ph
                imgUrls.append(url)
            }
        }
        return imgUrls
    }
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        let date1 = Date(timeIntervalSince1970: date)
        return formatter.string(from: date1)
    }
}

