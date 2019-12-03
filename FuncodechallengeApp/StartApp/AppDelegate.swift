//
//  AppDelegate.swift
//  FuncodechallengeApp
//
//  Created by Ванурин Алексей on 21.11.2019.
//  Copyright © 2019 Ванурин Алексей. All rights reserved.
//

public let key = "9CA297FA685F9CDAAC9CED27BE1D837C"

import UIKit
import AppAuth


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //window = UIWindow(frame: UIScreen.main.bounds)
        //window?.rootViewController = AuthorizationPresenter() as UIViewController
        //window?.makeKeyAndVisible()
        let launchRouter = RootBuilder().build()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        launchRouter.lauch(from: window!)
        window?.makeKeyAndVisible()
        launchRouter.routeToAuth()
        
        return true
    }
}

