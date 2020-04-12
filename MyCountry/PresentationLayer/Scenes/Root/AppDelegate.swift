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
        
        window?.backgroundColor = Theme.backgroundColor
        window?.tintColor = Theme.tintColor
        
//        SkeletonAppearance.default.multilineHeight = 5
//        SkeletonAppearance.default.tintColor = .green
//        SkeletonAppearance.default.multilineCornerRadius = 10
//        //SkeletonAppearance.default.multilineSpacing = 10
//        SkeletonAppearance.default.multilineLastLineFillPercent = 80
//        //SkeletonAppearance.default.li
        
        window?.rootViewController = UINavigationController(rootViewController: FactsListViewController())
        window?.makeKeyAndVisible()
        return true
    }
}
