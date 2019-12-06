//
//  NetworkDota2Dependancy.swift
//  FuncodechallengeApp
//
//  Created by Ванурин Алексей on 26.11.2019.
//  Copyright © 2019 Ванурин Алексей. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Dota2Match {
    var matchId: Int
    var startTime: Int
    var players: [Dota2MatchPlayer]
}

struct Dota2MatchPlayer {
    var accountId: Int
    var playerSlot: Int
    var heroId: Int
}

struct Dota2MatchDetails {
    var players: [Dota2MatchDetailsPlayer]
    var radiantWin: Bool
    var duration: Int
    var timeStamp: Int
    var matchId: Int
    var radiantScore: Int
    var direScore: Int
}

struct Dota2MatchDetailsPlayer {
    var accountId: Int
    var heroId: Int
    var kills: Int
    var deaths: Int
    var assists: Int
    var lastHits: Int
    var denies: Int
    var gpm: Int
    var xpm: Int
    var level: Int
    var slot: Int
}

fileprivate let base_url = "https://api.steampowered.com/"
fileprivate let Appkey = "9CA297FA685F9CDAAC9CED27BE1D837C"
fileprivate let testSteamId = "76561197988574396"


extension NetworkManager: RealmNetworkDependancy {
    func getProfileInfo(completion: @escaping([Dota2Match]?)->Void) {
        let url = "\(base_url)IDOTA2Match_570/GetMatchHistory/V001/"
        let params = [
            "key": Appkey,
            "account_id": SteamApi.appUserSteamId
        ]
        makeRequest(url: url, method: .get, parameters: params) { data in
            if data != nil {
                let matches = self.parseMatches(data: data!)
                completion(matches)
            }
        }
    }
    
    private func parseMatches(data: Data) -> [Dota2Match]? {
        if let json = try? JSON(data: data) {
            var matches: [Dota2Match] = []
            for match in json["result"]["matches"].arrayValue {
                let matchId = match["match_id"].intValue
                let startTime = match["start_time"].intValue
                var players: [Dota2MatchPlayer] = []
                for player in match["players"].arrayValue {
                    let playerId = player["account_id"].intValue
                    let slot = player["player_slot"].intValue
                    let hero = player["hero_id"].intValue
                    players.append(Dota2MatchPlayer(accountId: playerId, playerSlot: slot, heroId: hero))
                }
                matches.append(Dota2Match(matchId: matchId, startTime: startTime, players: players))
            }
            return matches
        } else { return nil }
    }
    
    func getMatchDetails(of matchId: String, completion: @escaping(Dota2MatchDetails?)->Void) {
        let url = "\(base_url)IDOTA2Match_570/GetMatchDetails/v1/"
        let params = [
            "key": Appkey,
            "match_id": matchId
        ]
        
        makeRequest(url: url, method: .get, parameters: params) { data in
            if data == nil {
                completion(nil)
            } else {
                let match = self.parseMatchDetails(data: data!)
                completion(match)
            }
        }
    }
    
    func parseMatchDetails(data: Data) -> Dota2MatchDetails? {
        if let json = try? JSON(data: data) {
            let radiantWin = json["result"]["radiant_win"].boolValue
            let timeStamp = json["result"]["start_time"].intValue
            let duration = json["result"]["duration"].intValue
            let matchId = json["result"]["match_id"].intValue
            let radiantScore = json["result"]["radiant_score"].intValue
            let direScore = json["result"]["dire_score"].intValue
            
            var players: [Dota2MatchDetailsPlayer] = []
            
            for player in json["result"]["players"].arrayValue {
                let accountId = player["account_id"].intValue
                let heroId = player["hero_id"].intValue
                let kills = player["kills"].intValue
                let deaths = player["deaths"].intValue
                let assists = player["assists"].intValue
                let lastHits = player["last_hits"].intValue
                let denies = player["denies"].intValue
                let gpm = player["gold_per_min"].intValue
                let xpm = player["xp_per_min"].intValue
                let level = player["level"].intValue
                let slot = player["player_slot"].intValue
                
                players.append(Dota2MatchDetailsPlayer(accountId: accountId, heroId: heroId, kills: kills, deaths: deaths, assists: assists, lastHits: lastHits, denies: denies, gpm: gpm, xpm: xpm, level: level, slot: slot))
            }
            return Dota2MatchDetails(players: players, radiantWin: radiantWin, duration: duration, timeStamp: timeStamp, matchId: matchId, radiantScore: radiantScore, direScore: direScore)
        } else {
            return nil
        }
    }
}
