//
//  LoginViewController.swift
//  CineFlix
//
//  Created by Arthur Lima on 09/06/2025.
//

import UIKit

class LoginViewController: UIViewController {
    
    var screen: LoginScreen?
    var viewModel: LoginViewModel = LoginViewModel()
    
    override func loadView() {
        screen = LoginScreen()
        view = screen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configViewModal()
        configScreen()
    }
    
    func configViewModal() {
        viewModel.delegate = self
    }
    
    func configScreen() {
        screen?.delegate = self
        screen?.emailTextField.delegate = self
    }
}

extension LoginViewController: LoginScreenProtocol {
    func tappedforgotPasswordButton() {
        navigationController?.pushViewController(ForgetPasswordViewController(), animated: true)
    }
    
    func tappedConfirmButton() {
        let email = screen?.emailTextField.text ?? ""
        let password = screen?.passwordTextField.text ?? ""
        viewModel.login(email: email, password: password)
    }
    
    func tappedRegisterNowButton() {
        navigationController?.pushViewController(RegisterViewController(), animated: true)
    }
}

extension LoginViewController: LoginViewModelProtocol {
    func loginSuccess() {
        let tabBar = TabBarController()
        
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
           let window = sceneDelegate.window {
            window.rootViewController = tabBar
            UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromRight, animations: nil)
        }
    }
    
    func loginError(message: String) {
        let alert = UIAlertController(title: "Login Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == screen?.emailTextField {
            return !string.contains(" ")
        } else {
            return true
        }
    }
}
