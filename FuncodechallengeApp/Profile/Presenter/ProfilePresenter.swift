//
//  ProfilePresenter.swift
//  FuncodechallengeApp
//
//  Created by Ванурин Алексей on 21.11.2019.
//  Copyright © 2019 Ванурин Алексей. All rights reserved.
//

import Foundation
import UIKit


protocol ProfilePresenterListener {
    func viewIsReadyToPresentData()
    func updateViewData()
}


final class ProfilePresenter: UIViewController, ProfilePresentable {
    var listener: ProfilePresenterListener?
    var tableView: UITableView!
    
    var steamProfile: SteamUserProfile? { didSet {
        tableView.reloadData()
        navigationItem.title = steamProfile?.name
        }
    }
    
    var recentyPlayedGames: [SteamRecentlyGame] = [] { didSet {
        tableView.reloadData()
        }
    }
    
    var ownedGames: [SteamOwnedGame] = [] { didSet {
        tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        configureView()
        listener?.viewIsReadyToPresentData()
    }
    
    private func configureView() {
        tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        view = tableView
    }
}

extension ProfilePresenter: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if steamProfile != nil {
                return 1
            } else {
                return 0
            }
        } else if section == 1 {
            if recentyPlayedGames.isEmpty {
                return 1
            } else {
                return recentyPlayedGames.count
            }
        } else if section == 2 {
            return ownedGames.count
        } else {
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        if section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell")!
            cell.textLabel?.text = steamProfile?.name
            return cell
        } else if section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell")!
            if recentyPlayedGames.isEmpty {
                cell.textLabel?.text = "Нет недавней активности"
                cell.textLabel?.textAlignment = .center
            } else {
                cell.textLabel?.text = recentyPlayedGames[indexPath.row].name
                cell.textLabel?.textAlignment = .left
            }
            return cell
        } else if section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell")!
            cell.textLabel?.text = ownedGames[indexPath.row].name
            return cell
            
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return ""
        } else if section == 1 {
            return "Недавно играл"
        } else if section == 2 {
            return "Библиотека игр"
        } else {
            fatalError("Нет такой секции")
        }
    }
}
