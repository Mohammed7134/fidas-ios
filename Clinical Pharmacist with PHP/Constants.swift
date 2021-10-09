//
//  Constants.swift
//  Cinical Pharmacist
//
//  Created by Mohammed Almutawa on 10/15/20.
//  Copyright © 2020 Mohammed Almutawa. All rights reserved.
//

import SwiftUI

let COLOR_LIGHT_GRAY = Color(red: 0, green: 0, blue: 0, opacity: 0.15)
let NAVIGATION_BAR_COLOR_HEX = "#41729FFF"
let HEADER_GRADIENT_1 = "#41729FFF"
let HEADER_GRADIENT_2 = "#41729EFF"
let BACKGROUND_GRADIENT_1 = "#41729FFF"
let BACKGROUND_GRADIENT_2 = "#41729FCC"
//sign in and sign up page
let IMAGE_LOGO = "fidas-2"
let TEXT_SIGNIN_HEADLINE = "Fidas"
let TEXT_SIGNIN_SUBHEADLINE = "Keep everything documented"
let TEXT_NEED_AN_ACCOUNT = "Don't have an account?"
let TEXT_SIGN_IN = "Sign in"
let TEXT_SIGN_UP = "Sign up"
let TEXT_EMAIL = "Email"
let TEXT_HOSPITAL = "Hospital"
let TEXT_UNIT = "Unit"
let TEXT_PHARMACY = "Pharmacy"
let TEXT_SIGN_UP_PASSWORD_REQUIRED = "At least 8 characters required"
let TEXT_SIGNUP_NOTE = "An account will allow you to save and access your patients information across devices. You can deactivate your account at any time you want."
let TEXT_USERNAME = "Username"
let TEXT_PASSWORD = "Password"
let TEXT_PASSWORD_REPEAT = "Repeat Password"
let IMAGE_USER_PLACEHOLDER = "user-placeholder"
let PLEASE_WAIT = "Please wait"
let ERROR_TITLE = "Error"
let SUCCESS_TITLE = "Success"
let SUBMIT = "Submit"
let OK = "Ok"
let KEY_FOR_USER_DATA = "UserData"
let KEY_FOR_LOG_STATUS = "isUserLoggedIn"
let FILL_DETAILS = "Please fill in your details"
let WRITE_EMAIL = "Please write your email:"
let TEXT_PASSWORD_FORGET = "Did you forget the password?"
let DELETE_REPORT = "Delete Report"
let DELETE_ANN = "Delete Announcement"

let EXIT = "Exit"
let PENDING_REPORTS = "Pending Reports"
let LIST_TYPES = ["Home", "Current", "Discharge"]
let SEX_ARRAY = ["Male", "Female"]
let LOCATIONS = ["location1", "location2", "location3", "location4"]
let EMAIL = "Fidas@farwaniyapharmacist.online"

let LOC_CODES = ["", "BF", "SF", "CP", "SH"]

let ADAN_UNITS = ["", "PICU", "NICU", "CCU", "ICU", "HDU"]
let FAR_UNITS = ["", "Post Natal 1", "Post Natal 2", "Post Natal 3", "Gynecology 1", "Gynecology 2", "Pediatric 5", "Pediatric 6", "Pediatric 7", "Pediatric 8", "Surgical 9", "Surgical 10", "Surgical 11", "Surgical 12", "Medical 14", "Medical 15", "Medical 16", "Medical 17", "Urology 18", "Medical 19", "Orthopedic 20", "Orthopedic 21", "ENT 22", "ENT 23", "Surgical 24", "Surgical 26", "Medical 27", "Medical 28", "ICU", "HDU", "CCU", "SCBU", "NICU", "PICU", "MOT", "Casuality OT", "Casuality", "Labor room", "Maternity Casuality", "Day Care", "Dialysis"]
let FAR_PHAR = ["", "Injection Store", "Central Pharmacy"]
let SABAH_PHAR = [String]()
let JAHRAH_PHAR = [String]()
let AMIRI_PHAR = [String]()
let ADAN_PHAR = [String]()
let MUBARAK_PHAR = [String]()
let HOSPITALS_LIST = [Hospital.Empty, Hospital.Farwaniya, Hospital.Adan]//, Hospital.Mubarak, Hospital.Amiri, Hospital.Jahrah, Hospital.Sabah]
let SABAH = "Sabah"
let JAHRAH = "Jahrah"
let AMIRI = "Amiri"
let MUBARAK = "Mubarak"
let FAR = "Farwaniya"
let ADAN = "Adan"
let FAR_LOC = "farwaniya_locations"
let ADAN_LOC = "adan_locations"
let AMIRI_LOC = "amiri_locations"
let JAHRAH_LOC = "jahrah_locations"
let SABAH_LOC = "sabah_locations"
let MUBARAK_LOC = "mubarak_locations"

