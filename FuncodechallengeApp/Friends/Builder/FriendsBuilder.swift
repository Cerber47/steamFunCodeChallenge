//
//  FriendsBuilder.swift
//  FuncodechallengeApp
//
//  Created by Ванурин Алексей on 22.11.2019.
//  Copyright © 2019 Ванурин Алексей. All rights reserved.
//

import Foundation


protocol FriendsBuildable {
    func build() -> FriendsRouter
}

class FriendsBuilder: FriendsBuildable {
    func build() -> FriendsRouter {
        let component = FriendsComponent()
        let presenter = FriendsPresenter()
        let interactor = FriendsInteractor(presenter: presenter, dependancy: component)
        presenter.listener = interactor
        
        let router = FriendsRouter(interactor: interactor, viewController: presenter)
    
        return router
    }
}
