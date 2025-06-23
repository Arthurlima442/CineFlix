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
        navigationController?.pushViewController(ChooseSignInViewController(), animated: true)    }
}
