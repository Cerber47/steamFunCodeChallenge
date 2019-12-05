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
        navigationItem.title = "Личный профиль"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.isTranslucent = false
        configureView()
        listener?.viewIsReadyToPresentData()
    }
    
    private func configureView() {
        tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        tableView.register(GameCellView.self, forCellReuseIdentifier: "GameCell")
        tableView.register(ProfileCellView.self, forCellReuseIdentifier: "PersonaCell")
        //tableView.rowHeight = 40.0
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "PersonaCell") as! ProfileCellView
            cell.present(name: steamProfile!.name, avatar: URL(string: steamProfile!.avararUrl)!)
            cell.textLabel?.text = steamProfile?.name
            return cell
        } else if section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell")!
            if recentyPlayedGames.isEmpty {
                cell.textLabel?.text = "Нет недавней активности"
                cell.textLabel?.textAlignment = .center
                cell.backgroundColor = .black
                cell.textLabel?.textColor = .white
            } else {
                cell.textLabel?.text = recentyPlayedGames[indexPath.row].name
                cell.backgroundColor = .black
                cell.textLabel?.textAlignment = .left
                cell.textLabel?.textColor = .white
            }
            return cell
        } else if section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell") as! GameCellView
            cell.present(game: ownedGames[indexPath.row].name, playedFor: ownedGames[indexPath.row].getPlayTimeAsString(), iconUrl: ownedGames[indexPath.row].getStaticUrlForIcon())
            cell.sizeToFit()
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
    
    func tableView(_ tableView: UITableView,
              heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 80
        } else if indexPath.section == 2 {
            return 40
        } else {
            return 30
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var sectionName = ""
        
        if section == 1 {
            sectionName = "Недавно играл"
        } else if section == 2 {
            sectionName = "Библиотека игр"
        }
        
        let view = UIView()
        let label = UILabel()
        label.text = sectionName
        label.textColor = .white
        label.textAlignment = .center
        view.addSubview(label)
        label.autoPinEdgesToSuperviewEdges()
        view.backgroundColor = .black
        
        return view
    }
    
}
