//
//  RootPresenter.swift
//  FuncodechallengeApp
//
//  Created by Ванурин Алексей on 26.11.2019.
//  Copyright © 2019 Ванурин Алексей. All rights reserved.
//


import Foundation
import UIKit

protocol RootPresenterListener {
}


class RootPresenter: UIViewController, RootPresentable {
    var listener: RootPresenterListener?
}
