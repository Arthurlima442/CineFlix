//
//  HomeScreen.swift
//  CineFlix
//
//  Created by Arthur Lima on 09/06/2025.
//

import UIKit

protocol HomeScreenProtocol: AnyObject {
    
}

class HomeScreen: UIView, UITextFieldDelegate {

    weak var delegate: HomeScreenProtocol?
    
    lazy var textLabel: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.text = "CineFlix"
        text.font = UIFont.systemFont(ofSize: 45)
        text.textColor = .red
        text.textAlignment = .center
        return text
    }()
    
    lazy var searchTextField: UITextField = {
        let search = UITextField()
        search.translatesAutoresizingMaskIntoConstraints = false
        search.borderStyle = .roundedRect
        search.clipsToBounds = true
        search.layer.cornerRadius = 4
        search.layer.borderColor = UIColor.white.cgColor
        search.layer.borderWidth = 1
        search.backgroundColor = .black
        search.textColor = .white

        // Placeholder branco
        search.attributedPlaceholder = NSAttributedString(
            string: "search movie:",
            attributes: [.foregroundColor: UIColor.lightGray]
        )
        return search
    }()
    
    
    
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
        addSubview(searchTextField)
    }
    
    func configConstraints() {
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            textLabel.heightAnchor.constraint(equalToConstant: 40),
            
            searchTextField.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 25),
            searchTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            searchTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            searchTextField.heightAnchor.constraint(equalToConstant: 40),
            
        ])
    }
    

}
