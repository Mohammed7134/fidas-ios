//
//  Hospital.swift
//  Fidas
//
//  Created by Mohammed Almutawa on 5/21/21.
//

import Foundation
enum Hospital {
    case Empty, Farwaniya , Adan//, Sabah, Amiri, Mubarak, Jahrah
    func tbName() -> String {
        switch self {
        case .Empty:
            return ""
        case .Farwaniya:
            return FAR_LOC
        case .Adan:
            return ADAN_LOC
//        case .Sabah:
//            return SABAH_LOC
//        case .Amiri:
//            return AMIRI_LOC
//        case .Mubarak:
//            return MUBARAK_LOC
//        case .Jahrah:
//            return JAHRAH_LOC
        }
    }
    func hpName() -> String {
        switch self {
        case .Empty:
            return ""
        case .Farwaniya:
            return FAR
        case .Adan:
            return ADAN
//        case .Sabah:
//            return SABAH
//        case .Amiri:
//            return AMIRI
//        case .Mubarak:
//            return MUBARAK
//        case .Jahrah:
//            return JAHRAH
        }
    }
    func pharNames() -> [String] {
        switch self {
        case .Empty:
            return [""]
        case .Farwaniya:
            return FAR_PHAR
        case .Adan:
            return ADAN_PHAR
//        case .Sabah:
//            return SABAH_PHAR
//        case .Amiri:
//            return AMIRI_PHAR
//        case .Mubarak:
//            return MUBARAK_PHAR
//        case .Jahrah:
//            return JAHRAH_PHAR
        }
    }
    func units() -> [String] {
        switch self {
        case .Empty:
            return [""]
        case .Farwaniya:
            return FAR_UNITS
        case .Adan:
            return ADAN_UNITS
        }
    }
}
