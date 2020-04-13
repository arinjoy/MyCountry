//
//  AppDelegate.swift
//  MyCountry
//
//  Created by Arinjoy Biswas on 10/4/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import UIKit
import SkeletonView

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        applyThemeStyles()
        
        window?.rootViewController = UINavigationController(rootViewController: FactsListViewController())
        window?.makeKeyAndVisible()
        return true
    }
    
    private func applyThemeStyles() {
        window?.backgroundColor = Theme.backgroundColor
        window?.tintColor = Theme.tintColor
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.font: Theme.titleFont,
                                                            NSAttributedString.Key.foregroundColor: Theme.primaryTextColor, ]
    }
}
