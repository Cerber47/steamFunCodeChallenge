//
//  ProfileRouter.swift
//  FuncodechallengeApp
//
//  Created by Ванурин Алексей on 22.11.2019.
//  Copyright © 2019 Ванурин Алексей. All rights reserved.
//

import Foundation
import UIKit


protocol ProfileRouting {
    func getMasterViewController() -> UIViewController
}

protocol ProfileInteractable {
}

protocol ProfileDependancy {
    var networkComponent: ProfileNetworkDependancy { get }
}


class ProfileRouter: ProfileRouting {
    var uiViewController: UIViewController!
    
    var interactor: ProfileInteractable
    
    init(interactor: ProfileInteractable, viewController: UIViewController) {
        self.interactor = interactor
        self.uiViewController = viewController
    }
    
    func getMasterViewController() -> UIViewController {
        let navigationViewController = UINavigationController(rootViewController: self.uiViewController)
        
        return navigationViewController
    }
}
