//
//  SeriesDetailWatchProvidersCell.swift
//  CineFlix
//
//  Created by Arthur Lima on 02/07/2026.
//

import UIKit

class SeriesDetailWatchProvidersCell: UITableViewCell {
    
    static let identifier = "SeriesDetailWatchProvidersCell"
    
    // MARK: - UI Components
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let providersStackView = UIStackView()
    private let noDataLabel = UILabel()
    private var regionLink: String?
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        // Container
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
        
        // Title Label
        titleLabel.text = "Onde Assistir"
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 1
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(titleLabel)
        
        // Providers Stack View (horizontal, wrapping)
        providersStackView.axis = .horizontal
        providersStackView.spacing = 10
        providersStackView.alignment = .center
        providersStackView.distribution = .fillEqually
        providersStackView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(providersStackView)
        
        // No Data Label
        noDataLabel.text = "Disponibilidade não informada"
        noDataLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        noDataLabel.textColor = .lightGray
        noDataLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(noDataLabel)
        noDataLabel.isHidden = true
        
        // Constraints
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 20),
            
            providersStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            providersStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            providersStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            providersStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            noDataLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            noDataLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            noDataLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        ])
    }
    
    // MARK: - Configure
    func configure(with watchProviders: SeriesWatchProvidersResponse?) {
        // Clear previous providers
        providersStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        regionLink = nil
        
        guard let results = watchProviders?.results else {
            showNoData()
            return
        }
        
        // Get Brazil providers or fallback to first available region
        let brazilKey = "BR"
        let providersData: [WatchProvider]?
        var selectedRegion: SeriesWatchProviderRegion?
        
        if let brProviders = results[brazilKey] {
            providersData = extractUniquProviders(from: brProviders)
            selectedRegion = brProviders
        } else if let firstRegion = results.values.first {
            providersData = extractUniquProviders(from: firstRegion)
            selectedRegion = firstRegion
        } else {
            providersData = nil
        }
        
        // Store the link for when user taps providers
        self.regionLink = selectedRegion?.link
        
        guard let providers = providersData, !providers.isEmpty else {
            showNoData()
            return
        }
        
        // Sort by display priority and limit to 4 providers
        let sortedProviders = providers.sorted { ($0.displayPriority ?? 999) < ($1.displayPriority ?? 999) }
            .prefix(4)
        
        // Add provider chips
        for provider in sortedProviders {
            let chipView = createProviderChip(for: provider)
            providersStackView.addArrangedSubview(chipView)
        }
        
        noDataLabel.isHidden = true
        providersStackView.isHidden = false
    }
    
    // Remove duplicates by name
    private func extractUniquProviders(from region: SeriesWatchProviderRegion) -> [WatchProvider] {
        var allProviders: [WatchProvider] = []
        var seenNames = Set<String>()
        
        // Combine all categories
        let categories = [region.flatrate, region.rent, region.buy, region.ads].compactMap { $0 }
        
        for category in categories {
            for provider in category {
                if !seenNames.contains(provider.name) {
                    allProviders.append(provider)
                    seenNames.insert(provider.name)
                }
            }
        }
        
        return allProviders
    }
    
    private func createProviderChip(for provider: WatchProvider) -> UIView {
        let chipView = UIView()
        chipView.translatesAutoresizingMaskIntoConstraints = false
        chipView.backgroundColor = UIColor(white: 0.12, alpha: 1)
        chipView.layer.cornerRadius = 10
        chipView.clipsToBounds = true
        chipView.layer.borderWidth = 1
        chipView.layer.borderColor = UIColor(white: 0.25, alpha: 1).cgColor
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        chipView.addSubview(stackView)
        
        // Logo
        let logoView = UIImageView()
        logoView.contentMode = .scaleAspectFill
        logoView.clipsToBounds = true
        logoView.layer.cornerRadius = 5
        logoView.translatesAutoresizingMaskIntoConstraints = false
        
        if let logoPath = provider.logoPath {
            let logoUrl = "https://image.tmdb.org/t/p/original\(logoPath)"
            loadImage(from: logoUrl, into: logoView)
        }
        
        stackView.addArrangedSubview(logoView)
        
        // Name
        let nameLabel = UILabel()
        nameLabel.text = provider.name
        nameLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        nameLabel.textColor = .white
        nameLabel.numberOfLines = 1
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(nameLabel)
        
        // Add tap gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(providerTapped))
        chipView.addGestureRecognizer(tapGesture)
        chipView.isUserInteractionEnabled = true
        
        // Constraints
        NSLayoutConstraint.activate([
            chipView.heightAnchor.constraint(equalToConstant: 44),
            
            logoView.widthAnchor.constraint(equalToConstant: 32),
            logoView.heightAnchor.constraint(equalToConstant: 32),
            
            stackView.topAnchor.constraint(equalTo: chipView.topAnchor, constant: 6),
            stackView.leadingAnchor.constraint(equalTo: chipView.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: chipView.trailingAnchor, constant: -10),
            stackView.bottomAnchor.constraint(equalTo: chipView.bottomAnchor, constant: -6),
        ])
        
        return chipView
    }
    
    @objc private func providerTapped() {
        guard let urlString = regionLink, let url = URL(string: urlString) else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    private func loadImage(from urlString: String, into imageView: UIImageView) {
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                imageView.image = image
            }
        }.resume()
    }
    
    private func showNoData() {
        providersStackView.isHidden = true
        noDataLabel.isHidden = false
        providersStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
}
