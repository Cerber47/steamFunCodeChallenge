//
//  GameinfoPresenter.swift
//  FuncodechallengeApp
//
//  Created by Ванурин Алексей on 22.11.2019.
//  Copyright © 2019 Ванурин Алексей. All rights reserved.
//

import Foundation
import UIKit
import Charts


struct ChartMatchInfo {
    var timestamp: Int
    var isWon: Bool
    var kills: Int
    var deaths: Int
    var kda: Float
    var gpm: Int
}


protocol GameinfoPresenterListener {
}


class GameinfoPresenter: UIViewController {
    var matches: [MatchInfo]!
    var listener: GameinfoPresenterListener?
    
    override func viewDidLoad() {
        let chartView = LineChartView()
        print("Presented!")
        
        view.addSubview(chartView)
        chartView.autoPinEdge(toSuperviewEdge: .top, withInset: 30.0)
        chartView.autoPinEdge(toSuperviewEdge: .left, withInset: 5.0)
        chartView.autoPinEdge(toSuperviewEdge: .right, withInset: 5.0)
    }
    
    func setMathces(matches: [MatchInfo]) {
        self.matches = matches
    }
    
    func loadData() {
        
    }
}
