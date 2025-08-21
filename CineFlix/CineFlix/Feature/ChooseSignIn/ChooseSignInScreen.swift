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
    
    private lazy var backgroundImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .black
        iv.clipsToBounds = true
        return iv
    }()
    
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
        message.text = "Discover the perfect movie!"
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
        button.backgroundColor = UIColor(red: 0.7, green: 0.0, blue: 0.1, alpha: 1.0)
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 8
        button.addTarget(self, action: #selector(tappedLoginButton), for: .touchUpInside)
        return button
    }()
    
    lazy var registerButton: UIButton = {
        let register = UIButton()
        register.translatesAutoresizingMaskIntoConstraints = false
        register.setTitle("Register", for: .normal)
        register.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        register.setTitleColor(.white, for: .normal)
        register.backgroundColor = UIColor(red: 0.7, green: 0.0, blue: 0.1, alpha: 1.0)
        register.clipsToBounds = true
        register.layer.cornerRadius = 10
        register.layer.shadowColor = UIColor.black.cgColor
        register.layer.shadowOpacity = 0.5
        register.layer.shadowOffset = CGSize(width: 0, height: 4)
        register.layer.shadowRadius = 8
        register.addTarget(self, action: #selector(tappedRegisterButton), for: .touchUpInside)
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
        addElements()
        configConstraints()
        backgroundImageView.image = UIImage(named: "fundoTelaPrincipal")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addElements() {
        addSubview(backgroundImageView)
        addSubview(titleLabel)
        addSubview(messageLabel)
        addSubview(registerButton)
        addSubview(loginButton)
    }
    
    func configConstraints() {
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 140),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            // Login (esquerda)
            loginButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 40),
            loginButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Register (direita)
            registerButton.topAnchor.constraint(equalTo: loginButton.topAnchor),
            registerButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            registerButton.heightAnchor.constraint(equalTo: loginButton.heightAnchor),
            registerButton.leadingAnchor.constraint(equalTo: loginButton.trailingAnchor, constant: 16),
            registerButton.widthAnchor.constraint(equalTo: loginButton.widthAnchor)
        ])
    }
}
