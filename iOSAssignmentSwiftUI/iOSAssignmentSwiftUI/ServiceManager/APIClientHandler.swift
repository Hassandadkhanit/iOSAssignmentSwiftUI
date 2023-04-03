//
//  APIHandler.swift
//  GitHubProfile
//
//  Created by Hassan dad khan on 31/03/2023.
//

import Foundation
import Combine

typealias APICompletionHander = (_ data : Data?,_ response : HTTPURLResponse?,_ error : Error?) -> Void

enum HTTPMethods {
    case post
    case get
    
    var value: String {
        switch self {
        case .post: return "POST"
        case .get: return "GET"
        }
    }
}

/// Defines the Network service errors.
enum NetworkError: Error {
    case unknownError
    case connectionError
    case invalidCredentials
    case invalidRequest
    case invalidURL
    case notFound
    case invalidResponse
    case serverError
    case serverUnavailable
    case timeOut
}

class APIClientHandler {
    static var shared = APIClientHandler()
    private let session: URLSession
    private var cancellable = Set<AnyCancellable>()
    
    init(session: URLSession = URLSession(configuration: URLSessionConfiguration.default)) {
        self.session = session
    }
    
    private var getHeaders : [String:String] {
        return [
            "Content-Type": "application/json",
        ]
    }
    
    //MARK: - Send Request
    func sendRequest(urlString : String,parameters : [String: Any?],method : HTTPMethods, completion :@escaping APICompletionHander) {
        
        guard let url = URL(string: urlString) else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.value
        do {
            request.httpBody  = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription )
        }
        request.allHTTPHeaderFields = self.getHeaders
        
