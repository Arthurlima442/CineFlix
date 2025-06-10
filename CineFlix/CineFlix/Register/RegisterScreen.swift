//
//  RegisterScreen.swift
//  CineFlix
//
//  Created by Arthur Lima on 09/06/2025.
//

import UIKit

protocol RegisterScreenProtocol: AnyObject {
    func tappedConfirmButton()
}

class RegisterScreen: UIView {
    
    weak var delegate: RegisterScreenProtocol?
    
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
        title.text = "Register"
        title.font = UIFont.boldSystemFont(ofSize: 25)
        title.textColor = .white
        title.textAlignment = .left
        return title
    }()
    
    lazy var nameTextFiel: UITextField = {
        var name = UITextField()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.borderStyle = .roundedRect
        name.clipsToBounds = true
        name.layer.cornerRadius = 4
        name.layer.borderColor = UIColor.white.cgColor
        name.layer.borderWidth = 1
        name.backgroundColor = .black
        name.textColor = .white
        name.keyboardType = .emailAddress
        // Placeholder branco
        name.attributedPlaceholder = NSAttributedString(
            string: "Enter your Name:",
            attributes: [.foregroundColor: UIColor.lightGray]
        )
        return name
    }()
    
    lazy var emailTextFiel: UITextField = {
        let email = UITextField()
        email.translatesAutoresizingMaskIntoConstraints = false
        email.borderStyle = .roundedRect
        email.clipsToBounds = true
        email.layer.cornerRadius = 4
        email.layer.borderColor = UIColor.white.cgColor
        email.layer.borderWidth = 1
        email.backgroundColor = .black
        email.textColor = .white
        email.keyboardType = .emailAddress
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
    
    lazy var confirmPasswordTextField: UITextField = {
        let confirm = UITextField()
        confirm.translatesAutoresizingMaskIntoConstraints = false
        confirm.borderStyle = .roundedRect
        confirm.clipsToBounds = true
        confirm.layer.cornerRadius = 4
        confirm.layer.borderColor = UIColor.white.cgColor
        confirm.layer.borderWidth = 1
        confirm.backgroundColor = .black
        confirm.textColor = .white
        confirm.keyboardType = .emailAddress
        confirm.isSecureTextEntry = true
        // Placeholder branco
        confirm.attributedPlaceholder = NSAttributedString(
            string: "Confirm your Password:",
            attributes: [.foregroundColor: UIColor.lightGray]
        )
        return confirm
    }()
    
    lazy var confirmButton: UIButton = {
        let confirm = UIButton()
        confirm.translatesAutoresizingMaskIntoConstraints = false
        confirm.setTitle("Confirm", for: .normal)
        confirm.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        confirm.backgroundColor = .red
        confirm.clipsToBounds = true
        confirm.layer.cornerRadius = 8
        confirm.addTarget(self, action: #selector(tappedConfirmButton), for: .touchUpInside)
        confirm.setTitleColor(.white, for: .normal)
        return confirm
    }()
    
    @objc func tappedConfirmButton() {
        delegate?.tappedConfirmButton()
    }
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .black
        addElements()
        configConstraints()
    }
    
    required init? (coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addElements() {
        addSubview(titleLabel)
        addSubview(textLabel)
        addSubview(nameTextFiel)
        addSubview(emailTextFiel)
        addSubview(passwordTextField)
        addSubview(confirmPasswordTextField)
        addSubview(confirmButton)
    }
    
    func configConstraints() {
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            titleLabel.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 30),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            nameTextFiel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            nameTextFiel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            nameTextFiel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            nameTextFiel.heightAnchor.constraint(equalToConstant: 40),
            
            emailTextFiel.topAnchor.constraint(equalTo: nameTextFiel.bottomAnchor, constant: 20),
            emailTextFiel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            emailTextFiel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            emailTextFiel.heightAnchor.constraint(equalToConstant: 40),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextFiel.bottomAnchor, constant: 20),
            passwordTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            passwordTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            passwordTextField.heightAnchor.constraint(equalToConstant: 40),
            
            confirmPasswordTextField.topAnchor.constraint(equalTo:passwordTextField.bottomAnchor, constant: 20),
            confirmPasswordTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            confirmPasswordTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            confirmPasswordTextField.heightAnchor.constraint(equalToConstant: 40),
            
            confirmButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -90),
            confirmButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            confirmButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            confirmButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
}
