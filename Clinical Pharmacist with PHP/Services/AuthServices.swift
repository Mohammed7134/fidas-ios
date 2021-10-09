//
//  AuthServices.swift
//  Clinical Pharmacist with PHP
//
//  Created by Mohammed Almutawa on 2/27/21.
//

import Foundation
import Combine


class AuthServices {
    
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
    
    static func autoLogIn() -> AnyPublisher<ResponseWithErrorAndMessageUser, FailureReason> {
        func returnPub(_ errString: String) -> AnyPublisher<ResponseWithErrorAndMessageUser, FailureReason> {
            let publisher = PassthroughSubject<ResponseWithErrorAndMessageUser, FailureReason>()
            publisher.send(ResponseWithErrorAndMessageUser(error: true, message: errString, user: nil))
            return publisher.eraseToAnyPublisher()
        }
        //Find userData in UserDefaults
        guard let currentUserData = UserDefaults.standard.data(forKey: KEY_FOR_USER_DATA)
        else {return returnPub("No data saved for the current user")}
        guard let user = try? JSONDecoder().decode(User.self, from: currentUserData) else {return returnPub("Could not decode current user data")}
        let username = user.username
        
        //Find password in keychain
        let kcw = KeychainWrapper()
        var password: String = ""
        if let pswd = try? kcw.getGenericPasswordFor( account: username, service: "unlockPassword") { password = pswd }
        else {return returnPub("Could not find password")}
        
        //Preparing data
        let request = NSMutableURLRequest(url: NSURL(string: Ref().LOGIN_FILE)! as URL)
        request.httpMethod = "POST"
        let postStringData = "username=\(username)&password=\(password)".data(using: String.Encoding.utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type")
        request.httpBody = postStringData
        
        //Sending data
        return URLSession.shared.dataTaskPublisher(for: request as URLRequest)
            .map{$0.data}
            .decode(type: ResponseWithErrorAndMessageUser.self, decoder: JSONDecoder())
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

    static func logout() {
        print("log out function started")
        let request = NSMutableURLRequest(url: NSURL(string: Ref().LOGOUT_FILE)! as URL)
        request.httpMethod = "POST"
        request.NetworkingWithErrorMessageResponse(onSuccess: {_ in}, onError: {_ in})
    }
    
    static func checkExpiredSession(onExpiredSession: @escaping (_ msg: String) -> Void) {
        print("checking session status function...")
        let request = NSMutableURLRequest(url: NSURL(string: Ref().CHECK_SESSION_FILE)! as URL)
        request.httpMethod = "GET"
        request.NetworkingWithErrorMessageResponse(onSuccess: {_ in}, onError: onExpiredSession)
    }
    
    static func resetPasswordRequest(email: String, completed: @escaping (_ successString: String) -> Void, onError: @escaping (_ errorString: String) -> Void) {
        print("reseting password function started")
        let request = NSMutableURLRequest(url: NSURL(string: Ref().RESET_PWD_REQUEST_FILE)! as URL)
        request.httpMethod = "POST"
        let postString = "email=\(email)"
        request.httpBody = postString.data(using: String.Encoding.utf8)
        request.NetworkingWithErrorMessageResponse(onSuccess: completed, onError: onError)
    }

}
