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
        text.text = "Register"
        text.font = UIFont.systemFont(ofSize: 45)
        text.textColor = .red
        text.textAlignment = .center
        return text
    }()
    
    lazy var emailLabel: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = "Email:"
        title.font = UIFont.boldSystemFont(ofSize: 20)
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
        email.keyboardType = .emailAddress
        // Placeholder branco
        email.attributedPlaceholder = NSAttributedString(
            string: "Enter your Email:",
            attributes: [.foregroundColor: UIColor.lightGray]
        )
        return email
    }()
    
    lazy var passwordLabel: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = "Password:"
        title.font = UIFont.boldSystemFont(ofSize: 20)
        title.textColor = .white
        title.textAlignment = .left
        return title
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
    
    lazy var confirmPasswordLabel: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = "Confirm Password:"
        title.font = UIFont.boldSystemFont(ofSize: 20)
        title.textColor = .white
        title.textAlignment = .left
        return title
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
        confirm.setTitleColor(.white, for: .normal)
        confirm.backgroundColor = UIColor(red: 0.7, green: 0.0, blue: 0.1, alpha: 1.0)
        confirm.clipsToBounds = true
        confirm.layer.cornerRadius = 10
        confirm.layer.shadowColor = UIColor.black.cgColor
        confirm.layer.shadowOpacity = 0.5
        confirm.layer.shadowOffset = CGSize(width: 0, height: 4)
        confirm.layer.shadowRadius = 8
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
        addSubview(textLabel)
        addSubview(emailLabel)
        addSubview(emailTextField)
        addSubview(passwordLabel)
        addSubview(passwordTextField)
        addSubview(confirmPasswordLabel)
        addSubview(confirmPasswordTextField)
        addSubview(confirmButton)
    }
    
    func configConstraints() {
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            emailLabel.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 20),
            emailLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            emailLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 5),
            emailTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            emailTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            emailTextField.heightAnchor.constraint(equalToConstant: 40),
            
            passwordLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            passwordLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            passwordLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            passwordTextField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 5),
            passwordTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            passwordTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            passwordTextField.heightAnchor.constraint(equalToConstant: 40),
            
            confirmPasswordLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            confirmPasswordLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            confirmPasswordLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            confirmPasswordTextField.topAnchor.constraint(equalTo:confirmPasswordLabel.bottomAnchor, constant: 5),
            confirmPasswordTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            confirmPasswordTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            confirmPasswordTextField.heightAnchor.constraint(equalToConstant: 40),
            
            confirmButton.bottomAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor, constant: 80),
            confirmButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            confirmButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            confirmButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
}
