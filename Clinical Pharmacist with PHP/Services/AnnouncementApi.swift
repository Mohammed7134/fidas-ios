//
//  AnnouncementApi.swift
//  Fidas
//
//  Created by Mohammed Almutawa on 5/26/21.
//

import Foundation
import Combine
enum FailureReason : Error {
    case sessionFailed(error: URLError)
    case decodingFailed
    case other(Error)
}
class AnnouncementApi {
    func getData<SomeDecodable: Decodable>(data: Data, to url: URL) -> AnyPublisher<SomeDecodable, FailureReason> {
        let request = NSMutableURLRequest(url: NSURL(string: Ref().LOAD_ANNOUNCEMENTS_FILE)! as URL)
        request.httpMethod = "POST"
        request.httpBody = data
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
    func postData<SomeDecodable: Decodable>(data: Data, to url: URL) -> AnyPublisher<SomeDecodable, FailureReason> {
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpBody =  data
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
