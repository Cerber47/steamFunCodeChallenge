//
//  FriendCellView.swift
//  FuncodechallengeApp
//
//  Created by Ванурин Алексей on 02.12.2019.
//  Copyright © 2019 Ванурин Алексей. All rights reserved.
//

import Foundation
import UIKit
import PureLayout

class FriendCellView: UITableViewCell {
    var avatarIcon: UIImageView!
    var nameLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpUI() {
        backgroundColor = .black
        avatarIcon = UIImageView()
        
        nameLabel = UILabel()
        nameLabel.textAlignment = .left
        nameLabel.textColor = .white
        nameLabel.font = UIFont.systemFont(ofSize: 14.0)
        
        addSubview(avatarIcon)
        avatarIcon.autoSetDimensions(to: CGSize(width: 30.0, height: 30.0))
        avatarIcon.autoPinEdge(toSuperviewEdge: .left, withInset: 5.0)
        avatarIcon.autoPinEdge(toSuperviewEdge: .top, withInset: 5.0)
        avatarIcon.autoPinEdge(toSuperviewEdge: .bottom, withInset: 5.0)
        
        addSubview(nameLabel)
        nameLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 10.0)
        nameLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 10.0)
        nameLabel.autoPinEdge(.left, to: .right, of: avatarIcon)
    }
    
    func present(name: String, avatar url: URL) {
        nameLabel.text = name
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    self.avatarIcon.image = UIImage(data: data)
                }
            }
        }
    }
}
