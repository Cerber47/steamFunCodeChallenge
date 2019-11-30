//
//  FriendsRouter.swift
//  FuncodechallengeApp
//
//  Created by Ванурин Алексей on 22.11.2019.
//  Copyright © 2019 Ванурин Алексей. All rights reserved.
//

import Foundation
import UIKit


protocol FriendsRouting {
    func getMasterViewController() -> UIViewController
}

protocol FriendsDependancy {
    var networkComponent: FriendsNetworkDependancy {get}
}

class FriendsComponent: FriendsDependancy {
    var networkComponent: FriendsNetworkDependancy
    
    init() {
        // TODO: make it not here
        networkComponent = NetworkManager()
    }
}

class FriendsRouter: FriendsRouting {
    var uiViewController: UIViewController
    var interactor: FriendsInteractor
    
    init(interactor: FriendsInteractor, viewController: UIViewController) {
        self.interactor = interactor
        self.uiViewController = viewController
    }
    
    func getMasterViewController() -> UIViewController {
        let navigationController = UINavigationController(rootViewController: uiViewController)
        
        return navigationController
    }
}
