//
//  RootRouter.swift
//  FuncodechallengeApp
//
//  Created by Ванурин Алексей on 26.11.2019.
//  Copyright © 2019 Ванурин Алексей. All rights reserved.
//

import Foundation
import UIKit


protocol RootRouting {
    func routeToRootTabs()
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
    }
    
    func routeToRootTabs() {
        if auth != nil {
            auth!.uiViewController.dismiss(animated: true)
        }
        let profile = profileBuilder.build()
        let gameInfo = gameInfoBuilder.build()
        let friends = friendsBuilder.build()
        
        let viewController = UITabBarController()
        
        viewController.viewControllers = [profile.getMasterViewController(), gameInfo.getMasterViewController(), friends.getMasterViewController()]
        
        uiViewController = viewController
        tabController = viewController
    }
    
    func routeToAuth() {
        auth = authorizationBuilder.build()
        uiViewController.present(auth!.uiViewController, animated: true, completion: nil)
    }
}
