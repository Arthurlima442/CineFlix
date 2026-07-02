//
//  SeriesDetailScreen.swift
//  CineFlix
//
//  Created by Arthur Lima on 10/01/2025.
//

import UIKit

class SeriesDetailScreen: UIView {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(SeriesDetailHeaderCell.self, forCellReuseIdentifier: SeriesDetailHeaderCell.identifier)
        tableView.register(SeriesDetailActionsCell.self, forCellReuseIdentifier: SeriesDetailActionsCell.identifier)
        tableView.register(SeriesDetailSynopsisCell.self, forCellReuseIdentifier: SeriesDetailSynopsisCell.identifier)
        tableView.register(SeriesDetailInfoCell.self, forCellReuseIdentifier: SeriesDetailInfoCell.identifier)
        tableView.register(SeriesDetailWatchProvidersCell.self, forCellReuseIdentifier: SeriesDetailWatchProvidersCell.identifier)
        tableView.backgroundColor = .black
        tableView.separatorStyle = .none
        return tableView
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
        addSubview(tableView)
    }
    
    func configConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    func configTableViewProtocols(delegate: UITableViewDelegate, dataSource: UITableViewDataSource) {
        tableView.delegate = delegate
        tableView.dataSource = dataSource
    }
}
