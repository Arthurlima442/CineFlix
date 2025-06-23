//
//  SettingsViewController.swift
//  CineFlix
//
//  Created by Arthur Lima on 10/06/2025.
//

import UIKit

class SettingsViewController: UIViewController {
    
    var screen: SettingsScreen?
    
    override func loadView() {
        screen = SettingsScreen()
        view = screen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configScreen()
        
        func configScreen() {
            screen?.delegate = self
        }
    }
}

extension SettingsViewController: SettingsScreenProtocol {
    func tappedDeleteAccontButton() {
        print(#function)
    }
    
    func tappedExitAppButton() {
        let loginVC = ChooseSignInViewController()
        let navController = UINavigationController(rootViewController: loginVC)

        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
           let window = sceneDelegate.window {
            window.rootViewController = navController
            UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromLeft, animations: nil)
        }
    }
}
