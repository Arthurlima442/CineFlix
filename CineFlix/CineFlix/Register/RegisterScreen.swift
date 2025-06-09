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
    
    lazy var titleLabel: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = "Cadastro"
        title.font = UIFont.boldSystemFont(ofSize: 20)
        title.textColor = .white
        title.textAlignment = .left
        return title
    }()
    
    lazy var textLabel: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.text = "CineFlix"
        text.font = UIFont.systemFont(ofSize: 30)
        text.textColor = .red
        text.textAlignment = .center
        return text
    }()
    
    lazy var nameTextFiel: UITextField = {
        var name = UITextField()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.placeholder = "Enter your Name:"
        name.textColor = .black
        name.borderStyle = .roundedRect
        return name
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
    
    lazy var confirmPasswordTextField: UITextField = {
        let confirm = UITextField()
        confirm.translatesAutoresizingMaskIntoConstraints = false
        confirm.placeholder = "Confirm your Password:"
        confirm.borderStyle = .roundedRect
        confirm.keyboardType = .emailAddress
        confirm.isSecureTextEntry = true
        return confirm
    }()
    
    lazy var confirmButton: UIButton = {
        let confirm = UIButton()
        confirm.translatesAutoresizingMaskIntoConstraints = false
        confirm.setTitle("Confirm", for: .normal)
        confirm.titleLabel?.font = UIFont.systemFont(ofSize: 14)
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
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            textLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 45),
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            emailTextFiel.topAnchor.constraint(equalTo: nameTextFiel.bottomAnchor, constant: 20),
            emailTextFiel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            emailTextFiel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            emailTextFiel.heightAnchor.constraint(equalToConstant: 40),
            
            nameTextFiel.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 20),
            nameTextFiel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            nameTextFiel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            nameTextFiel.heightAnchor.constraint(equalToConstant: 40),
            
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
