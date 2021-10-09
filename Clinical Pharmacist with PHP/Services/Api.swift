//
//  Api.swift
//  Cinical Pharmacist
//
//  Created by Mohammed Almutawa on 10/18/20.
//  Copyright © 2020 Mohammed Almutawa. All rights reserved.
//

import Foundation
import Combine
class Api {
    static var User = UserApi()
    static var Patient = PatientApi()
    static var Medicine = MedicineApi()
    static var Report = ReportApi()
    static var Announcement = AnnouncementApi()
    
    static func postJSON<SomeDecodable: Decodable>(data: Data, url: URL) ->  AnyPublisher<SomeDecodable, FailureReason>{
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
    static func postData<SomeDecodable: Decodable>(data: Data, url: URL) -> AnyPublisher<SomeDecodable, FailureReason> {
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = data
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
