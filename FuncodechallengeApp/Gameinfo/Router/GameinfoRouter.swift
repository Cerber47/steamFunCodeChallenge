//
//  GameinfoRouter.swift
//  FuncodechallengeApp
//
//  Created by Ванурин Алексей on 22.11.2019.
//  Copyright © 2019 Ванурин Алексей. All rights reserved.
//

import Foundation
import UIKit


protocol GameinfoRouting {
    func getMasterViewController() -> UIViewController
}

class GameinfoRouter: GameinfoRouting {
    var uiViewController: UIViewController
    var interactor: GameinfoInteractor
    
    init(interactor: GameinfoInteractor, viewController: UIViewController) {
        self.uiViewController = viewController
        self.interactor = interactor
    }
    
    func getMasterViewController() -> UIViewController {
        return self.uiViewController
    }
}
