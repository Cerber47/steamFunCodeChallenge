//
//  GameInfoBuilder.swift
//  FuncodechallengeApp
//
//  Created by Ванурин Алексей on 22.11.2019.
//  Copyright © 2019 Ванурин Алексей. All rights reserved.
//

import Foundation
import RealmSwift


protocol GameinfoBuildable {
    func build(dependancy: DataManager) -> GameinfoRouting
}

protocol GameInfoDataManagable {
    func getMatches() -> Results<MatchInfo>
}

class GameinfoBuilder: GameinfoBuildable {
    func build(dependancy: DataManager) -> GameinfoRouting {
        let component = GameInfoComponent(dataManager: dependancy)
        
        let presenter = GameinfoPresenter()
        let interactor = GameinfoInteractor(presenter: presenter, dependancy: component)
        presenter.listener = interactor
        
        let router = GameinfoRouter(interactor: interactor, viewController: presenter)
        
        return router
    }
}
