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
import RealmSwift

struct ChartMatchInfo {
    var timestamp: Int
    var isWon: Bool
    var kills: Int
    var deaths: Int
    var kda: Float
    var gpm: Int
    var xpm: Int
    
    static func array(from matches: Results<MatchInfo>) -> [ChartMatchInfo] {
        var newArrays: [ChartMatchInfo] = []
        for match in matches {
            var isWon = false
            if match.slot < 64  {
                if match.radiantWin {
                    isWon = true
                }
            } else {
                if !match.radiantWin {
                    isWon = true
                }
            }
            
            let timestamp = match.timestamp
            let kills = match.kills
            let deaths = match.deaths
            var kda: Float = Float(match.kills + match.assists)
            if match.deaths != 0 {
                kda = kda / Float(match.deaths)
            }
            let gpm = match.gpm
            let xpm = match.xpm
            let newMatch = ChartMatchInfo(timestamp: timestamp, isWon: isWon, kills: kills, deaths: deaths, kda: kda, gpm: gpm, xpm: xpm)
            
            newArrays.append(newMatch)
        }
        return newArrays
    }
}

enum chartGoldMode {
    case gpm
    case xpm
    case disabled
}

enum chartKillMode {
    case kills
    case kda
    case disabled
}


protocol GameinfoPresenterListener {
}


class GameinfoPresenter: UIViewController {
    var matches: [ChartMatchInfo]!
    var listener: GameinfoPresenterListener?
    var chartView: LineChartView!
    
    var leftPivot: Int = 0
    var rightPivot: Int = 10
    
    var currentGoldMode: chartGoldMode = .gpm
    var currentKillsMode: chartKillMode = .kills
    
