//
//  HomeTableViewCell.swift
//  CineFlix
//
//  Created by Arthur Lima on 23/06/2025.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    
    static let identifier: String = String(describing: HomeTableViewCell.self)
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .orange
        addElements()
        configConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addElements() {
        //  contentView.addSubview(suaView)
          
    }
    
    func configConstraints() {
        NSLayoutConstraint.activate([

        ])
    }
}


