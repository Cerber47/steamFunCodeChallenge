//
//  AuthorizationInteractor.swift
//  FuncodechallengeApp
//
//  Created by Ванурин Алексей on 26.11.2019.
//  Copyright © 2019 Ванурин Алексей. All rights reserved.
//

import Foundation


protocol AuthorizationPresentable: class {
}


protocol AuthorizationInteractorListener {
}

class AuthorizationInteractor: AuthorizationPresenterListener {
    weak var presenter: AuthorizationPresentable?
    var router: AuthorizationRouting
    
    init(presenter: AuthorizationPresentable, router: AuthorizationRouter) {
        self.presenter = presenter
        self.router = router
    }
    
    func authCompleted() {
        router.routeToTabs()
    }
}
