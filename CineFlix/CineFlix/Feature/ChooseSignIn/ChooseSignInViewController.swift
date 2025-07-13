//
//  ChooseSignIn.swift
//  CineFlix
//
//  Created by Arthur Lima on 09/06/2025.
//

import UIKit

class ChooseSignInViewController: UIViewController {
    
    var screen: ChooseSignInScreen?
    
    override func loadView() {
        screen = ChooseSignInScreen()
        view = screen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configScreen()
    }
//    Serve para mostrar a navigation bar sempre que essa tela for prestes a aparecer, mesmo que ela tenha sido escondida em outras telas.
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            navigationController?.setNavigationBarHidden(false, animated: false)
        }
    
    func configScreen() {
        screen?.delegate = self
    }
}

extension ChooseSignInViewController: ChooseSignInScreenProtocol {
    func tappedLoginButton() {
        navigationController?.pushViewController(LoginViewController(), animated: true)    }
    
    func tappedRegisterButton() {
        navigationController?.pushViewController(RegisterViewController(), animated: true)
    }
}

