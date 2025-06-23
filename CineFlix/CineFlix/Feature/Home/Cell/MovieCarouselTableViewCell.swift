//
//  MovieCarouselTableViewCell.swift
//  CineFlix
//
//  Created by Arthur Lima on 23/06/2025.
//

import UIKit

protocol MovieCarouselTableViewCellProtocol: AnyObject {
    func tappedMovie()
}

class MovieCarouselTableViewCell: UITableViewCell {
    
    
    static let identifier: String = String(describing: MovieCarouselTableViewCell.self)
    
    weak var delegate: MovieCarouselTableViewCellProtocol?
    
    private var items: [String] = []
    
    lazy var sectionTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 120, height: 180)
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .black// fundo preto
        collectionView.register(MoviePosterCollectionViewCell.self, forCellWithReuseIdentifier: MoviePosterCollectionViewCell.identifier)
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .black
        addElements()
        configConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addElements() {
        contentView.addSubview(collectionView)
        contentView.addSubview(sectionTitleLabel)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    
    
    func configConstraints() {
        NSLayoutConstraint.activate([
            sectionTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            sectionTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            sectionTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            collectionView.topAnchor.constraint(equalTo: sectionTitleLabel.bottomAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 190) // ajuste conforme o tamanho das imagen
        ])
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    
    func configure(movieSection: MovieSection) {
        sectionTitleLabel.text = movieSection.title
        self.items = movieSection.items
        collectionView.reloadData()
    }
//    func configure(with items: [String]) {
//        self.items = items
//        collectionView.reloadData()
    
}

extension MovieCarouselTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoviePosterCollectionViewCell.identifier, for: indexPath) as? MoviePosterCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: items[indexPath.item])
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //        let selectedItem = items[indexPath.item]
        delegate?.tappedMovie()
    }
}

