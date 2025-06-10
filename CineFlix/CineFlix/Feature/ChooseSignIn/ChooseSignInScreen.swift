//
//  ChooseSignInScreen.swift
//  CineFlix
//
//  Created by Arthur Lima on 09/06/2025.
//

import UIKit

protocol ChooseSignInScreenProtocol: AnyObject {
    func tappedLoginButton()
    func tappedRegisterButton()
}

class ChooseSignInScreen: UIView {
    
    weak var delegate: ChooseSignInScreenProtocol?
    
    lazy var titleLabel: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = "CineFlix"
        title.font = UIFont.boldSystemFont(ofSize: 50)
        title.textColor = .red
        return title
    }()
    
    lazy var messageLabel: UILabel = {
        let message = UILabel()
        message.translatesAutoresizingMaskIntoConstraints = false
        message.text = "Discover the perfect movie."
        message.font = UIFont.systemFont(ofSize: 25)
        message.textAlignment = .center
        message.textColor = .white
        return message
    }()
    
    lazy var loginButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Login", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .red
        button.clipsToBounds = true
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(tappedLoginButton), for: .touchUpInside)
        return button
    }()
    
    lazy var registerButton: UIButton = {
        let register = UIButton()
        register.translatesAutoresizingMaskIntoConstraints = false
        register.setTitle("Register", for: .normal)
        register.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        register.setTitleColor(.white, for: .normal)
        register.addTarget(self, action: #selector(tappedRegisterButton), for: .touchUpInside)
        register.backgroundColor = .red
        register.layer.cornerRadius = 5
        return register
    }()
    
    @objc func tappedLoginButton() {
        delegate?.tappedLoginButton()
    }
    
    @objc func tappedRegisterButton() {
        delegate?.tappedRegisterButton()
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
        addSubview(titleLabel)
        addSubview(messageLabel)
        addSubview(registerButton)
        addSubview(loginButton)
    }
    
    func configConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 90),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            loginButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -50),
            loginButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            loginButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            registerButton.bottomAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: -55),
            registerButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            registerButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
        ])
    }
}
