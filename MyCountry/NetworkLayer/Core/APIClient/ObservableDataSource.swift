//
//  ObservableDataSource.swift
//  MyCountry
//
//  Created by Arinjoy Biswas on 10/4/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import Foundation
import RxSwift

/// Data tasks which handles a api/server request and optionally return a Data instance via Single
protocol ObservableDataSource {
    
    ///  Calls the server, fetches and returns a `Single<T>` instance.single(.error(error))
    ///
    /// - Parameter request: A BaseRequest instance that defines the API call
    /// - Returns: a `Single<T>` instance containing the data returned from the API call
    @discardableResult
    func fetchSingleObject<T>(with request: BaseRequest) -> Single<T> where T: Decodable
    
    ///  Calls the server, downloads and returns a `Single<Data>` instance.
    ///
    /// - Parameter url: An web image url to download the image data from
    /// - Returns: a `Single<Data>` instance containing the data of the image downloaded
    @discardableResult
    func downloadSingleImageData(with url: URL) -> Single<Data>
}
