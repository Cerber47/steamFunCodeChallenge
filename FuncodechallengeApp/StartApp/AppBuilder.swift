//
//  AppBuilder.swift
//  FuncodechallengeApp
//
//  Created by Ванурин Алексей on 22.11.2019.
//  Copyright © 2019 Ванурин Алексей. All rights reserved.
//

import Foundation
import UIKit


final class AppBuilder {
    func build() -> UIViewController {
        let tabViewController = UITabBarController()
        
        let profileRouter = ProfileBuilder().build()
        let gameinfoRouter  = GameinfoBuilder().build()
        let friendsRouter = FriendsBuilder().build()
        
        let profileViewController = profileRouter.getMasterViewController()
        let gameingoViewController = gameinfoRouter.getMasterViewController()
        let friendsViewController = friendsRouter.getMasterViewController()
        
        let tabViewControllers = [profileViewController, gameingoViewController, friendsViewController]
        
        profileViewController.tabBarItem = getTabBarItem(for: "Profile")
        gameingoViewController.tabBarItem = getTabBarItem(for: "Dota 2")
        friendsViewController.tabBarItem = getTabBarItem(for: "Friends")
        
        tabViewController.viewControllers = tabViewControllers
        print(tabViewControllers)
        return tabViewController
    }
    
    private func getTabBarItem(for tab: String) -> UITabBarItem {
        let tabBarItem = UITabBarItem(title: tab, image: nil, selectedImage: nil)
        return tabBarItem
    }
}
