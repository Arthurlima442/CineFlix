//
//  LoginScreen.swift
//  CineFlix
//
//  Created by Arthur Lima on 09/06/2025.
//

import UIKit

protocol LoginScreenProtocol: AnyObject {
    func tappedforgotPasswordButton()
    func tappedConfirmButton()
    func tappedRegisterNowButton()
}

class LoginScreen: UIView {
    
    weak var delegate: LoginScreenProtocol?
    
    lazy var textLabel: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.text = "CineFlix"
        text.font = UIFont.systemFont(ofSize: 45)
        text.textColor = .red
        text.textAlignment = .center
        return text
    }()
    
    lazy var titleLabel: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = "Login"
        title.font = UIFont.boldSystemFont(ofSize: 25)
        title.textColor = .white
        title.textAlignment = .left
        return title
    }()
    
    lazy var emailTextField: UITextField = {
        let email = UITextField()
        email.translatesAutoresizingMaskIntoConstraints = false
        email.borderStyle = .roundedRect
        email.clipsToBounds = true
        email.layer.cornerRadius = 4
        email.layer.borderColor = UIColor.white.cgColor
        email.layer.borderWidth = 1
        email.backgroundColor = .black
        email.textColor = .white
        // Placeholder branco
        email.attributedPlaceholder = NSAttributedString(
            string: "Enter your Email:",
            attributes: [.foregroundColor: UIColor.lightGray]
        )
        return email
    }()
    
    lazy var passwordTextField: UITextField = {
        let password = UITextField()
        password.translatesAutoresizingMaskIntoConstraints = false
        password.borderStyle = .roundedRect
        password.clipsToBounds = true
        password.layer.cornerRadius = 4
        password.layer.borderColor = UIColor.white.cgColor
        password.layer.borderWidth = 1
        password.backgroundColor = .black
        password.textColor = .white
        password.keyboardType = .emailAddress
        password.isSecureTextEntry = true
        // Placeholder branco
        password.attributedPlaceholder = NSAttributedString(
            string: "Enter your Password:",
            attributes: [.foregroundColor: UIColor.lightGray]
        )
        return password
    }()
    
    lazy var forgotPasswordButton: UIButton = {
        let forgot = UIButton()
        forgot.translatesAutoresizingMaskIntoConstraints = false
        forgot.setTitle("Forgot my Password?", for: .normal)
        forgot.setTitleColor(.white, for: .normal)
        forgot.backgroundColor = .black
        forgot.addTarget(self, action: #selector(tappedforgotPasswordButton), for: .touchUpInside)
        return forgot
    }()
    
    lazy var confirmButton: UIButton = {
        let confirm = UIButton()
        confirm.translatesAutoresizingMaskIntoConstraints = false
        confirm.setTitle("Confirm", for: .normal)
        confirm.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        confirm.setTitleColor(.white, for: .normal)
        confirm.backgroundColor = .red
        confirm.addTarget(self, action: #selector(tappedConfirmButton), for: .touchUpInside)
        confirm.layer.cornerRadius = 8
        return confirm
    }()
    
    lazy var registerNowButton: UIButton = {
        let now = UIButton()
        now.setTitle("Don't have an account? Register", for: .normal)
        now.translatesAutoresizingMaskIntoConstraints = false
        now.setTitleColor(.white, for: .normal)
        now .backgroundColor = .black
        now.addTarget(self, action: #selector(tappedRegisterNowButton), for: .touchUpInside)
        return now
    }()
    
    @objc func tappedRegisterNowButton() {
        delegate?.tappedRegisterNowButton()
        
    }
    
    @objc func tappedConfirmButton() {
        delegate?.tappedConfirmButton()
        let tabBar = TabBarController()
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
           let window = sceneDelegate.window {
            window.rootViewController = tabBar
            UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromRight, animations: nil)
        }
    }
    
    @objc func tappedforgotPasswordButton() {
        delegate?.tappedforgotPasswordButton()
    }
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .black
        addElements()
        configConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addElements() {
        addSubview(textLabel)
        addSubview(titleLabel)
        addSubview(emailTextField)
        addSubview(passwordTextField)
        addSubview(forgotPasswordButton)
        addSubview(confirmButton)
        addSubview(registerNowButton)
    }
    
    func configConstraints() {
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            titleLabel.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 30),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            emailTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            emailTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            emailTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            emailTextField.heightAnchor.constraint(equalToConstant: 40),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            passwordTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            passwordTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            passwordTextField.heightAnchor.constraint(equalToConstant: 40),
            
            forgotPasswordButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 10),
            forgotPasswordButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            forgotPasswordButton.heightAnchor.constraint(equalToConstant: 20),
            
            confirmButton.topAnchor.constraint(equalTo: forgotPasswordButton.bottomAnchor, constant: 50),
            confirmButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            confirmButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            confirmButton.heightAnchor.constraint(equalToConstant: 40),
            
            registerNowButton.topAnchor.constraint(equalTo: confirmButton.bottomAnchor, constant: 10),
            registerNowButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            registerNowButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            registerNowButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
}
