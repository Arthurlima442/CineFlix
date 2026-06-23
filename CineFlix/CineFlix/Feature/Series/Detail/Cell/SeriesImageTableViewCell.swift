//
//  SeriesImageTableViewCell.swift
//  CineFlix
//
//  Created by Arthur Lima on 10/01/2025.
//

import UIKit

class SeriesImageTableViewCell: UITableViewCell {

    static let identifier: String = String(describing: SeriesImageTableViewCell.self)
    
    lazy var coverSeriesImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        addElements()
        configConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addElements() {
        contentView.addSubview(coverSeriesImageView)
    }
    
    func configConstraints() {
        NSLayoutConstraint.activate([
            coverSeriesImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            coverSeriesImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            coverSeriesImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            coverSeriesImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            coverSeriesImageView.heightAnchor.constraint(equalToConstant: 400),
        ])
    }
    
    func setupCell(seriesData: SeriesDetail) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w400\(seriesData.posterPath ?? "")") else { return }
        coverSeriesImageView.loadImageFromURL(from: url, placeholder: UIImage(systemName: "gobackward"))
    }
}
