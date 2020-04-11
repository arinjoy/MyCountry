//
//  MyCountryApp+StringKeys.swift
//  MyCountry
//
//  Created by Arinjoy Biswas on 11/4/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import Foundation

extension StringKeys {
    
    enum MyCountryApp: String, LocalizationKeys {
        
        // MARK: - General
        
        case genericErrorTitle = "error.generic.title"
        case genericErrorMessage = "error.generic.message"
        case errorDismissActionTitle = "error.dismiss.action.title"
        
        case networkConnectionErrorMessage = "error.networkConnection.message"

        // MARK: - LocalizationKeys
        
        var table: String? { return "MyCountryApp" }
    }
}
