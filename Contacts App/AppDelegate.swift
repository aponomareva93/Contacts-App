//
//  AppDelegate.swift
//  Contacts App
//
//  Created by anna on 18.09.17.
//  Copyright © 2017 anna. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator!

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.appCoordinator = AppCoordinator(window: self.window!)
        self.appCoordinator.start()
        
        return true
    }
}
