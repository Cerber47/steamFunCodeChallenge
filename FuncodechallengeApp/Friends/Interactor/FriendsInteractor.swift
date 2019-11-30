//
//  FriendsInteractor.swift
//  FuncodechallengeApp
//
//  Created by Ванурин Алексей on 22.11.2019.
//  Copyright © 2019 Ванурин Алексей. All rights reserved.
//

import Foundation


protocol FriendsNetworkDependancy {
    func getFriendsList(completion: @escaping([SteamFriend]?)->Void)
}

protocol FriendsPresentable: class {
    var friends: [SteamFriend]? {get set}
}


class FriendsInteractor: FriendsPresenterListener {
    
    weak var presenter: FriendsPresentable?
    var dependancy: FriendsDependancy
    
    init(presenter: FriendsPresenter, dependancy: FriendsDependancy) {
        self.presenter = presenter
        self.dependancy = dependancy
    }
    
    func viewIsReadyToPresentData() {
        dependancy.networkComponent.getFriendsList() { friends in
            if friends != nil {
                self.presenter?.friends = friends!
            }
        }
    }
}
