//
//  GameCellView.swift
//  FuncodechallengeApp
//
//  Created by Ванурин Алексей on 01.12.2019.
//  Copyright © 2019 Ванурин Алексей. All rights reserved.
//

import Foundation
import UIKit
import PureLayout
import Dispatch


class GameCellView: UITableViewCell {
    
    var gameIconView: UIImageView!
    var gameNameLabel: UILabel!
    var gameHoursLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUI()
    }
    
    func present(game: String, playedFor: String, iconUrl: URL) {
        gameNameLabel.text = game
        gameHoursLabel.text = playedFor
        
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: iconUrl) {
                DispatchQueue.main.async {
                    self.gameIconView.image = UIImage(data: data)
                }
            }
        }
    }
    
    private func setUpUI() {
        backgroundColor = .black
        gameIconView = UIImageView()
        
        gameNameLabel = UILabel()
        gameNameLabel.textColor = .white
        gameNameLabel.font = UIFont.boldSystemFont(ofSize: 14.0)
        gameNameLabel.numberOfLines = 0
        gameNameLabel.textAlignment = .center
        
        gameHoursLabel = UILabel()
        gameHoursLabel.textColor = .white
        gameHoursLabel.font = UIFont.systemFont(ofSize: 10.0)
        gameHoursLabel.textAlignment = .right
        
        addSubview(gameIconView)
        gameIconView.autoPinEdge(toSuperviewEdge: .left, withInset: 5.0)
        gameIconView.autoPinEdge(toSuperviewEdge: .top, withInset: 5.0)
        gameIconView.autoPinEdge(toSuperviewEdge: .bottom, withInset: 5.0)
        gameIconView.autoSetDimensions(to: CGSize(width: 30.0, height: 30.0))
        
        addSubview(gameNameLabel)
        gameNameLabel.autoPinEdge(.left, to: .right, of: gameIconView, withOffset: 15.0)
        gameNameLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 15.0)
        gameNameLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 15.0)
        
        addSubview(gameHoursLabel)
        gameHoursLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 10.0)
        gameHoursLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 5.0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
