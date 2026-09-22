//
//  Networking.swift
//  Excericse2
//
//  Created by emre on 22.09.26.
//

import Foundation


enum NetworkError: Error, LocalizedError{
    case invalidEmailFormat
    case incorrectPassword
    case networkOffline
    case unexpectedDataFormat
    case unknown
    case invalidURL
    case noData
    case serializationFailed
    case serverError(statusCode: Int)
    
    var errorDescription: String?
    {
        switch self {
        case .invalidEmailFormat:
            return "Invalid email format"
        case .incorrectPassword:
            return "Incorrect password or Email"
        case .networkOffline:
            return "Network is offline"
        case .unexpectedDataFormat:
            return "Unexpected data format"
        case .unknown:
            return "Unknown error"
        case .invalidURL:
            return "Invalid URL"
            case .noData:
            return "No data"
        case .serializationFailed:
            return "Serialization failed"
        case .serverError(statusCode: let statusCode):
            return "Server error with status code: \(statusCode)"
        }
    }
}

class NetworkManager {
    private let session: URLSession
    private let APIKEY: String = "REPLACE_IN_PROD"
    
    init(session: URLSession = .shared){
        self.session = session
    }
    
    func login(email: String, password: String, completion: @escaping (User?, NetworkError?) -> Void){
        guard let url = URL(string: "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=\(APIKEY)") else {
            
            completion(nil, .invalidURL)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "email":email,
            "password":password,
            "returnSecureToken":true
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        }
            catch {
                completion(nil, .serializationFailed)
                
                return
            }
        
        let task: URLSessionDataTask = session.dataTask(with: request) { (data, response, error) in
            
            if let error = error as NSError?{
                DispatchQueue.main.async {
                    completion(nil, .networkOffline)
                }
                
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, .noData)
                }
                
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode){
                if let apiError = try? JSONDecoder().decode(ResponseError.self, from: data){
                    let mappedError = self.mapAPIError(apiError.error.message, statusCode: apiError.error.code)
                    DispatchQueue.main.async {
                        completion(nil, mappedError)
                    }
                    
                    
                }else{
                    DispatchQueue.main.async {
                        completion(nil, .serverError(statusCode: httpResponse.statusCode))
                    }

                }

                return
            }
            

            
            do{
                
                let loginResponse = try JSONDecoder().decode(User.self, from: data)
                
            DispatchQueue.main.async {
                    completion(loginResponse, nil)
                }
            }catch {
                DispatchQueue.main.async {
                    completion(nil, .unexpectedDataFormat)
                }
                
            }
            
            
        }
        task.resume()
        
    }
    
    private func mapAPIError(_ message: String, statusCode: Int) -> NetworkError {
        switch message {
        case "INVALID_EMAIL":
            return .invalidEmailFormat
        case "INVALID_LOGIN_CREDENTIALS":
            return .incorrectPassword
        default:
            return .serverError(statusCode: statusCode)
        }
    }
}
