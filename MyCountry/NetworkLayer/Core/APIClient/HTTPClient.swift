//
//  HTTPClient.swift
//  MyCountry
//
//  Created by Arinjoy Biswas on 10/4/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import Foundation
import RxSwift

final class HTTPClient: ObservableDataSource {
    
    // MARK: - Private properties
    
    private let defaultSession: URLSession
    private var dataTask: URLSessionDataTask?
    
    init(withSession session: URLSession = URLSession(configuration: .default)) {
        self.defaultSession = session
    }
    
    // MARK: - ObservableDataSource
    
    /// Fetches API call result in terms of Rx `Single` for a request
    /// - Parameter request: The configured URL request
    @discardableResult
    func fetchSingleObject<T>(with request: BaseRequest) -> Single<T> where T: Decodable {
        
        return Single<T>.create { single in
            
            self.dataTask?.cancel()
                        
            self.dataTask = self.defaultSession.dataTask(with: request.urlRequest) { [weak self] data, response, error in
                
                defer {
                  self?.dataTask = nil
                }
            
                let decoder = JSONDecoder()
                let result: Result<T, Error> = decoder.decodeResponse(from: DataResponse(response: response,
                                                                                         data: data,
                                                                                         error: error))
                switch result {
                case .success(let result):
                    single(.success(result))
                case .failure(let error):
                    single(.error(error))
                }
            }
            
            self.dataTask?.resume()
            
            return Disposables.create()
        }
    }
}

/// A data structure to capture potential outcome of API call / URL session data task
/// in terms of response and returned data and/or error
private struct DataResponse {
    let response: URLResponse?
    let data: Data?
    let error: Error?
}

private extension JSONDecoder {
    
    /// Decodes a resulting type of T from a `DataResponse` and wraps into `Result<T, Error>`
    func decodeResponse<T: Decodable>(from dataResponse: DataResponse) -> Result<T, Error> {
        
        // Networking and API client related errors here
        if let error = dataResponse.error {

            let networkError: NSError = error as NSError
            switch networkError.code {
            case NSURLErrorNotConnectedToInternet:
                return .failure(APIError.networkFailure)
            case NSURLErrorTimedOut:
                return .failure(APIError.timeout)
            default:
                break
            }
            return .failure(error)
        }
        
        guard let httpResponse = dataResponse.response as? HTTPURLResponse else {
            return .failure(APIError.unknown)
        }
        
        switch httpResponse.statusCode {
        case 401:
            return .failure(APIError.unAuthorized)
        case 403:
            return .failure(APIError.forbidden)
        case 503:
            return .failure(APIError.seviceUnavailable)
        case 500 ... 599:
            return .failure(APIError.server)
        default:
            break
        }
        
        // Other than the above error cases,
        // we expect response may have some data (including error body sent from server)
        // If not, treat as missing data error
        guard let responseData = dataResponse.data else {
            return .failure(APIError.noData)
        }
        
        // If response data body exists, try to decode from JSON as expected Data type
        do {
            let item = try decode(T.self, from: responseData)
            return .success(item)
        } catch {
            // Most likely JSON data/contract conversion error here
            // Or if a custom Error json body was sent from server
            return .failure(APIError.dataConversion)
        }
    }
}
