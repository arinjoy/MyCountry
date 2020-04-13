//
//  ImageLoadingService.swift
//  MyCountry
//
//  Created by Arinjoy Biswas on 11/4/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import Foundation
import RxSwift

protocol ImageLoadingClientType {
    
    /// Downloads image data from an web URL
    /// - Returns: The downloaded in terms of Single
    func loadImageData(fromUrl webUrl: URL) -> Single<Data>
}

final class ImageLoadingServiceClient: ImageLoadingClientType {
    
    private let dataSource: ObservableDataSource
    
    init(dataSource: ObservableDataSource) {
        self.dataSource = dataSource
    }
    
    func loadImageData(fromUrl webUrl: URL) -> Single<Data> {
        
        let imageLoadingRequest = ImageLoadingRequest(url: webUrl)
                
        return dataSource.downloadSingleImageData(with: imageLoadingRequest)
    }
}
