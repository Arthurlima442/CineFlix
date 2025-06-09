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
    
    lazy var titleLabel: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = "Login"
        title.font = UIFont.boldSystemFont(ofSize: 30)
        title.textColor = .white
        title.textAlignment = .center
        return title
    }()
    
    lazy var textLabel: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.text = "CineFlix"
        text.font = UIFont.systemFont(ofSize: 45)
        text.textColor = .red
        text.textAlignment = .center
        return text
    }()
    
    lazy var emailTextFiel: UITextField = {
        let email = UITextField()
        email.translatesAutoresizingMaskIntoConstraints = false
        email.placeholder = "Enter your Email:"
        email.borderStyle = .roundedRect
        email.keyboardType = .emailAddress
        return email
    }()
    
    lazy var passwordTextField: UITextField = {
        let password = UITextField()
        password.translatesAutoresizingMaskIntoConstraints = false
        password.placeholder = "Enter your Password:"
        password.borderStyle = .roundedRect
        password.keyboardType = .emailAddress
        password.isSecureTextEntry = true
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
        confirm.setTitle("Confirmar", for: .normal)
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
        addSubview(emailTextFiel)
        addSubview(passwordTextField)
        addSubview(forgotPasswordButton)
        addSubview(confirmButton)
        addSubview(registerNowButton)
    }
    
    func configConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 0),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            textLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            emailTextFiel.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 20),
            emailTextFiel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            emailTextFiel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            emailTextFiel.heightAnchor.constraint(equalToConstant: 40),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextFiel.bottomAnchor, constant: 20),
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
