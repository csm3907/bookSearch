//
//  AppDelegate.swift
//  bookSearch
//
//  Created by USER on 2022/11/08.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let navVC = UINavigationController(rootViewController: ViewController())
        window?.rootViewController = navVC
        window?.makeKeyAndVisible()
        return true
    }
    
    
}

