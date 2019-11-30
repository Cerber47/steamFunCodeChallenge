//
//  DataManager.swift
//  FuncodechallengeApp
//
//  Created by Ванурин Алексей on 26.11.2019.
//  Copyright © 2019 Ванурин Алексей. All rights reserved.
//

import Foundation
import RealmSwift

protocol RealmHandler {
    func addMathces(newMatches: [Dota2Match])
}

protocol RealmNetworkDependancy {
    func getMatchDetails(of matchId: String, completion: @escaping(Dota2MatchDetails?)->Void)
    func getProfileInfo(completion: @escaping([Dota2Match]?)->Void)
}

class DataManager: DataManagable {
    
    var realm: Realm
    var networkComponent: RealmNetworkDependancy
    
    init(component: RealmNetworkDependancy) {
        realm = try! Realm()
        
        networkComponent = component
        
    }
    
    func updateRealmMatches() {
        networkComponent.getProfileInfo() { matches in
            if matches != nil {
                self.addMathces(newMatches: matches!)
            }
        }
    }
    
    func addMathces(newMatches: [Dota2Match]) {
        let matches = getMatchesFromRealm()
        var matchToAdd: [Dota2Match] = []
        for newMatch in newMatches {
            var foundFlag = false
            for match in matches {
                if match.id == newMatch.matchId {
                    foundFlag = true
                    break
                }
            }
            if foundFlag {
                continue
            } else {
                matchToAdd.append(newMatch)
            }
        }
    }
    
    private func getMatchesFromRealm() -> Results<MatchId> {
        return realm.objects(MatchId.self)
    }
    
    private func writeMatchesToDB(matches: [Dota2Match]) {
        let loadingQueue = DispatchQueue.global(qos: .utility)
        for match in matches {
            loadingQueue.sync {
                networkComponent.getMatchDetails(of: String(match.matchId)) { details in
                    if details != nil {
                        self.writeIdToRealm(with: match.matchId)
                    }
                }
            }
        }
    }
    
    private func writeIdToRealm(with id: Int) {
        realm.add(MatchId(value: [id]))
    }
    
    private func writeMatchDetaisToRealm(details: Dota2MatchDetails) {
        let matchInfo = MatchInfo()
        matchInfo.id = details.matchId
        matchInfo.duration = details.duration
        matchInfo.direScore = details.direScore
        matchInfo.radiantScore = details.radiantScore
        matchInfo.timestamp = details.timeStamp
        matchInfo.radiantWin = details.radiantWin
        
        var playersList: List<MatchInfoPlayer> = List<MatchInfoPlayer>()
        
        for player in details.players {
            var newPlayer = MatchInfoPlayer()
            newPlayer.kills = player.kills
            newPlayer.assists = player.assists
            newPlayer.deaths = player.deaths
            newPlayer.id = player.heroId
            newPlayer.lastHits = player.lastHits
            newPlayer.level = player.level
            newPlayer.gpm = player.gpm
            newPlayer.xpm = player.xpm
            newPlayer.heroId = player.heroId
            playersList.append(newPlayer)
        }
        matchInfo.players = playersList
        
        realm.add(matchInfo)
    }
}
