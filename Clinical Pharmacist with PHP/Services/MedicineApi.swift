//
//  MedicineApi.swift
//  Clinical Pharmacist with PHP
//
//  Created by Mohammed Almutawa on 3/26/21.
//

import Foundation
import Combine
class MedicineApi {
//    func searchMedicines(text: String, onSuccess: @escaping (_ medicines: [String]) -> Void) {
//        let request = NSMutableURLRequest(url: NSURL(string: Ref().SEARCHMEDICINE_FILE)! as URL)
//        request.httpMethod = "POST"
//        let postString = "searchText=\(text)"
//        request.httpBody = postString.data(using: String.Encoding.utf8)
//        request.NetworkingWithLoadMedicinesResponse(onSuccess: onSuccess, onError: {print($0)})
//    }
//    func searchMedicinesLocations(hospital: String, pharmacy: String, medicine: String, onSuccess: @escaping (_ meds: [MedicineLocations]) -> Void, onError: @escaping (_ errorMsg: String) -> Void){
//        let request = NSMutableURLRequest(url: NSURL(string: Ref().SEARCH_MEDICINE_LOCATION_FILE)! as URL)
//        request.httpMethod = "POST"
//        let postString = "hospital=\(hospital)&pharmacy=\(pharmacy)&searchText=\(medicine)"
//        request.httpBody = postString.data(using: String.Encoding.utf8)
//    return request.NetworkingWithLoadMedicinesLocationsResponse(onSuccess: onSuccess, onError: onError)
//    }

    func getMedicines(text: String) -> AnyPublisher<LoadMedicinesResponse, Error>{
        let request = NSMutableURLRequest(url: NSURL(string: Ref().SEARCHMEDICINE_FILE)! as URL)
        request.httpMethod = "POST"
        let postString = "searchText=\(text)"
        request.httpBody = postString.data(using: String.Encoding.utf8)
        return URLSession.shared.dataTaskPublisher(for: request as URLRequest)
            .map{$0.data}
            .decode(type: LoadMedicinesResponse.self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
