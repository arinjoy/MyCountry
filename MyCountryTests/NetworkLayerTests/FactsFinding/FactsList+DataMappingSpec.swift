//
//  FactsListDataMappingSpec.swift
//  MyCountryTests
//
//  Created by Arinjoy Biswas on 10/4/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import Quick
import Nimble
@testable import MyCountry

final class FactsListDataMappingSpec: QuickSpec {

    override func spec() {
        
        describe("Facts List Data Mapping Spec") {
            
            var testJSONData: Data!
            
            context("correct JSON response") {
                
                beforeEach {
                    testJSONData = Bundle(for: type(of: self)).jsonData(forResource: "factsList")
                }
                
                it("should successfully decode to valid `FactLists` object") {
                    
                    let mappedItem: FactsList? = try? JSONDecoder().decode(FactsList.self, from: testJSONData)
                    
                    // The entire structure is mapped
                    expect(mappedItem).toNot(beNil())
                    
                    expect(mappedItem?.title).to(equal("About Australia"))
                    
                    // 5 facts got mapped (the last one got discarded from JSON due to all-missing attributes)
                    expect(mappedItem?.facts.count).to(equal(5))
                    
                    // Only a few of the facts are tested below
                    let firstFact = mappedItem?.facts.first
                    expect(firstFact?.title).to(equal("Kangaroo"))
                    expect(firstFact?.description).to(equal("Kangaroos are second only to humans in their ability."))
                    expect(firstFact?.imageUrl).to(equal("http://upload.wikimedia.org/kangaroo.jpg"))
                    
                    let fourthFact = mappedItem?.facts[3]
                    expect(fourthFact?.title).to(beNil())
                    expect(fourthFact?.description).to(equal("Warmer than you might think."))
                    expect(fourthFact?.imageUrl).to(equal("http://icons.iconarchive.com/icons/uluru.png"))
                }
            }
            
            context("incorrect JSON response") {
                
                beforeEach {
                    testJSONData = Bundle(for: type(of: self)).jsonData(forResource: "factsList_Incorrect_Format")
                }
                
                it("should not decode to valid `FactLists` object") {
                    
                    let mappedItem: FactsList? = try? JSONDecoder().decode(FactsList.self, from: testJSONData)
                    
                    // due to incorrect JSON struture, it cannot be mapped to `FactsList` object
                    expect(mappedItem).to(beNil())
                }
            }
        }
    }
}
