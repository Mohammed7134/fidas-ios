//
//  WebServices.swift
//  Fidas
//
//  Created by Mohammed Almutawa on 5/20/21.
//

import Foundation
import Combine

extension NSMutableURLRequest {
    func NetworkingWithErrorMessageUserResponse(onSuccess: @escaping (_ user: User?) -> Void, onError: @escaping (_ errorMsg: String) -> Void) {
        let task = URLSession.shared.dataTask(with: self as URLRequest) {
            data, response, error in
            if error != nil {
                DispatchQueue.main.async {
                    onError(error!.localizedDescription)
                }
                return
            }
            let res = try? JSONDecoder().decode(ResponseWithErrorAndMessageUser.self, from: data!)
            if let response = res {
                if response.error {
                    DispatchQueue.main.async {
                        onError(response.message!)
                    }
                } else {
                    DispatchQueue.main.async {
                        onSuccess(response.user)
                    }
                }
            } else {
                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                let str = String(describing: responseString)
                DispatchQueue.main.async {
                    onError(str)
                }
            }
        }
        task.resume()
    }
    func NetworkingWithErrorMessageResponse(onSuccess: @escaping (_ successMsg: String) -> Void, onError: @escaping (_ errorMsg: String) -> Void) {
        let task = URLSession.shared.dataTask(with: self as URLRequest) {
            data, response, error in
            if error != nil {
                DispatchQueue.main.async {
                    onError(error!.localizedDescription)
                }
                return
            }
            let res = try? JSONDecoder().decode(ResponseWithErrorAndMessage.self, from: data!)
            if let response = res {
                if response.error == false {
                    DispatchQueue.main.async {
                        onSuccess(response.message)
                    }
                } else {
                    DispatchQueue.main.async {
                        onError(response.message)
                    }
                }
            } else {
                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                let str = String(describing: responseString)
                DispatchQueue.main.async {
                    onError(str)
                }
            }
        }
        task.resume()
    }
    func NetworkingWithLoadUsersResponse(onSuccess: @escaping (_ users: [User]) -> Void, onError: @escaping (_ errorString: String) -> Void) {
        let task = URLSession.shared.dataTask(with: self as URLRequest) {
            data, response, error in
            if error != nil {
                DispatchQueue.main.async {
                    onError(error!.localizedDescription)
                }
                return
            }
            let res = try? JSONDecoder().decode(LoadUsersResponse.self, from: data!)
            if let response = res {
                if response.error == false {
                    DispatchQueue.main.async {
                        onSuccess(response.users!)
                    }
                } else {
                    DispatchQueue.main.async {
                        onError(response.message!); return
                    }
                }
            } else {
                DispatchQueue.main.async {
                    onError("Could not get response result from php file")
                    print(String(describing: NSString(data: data!, encoding: String.Encoding.utf8.rawValue))); return
                }
            }
        }
        task.resume()
    }
    func NetworkingWithLoadPatientsResponse(onSuccess: @escaping (_ patient: [PatientViewModel]) -> Void, onError: @escaping (_ errorString: String) -> Void) {
        let task = URLSession.shared.dataTask(with: self as URLRequest) {
            data, response, error in
            if error != nil {
                DispatchQueue.main.async {
                    onError(error!.localizedDescription)
                }
                return
            }
            let res = try? JSONDecoder().decode(LoadPatientsResponse.self, from: data!)
            if let response = res {
                if response.error == false {
                    var patientsArray: [PatientViewModel] = []
                    for patient in response.patients! {
                        patientsArray.append(PatientViewModel(patient: patient))
                    }
                    DispatchQueue.main.async {
                        onSuccess(patientsArray)
                    }
                } else {
                    DispatchQueue.main.async {
                        onError(response.message!); return
                    }
                }
            } else {
                DispatchQueue.main.async {
                    onError("Could not get response result from php file")
                    print(String(describing: NSString(data: data!, encoding: String.Encoding.utf8.rawValue))); return
                }
            }
        }
        task.resume()
    }
    func NetworkingWithCountAdmissionsResponse(onSuccess: @escaping (_ count: Int) -> Void, onError: @escaping (_ errorString: String) -> Void) {
        let task = URLSession.shared.dataTask(with: self as URLRequest) {
            data, response, error in
            if error != nil {
                DispatchQueue.main.async {
                    onError(error!.localizedDescription)
                }
                return
            }
            let res = try? JSONDecoder().decode(CountAdmissionsResponse.self, from: data!)
            if let response = res {
                if response.error == false {
                    DispatchQueue.main.async {
                        onSuccess(response.count!)
                    }
                } else {
                    DispatchQueue.main.async {
                        onError(response.message!); return
                    }
                }
            } else {
                DispatchQueue.main.async {
                    onError("Could not get response result from retrieve count file")
                    print(String(describing: NSString(data: data!, encoding: String.Encoding.utf8.rawValue))); return
                }
            }
        }
        task.resume()
    }
    func NetworkingWithErrorMessageReportsResponse(onSuccess: @escaping (_ reports: [Report]) -> Void, onError: @escaping (_ errorString: String) -> Void) {
        let task = URLSession.shared.dataTask(with: self as URLRequest) {
            data, response, error in
            if error != nil {
                DispatchQueue.main.async {
                    onError(error!.localizedDescription)
                }
                return
            }
            let res = try? JSONDecoder().decode(LoadReportsResponse.self, from: data!)
            if let response = res {
                if response.error == false {
                    DispatchQueue.main.async {
                        onSuccess(response.reports!)
                    }
                } else {
                    DispatchQueue.main.async {
                        onError(response.message!)
                    }
                    return
                }
            } else {
                DispatchQueue.main.async {
                    onError("Could not get response result from Search Medicines file")
                    print(String(describing: NSString(data: data!, encoding: String.Encoding.utf8.rawValue)))
                }
                return
            }
        }
        task.resume()
    }
}

