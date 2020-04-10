//
//  Decoding+Helpers.swift
//  MyCountry
//
//  Created by Arinjoy Biswas on 10/4/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import Foundation

/// A data struct to capture potential outcome of API call / URL session data task in terms of
/// response and returned data and/or error
struct DataResponse {
    let response: URLResponse?
    let data: Data?
    let error: Error?
}

extension JSONDecoder {
    
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
            return .failure(error)
        }
    }
}
