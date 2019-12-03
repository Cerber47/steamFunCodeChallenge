//
//  Dota2Match.swift
//  FuncodechallengeApp
//
//  Created by Ванурин Алексей on 26.11.2019.
//  Copyright © 2019 Ванурин Алексей. All rights reserved.
//

import Foundation
import RealmSwift

class MatchId: Object {
    @objc dynamic var id = 0
}


class MatchInfo: Object {
    @objc dynamic var id = 0
    @objc dynamic var timestamp = 0
    @objc dynamic var radiantWin = true
    @objc dynamic var duration = 0
    @objc dynamic var radiantScore = 0
    @objc dynamic var direScore = 0
    
    @objc dynamic var heroId = 0
    
    @objc dynamic var kills = 0
    @objc dynamic var deaths = 0
    @objc dynamic var assists = 0
    
    @objc dynamic var lastHits = 0
    @objc dynamic var gpm = 0
    @objc dynamic var xpm = 0
    
    @objc dynamic var level = 0
    
    //dynamic var players = List<MatchInfoPlayer>()
}


class MatchInfoPlayer: Object {
    @objc dynamic var id = 0
    @objc dynamic var heroId = 0
    
    @objc dynamic var kills = 0
    @objc dynamic var deaths = 0
    @objc dynamic var assists = 0
    
    @objc dynamic var lastHits = 0
    @objc dynamic var gpm = 0
    @objc dynamic var xpm = 0
    
    @objc dynamic var level = 0
}
