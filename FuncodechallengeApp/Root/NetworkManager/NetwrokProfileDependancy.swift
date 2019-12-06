//
//  NetwrokProfileDependancy.swift
//  FuncodechallengeApp
//
//  Created by Ванурин Алексей on 22.11.2019.
//  Copyright © 2019 Ванурин Алексей. All rights reserved.
//

import Foundation
import SwiftyJSON


fileprivate let baseUrl = "https://api.steampowered.com/"
fileprivate let Appkey = "9CA297FA685F9CDAAC9CED27BE1D837C"
fileprivate let testSteamId = "76561197988574396"

struct SteamOwnedGame {
    var appid: Int
    var name: String
    var playtime: Int
    var iconUrl: String
    var imgUrl: String
    
    func getPlayTimeAsString() -> String {
        return String(playtime/60) + " часов"
    }
    
    func getStaticUrlForIcon() -> URL {
        let urlString = "http://media.steampowered.com/steamcommunity/public/images/apps/\(appid)/\(iconUrl).jpg"
        return URL(string: urlString)!
    }
}

struct SteamRecentlyGame {
    var appid: Int
    var name: String
}

struct SteamUserProfile {
    var name: String
    var avararUrl: String
}


extension NetworkManager: ProfileNetworkDependancy {
    func getOwnedGames(completion: @escaping ([SteamOwnedGame]?)->Void) {
        // TODO: -Make use of steamId
        pullGameList(of: "<???>") { games in
            if games != nil {
                completion(games)
            } else {
                completion(nil)
            }
        }
    }
    
    func pullGameList(of steamId: String, completion: @escaping(([SteamOwnedGame]?) -> Void)) {
        let url = "\(SteamApi.baseUrl)IPlayerService/GetOwnedGames/v0001/"
        let paramAsString = "?key=\(Appkey)&include_played_free_games=1&include_appinfo=1&format=json&steamid=\(SteamApi.appUserSteamId)"
        print(SteamApi.appUserSteamId)
        makeRequest(url: url+paramAsString, method: .get, parameters: [:]) { data in
            if data == nil {
                completion(nil)
            } else {
                if let games = self.parseGameList(data: data!) {
                    completion(games)
                } else {completion(nil)}}
        }
    }
    
    private func parseGameList(data: Data) -> [SteamOwnedGame]? {
        if let json = try? JSON(data: data) {
            var games:[SteamOwnedGame] = []
            for game in json["response"]["games"].arrayValue {
                let appid = game["appid"].intValue
                let playtime = game["playtime_forever"].intValue
                let name = game["name"].stringValue
                let imgIcon = game["img_icon_url"].stringValue
                let imgLogo = game["img_logo_url"].stringValue
                let newGame = SteamOwnedGame(appid: appid, name: name, playtime: playtime, iconUrl: imgIcon, imgUrl: imgLogo)
                games.append(newGame)
            }
            return games
        } else {
            // TODO: - Make handling this in a right way
            fatalError("Problem with parsing data")
        }
    }

    func pullRecentlyPlayedGames(of steamId: String, completion: @escaping([SteamRecentlyGame]?)->Void) {
        let url = "\(SteamApi.baseUrl)IPlayerService/GetRecentlyPlayedGames/v1/"
        let params = [
            "key": Appkey,
            "steamid": SteamApi.appUserSteamId,
            "count": 3
            ] as [String : Any]
        makeRequest(url: url, method: .get, parameters: params) { data in
            if data != nil {
            if let games = self.parseRecentlyPlayedGems(data: data!) {
                print(games)
                completion(games)
            } else {
                completion(nil)
            }
            } else {completion(nil)}
        }
    }
    
    private func parseRecentlyPlayedGems(data: Data) -> [SteamRecentlyGame]? {
        if let json = try? JSON(data: data) {
            let totalCount = json["response"]["total_count"].intValue
            if totalCount == 0 {
                return []
            }
            return []
        } else {
        return nil
        }
    }
    
    func getNickName(completion: @escaping(SteamUserProfile?)-> Void) {
        let url = "\(SteamApi.baseUrl)ISteamUser/GetPlayerSummaries/v0002/"
        let params = [
            "key":Appkey,
            "steamids": SteamApi.appUserSteamId
        ]
        makeRequest(url: url, method: .get, parameters: params) { data in
            if data != nil {
                completion(self.parsePlayerProfile(data: data!))
            }
        }
    }
    
    func parsePlayerProfile(data: Data) -> SteamUserProfile? {
        if let json = try? JSON(data: data) {
            let player = json["response"]["players"][0]
            
            let avatar = player["avatar"].stringValue
            let name = player["personaname"].stringValue
            
            return SteamUserProfile(name: name, avararUrl: avatar)
        } else {
            return nil
        }
    }
    
    func getFriendsList() {
        // TODO
    }
    
    
}
