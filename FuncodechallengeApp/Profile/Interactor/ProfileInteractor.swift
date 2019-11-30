//
//  ProfileInteractor.swift
//  FuncodechallengeApp
//
//  Created by Ванурин Алексей on 22.11.2019.
//  Copyright © 2019 Ванурин Алексей. All rights reserved.
//

import Foundation
import UIKit


protocol ProfilePresentable: class {
    var steamProfile: SteamUserProfile? {get set}
    var ownedGames: [SteamOwnedGame] {get set}
    var recentyPlayedGames: [SteamRecentlyGame] {get set}
}

protocol ProfileNetworkDependancy {
    func getOwnedGames(completion: @escaping ([SteamOwnedGame]?) -> Void)
    func getNickName(completion: @escaping(SteamUserProfile?)-> Void)
    func getFriendsList()
    func pullRecentlyPlayedGames(of steamId: String, completion: @escaping([SteamRecentlyGame]?)->Void)
}


final class ProfileInteractor: ProfilePresenterListener, ProfileInteractable {
    weak var presenter: ProfilePresentable!
    var dependancy: ProfileDependancy!
    
    func viewIsReadyToPresentData() {
        loadOwnedGames()
        loadRecentlyPlayed()
        loadSummary()
    }
    
    func updateViewData() {
    }
    
    init(presenter: ProfilePresentable, dependancy: ProfileDependancy) {
        self.presenter = presenter
        self.dependancy = dependancy
    }
    
    // MARK: -Private
    
    private func loadOwnedGames() {
        dependancy.networkComponent.getOwnedGames() { games in
            if games != nil {
                var sortedGames = games!
                sortedGames.sort(by: {$0.playtime > $1.playtime})
                self.presenter.ownedGames = sortedGames
            }
        }
    }
    
    private func loadRecentlyPlayed() {
        dependancy.networkComponent.pullRecentlyPlayedGames(of: "<???>") { games in
            if games != nil {
                self.presenter.recentyPlayedGames = games!
            }
            // TODO: -Make error handling
        }
    }
    
    private func loadSummary() {
        dependancy.networkComponent.getNickName() { profile in
            if profile != nil {
                self.presenter.steamProfile = profile
            } else {
                print("Error")
            }
        }
    }
}
