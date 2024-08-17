//
//  AppDelegate.swift
//  Project
//
//  Created by Abdulkadir Oruç on 20.04.2024.
//

import UIKit
import FirebaseCore
import FirebaseAuth

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        guard let window = window else {
            return false
        }
        
        let initialViewController = UINavigationController()
        
        if Auth.auth().currentUser == nil{
            initialViewController.setRootWireframe(LoginWireframe())
        }else{
            initialViewController.setRootWireframe(TabBarWireframe())
        }
        
        window.rootViewController = initialViewController
        window.makeKeyAndVisible()
        

        return true
    }
}

