//
//  AuthorizationRouter.swift
//  FuncodechallengeApp
//
//  Created by Ванурин Алексей on 26.11.2019.
//  Copyright © 2019 Ванурин Алексей. All rights reserved.
//

import Foundation
import UIKit


protocol AuthorizationRouting {
    var uiViewController: UIViewController {get set}
    func routeToTabs()
}

class AuthorizationRouter: AuthorizationRouting {
    var uiViewController: UIViewController
    var rootRouter: RootRouting
    
    init(rootRouter: RootRouting, viewController: UIViewController) {
        uiViewController = viewController
        self.rootRouter = rootRouter
    }
    
    func routeToTabs() {
        rootRouter.routeToRootTabs()
    }
}
