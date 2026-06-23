import UIKit

class MoviePosterCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "MoviePosterCollectionViewCell"
    
    private let posterImageView = UIImageView()
    private let titleLabel = UILabel()
    private let ratingLabel = UILabel()
    private let containerView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        contentView.backgroundColor = .clear
        backgroundColor = .black
        layer.cornerRadius = 8
        clipsToBounds = true
        
        // Container View
        contentView.addSubview(containerView)
        containerView.backgroundColor = .black
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        // Poster Image View
        containerView.addSubview(posterImageView)
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.clipsToBounds = true
        posterImageView.layer.cornerRadius = 10
        posterImageView.backgroundColor = .clear
        
        // Add subtle shadow
        posterImageView.layer.shadowColor = UIColor.black.cgColor
        posterImageView.layer.shadowOpacity = 0.2
        posterImageView.layer.shadowOffset = CGSize(width: 0, height: 2)
        posterImageView.layer.shadowRadius = 4
        
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            posterImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            posterImageView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        // Title Label
        containerView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 1
        titleLabel.lineBreakMode = .byTruncatingTail
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 6),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 2),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -2)
        ])
        
        // Rating Label
        containerView.addSubview(ratingLabel)
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingLabel.font = .systemFont(ofSize: 12, weight: .medium)
        ratingLabel.textColor = .systemYellow
        
        NSLayoutConstraint.activate([
            ratingLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            ratingLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 4),
            ratingLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -4)
        ])
    }
    
    // MARK: - Configuration
    
    func configure(with movie: MovieSummary) {
        titleLabel.text = movie.title
        
        // Handle optional voteAverage
        if let voteAverage = movie.voteAverage {
            ratingLabel.text = "⭐ \(String(format: "%.1f", voteAverage))"
        } else {
            ratingLabel.text = "⭐ -"
        }
        
        // Load poster image
        if let posterPath = movie.posterPath {
            let imageURL = URL(string: "https://image.tmdb.org/t/p/w200\(posterPath)")
            posterImageView.loadImageFromURL(from: imageURL!, placeholder: UIImage(systemName: "hourglass"))
        } else {
            posterImageView.image = UIImage(systemName: "hourglass")
        }
    }
    
    // MARK: - Cell Lifecycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.imageDownloadTask?.cancel()
        posterImageView.image = nil
        titleLabel.text = ""
        ratingLabel.text = ""
    }
}
