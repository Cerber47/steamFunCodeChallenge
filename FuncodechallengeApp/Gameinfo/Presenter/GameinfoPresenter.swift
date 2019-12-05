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

let gradientColors = [ChartColorTemplates.colorFromString("#00ff0000").cgColor,
                      ChartColorTemplates.colorFromString("#ffff0000").cgColor]
let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!


class GameinfoPresenter: UIViewController {
    var matches: [ChartMatchInfo]!
    var listener: GameinfoPresenterListener?
    var chartView: LineChartView!
    
    var leftPivot: Int = 0
    var rightPivot: Int = 10
    
    var currentGoldMode: chartGoldMode = .gpm
    var currentKillsMode: chartKillMode = .kills
    
    var goldGPMButton: UIButton!
    var goldNetworthButton: UIButton!
    var goldDisableButton: UIButton!
    var killsButton: UIButton!
    var kdaButton: UIButton!
    var disableKillsButton: UIButton!
    
    override func viewDidLoad() {
        view.backgroundColor = .black
        chartView = LineChartView()
        chartView.backgroundColor = UIColor(red: 0.1, green: 0.9, blue: 0.3, alpha: 1.0)
        
        chartView.xAxis.drawLabelsEnabled = false
        chartView.leftAxis.drawLabelsEnabled = false
        chartView.rightAxis.drawLabelsEnabled = false
        
        view.addSubview(chartView)
        chartView.autoPinEdge(toSuperviewEdge: .top, withInset: 100.0)
        chartView.autoPinEdge(toSuperviewEdge: .left, withInset: 30.0)
        chartView.autoPinEdge(toSuperviewEdge: .right, withInset: 30.0)
        //chartView.autoPinEdge(toSuperviewEdge: .bottom)
        
        let backButton = UIButton()
        backButton.setTitle("<--", for: .normal)
        backButton.setTitleColor(.white, for: .normal)
        backButton.tintColor = .blue
        
        backButton.addTarget(self, action: #selector(stepUp), for: .touchUpInside)
        
        view.addSubview(backButton)
        backButton.autoPinEdge(toSuperviewEdge: .left, withInset: 15.0)
        backButton.autoPinEdge(.top, to: .bottom, of: chartView, withOffset: 20.0)
        
        let rightButton = UIButton()
        rightButton.setTitle("-->", for: .normal)
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
        goldSwitcher.spacing = 5
        
        goldGPMButton = UIButton()
        goldGPMButton.setTitle("GPM", for: .normal)
        goldGPMButton.addTarget(self, action: #selector(switchToGpm), for: .touchUpInside)
        makeRounded(button: goldGPMButton)
        
        goldNetworthButton = UIButton()
        goldNetworthButton.setTitle("XPM", for: .normal)
        goldNetworthButton.addTarget(self, action: #selector(switchToXpm), for: .touchUpInside)
        makeRounded(button: goldNetworthButton)
        
        goldDisableButton = UIButton()
        goldDisableButton.setTitle("Выключить", for: .normal)
        goldDisableButton.addTarget(self, action: #selector(switchGoldDisable), for: .touchUpInside)
        makeRounded(button: goldDisableButton)
        
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
        killsSwitcher.spacing = 5
        
        killsButton = UIButton()
        killsButton.setTitle("Kills", for: .normal)
        killsButton.setTitleColor(.red, for: .normal)
        killsButton.addTarget(self, action: #selector(switchToKills), for: .touchUpInside)
        makeRounded(button: killsButton)
        
        kdaButton = UIButton()
        kdaButton.setTitle("KDA", for: .normal)
        kdaButton.setTitleColor(.red, for: .normal)
        kdaButton.addTarget(self, action: #selector(switchToKda), for: .touchUpInside)
        makeRounded(button: kdaButton)
        
        disableKillsButton = UIButton()
        disableKillsButton.setTitle("Выключить", for: .normal)
        disableKillsButton.setTitleColor(.red, for: .normal)
        disableKillsButton.addTarget(self, action: #selector(disableKills), for: .touchUpInside)
        makeRounded(button: disableKillsButton)
        
        killsSwitcher.addArrangedSubview(killsButton)
        killsSwitcher.addArrangedSubview(kdaButton)
        killsSwitcher.addArrangedSubview(disableKillsButton)
        
        view.addSubview(killsSwitcher)
        killsSwitcher.autoPinEdge(.top, to: .bottom, of: goldSwitcher, withOffset: 10.0)
        killsSwitcher.autoPinEdge(toSuperviewEdge: .left, withInset: 30.0)
        killsSwitcher.autoPinEdge(toSuperviewEdge: .right, withInset: 30.0)
        
        killsButton.isSelected = true
        goldGPMButton.isSelected = true
        
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
        let data = LineChartData()
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
        goldGPMButton.isSelected = true
        goldNetworthButton.isSelected = false
        goldDisableButton.isSelected = false
        updateValues()
    }
    
    @objc private func switchToXpm() {
        currentGoldMode = .xpm
        goldGPMButton.isSelected = false
        goldNetworthButton.isSelected = true
        goldDisableButton.isSelected = false
        updateValues()
    }
    
    @objc private func switchGoldDisable() {
        currentGoldMode = .disabled
        goldGPMButton.isSelected = false
        goldNetworthButton.isSelected = false
        goldDisableButton.isSelected = true
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
        
        line.setCircleColor(.red)
        line.setColor(.red)
        line.circleRadius = 1
        line.drawCircleHoleEnabled = false
        line.valueFont = .systemFont(ofSize: 16)
        line.valueTextColor = .black
        line.fillAlpha = 1
        line.drawFilledEnabled = true
        line.fill = Fill(linearGradient: gradient, angle: 90)
        
        return line
    }
    
    @objc private func switchToKills() {
        currentKillsMode = .kills
        killsButton.isSelected = true
        kdaButton.isSelected = false
        disableKillsButton.isSelected = false
        updateValues()
    }
    
    @objc private func switchToKda() {
        currentKillsMode = .kda
        killsButton.isSelected = false
        kdaButton.isSelected = true
        disableKillsButton.isSelected = false
        updateValues()
    }
    
    @objc private func disableKills() {
        currentKillsMode = .disabled
        killsButton.isSelected = false
        kdaButton.isSelected = false
        disableKillsButton.isSelected = true
        updateValues()
    }
    
    private func makeKillsData(from: Int, to: Int, with mode: chartKillMode) -> LineChartDataSet? {
        var killsData = [ChartDataEntry]()
        for index in from..<to {
            switch mode {
            case .kda:
                let killsEntry = ChartDataEntry(x: Double(index), y: Double(matches[index].kills * 100))
                killsData.append(killsEntry)
            case .kills:
                let kdaEntry = ChartDataEntry(x: Double(index), y: Double(matches[index].kda * 100))
                killsData.append(kdaEntry)
            case .disabled:
                return nil
            }
        }
        let line = LineChartDataSet(entries: killsData)
        
        line.setCircleColor(.blue)
        line.setColor(.blue)
        line.circleRadius = 2
        line.lineWidth = 2
        line.drawCircleHoleEnabled = false
        line.valueFont = .systemFont(ofSize: 14)
        line.valueTextColor = .black
        line.drawValuesEnabled = false
        
        return line
    }
    
}

func makeRounded(button: UIButton) {
    button.layer.opacity = 0.9
    button.backgroundColor = .white
    button.layer.cornerRadius = 10
    button.layer.borderColor = UIColor(ciColor: .white).cgColor
    
    button.setTitleColor(.red, for: .selected)
    button.setTitleColor(.blue, for: .highlighted)
    button.setTitleColor(.black, for: .normal)
}
