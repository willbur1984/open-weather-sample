//
//  SceneDelegate.swift
//  open-weather
//
//  Created by William Towe on 4/7/24.
//

import Feige
import Foundation
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    // MARK: - UIWindowSceneDelegate
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else {
            return
        }
        window = UIWindow(windowScene: windowScene).also {
            $0.rootViewController = RootViewController(nibName: nil, bundle: nil)
            $0.makeKeyAndVisible()
        }
    }
}

