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
    
    func configScreen() {
        screen?.delegate = self
    }
}

extension ChooseSignInViewController: ChooseSignInScreenProtocol {
    func tappedLoginButton() {
        print(#function)
    }
    
    func tappedRegisterButton() {
        print(#function)
    }
}