    override func viewDidLoad() {
        view.backgroundColor = .black
        chartView = LineChartView()
        
        view.addSubview(chartView)
        chartView.autoPinEdge(toSuperviewEdge: .top, withInset: 100.0)
        chartView.autoPinEdge(toSuperviewEdge: .left, withInset: 30.0)
        chartView.autoPinEdge(toSuperviewEdge: .right, withInset: 30.0)
        //chartView.autoPinEdge(toSuperviewEdge: .bottom)
        
        let backButton = UIButton()
        backButton.setTitle("Вперед", for: .normal)
        backButton.setTitleColor(.white, for: .normal)
        backButton.tintColor = .blue
        
        backButton.addTarget(self, action: #selector(stepUp), for: .touchUpInside)
        
        view.addSubview(backButton)
        backButton.autoPinEdge(toSuperviewEdge: .left, withInset: 15.0)
        backButton.autoPinEdge(.top, to: .bottom, of: chartView, withOffset: 20.0)
        
        let rightButton = UIButton()
        rightButton.setTitle("Назад", for: .normal)
        rightButton.setTitleColor(.white, for: .normal)
        
        rightButton.addTarget(self, action: #selector(stepDown), for: .touchUpInside)
        
        view.addSubview(rightButton)
        rightButton.autoPinEdge(toSuperviewEdge: .right, withInset: 15.0)
        rightButton.autoPinEdge(.top, to: .bottom, of: chartView, withOffset: 20.0)
        
        backButton.autoPinEdge(toSuperviewEdge: .bottom, withInset: 200.0)
        rightButton.autoPinEdge(toSuperviewEdge: .bottom, withInset: 200.0)
        
        let goldSwitcher = UIStackView()
        goldSwitcher.axis = .horizontal
        goldSwitcher.alignment = .fill
        goldSwitcher.distribution = .fillEqually
        
        let goldGPMButton = UIButton()
        goldGPMButton.setTitle("GPM", for: .normal)
        goldGPMButton.setTitleColor(.red, for: .normal)
        goldGPMButton.addTarget(self, action: #selector(switchToGpm), for: .touchUpInside)
        
        let goldNetworthButton = UIButton()
        goldNetworthButton.setTitle("Networth", for: .normal)
        goldNetworthButton.setTitleColor(.red, for: .normal)
        goldNetworthButton.addTarget(self, action: #selector(switchToXpm), for: .touchUpInside)
        
        let goldDisableButton = UIButton()
        goldDisableButton.setTitle("Выключить", for: .normal)
        goldDisableButton.setTitleColor(.red, for: .normal)
        goldDisableButton.addTarget(self, action: #selector(switchGoldDisable), for: .touchUpInside)
        
        goldSwitcher.addArrangedSubview(goldGPMButton)
        goldSwitcher.addArrangedSubview(goldNetworthButton)
        goldSwitcher.addArrangedSubview(goldDisableButton)
        
        view.addSubview(goldSwitcher)
        goldSwitcher.autoPinEdge(.top, to: .bottom, of: chartView, withOffset: 50.0)
        goldSwitcher.autoPinEdge(toSuperviewEdge: .left, withInset: 30.0)
        goldSwitcher.autoPinEdge(toSuperviewEdge: .right, withInset: 30.0)
        
        let killsSwitcher = UIStackView()
        killsSwitcher.axis = .horizontal
        killsSwitcher.alignment = .fill
        killsSwitcher.distribution = .fillEqually
        
        let killsButton = UIButton()
        killsButton.setTitle("Kills", for: .normal)
        killsButton.setTitleColor(.red, for: .normal)
        killsButton.addTarget(self, action: #selector(switchToKills), for: .touchUpInside)
        
        let kdaButton = UIButton()
        kdaButton.setTitle("KDA", for: .normal)
        kdaButton.setTitleColor(.red, for: .normal)
        kdaButton.addTarget(self, action: #selector(switchToKda), for: .touchUpInside)
        
        let disableKillsButton = UIButton()
        disableKillsButton.setTitle("Выключить", for: .normal)
        disableKillsButton.setTitleColor(.red, for: .normal)
        disableKillsButton.addTarget(self, action: #selector(disableKills), for: .touchUpInside)
        
        killsSwitcher.addArrangedSubview(killsButton)
        killsSwitcher.addArrangedSubview(kdaButton)
        killsSwitcher.addArrangedSubview(disableKillsButton)
        
        view.addSubview(killsSwitcher)
        killsSwitcher.autoPinEdge(.top, to: .bottom, of: goldSwitcher)
        killsSwitcher.autoPinEdge(toSuperviewEdge: .left, withInset: 30.0)
        killsSwitcher.autoPinEdge(toSuperviewEdge: .right, withInset: 30.0)
        
        updateValues()
    }
    
    func setMathces(matches: [ChartMatchInfo]) {
        self.matches = matches
    }
    
    func loadData() {
        
    }
    
    // MARK: -Private
    
    @objc private func stepUp() {
        if leftPivot > 0 {
            leftPivot -= 1
            rightPivot -= 1
            updateValues()
        }
    }
    
    @objc private func stepDown() {
        if rightPivot < matches.count - 1 {
            rightPivot += 1
            leftPivot += 1
            updateValues()
        }
    }
    
    @objc private func updateValues() {
        var data = LineChartData()
        if let gpmLine = makeGpmData(from: leftPivot, to: rightPivot, with: currentGoldMode) {
            data.addDataSet(gpmLine)
        }
        if let killsLine = makeKillsData(from: leftPivot, to: rightPivot, with: currentKillsMode) {
            data.addDataSet(killsLine)
        }
        chartView.data = data
    }
    
    @objc private func switchToGpm() {
        currentGoldMode = .gpm
        updateValues()
    }
    
    @objc private func switchToXpm() {
        currentGoldMode = .xpm
        updateValues()
    }
    
    @objc private func switchGoldDisable() {
        currentGoldMode = .disabled
        updateValues()
    }
    
    private func makeGpmData(from: Int, to: Int, with mode: chartGoldMode) -> LineChartDataSet? {
        var gpmData = [ChartDataEntry]()
        for index in from..<to {
            switch mode {
            case .gpm:
                let gpmEntry = ChartDataEntry(x: Double(index), y: Double(matches[index].gpm))
                gpmData.append(gpmEntry)
            case .xpm:
                let xpmEntry = ChartDataEntry(x: Double(index), y: Double(matches[index].xpm))
                gpmData.append(xpmEntry)
            case .disabled:
                return nil
            }
        }
        let line = LineChartDataSet(entries: gpmData, label: "GPM")
        return line
        //let data = LineChartData()
        //data.addDataSet(line)
        
        //chartView.data = data
    }
    
    @objc private func switchToKills() {
        currentKillsMode = .kills
        updateValues()
    }
    
    @objc private func switchToKda() {
        currentKillsMode = .kda
        updateValues()
    }
    
    @objc private func disableKills() {
        currentKillsMode = .disabled
        updateValues()
    }
    
    private func makeKillsData(from: Int, to: Int, with mode: chartKillMode) -> LineChartDataSet? {
        var killsData = [ChartDataEntry]()
        for index in from..<to {
            switch mode {
            case .kda:
                let killsEntry = ChartDataEntry(x: Double(index), y: Double(matches[index].kills))
                killsData.append(killsEntry)
            case .kills:
                let kdaEntry = ChartDataEntry(x: Double(index), y: Double(matches[index].kda))
                killsData.append(kdaEntry)
            case .disabled:
                return nil
            }
        }
        let line = LineChartDataSet(entries: killsData)
        return line
    }
    
}
