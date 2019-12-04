//
//  GameinfoInteractor.swift
//  FuncodechallengeApp
//
//  Created by Ванурин Алексей on 22.11.2019.
//  Copyright © 2019 Ванурин Алексей. All rights reserved.
//

import Foundation
import UIKit


protocol GameInfoInteractorListener {
}

class GameInfoComponent {
    
    var dataManager: DataManager
    
    // TODO - Make as protocol
    
    init(dataManager: DataManager) {
        self.dataManager = dataManager
    }
}

class GameinfoInteractor: GameinfoPresenterListener {
    
    var presenter: GameinfoPresenter
    var dependancy: GameInfoComponent
    
    // TODO - make as protocol
    
    init(presenter: GameinfoPresenter, dependancy: GameInfoComponent) {
        self.presenter = presenter
        self.dependancy = dependancy
        updateInformation()
    }
    
    func updateInformation() {
        dependancy.dataManager.updateRealmMatches()
        let matches = dependancy.dataManager.getMatches()
        presenter.setMathces(matches: ChartMatchInfo.array(from: matches))
    }
}
