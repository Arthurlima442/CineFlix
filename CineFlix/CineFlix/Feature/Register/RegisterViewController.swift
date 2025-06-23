//
//  RegisterViewController.swift
//  CineFlix
//
//  Created by Arthur Lima on 09/06/2025.
//

import UIKit

class RegisterViewController: UIViewController {
    
    var screen: RegisterScreen?
    
    override func loadView() {
        screen = RegisterScreen()
        view = screen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configScreen()
   }
    
    func configScreen() {
        screen?.delegate = self
    }
}

extension RegisterViewController: RegisterScreenProtocol {
    func tappedConfirmButton() {
        navigationController?.pushViewController(TabBarController(), animated: true)    }
}
