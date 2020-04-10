//
//  ObservableDataSource.swift
//  MyCountry
//
//  Created by Arinjoy Biswas on 10/4/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import RxSwift

/// Data tasks which handles a api/server request and optionally return a Data instance via Single
protocol ObservableDataSource {
    
    ///  Calls the server, fetches and returns a `Single<T>` instance.
    ///
    /// - Parameter request: A BaseRequest instance that defines the API call
    /// - Returns: a `Single<T>` instance containing the data returned from the API call
    @discardableResult
    func fetchSingleObject<T>(with request: BaseRequest) -> Single<T> where T: Decodable
}
