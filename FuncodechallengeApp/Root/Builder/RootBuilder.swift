//
//  RootBuilder.swift
//  FuncodechallengeApp
//
//  Created by Ванурин Алексей on 26.11.2019.
//  Copyright © 2019 Ванурин Алексей. All rights reserved.
//

import Foundation
import UIKit


protocol RootBuildable {
    func build() -> RootRouting
}

class RootBuilder: RootBuildable {
    func build() -> RootRouting {
        let component = NetworkManager()
        let dataManager = DataManager(component: component)
        
        
        let presenter = RootPresenter()
        let interactor = RootInteractor(presenter: presenter, dataManager: dataManager)
        
        presenter.listener = interactor
        
        let profileBuilder = ProfileBuilder()
        let gameInfoBuilder = GameinfoBuilder()
        let friendsBuilder = FriendsBuilder()
        let authorizationBuilder = AuthorizationBuilder()
        
        let router = RootRouter(profileBuilder: profileBuilder, gameInfoBuilder: gameInfoBuilder, friendsBuilder: friendsBuilder, authorizationBuilder: authorizationBuilder, viewController: UIViewController())
        
        return router
    }
    
}
