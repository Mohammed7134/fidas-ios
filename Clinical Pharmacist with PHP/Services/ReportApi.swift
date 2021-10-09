//
//  ReportApi.swift
//  Fidas
//
//  Created by Mohammed Almutawa on 5/16/21.
//
import Foundation
import Combine
class ReportApi {
    func postJSON<SomeDecodable: Decodable>(data: Data, url: URL) ->  AnyPublisher<SomeDecodable, FailureReason>{
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpBody =  data
        return URLSession.shared.dataTaskPublisher(for: request as URLRequest)
            .map{return $0.data}
            .decode(type: SomeDecodable.self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .mapError({ error in
                switch error {
                case is Swift.DecodingError:
                    return .decodingFailed
                case let urlError as URLError:
                    return .sessionFailed(error: urlError)
                default:
                    return .other(error)
                }
            })
            .eraseToAnyPublisher()
    }
    func loadReports(hospital: String, onSuccess: @escaping (_ reports: [Report]) -> Void, onError: @escaping (_ errorMsg: String) -> Void) {
        let request = NSMutableURLRequest(url: NSURL(string: Ref().LOAD_REPORTS_FILE)! as URL)
        request.httpMethod = "POST"
        let postString = "hospital=\(hospital)"
        request.httpBody = postString.data(using: String.Encoding.utf8)
        request.NetworkingWithErrorMessageReportsResponse(onSuccess: onSuccess, onError: onError)
    }
    func reportAction(place: String, medicine: MedicineLocations, reject: Bool, report: Report, onSuccess: @escaping (_ success: String) -> Void, onError: @escaping (_ errorString: String) -> Void) {
        let request = NSMutableURLRequest(url: NSURL(string: Ref().ADMIN_FILE)! as URL)
        request.httpMethod = "POST"
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        let rejected = (reject ? "true" : "false")
        guard let med = try? medicine.toDictionary() else {onError("could not convert medicine to dictionary");return}
        let dicti: [String : Any] = ["reject" : rejected, "reportId" : report.id!, "medicineLocations" : med, "place": place]
        guard let data = try? JSONSerialization.data(withJSONObject: dicti, options: .prettyPrinted) else {onError("Could not convert data to json format");return}
        request.httpBody =  data
        request.NetworkingWithErrorMessageResponse(onSuccess: onSuccess, onError: onError)
    }
}
