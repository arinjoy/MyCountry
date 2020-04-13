//
//  ImageLoadOperation.swift
//  MyCountry
//
//  Created by Arinjoy Biswas on 11/4/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

/// An async operation that is cancellable and is used to download an image from an URL
final class ImageLoadOperation: Operation {
    
    // MARK: - Public
    
    /// The image that is being downloaded. `nil` represents it's not loaded due to an error.
    var image: UIImage?
    
    /// A closure that is executed when this operation ends and the downloaded image data is passed back.
    /// `nil`value  represents that image has not been loaded due to some issue.
    var completionHandler: ((UIImage?) -> Void)?
    
    // MARK: - Private
    
    /// The image url to load from
    private let imageWebUrl: URL
    
//    /// `weakly` attached interactor that has ability to load an image from network
//    weak var interactor: FactsInteracting!
    
    private lazy var imageLoadingService: ImageLoadingClientType = {
       return ImageLoadingServiceClient(dataSource: HTTPClient())
    }()
    
    let disposeBag: DisposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    
    init(withUrl url: URL) {
        imageWebUrl = url
    }
    
    override func main() {

        guard !isCancelled else { return }
        
        //guard let interactor = interactor else { return }
        
        imageLoadingService.loadImageData(fromUrl: imageWebUrl)
            .observeOn(MainScheduler.instance)
            
            // Add some delay to show asynchronous acitivity
            // [Used for testing only, But never in production app]
            .delay(2.0, scheduler: MainScheduler.instance)
            
            .subscribe(onSuccess: { imageData in
                
                // If image data is passed as `nil`, means image would be `nil`
        
                self.image = UIImage(data: imageData)
                self.completionHandler?(self.image)
                
            }, onError: { _ in
                // Any error is indicated as `nil` outcome as there is no
                // custom error handling to manage here.

                self.image = nil
                self.completionHandler?(self.image)
                
            })
            .disposed(by: disposeBag)
        
//        imageLoadingService.d
//            .downloadImage(fromUrl: imageWebUrl, completion: { [weak self] imageData in
//
//            guard let self = self else { return }
//
//            guard !self.isCancelled else { return }
//
//            // If image data is passed as `nil`, means image would be `nil`
//
//            var resutingImage: UIImage?
//            if let data = imageData {
//                resutingImage = UIImage(data: data)
//            }
//
//            self.image = resutingImage
//            self.completionHandler?(self.image)
//        })
    }
}