class Rules {
    static let patientInitials = NSPredicate(format: "SELF MATCHES %@ ", "^[a-zA-Z]+$")
    static let username = NSPredicate(format:"SELF MATCHES %@", "^[A-Z0-9a-z]{2,20}$")
    static let password = NSPredicate(format: "SELF MATCHES %@ ", "^(?=.*[a-z])(?=.*[A-Z]).{8,}$")
    static let email = NSPredicate(format:"SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
    static let bedAndWardAndFn = NSPredicate(format:"SELF MATCHES %@", "^[A-Z0-9a-z ]{1,12}+$")
    static let weightAndHeightAndBalance = NSPredicate(format:"SELF MATCHES %@", "^[0-9.]{0,6}$")
    static let condition = NSPredicate(format:"SELF MATCHES %@", "^[A-Z0-9a-z ]{2,34}$")
    static let frequency = NSPredicate(format:"SELF MATCHES %@", "^[A-Z0-9a-z ]{1,20}$")
}
class Ref {
//    var WEBSITE: String {
//        guard let currentServerAddress = UserDefaults.standard.string(forKey: "WEBSITE") else {print("No data saved for the local server address"); return "error"}
//        return currentServerAddress
//    }
    let WEBSITE = "https://www.farwaniyapharmacist.online/FidasDevelopment/v1/"
        //"http://192.168.8.111/IOSRegistrationForm/v1/"
    //"https://www.farwaniyapharmacist.online/IOSRegistrationForm/v1/"
    var REGISTER_FILE: String { "\(WEBSITE)register.php"}
    var LOGIN_FILE: String { "\(WEBSITE)login.php"}
    var ADDPATIENT_FILE: String { "\(WEBSITE)addPatient.php"}
    var LOADPATIENTS_FILE: String {"\(WEBSITE)loadPatients.php"}
    var UPDATEADMISSION_FILE: String { "\(WEBSITE)updateAdmission.php"}
    var SEARCH_FILE: String { "\(WEBSITE)searchFileNumber.php"}
    var LOGOUT_FILE: String { "\(WEBSITE)endSession.php"}
    var DELETEADMISSON_FILE: String { "\(WEBSITE)deleteAdmission.php"}
    var SEARCHMEDICINE_FILE : String {"\(WEBSITE)searchMedicine.php"}
    var RETRIEVECOUNT_FILE : String { "\(WEBSITE)retrieveCount.php"}
    var ADMIN_FILE: String { "\(WEBSITE)adminPage.php"}
    var RESET_PWD_REQUEST_FILE: String { "\(WEBSITE)resetPasswordRequest.php"}
    var CHECK_SESSION_FILE: String { "\(WEBSITE)checkSession.php"}
    var REPORT_LOCATION_FILE: String {"\(WEBSITE)reportLocation.php"}
    var LOAD_REPORTS_FILE: String {"\(WEBSITE)loadReports.php"}
    var SEARCH_MEDICINE_LOCATION_FILE: String {"\(WEBSITE)searchMedicineLocation.php"}
    var LOAD_ANNOUNCEMENTS_FILE: String {"\(WEBSITE)loadWriteAnnouncements.php"}
    var UPDATE_ANNOUNCEMENT_FILE: String {"\(WEBSITE)updateAnnouncement.php"}
    var REMOVE_ANNOUNCEMENTS_FILE: String {"\(WEBSITE)deleteAnnouncement.php"}
}
class RefVals {
    static let RFT = [("Na", 135.0, 145.0, "mmol/L", ""), ("K", 3.5, 5.0, "mmol/L", ""), ("Ca", 2.1, 2.6, "mmol/L", ""), ("CorrectedCa", 2.1, 2.6, "mmol/L", ""), ("Urea", 3.3, 6.0, "mmol/L", ""), ("Gluc", 3.9, 5.0, "mmol/L", ""), ("Creat", 70, 110, "micromol/L", "")]
    static let LFT = [("ALT", 5.0, 59.0, "IU/L", ""), ("Bili", 3.0, 16.0, "micromol/L", ""), ("AlkPhos", 30.0, 140.0, "IU/L", ""), ("GGT", 8, 31, "IU/L", ""), ("Alb", 35.0, 50.0, "g/L", ""), ("Prot", 60.0, 80.0, "g/L", ""), ("AST", 9.0, 52.0, "IU/L", "")]
}

