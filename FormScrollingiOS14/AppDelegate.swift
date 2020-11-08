//
//  AppDelegate.swift
//  FormScrollingiOS14
//
//  Created by AT on 10/13/20.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var mainViewController: MainViewController?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let mainViewController = MainViewController()
        self.mainViewController = mainViewController
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.overrideUserInterfaceStyle = .light
        window.rootViewController = mainViewController
        window.makeKeyAndVisible()
        
        self.window = window
        
        return true
    }

}

