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
    
    let defaultSession = URLSession(configuration: .default)
    
    var dataTask: URLSessionDataTask?
    
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
