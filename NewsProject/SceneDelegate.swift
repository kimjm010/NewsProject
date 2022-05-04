//
//  SceneDelegate.swift
//  NewsProject
//
//  Created by Chris Kim on 2022/03/28.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    var token: NSObjectProtocol?
    


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        
        let windorUIStyle = window?.overrideUserInterfaceStyle
        
        if windorUIStyle == .dark {
            
        }
        
        token = NotificationCenter.default.addObserver(forName: .setDarktMode,
                                               object: nil,
                                               queue: .main) { [weak self] (noti) in
            guard let self = self else { return }
            guard let darkMode = noti.userInfo?["mode"] as? Bool else { return }
            self.window?.overrideUserInterfaceStyle = darkMode ? .dark : .light
        }
    }

    
    /// change root ViewController.
    /// - Parameters:
    ///   - vc: viewController which try to change.
    ///   - animated: animation effect
    func changeRootVC(_ vc: UIViewController, animated: Bool = true) {
        guard let window = window else { return }
        
        window.rootViewController = vc
        
        UIView.transition(with: window,
                          duration: 0.5,
                          options: [.transitionCrossDissolve],
                          animations: nil,
                          completion: nil)
    }
}