        let task =  URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            if error != nil {
                completion(nil,nil,error)
            } else {
                if let responseData = data,
                   let httpResponse = response as? HTTPURLResponse,
                   (200...299).contains(httpResponse.statusCode) {
                    completion(responseData,httpResponse, nil)
                } else {
                    completion(nil,nil,error)
                }
            }
        }
        task.resume()
        
    }
    func sendRequest<T: Decodable>(urlString : String,parameters: [String: Any?],method: HTTPMethods,type: T.Type) -> Future<T?, Error> {
        return Future<T?,Error> { [weak self] promise in
            
            guard let request = self?.makeRequest(urlString: urlString, parameters: parameters, method: method) else {
                promise(.failure(NetworkError.invalidRequest))
                return
            }
            
            URLSession.shared.dataTaskPublisher(for: request)
                .tryMap { (data, response) -> Data in
                    
                    guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                        var statusCode : Int?
                        if let httpResponse = response as? HTTPURLResponse   {
                            statusCode = httpResponse.statusCode
                           self?.showRequestDetailForFailure(responseObject: httpResponse, data: data)
                        }
                        throw APIClientHandler.checkErrorCode(statusCode ?? 0)

                    }
                    self?.showRequestDetailForSuccess(responseObject: httpResponse, data: data)
                    return data
                }
                .decode(type: T.self, decoder: JSONDecoder())
                .sink(receiveCompletion: { (completion) in
                    if case let .failure(error) = completion {
                        switch error {
                        case let decodingError as DecodingError:
                            promise(.failure(decodingError))
                        case let apiError as NetworkError:
                            promise(.failure(apiError))
                        default:
                            promise(.failure(NetworkError.unknownError))
                        }
                        
                    }
                }, receiveValue: {
                    promise(.success($0))
                    
                })
                .store(in: &self!.cancellable)
        }
    }
    
    func sendRequest(urlString: String, parameters: [String: Any?],method: HTTPMethods) -> AnyPublisher<Data, Error> {
        guard let request = self.makeRequest(urlString: urlString, parameters: parameters, method: method) else {
            return .fail(NetworkError.invalidRequest)
        }
        return session.dataTaskPublisher(for: request)
            .mapError { _ in NetworkError.invalidRequest }
            .flatMap { data, response -> AnyPublisher<Data, Error> in
                guard let httpResponse = response as? HTTPURLResponse else {
                    if let httpResponse = response as? HTTPURLResponse {
                        self.showRequestDetailForFailure(responseObject: httpResponse, data: data)
                    }
                    return .fail(NetworkError.invalidURL)
                }
                
                guard 200..<300 ~= httpResponse.statusCode else {
                    self.showRequestDetailForFailure(responseObject: httpResponse, data: data)
                    return .fail(NetworkError.invalidResponse)
                }
                self.showRequestDetailForSuccess(responseObject: httpResponse, data: data)
                return .just(data)
            }
            .eraseToAnyPublisher()
    }
    
    //MARK: - Request
    private func makeRequest(urlString : String,parameters : [String: Any?],method : HTTPMethods) -> URLRequest? {
        var url : URL?
        if method.value == HTTPMethods.post.value {
            url = postUrl(urlString: urlString)
        } else {
            url = getUrl(urlString: urlString, parameters: parameters)
        }
        guard let url = url else  {
            return nil
        }
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = getHeaders
        if method.value == HTTPMethods.post.value {
            let jsonData = try? JSONSerialization.data(withJSONObject: parameters)
            request.httpBody = jsonData
        }
        return request
    }
    
    func getUrl(urlString : String,parameters : [String: Any?]) -> URL? {
        guard var components = URLComponents(string: urlString) else {
            return nil
        }
        components.queryItems = parameters.map({ key,value in
            URLQueryItem(name: key, value: value as? String)
        })
        guard let url = components.url else {
            return nil
        }
        return url
    }
    func postUrl(urlString : String) -> URL? {
        guard let url = URL(string: urlString) else {
            return nil
        }
        return url
    }
    
    //MARK: - Show Result
    func showRequestDetailForSuccess(responseObject response : HTTPURLResponse,data : Data?) {
        
        print("\n\n\n✅✅✅✅ ------- Success Response Start ------- ✅✅✅✅\n")
        
        
        print("URL: "+(response.url?.absoluteString ?? ""))
        
        print("\n=========    Status Code: \(response.statusCode)    ==========")
        
        print("\n=========    HTTP Header Fields   ========== ")
        print(response.allHeaderFields as? AnyObject)
        
        
        if let bodyData : Data = data {
            let bodyString = String(data: bodyData, encoding: .utf8)
            print("\n=========   Response httpBody   ========== \n\n" + (bodyString ?? ""))
        } else {
            print("\n=========   Response httpBody   ========== \n\n" + "Found Response Body Nil")
        }
        
        print("\n✅✅✅✅ ------- Success Response End ------- ✅✅✅✅\n\n\n")
        
    }
    private func showRequestDetailForFailure(responseObject response : HTTPURLResponse,data: Data?, error: Error = NetworkError.unknownError) {
        
        print("\n\n\n❌❌❌❌ ------- Failure Response Start ------- ❌❌❌❌\n")
        
        print("URL: "+(response.url?.absoluteString ?? ""))
        
        print("\n=========    Status Code: \(response.statusCode)    ==========")
        
        print("\n=========    HTTP Header Fields   ========== ")
        print(response.allHeaderFields)
        
        
        print("\n=========   Response Body   ========== \n")
        if  !(error.localizedDescription.isEmpty) {
            print(error.localizedDescription)
        } else {
            if let responseData = data, let responseString = String(data: responseData, encoding: .utf8) {
                print(responseString)
            } else {
                print("Found Response Body Nil")
            }
        }
        
        print("\n❌❌❌❌ ------- Failure Response End ------- ❌❌❌❌\n\n\n")
        
    }
    // MARK: - Utility
    static func checkErrorCode(_ statusCode: Int) -> NetworkError {
        switch statusCode {
        case 400:
            return .invalidRequest
        case 401:
            return .invalidCredentials
        case 404:
            return .notFound
        default:
            return .unknownError
        }
    }
}
extension Publisher {

    static func empty() -> AnyPublisher<Output, Failure> {
        return Empty().eraseToAnyPublisher()
    }

    static func just(_ output: Output) -> AnyPublisher<Output, Failure> {
        return Just(output)
            .catch { _ in AnyPublisher<Output, Failure>.empty() }
            .eraseToAnyPublisher()
    }

    static func fail(_ error: Failure) -> AnyPublisher<Output, Failure> {
        return Fail(error: error).eraseToAnyPublisher()
    }
}
