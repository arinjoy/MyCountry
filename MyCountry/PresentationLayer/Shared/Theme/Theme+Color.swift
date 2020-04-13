//
//  Theme+Color.swift
//  MyCountry
//
//  Created by Arinjoy Biswas on 11/4/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import UIKit

enum Theme {
    
    // MARK: - Colors
    
    static let tintColor = UIColor.colorFrom(red: 71, green: 158, blue: 104) // light teal
    
    static let backgroundColor = UIColor.white
    
    static let primaryTextColor = UIColor.colorFrom(red: 72, green: 82, blue: 86)
    
    static let secondaryTextColor = UIColor.darkGray
    
    static let errorColor = UIColor.colorFrom(red: 165, green: 69, blue: 69) // Grayish red
    
    static let shimmerBaseColor = UIColor.colorFrom(red: 226, green: 232, blue: 230) // light tealish grey
    
    static let shimmerGradientColor = Theme.shimmerBaseColor.withAlphaComponent(0.6)
}

private extension UIColor {
    static func colorFrom(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: 1.0)
    }
}
