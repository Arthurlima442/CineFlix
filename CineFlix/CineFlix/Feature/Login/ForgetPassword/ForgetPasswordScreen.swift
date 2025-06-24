//
//  ForgetPasswordScreen.swift
//  CineFlix
//
//  Created by Arthur Lima on 24/06/2025.
//

import UIKit

protocol ForgetPasswordScreenProtocol: AnyObject {
    func tappedConfirmButton()
}

class ForgetPasswordScreen: UIView {

    weak var delegate: ForgetPasswordScreenProtocol?
    
    lazy var textLabel: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.text = "CineFlix"
        text.font = UIFont.systemFont(ofSize: 45, weight: .bold)
        text.textColor = .red
        text.textAlignment = .center
        return text
    }()
    
    lazy var titleLabel: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = "Forgot your password?"
        title.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        title.textColor = .white
        title.textAlignment = .left
        return title
    }()
    
    lazy var resetLabel: UILabel = {
        let reset = UILabel()
        reset.translatesAutoresizingMaskIntoConstraints = false
        reset.text = "Reset password with email:"
        reset.font = UIFont.systemFont(ofSize: 19, weight: .regular)
        reset.textColor = .white
        reset.textAlignment = .left
        return reset
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
    
    lazy var confirmEmailTextField: UITextField = {
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
            string: "Confirm your email:",
            attributes: [.foregroundColor: UIColor.lightGray]
        )
        return email
    }()
    
    lazy var confirmButton: UIButton = {
        let confirm = UIButton()
        confirm.translatesAutoresizingMaskIntoConstraints = false
        confirm.setTitle("Send", for: .normal)
        confirm.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        confirm.setTitleColor(.white, for: .normal)
        confirm.backgroundColor = .red
        confirm.addTarget(self, action: #selector(tappedConfirmButton), for: .touchUpInside)
        confirm.layer.cornerRadius = 8
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addElements() {
        addSubview(textLabel)
        addSubview(titleLabel)
        addSubview(resetLabel)
        addSubview(emailTextField)
        addSubview(confirmEmailTextField)
        addSubview(confirmButton)
    }
    
    func configConstraints() {
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            titleLabel.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 50),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            resetLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            resetLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            resetLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            
            emailTextField.topAnchor.constraint(equalTo: resetLabel.bottomAnchor, constant: 20),
            emailTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            emailTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            emailTextField.heightAnchor.constraint(equalToConstant: 40),
            
            confirmEmailTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            confirmEmailTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            confirmEmailTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            confirmEmailTextField.heightAnchor.constraint(equalToConstant: 40),
            
            confirmButton.topAnchor.constraint(equalTo: confirmEmailTextField.bottomAnchor, constant: 30),
            confirmButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            confirmButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            confirmButton.heightAnchor.constraint(equalToConstant: 40),
            
        ])
    }
}
