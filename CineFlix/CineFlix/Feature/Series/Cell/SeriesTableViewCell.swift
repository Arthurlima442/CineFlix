// filepath: SeriesTableViewCell.swift
//
//  SeriesTableViewCell.swift
//  CineFlix
//
//  Created by Arthur Lima on 10/01/2025.
//

import UIKit

class SeriesTableViewCell: UITableViewCell {
    
    static let identifier: String = String(describing: SeriesTableViewCell.self)
    
    lazy var seriesImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleToFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 15
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.tintColor = .white
        return iv
    }()
    
    lazy var nameSeriesLabel: UILabel = {
        let name = UILabel()
        name.font = .systemFont(ofSize: 19, weight: .semibold)
        name.textColor = .white
        name.numberOfLines = 2
        name.translatesAutoresizingMaskIntoConstraints = false
        return name
    }()
    
    lazy var firstAirDateLabel: UILabel = {
        let date = UILabel()
        date.font = .systemFont(ofSize: 17, weight: .semibold)
        date.textColor = .white
        date.translatesAutoresizingMaskIntoConstraints = false
        return date
    }()
    
    lazy var genreSeriesLabel: UILabel = {
        let genre = UILabel()
        genre.font = .systemFont(ofSize: 17, weight: .semibold)
        genre.textColor = .white
        genre.numberOfLines = 2
        genre.translatesAutoresizingMaskIntoConstraints = false
        return genre
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
        contentView.addSubview(seriesImageView)
        contentView.addSubview(nameSeriesLabel)
        contentView.addSubview(firstAirDateLabel)
        contentView.addSubview(genreSeriesLabel)
    }
    
    func configConstraints() {
        NSLayoutConstraint.activate([
            seriesImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14),
            seriesImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            seriesImageView.heightAnchor.constraint(equalToConstant: 160),
            seriesImageView.widthAnchor.constraint(equalToConstant: 140),
            seriesImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            nameSeriesLabel.topAnchor.constraint(equalTo: seriesImageView.topAnchor, constant: 10),
            nameSeriesLabel.leadingAnchor.constraint(equalTo: seriesImageView.trailingAnchor, constant: 10),
            nameSeriesLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            
            firstAirDateLabel.topAnchor.constraint(equalTo: nameSeriesLabel.bottomAnchor, constant: 10),
            firstAirDateLabel.leadingAnchor.constraint(equalTo: seriesImageView.trailingAnchor, constant: 10),
            firstAirDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            
            genreSeriesLabel.topAnchor.constraint(equalTo: firstAirDateLabel.bottomAnchor, constant: 10),
            genreSeriesLabel.leadingAnchor.constraint(equalTo: seriesImageView.trailingAnchor, constant: 10),
            genreSeriesLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
        ])
    }
    
    func setupCell(seriesData: SeriesSummary) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w200\(seriesData.posterPath ?? "")") else { return }
        seriesImageView.loadImageFromURL(from: url, placeholder: UIImage(systemName: "hourglass"))
        nameSeriesLabel.text = seriesData.name
        firstAirDateLabel.text = Util.formatReleaseDate(seriesData.firstAirDate)
        let genreMap = Dictionary(uniqueKeysWithValues: SeriesGenre.allCases.map { ($0.rawValue, $0.displayName) })
        genreSeriesLabel.text = seriesData.genreIds
            .compactMap { genreMap[$0] }
            .joined(separator: ", ")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        seriesImageView.imageDownloadTask?.cancel()
        seriesImageView.image = nil
        nameSeriesLabel.text = ""
        firstAirDateLabel.text = ""
        genreSeriesLabel.text = ""
    }
}
