//
//  FactsTransformerSpec.swift
//  MyCountryTests
//
//  Created by Arinjoy Biswas on 13/4/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import Quick
import Nimble
@testable import MyCountry

final class FactsTransformerSpec: QuickSpec {
    
    override func spec() {
        
        describe("Facts Transformer Spec") {
            
            var trasformer: FactsTransformer!
            var results: FactsListDataSource!
            
            beforeEach {
                trasformer = FactsTransformer()
                results = trasformer.transform(input: self.sampleFacts())
            }
            
            it("should tranform fact data items correctly into presentation items") {
                // A single section
                expect(results.sections.count).to(equal(1))
                
                // The section contains 5 elements
                expect(results.sections.first?.items.count).to(equal(5))
                
                let item1 = results.sections.first?.items[0]
                let item2 = results.sections.first?.items[1]
                let item3 = results.sections.first?.items[2]
                let item4 = results.sections.first?.items[3]
                let item5 = results.sections.first?.items[4]
                
                expect(item1?.title?.string).to(equal("It's a magical land"))
                expect(item1?.body?.string).to(equal("We all live with wonders of natures everywhere.."))
                expect(item1?.webImageUrl?.absoluteString).to(equal("http://www.nz.com/free.png"))
                expect(item1?.accessibility?.titleAccessibility?.label)
                    .to(equal("Fact title, It's a magical land"))
                expect(item1?.accessibility?.titleAccessibility?.identifier)
                    .to(equal("accessibilityId.factsList.title"))
                expect(item1?.accessibility?.bodyAccessibility?.label)
                    .to(equal("Fact description, We all live with wonders of natures everywhere.."))
                expect(item1?.accessibility?.bodyAccessibility?.identifier)
                    .to(equal("accessibilityId.factsList.body"))
                expect(item1?.accessibility?.imageAccessibility?.label)
                    .to(equal("Fact image"))
                expect(item1?.accessibility?.imageAccessibility?.identifier)
                    .to(equal("accessibilityId.factsList.image"))
                
                expect(item2?.title?.string).to(equal("Kiwi"))
                expect(item2?.body?.string).to(equal("They are the most cute little birdies with great persona."))
                expect(item2?.webImageUrl?.absoluteString).to(equal("https://www.nz.com/kiwi.png"))
                
                // Correctly nullifies items if `nil` or empty string in raw data
                expect(item3?.title).to(beNil())
                expect(item3?.body).toNot(beNil())
                expect(item3?.webImageUrl).to(beNil())
                
                expect(item4?.title).to(beNil())
                expect(item4?.body).toNot(beNil())
                expect(item4?.webImageUrl).to(beNil())
                
                expect(item5?.title).toNot(beNil())
                expect(item5?.body).to(beNil())
                expect(item5?.webImageUrl).to(beNil())
            }
        }
    }
    
    // MARK: - Private Test Helpers
    
    private func sampleFacts() -> [Fact] {
        return [Fact(title: "It's a magical land",
                         description: "We all live with wonders of natures everywhere..",
                         webImageUrl: "http://www.nz.com/free.png"),
                Fact(title: "Kiwi",
                     description: "They are the most cute little birdies with great persona.",
                     webImageUrl: "https://www.nz.com/kiwi.png"),
                Fact(title: "",
                     description: "some information 1",
                     webImageUrl: nil),
                Fact(title: nil,
                     description: "some information 2",
                     webImageUrl: ""),
                Fact(title: "some title 3",
                     description: nil,
                     webImageUrl: nil)
                ]
    }
}
