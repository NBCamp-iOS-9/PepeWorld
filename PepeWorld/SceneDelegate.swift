//
//  SceneDelegate.swift
//  PepeWorld
//
//  Created by 정재성 on 1/22/26.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = scene as? UIWindowScene else {
      return
    }
    let newWindow = UIWindow(windowScene: windowScene)
    newWindow.makeKeyAndVisible()
    newWindow.rootViewController = ViewController()
    window = newWindow
  }
}
