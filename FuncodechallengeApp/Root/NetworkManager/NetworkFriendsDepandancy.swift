//
//  NetworkFriendsDepandancy.swift
//  FuncodechallengeApp
//
//  Created by Ванурин Алексей on 25.11.2019.
//  Copyright © 2019 Ванурин Алексей. All rights reserved.
//

import Foundation
import SwiftyJSON

fileprivate let baseUrl = "https://api.steampowered.com/"
fileprivate let Appkey = "9CA297FA685F9CDAAC9CED27BE1D837C"
fileprivate let testSteamId = "76561197988574396"

struct SteamFriend {
    var steamid: Int
    var name: String
    var avatar: String
}

extension NetworkManager: FriendsNetworkDependancy {
    func getFriendsList(completion: @escaping([SteamFriend]?)->Void) {
        let url = "\(SteamApi.baseUrl)ISteamUser/GetFriendList/v1/"
        let parameters = [
            "key": Appkey,
            "steamid": SteamApi.appUserSteamId
            ]
        makeRequest(url: url, method: .get, parameters: parameters) { data in
            if data != nil {
                if let ids = self.parseFriendsIds(data: data!) {
                    self.getPlayers(with: ids) { players in
                        completion(players)
                    }
                }
            }
        }
    }
    
    private func parseFriendsIds(data: Data) -> [Int]? {
        if let json = try? JSON(data: data) {
            var steamids: [Int] = []
            for friend in json["friendslist"]["friends"].arrayValue {
                steamids.append(friend["steamid"].intValue)
            }
            return steamids
        } else {return nil}
    }
    
    private func getPlayers(with ids: [Int], completion: @escaping([SteamFriend]?)-> Void) {
        let url = "\(SteamApi.baseUrl)ISteamUser/GetPlayerSummaries/v0002/"
        var steamids = ""
        for id in ids {
            steamids = steamids + "," + String(id)
        }
        let params = [
            "key":Appkey,
            "steamids": steamids
            ]
        makeRequest(url: url, method: .get, parameters: params) { data in
            if data != nil {
                completion(self.parseFriendsList(data: data!))
            }
        }
    }
    
    private func parseFriendsList(data: Data) -> [SteamFriend]? {
        if let json = try? JSON(data: data) {
            var friends: [SteamFriend] = []
            for friend in json["response"]["players"].arrayValue {
                let name = friend["personaname"].stringValue
                let steamid = friend["steamid"].intValue
                let avatarUrl = friend["avatar"].stringValue
                
                friends.append(SteamFriend(steamid: steamid, name: name, avatar: avatarUrl))
            }
            return friends
        } else {return nil}
    }
}
