//
//  ImageLoadingServiceSpec.swift
//  MyCountryTests
//
//  Created by Arinjoy Biswas on 11/4/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import Quick
import Nimble
import RxSwift
@testable import MyCountry

final class ImageLoadingServiceSpec: QuickSpec {

    override func spec() {
        
        describe("Image Loading Service Spec") {
            
            var disposeBag: DisposeBag!
            
            beforeEach {
                disposeBag = DisposeBag()
            }
            
            afterEach {
                disposeBag = nil
            }
            
            it("should pass the response from unchanged when succeeds") {

                let dataSourceMock = ObservableDataSourceMock(
                    response: self.sampleData(),
                    returningError: false  // No error returned, means response is returned with success
                )
                var expectedError: Error?
                var receivedResponse: Data?

                let service = ImageLoadingServiceClient(dataSource: dataSourceMock)

                // when
                service.loadImageData(fromUrl: URL(string: "www.google.com/abc.jpg")!)
                    .subscribe(onSuccess: { response in
                        receivedResponse = response
                    }, onError: { error in
                        expectedError = error
                    }).disposed(by: disposeBag)

                // then
                expect(expectedError).to(beNil())
                expect(receivedResponse).toNot(beNil())
            }

            it("should pass error from the api client when fails") {

                let dataSourceMock = ObservableDataSourceMock(
                    response: Data(),
                    returningError: true,  // Error returned, means no response will be returned due to failure
                    error: APIError.notFound
                )
                var expectedError: Error?
                var receivedResponse: Data?

                let service = ImageLoadingServiceClient(dataSource: dataSourceMock)

                // when
                service.loadImageData(fromUrl: URL(string: "www.google.com/error.jpg")!)
                    .subscribe(onSuccess: { response in
                        receivedResponse = response
                    }, onError: { error in
                        expectedError = error
                    }).disposed(by: disposeBag)

                // then
                expect(receivedResponse).to(beNil())
                expect(expectedError).toNot(beNil())
                expect(expectedError as? APIError).to(equal(APIError.notFound))
            }
        }
    }
    
    private func sampleData() -> Data {
        let string = "some image binary data"
        return string.data(using: .utf8)!
    }
}
