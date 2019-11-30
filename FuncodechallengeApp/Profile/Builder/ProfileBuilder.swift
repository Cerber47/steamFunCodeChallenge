//
//  ProfileBuilder.swift
//  FuncodechallengeApp
//
//  Created by Ванурин Алексей on 22.11.2019.
//  Copyright © 2019 Ванурин Алексей. All rights reserved.
//

import Foundation


protocol ProfileBuildable {
    func build() -> ProfileRouting
}

class ProfileComponent: ProfileDependancy {
    var networkComponent: ProfileNetworkDependancy
    
    init() {
        self.networkComponent = NetworkManager()
    }
}

class ProfileBuilder: ProfileBuildable {
    func build() -> ProfileRouting {
        let presenter = ProfilePresenter()
        // TODO: - Fix this stub
        let interactor = ProfileInteractor(presenter: presenter, dependancy: ProfileComponent())
        
        presenter.listener = interactor
        interactor.presenter = presenter
        
        let router = ProfileRouter(interactor: interactor, viewController: presenter)
        
        return router
    }
    
    
}
