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
    dynamic var id = 0
}


class MatchInfo: Object {
    dynamic var id = 0
    dynamic var timestamp = 0
    dynamic var radiantWin = true
    dynamic var duration = 0
    dynamic var radiantScore = 0
    dynamic var direScore = 0
    
    dynamic var players = List<MatchInfoPlayer>()
}


class MatchInfoPlayer: Object {
    dynamic var id = 0
    dynamic var heroId = 0
    
    dynamic var kills = 0
    dynamic var deaths = 0
    dynamic var assists = 0
    
    dynamic var lastHits = 0
    dynamic var gpm = 0
    dynamic var xpm = 0
    
    dynamic var level = 0
}
