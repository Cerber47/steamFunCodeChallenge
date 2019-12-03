//
//  ProfileCellView.swift
//  FuncodechallengeApp
//
//  Created by Ванурин Алексей on 02.12.2019.
//  Copyright © 2019 Ванурин Алексей. All rights reserved.
//

import Foundation
import UIKit
import Dispatch


class ProfileCellView: UITableViewCell {
    var avatarView: UIImageView!
    var nameLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func present(name: String, avatar url: URL) {
        nameLabel.text = name
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    self.avatarView.image = UIImage(data: data)
                }
            }
        }
    }
    
    func setUpUI() {
        backgroundColor = .black
        avatarView = UIImageView()
        nameLabel = UILabel()
        
        nameLabel.textColor = .white
        nameLabel.textAlignment = .left
        nameLabel.font = UIFont.systemFont(ofSize: 30.0)
        
        addSubview(avatarView)
        avatarView.autoSetDimensions(to: CGSize(width: 70.0, height: 70.0))
        avatarView.autoPinEdge(toSuperviewEdge: .top, withInset: 5.0)
        avatarView.autoPinEdge(toSuperviewEdge: .bottom, withInset: 5.0)
        avatarView.autoPinEdge(toSuperviewEdge: .left, withInset: 5.0)
        
        addSubview(nameLabel)
        nameLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 15.0)
        nameLabel.autoPinEdge(.left, to: .right, of: avatarView, withOffset: 10.0)
        nameLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 35.0)
    }
}
