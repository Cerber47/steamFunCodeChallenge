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
        
        let config = Realm.Configuration(
        schemaVersion: 5,
        migrationBlock: { migration, oldSchemaVersion in
        if oldSchemaVersion < 5 {
            }}
        )
        Realm.Configuration.defaultConfiguration = config
        
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
            //for match in matches {
            for i in 0..<matches.count {
                if matches[i].id == newMatch.matchId {
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
        writeMatchesToDB(matches: matchToAdd)
    }
    
    func getMatches() -> Results<MatchInfo> {
        return realm.objects(MatchInfo.self)
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
                        self.writeMatchDetaisToRealm(details: details!)
                        self.writeIdToRealm(with: match.matchId)
                    }
                }
            }
        }
    }
    
    private func writeIdToRealm(with id: Int) {
        try! realm.write {
            let matchId = MatchId()
            matchId.id = id
            realm.add(matchId)
        }
    }
    
    private func writeMatchDetaisToRealm(details: Dota2MatchDetails) {
        let thisPlayerId = SteamApi.appUserStramIdShort
        let matchInfo = MatchInfo()
        
        matchInfo.id = details.matchId
        matchInfo.duration = details.duration
        matchInfo.direScore = details.direScore
        matchInfo.radiantScore = details.radiantScore
        matchInfo.timestamp = details.timeStamp
        
        matchInfo.radiantWin = details.radiantWin
        
        for player in details.players {
            if player.accountId == Int(thisPlayerId) {
                
                matchInfo.kills = player.kills
                matchInfo.assists = player.assists
                matchInfo.deaths = player.deaths
                matchInfo.id = player.heroId
                matchInfo.lastHits = player.lastHits
                matchInfo.level = player.level
                matchInfo.gpm = player.gpm
                matchInfo.xpm = player.xpm
                matchInfo.heroId = player.heroId
                matchInfo.slot = player.slot
                break
            }
        }
        try! realm.write {
            realm.add(matchInfo)
        }
    }
}
