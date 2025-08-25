//
//  S.swift
//  CineFlix
//
//  Created by Arthur Lima on 21/08/25.
//

import UIKit

protocol SettingsScreenProtocol: AnyObject {
    func tappedExitAppButton()
    func tappedDeleteAccontButton()
}

class SettingsScreen: UIView {
    
    weak var delegate: SettingsScreenProtocol?
    
    lazy var textLabel: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.text = "CineFlix"
        text.font = UIFont.systemFont(ofSize: 45)
        text.textColor = .red
        text.textAlignment = .center
        return text
    }()
    
    lazy var settingsLabel: UILabel = {
        let settings = UILabel()
        settings.translatesAutoresizingMaskIntoConstraints = false
        settings.text = "Settings"
        settings.font = UIFont.boldSystemFont(ofSize: 25)
        settings.textColor = .white
        settings.textAlignment = .left
        return settings
    }()
    
    lazy var nameLabel: UILabel = {
        let name = UILabel()
        name.text = "Name:"
        name.textColor = .white
        name.textAlignment = .left
        name.translatesAutoresizingMaskIntoConstraints = false
        name.font = .systemFont(ofSize: 18)
        return name
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
    
    lazy var emailLabel: UILabel = {
        let emailLabel = UILabel()
        emailLabel.text = "Email:"
        emailLabel.textColor = .white
        emailLabel.textAlignment = .left
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.font = .systemFont(ofSize: 18)
        return emailLabel
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
    
    lazy var birthdayLabel: UILabel = {
        let birthdayLabel = UILabel()
        birthdayLabel.text = "Birthday:"
        birthdayLabel.textColor = .white
        birthdayLabel.textAlignment = .left
        birthdayLabel.translatesAutoresizingMaskIntoConstraints = false
        birthdayLabel.font = .systemFont(ofSize: 18)
        return birthdayLabel
    }()
    
    lazy var birthdayTextField: UITextField = {
        let birthday = UITextField()
        birthday.translatesAutoresizingMaskIntoConstraints = false
        birthday.borderStyle = .roundedRect
        birthday.clipsToBounds = true
        birthday.layer.cornerRadius = 4
        birthday.layer.borderColor = UIColor.white.cgColor
        birthday.layer.borderWidth = 1
        birthday.backgroundColor = .black
        birthday.textColor = .white
        birthday.keyboardType = .numberPad
        // Placeholder branco
        birthday.attributedPlaceholder = NSAttributedString(
            string: "07/01/2002(Optional):",
            attributes: [.foregroundColor: UIColor.lightGray]
        )
        return birthday
    }()
    
    lazy var exitAppButton: UIButton = {
        let exit = UIButton()
        exit.setTitle("Exit the App", for: .normal)
        exit.translatesAutoresizingMaskIntoConstraints = false
        exit.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        exit.setTitleColor(.white, for: .normal)
        exit.backgroundColor = UIColor(red: 0.7, green: 0.0, blue: 0.1, alpha: 1.0)
        exit.clipsToBounds = true
        exit.layer.cornerRadius = 10
        exit.layer.shadowColor = UIColor.black.cgColor
        exit.layer.shadowOpacity = 0.5
        exit.layer.shadowOffset = CGSize(width: 0, height: 4)
        exit.layer.shadowRadius = 8
        exit.addTarget(self, action: #selector(tappedExitAppButton), for: .touchUpInside)
        return exit
    }()
    
    lazy var deleteAccontButton: UIButton = {
        let delete = UIButton()
        delete.setTitle("Delete Accont", for: .normal)
        delete.translatesAutoresizingMaskIntoConstraints = false
        delete.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        delete.setTitleColor(.white, for: .normal)
        delete.backgroundColor = UIColor(red: 0.7, green: 0.0, blue: 0.1, alpha: 1.0)
        delete.clipsToBounds = true
        delete.layer.cornerRadius = 10
        delete.layer.shadowColor = UIColor.black.cgColor
        delete.layer.shadowOpacity = 0.5
        delete.layer.shadowOffset = CGSize(width: 0, height: 4)
        delete.layer.shadowRadius = 8
        delete.addTarget(self, action: #selector(tappedDeleteAccontButton), for: .touchUpInside)
        return delete
    }()
    
    @objc func tappedExitAppButton() {
        delegate?.tappedExitAppButton()
    }
    
    @objc func tappedDeleteAccontButton() {
        delegate?.tappedDeleteAccontButton()
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
        addSubview(settingsLabel)
        addSubview(nameLabel)
        addSubview(nameTextFiel)
        addSubview(emailLabel)
        addSubview(emailTextFiel)
        addSubview(birthdayLabel)
        addSubview(birthdayTextField)
        addSubview(exitAppButton)
        addSubview(deleteAccontButton)
    }
    
    func configConstraints() {
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor , constant: 20),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            textLabel.heightAnchor.constraint(equalToConstant: 40),
            
            settingsLabel.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 30),
            settingsLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            settingsLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            nameLabel.topAnchor.constraint(equalTo: settingsLabel.bottomAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            nameLabel.heightAnchor.constraint(equalToConstant: 40),
            
            nameTextFiel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 0),
            nameTextFiel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            nameTextFiel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            nameTextFiel.heightAnchor.constraint(equalToConstant: 40),
            
            emailLabel.topAnchor.constraint(equalTo: nameTextFiel.bottomAnchor, constant: 20),
            emailLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            emailLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            emailLabel.heightAnchor.constraint(equalToConstant: 40),
            
            emailTextFiel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 0),
            emailTextFiel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            emailTextFiel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            emailTextFiel.heightAnchor.constraint(equalToConstant: 40),
            
            birthdayLabel.topAnchor.constraint(equalTo: emailTextFiel.bottomAnchor, constant: 20),
            birthdayLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            birthdayLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            birthdayLabel.heightAnchor.constraint(equalToConstant: 40),
            
            birthdayTextField.topAnchor.constraint(equalTo: birthdayLabel.bottomAnchor, constant: 0),
            birthdayTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            birthdayTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            birthdayTextField.heightAnchor.constraint(equalToConstant: 40),
            
            exitAppButton.bottomAnchor.constraint(equalTo: deleteAccontButton.bottomAnchor, constant: -60),
            exitAppButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            exitAppButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            exitAppButton.heightAnchor.constraint(equalToConstant: 40),
            
            deleteAccontButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -40),
            deleteAccontButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            deleteAccontButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            deleteAccontButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
}
