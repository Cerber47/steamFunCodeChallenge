//
//  RootInteractor.swift
//  FuncodechallengeApp
//
//  Created by Ванурин Алексей on 26.11.2019.
//  Copyright © 2019 Ванурин Алексей. All rights reserved.
//

import Foundation


protocol RootPresentable {
}

protocol DataManagable {
}


class RootInteractor: RootPresenterListener, GameInfoInteractorListener {
    var presenter: RootPresentable
    var dataManager: DataManagable
    
    init(presenter: RootPresentable, dataManager: DataManagable) {
        self.presenter = presenter
        self.dataManager = dataManager
    }
}
