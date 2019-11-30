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
    func build() -> AuthorizationRouting
}

class AuthorizationBuilder: AuthorizationBuildable {
    func build() -> AuthorizationRouting {
        let presenter = AuthorizationPresenter()
        let interactor = AuthorizationInteractor(presenter: presenter)
        presenter.listener = interactor
        
        let router = AuthorizationRouter(viewController: UIViewController())
        
        return router
    }
}
