//
//  DataManagerBuilder.swift
//  FuncodechallengeApp
//
//  Created by Ванурин Алексей on 02.12.2019.
//  Copyright © 2019 Ванурин Алексей. All rights reserved.
//

import Foundation


class DataManagerBuilder {
    func build() -> DataManager {
        let network = NetworkManager()
        
        let dataManager = DataManager(component: network)
        
        return dataManager
    }
}
