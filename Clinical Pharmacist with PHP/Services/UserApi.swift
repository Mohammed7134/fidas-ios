//
//  UserApi.swift
//  Clinical Pharmacist with PHP
//
//  Created by Mohammed Almutawa on 5/1/21.
//

import Foundation
import Combine
class UserApi {
    func acceptOrRejectUser(accept: Bool, user: User, onSuccess: @escaping (_ success: String) -> Void, onError: @escaping (_ errorString: String) -> Void) {
        let request = NSMutableURLRequest(url: NSURL(string: Ref().ADMIN_FILE)! as URL)
        request.httpMethod = "POST"
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        let accepted = (accept ? "true" : "false")
        let dicti: [String : Any] = ["accept" : accepted, "userId" : user.id, "email" : user.email]
        guard let data = try? JSONSerialization.data(withJSONObject: dicti, options: .prettyPrinted) else {onError("Could not convert data to json format");return}
        request.httpBody =  data
        request.NetworkingWithErrorMessageResponse(onSuccess: onSuccess, onError: onError)
    }
    func loadPendingUsers<SomeDecodable: Decodable>(url: URL) -> AnyPublisher<SomeDecodable, FailureReason> {
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        return URLSession.shared.dataTaskPublisher(for: request as URLRequest)
            .map{$0.data}
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
}
