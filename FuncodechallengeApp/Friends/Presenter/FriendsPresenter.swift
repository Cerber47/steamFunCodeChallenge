//
//  FriendsPresenter.swift
//  FuncodechallengeApp
//
//  Created by Ванурин Алексей on 22.11.2019.
//  Copyright © 2019 Ванурин Алексей. All rights reserved.
//

import Foundation
import UIKit


protocol FriendsPresenterListener {
    func viewIsReadyToPresentData()
}


class FriendsPresenter: UIViewController, FriendsPresentable {
    var listener: FriendsPresenterListener?
    var tableView: UITableView!
    
    var friends: [SteamFriend]? { didSet {
        tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        configurateView()
        view = tableView
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        tableView.register(FriendCellView.self, forCellReuseIdentifier: "FriendCell")
        tableView.rowHeight = 40.0
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.separatorColor = .black
        tableView.backgroundColor = .black
        
        navigationItem.title = "Друзья"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.isTranslucent = false
        
        listener?.viewIsReadyToPresentData()
    }
    
    private func configurateView() {
        tableView = UITableView()
    }
}

extension FriendsPresenter: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if friends != nil {
            print(friends!.count)
            return friends!.count
        } else {return 0}
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell") as! FriendCellView
        cell.present(name: friends![indexPath.row].name, avatar: URL(string: friends![indexPath.row].avatar)!)
        return cell
    }
    
}
