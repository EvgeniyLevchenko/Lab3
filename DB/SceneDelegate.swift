//
//  SceneDelegate.swift
//  DB
//
//  Created by QwertY on 06.06.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let mainVC = MainViewController()
        let navigationController = UINavigationController(rootViewController: mainVC)
        window.makeKeyAndVisible()
        window.rootViewController = navigationController
        self.window = window
    }
}

