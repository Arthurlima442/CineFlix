//
//  LoginViewController.swift
//  CineFlix
//
//  Created by Arthur Lima on 09/06/2025.
//

import UIKit

class LoginViewController: UIViewController {
    
    var screen: LoginScreen?
    
    override func loadView() {
        screen = LoginScreen()
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

extension LoginViewController: LoginScreenProtocol {
    func tappedforgotPasswordButton() {
        print(#function)
    }
    
    func tappedConfirmButton() {
        navigationController?.pushViewController(TabBarController(), animated: true)
    }
    
    func tappedRegisterNowButton() {
        navigationController?.pushViewController(RegisterViewController(), animated: true)
    }
}

