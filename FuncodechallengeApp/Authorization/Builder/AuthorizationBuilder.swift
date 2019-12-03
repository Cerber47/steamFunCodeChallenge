//
//  AuthorizationBuilder.swift
//  FuncodechallengeApp
//
//  Created by Ванурин Алексей on 26.11.2019.
//  Copyright © 2019 Ванурин Алексей. All rights reserved.
//

import Foundation
import UIKit

protocol AuthorizationBuildable {
    func build(parentRouter: RootRouting) -> AuthorizationRouting
}

class AuthorizationBuilder: AuthorizationBuildable {
    func build(parentRouter: RootRouting) -> AuthorizationRouting {
        let presenter = AuthorizationPresenter()
        
        let router = AuthorizationRouter(rootRouter: parentRouter, viewController: presenter)
        
        let interactor = AuthorizationInteractor(presenter: presenter, router: router)
        presenter.listener = interactor
        
        return router
    }
}
