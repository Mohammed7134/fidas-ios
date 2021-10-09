//
//  User.swift
//  Cinical Pharmacist
//
//  Created by Mohammed Almutawa on 10/15/20.
//  Copyright © 2020 Mohammed Almutawa. All rights reserved.
//

import Foundation

struct User: Codable, Identifiable {
    var id: Int
    var username: String
    var email: String
    var hospital: String
    var unit: String
    var admin: Bool
    var hospEnum: Hospital {
        switch hospital {
        case "":
            return .Empty
        case FAR:
            return .Farwaniya
//        case ADAN:
//            return .Adan
//        case SABAH:
//            return .Sabah
//        case AMIRI:
//            return .Amiri
//        case MUBARAK:
//            return .Mubarak
//        case JAHRAH:
//            return .Jahrah
        default:
            return .Empty
        }
    }
}


