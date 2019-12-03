//
//  NetworkManager.swift
//  FuncodechallengeApp
//
//  Created by Ванурин Алексей on 22.11.2019.
//  Copyright © 2019 Ванурин Алексей. All rights reserved.
//

import Foundation
import Alamofire


fileprivate let baseUrl = "https://api.steampowered.com/"
fileprivate let Appkey = "9CA297FA685F9CDAAC9CED27BE1D837C"
fileprivate let testSteamId = "76561197988574396"

class SteamApi {
    static let headers: HTTPHeaders = [
        "Content-Type":"application/x-www-form-urlencoded"
    ]
    static var appUserSteamId: String = ""
    static var appUserStramIdShort: Int32 = 0
    static let baseUrl: String = "https://api.steampowered.com/"
}

class NetworkManager {
    func makeRequest(url: String, method: HTTPMethod, parameters:[String: Any], completion: @escaping (Data?)->Void) {
        AF.request(url, method: method, parameters: parameters, headers: SteamApi.headers).responseJSON() { response in
            switch response.result {
            case .success( _):
                completion(response.data)
            case .failure( _):
                completion(nil)
            }
        }
    }
}
