//
//  AuthorizationPresenter.swift
//  FuncodechallengeApp
//
//  Created by Ванурин Алексей on 21.11.2019.
//  Copyright © 2019 Ванурин Алексей. All rights reserved.
//

import Foundation
import UIKit
import WebKit
import AppAuth
import SteamLogin

fileprivate let appKey = "9CA297FA685F9CDAAC9CED27BE1D837C"


protocol AuthorizationPresenterListener{
    func authCompleted()
}


final class AuthorizationPresenter: UIViewController, AuthorizationPresentable {
    var listener: AuthorizationPresenterListener?
    
    var steamUser: SteamUser? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        SteamLogin.steamApiKey = appKey
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startAuth()
    }
    
    private func startAuth() {
        self.steamUser = SteamUser.load()
        
        if steamUser == nil {
            SteamLoginVC.login(from: self) { [weak self] (user, error) in
                guard let self = self else {return}
                if let user = user {
                    self.steamUser = user
                    self.steamUser?.save()
                    self.onSuccessAuth()
                } else {
                    print("error!")
                }
            }
        } else {
            onSuccessAuth()
        }
    }
    
    func onSuccessAuth() {
        print("Sucess! \(steamUser?.steamID64 ?? "") ")
        SteamApi.appUserSteamId = steamUser!.steamID64!
        SteamApi.appUserStramIdShort = Int32(steamUser!.steamID32!)!
        listener?.authCompleted()
    }
}

