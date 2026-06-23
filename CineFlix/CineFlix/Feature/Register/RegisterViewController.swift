//
//  RegisterViewController.swift
//  CineFlix
//
//  Created by Arthur Lima on 09/06/2025.
//

import UIKit

class RegisterViewController: UIViewController {
    
    var screen: RegisterScreen?
    var viewModel: RegisterViewModel = RegisterViewModel()
    
    override func loadView() {
        screen = RegisterScreen()
        view = screen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configViewModel()
        configScreen()
   }
    
    func configViewModel() {
        viewModel.delegate = self
    }
    
    func configScreen() {
        screen?.delegate = self
    }
}

extension RegisterViewController: RegisterScreenProtocol {
    func tappedConfirmButton() {
        let email = screen?.emailTextField.text ?? ""
        let password = screen?.passwordTextField.text ?? ""
        let confirmPassword = screen?.confirmPasswordTextField.text ?? ""
        
        viewModel.validateFields(email: email, password: password, confirmPassword: confirmPassword)
    }
}

extension RegisterViewController: RegisterViewModelProtocol {
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    func registerSuccess() {
        let tabBar = TabBarController()
        AppTransition.changeRootViewController(to: tabBar, with: .transitionFlipFromRight)
    }
}
