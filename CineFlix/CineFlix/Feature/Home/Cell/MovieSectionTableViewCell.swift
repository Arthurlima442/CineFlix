import UIKit

protocol MovieSectionTableViewCellDelegate: AnyObject {
    func movieSectionCell(_ cell: MovieSectionTableViewCell, didSelectMovieAt index: Int, sectionIndex: Int)
    func movieSectionCell(_ cell: MovieSectionTableViewCell, shouldLoadMoreAt index: Int)
}

class MovieSectionTableViewCell: UITableViewCell {
    
    static let identifier = "MovieSectionTableViewCell"
    
    weak var delegate: MovieSectionTableViewCellDelegate?
    
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let collectionView: UICollectionView
    
    private var movies: [MovieSummary] = []
    private var sectionIndex: Int = 0
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        let layout = UICollectionViewFlowLayout()
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        contentView.backgroundColor = .black
        selectionStyle = .none
        
        contentView.addSubview(containerView)
        containerView.backgroundColor = .black
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        // Title Label
        containerView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        titleLabel.textColor = .white
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 25)
        ])
        
        // CollectionView Setup
        containerView.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MoviePosterCollectionViewCell.self, forCellWithReuseIdentifier: MoviePosterCollectionViewCell.identifier)
        
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.scrollDirection = .horizontal
        layout?.minimumLineSpacing = 12
        layout?.minimumInteritemSpacing = 0
        layout?.itemSize = CGSize(width: 160, height: 240)
        layout?.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        collectionView.showsHorizontalScrollIndicator = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 250),
            collectionView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
        ])
    }
    
    // MARK: - Configuration
    
    func configure(with section: MovieSection, sectionIndex: Int) {
        self.titleLabel.text = section.title
        self.movies = section.movies
        self.sectionIndex = sectionIndex
        
        // Reset scroll position para o início
        collectionView.setContentOffset(.zero, animated: false)
        
        if movies.isEmpty {
            // Show empty state
            let emptyLabel = UILabel()
            emptyLabel.text = "Nenhum filme disponível"
            emptyLabel.textColor = .gray
            emptyLabel.font = .systemFont(ofSize: 14)
            emptyLabel.textAlignment = .center
            
            collectionView.backgroundView = emptyLabel
        } else {
            collectionView.backgroundView = nil
        }
        
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource

extension MovieSectionTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoviePosterCollectionViewCell.identifier, for: indexPath) as? MoviePosterCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let movie = movies[indexPath.item]
        cell.configure(with: movie)
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension MovieSectionTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.movieSectionCell(self, didSelectMovieAt: indexPath.item, sectionIndex: sectionIndex)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // Check if should load more
        let threshold = movies.count - 5 // Load when there are 5 items left
        if indexPath.item >= threshold && !movies.isEmpty {
            delegate?.movieSectionCell(self, shouldLoadMoreAt: sectionIndex)
        }
    }
}
