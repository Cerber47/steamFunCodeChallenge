//
//  RootRouter.swift
//  FuncodechallengeApp
//
//  Created by Ванурин Алексей on 26.11.2019.
//  Copyright © 2019 Ванурин Алексей. All rights reserved.
//

import Foundation
import UIKit


protocol RootRouting: launchingRouter {
    func routeToRootTabs()
    func routeToAuth() 
}

protocol launchingRouter {
    func lauch(from window: UIWindow)
}

protocol RootDependancy {
    var dataManager: DataManager {get}
}

class RootComponent {
    var dataManager: DataManager
    
    init() {
        dataManager = DataManagerBuilder().build()
    }
}


class RootRouter: RootRouting {
    var uiViewController: UIViewController
    var tabController: UITabBarController?
    
    var auth: AuthorizationRouting?
    
    var profileBuilder: ProfileBuildable
    var gameInfoBuilder: GameinfoBuildable
    var friendsBuilder: FriendsBuildable
    var authorizationBuilder: AuthorizationBuildable
    
    init(profileBuilder: ProfileBuildable, gameInfoBuilder: GameinfoBuildable, friendsBuilder: FriendsBuildable, authorizationBuilder: AuthorizationBuildable, viewController: UIViewController) {
        self.profileBuilder = profileBuilder
        self.gameInfoBuilder = gameInfoBuilder
        self.friendsBuilder = friendsBuilder
        self.authorizationBuilder = authorizationBuilder
        
        uiViewController = viewController
        viewController.view.backgroundColor = .green
    }
    
    func routeToRootTabs() {
        if auth != nil {
            auth!.uiViewController.dismiss(animated: true) {
                let labViewController = self.makeTabViewController()
                labViewController.modalPresentationStyle = .overFullScreen
                self.uiViewController.show(labViewController, sender: nil)
            }
        }
    }
    
    func routeToAuth() {
        auth = authorizationBuilder.build(parentRouter: self)
        uiViewController.present(auth!.uiViewController, animated: false, completion: nil)
    }
    
    func lauch(from window: UIWindow) {
        window.rootViewController = uiViewController
    }
    
    private func makeTabViewController() -> UIViewController {
        let profile = profileBuilder.build()
        let gameInfo = gameInfoBuilder.build(dependancy: DataManagerBuilder().build())
        let friends = friendsBuilder.build()
        
        let viewController = UITabBarController()
        
        let profileVC = profile.getMasterViewController()
        let gameInfoVC = gameInfo.getMasterViewController()
        let friendsVC = friends.getMasterViewController()
        
        profileVC.tabBarItem = UITabBarItem(title: "Профиль", image: nil, selectedImage: nil)
        gameInfoVC.tabBarItem = UITabBarItem(title: "Статистика", image: nil, selectedImage: nil)
        friendsVC.tabBarItem = UITabBarItem(title: "Друзей", image: nil, selectedImage: nil)
        
        viewController.viewControllers = [profileVC, gameInfoVC, friendsVC]
        return viewController
    }
}
