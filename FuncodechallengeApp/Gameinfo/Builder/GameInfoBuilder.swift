//
//  GameInfoBuilder.swift
//  FuncodechallengeApp
//
//  Created by Ванурин Алексей on 22.11.2019.
//  Copyright © 2019 Ванурин Алексей. All rights reserved.
//

import Foundation


protocol GameinfoBuildable {
    func build() -> GameinfoRouting
}

protocol GameInfoDataManagable {
}

class GameinfoBuilder: GameinfoBuildable {
    func build() -> GameinfoRouting {
        let interactor = GameinfoInteractor()
        let presenter = GameinfoPresenter()
        
        let router = GameinfoRouter(interactor: interactor, viewController: presenter)
        
        return router
    }
}
